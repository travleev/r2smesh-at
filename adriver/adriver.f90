program adriver
    use proc  ! mpi module is available from here
    use matcomp, only: get_mat
    use gen, only: print_log, ijk2str
    use meshtal
    use matall
    use fispactdriver, only: run_condense, run_collapse, run_inventory, read_tab4, write_gi
    use r2senv, only: env_init
    implicit none

    integer:: i_c, j_c, k_c ! indices for coarse mesh elements
    integer:: nfir, &  ! number of fispact inventory runs
              nfir1, & ! number of fispact inventory runs in coarse mesh element
              nfcr     ! number of fispact collapse runs

    integer:: cmax  ! maximal number of cells in fine mesh element

    ! variables for mpi
    integer, allocatable:: pstat(:)  ! Status of slave processes
    integer, parameter:: &
        nb=4,            &   ! length of the buffer between the master and slaves
        tag1=1,          &   ! tag to continue job
        tag2=2,          &   ! tag telling that no more jobs
        master=0             ! sender or recepient
    integer:: buf(nb)  ! Message buffer between the master and slaves

    real:: nfirtot   ! Total number of inventory runs (real to compute %)

    ! Get all necessary environment variables
    call env_init


    call pr_initialize

    nfir = 0  ! number of inventory runs

    ! Initialization
    call initialize()
    ! Compute number of inventory runs
    call print_log('Computing number of inventory runs ...')
    do i_c = 1, size(xc) - 1
        do j_c = 1, size(yc) - 1
            do k_c = 1, size(zc) - 1 
                call process_coarse_element(i_c, j_c, k_c, nfir1, .TRUE.)
                if (nfir1 .gt. 0) nfcr = nfcr + 1
                nfir = nfir + nfir1
            end do
        end do
    end do
    nfirtot = float(nfir) * 1e-2
    call print_log(ijk2str('Number of collapse/inventory runs:', (/nfcr, nfir/)))

    nfir = 0  ! number of inventory runs
    nfcr = 0  ! Number of collapse runs (at most once per coarse element)

    if (pr_np .eq. 1) then 
        ! Only one process, do sequentially
        call run_condense()
        do i_c = 1, size(xc) - 1
            do j_c = 1, size(yc) - 1
                do k_c = 1, size(zc) - 1 
                    nfir1 = nfir
                    call process_coarse_element(i_c, j_c, k_c, nfir1, .FALSE.)
                    if (nfir1 .gt. 0) nfcr = nfcr + 1
                    nfir = nfir + nfir1
                end do
            end do
        end do
        write(pr_log, *) 'Number of  collapse runs:', nfcr
        write(pr_log, *) 'Number of inventory runs:', nfir
    else
        if (pr_id .eq. 0) then
            ! Code for master
            call run_condense()
            call MPI_Barrier(MPI_COMM_WORLD, pr_er)
            allocate(pstat(pr_np - 1))
            pstat = 0
            do i_c = 1, size(xc) - 1
                do j_c = 1, size(yc) - 1
                    do k_c = 1, size(zc) - 1 
                        ! Get the next free process and supply it with the next job
                        call MPI_Recv(buf, nb, MPI_INTEGER, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, pr_st, pr_er)   ! Get I_am_ready message

                        ! In the buf received from slave -- number nfir1
                        nfir1 = buf(1)
                        if (nfir1 .gt. 0) nfcr = nfcr + 1
                        nfir = nfir + nfir1
                        ! In the buffer sent to a slave -- indices of the coarse mesh element, and number of already completed fispact runs (for logging)
                        buf(1:nb) = (/i_c, j_c, k_c, nfir/)
                        call MPI_Send(buf, nb, MPI_INTEGER, pr_st(MPI_SOURCE), tag1, MPI_COMM_WORLD, pr_er)  ! Send work_definition message
                        pstat(pr_st(MPI_SOURCE)) = pstat(pr_st(MPI_SOURCE)) + 1  ! compute the number of jobs each processor receives 
                    end do
                end do
            end do
            write(pr_log, *) 'Number of jobs accomplshed by each slave process:'
            write(pr_log, *) pstat
            ! When all coarse meshes are ready, inform all slaves that there is no work
            do while (count(pstat > 0) .gt. 0)
                call MPI_Recv(buf, nb, MPI_INTEGER, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, pr_st, pr_er)   ! Get I_am_ready message
                nfir1 = buf(1)
                if (nfir1 .gt. 0) nfcr = nfcr + 1
                nfir = nfir + nfir1
                buf = 0.0
                call MPI_Send(buf, nb, MPI_INTEGER, pr_st(MPI_SOURCE), tag2, MPI_COMM_WORLD, pr_er)                 ! Send end_of_work message
                write(pr_log, *) 'Sent end-of-job message to process', pr_st(MPI_SOURCE)
                pstat(pr_st(MPI_SOURCE)) = 0
            end do
            write(pr_log, *) 'Number of  collapse runs:', nfcr
            write(pr_log, *) 'Number of inventory runs:', nfir
        else
            ! Code for slaves
            call MPI_Barrier(MPI_COMM_WORLD, pr_er)
            ! Send "I'm ready" signal to the master
            buf = 0
            call MPI_Send(buf, nb, MPI_INTEGER, master, tag1, MPI_COMM_WORLD, pr_er)    ! Send I_am_ready message
            call MPI_Recv(buf, nb, MPI_INTEGER, master, MPI_ANY_TAG, MPI_COMM_WORLD, pr_st, pr_er)    ! Get work_definition message
            do while (pr_st(MPI_TAG) .eq. tag1)
                i_c = buf(1)
                j_c = buf(2)
                k_c = buf(3)
                nfir1 =  buf(4)
                call process_coarse_element(i_c, j_c, k_c, nfir1, .FALSE.)
                buf(1) = nfir1
                buf(2:nb) = 0
                call MPI_Send(buf, nb, MPI_INTEGER, master, tag1, MPI_COMM_WORLD, pr_er)    ! Send I_am_ready message
                call MPI_Recv(buf, nb, MPI_INTEGER, master, MPI_ANY_TAG, MPI_COMM_WORLD, pr_st, pr_er)    ! Get work_definition or end_of_work message
            end do
        end if
        call print_log('Process completed')
    end if
    call print_log('Program completed')
    call pr_finalize()

    contains

    subroutine initialize()
        implicit none
        ! local vars
        integer:: nf, nc  ! meshtal numbers for the fine and coarse meshes
        integer, allocatable:: mn(:)  ! material names

        integer:: n

        ! Read material compositions
        call get_mat('mat_table')

        call get_fluxes

        call get_mcnp_names('cmi_table')
        call get_mat_allocation('fine_mesh_content')

        ! Loop for fispact runs. 
        call print_log('Loop over coarse mesh elements ... ')
        nfir = 0  
        nfcr = 0  
        return
    end subroutine initialize

    subroutine process_coarse_element(ic, jc, kc, nfr, dryrun)
        implicit none
        integer, intent(in):: ic, jc, kc
        integer, intent(inout):: nfr ! number of fispact inventory runs in the coarse mesh element
        logical, intent(in):: dryrun ! If TRUE, fispact not actually started, only numer of runs is computed

        ! local variables
        logical collapse_completed
        integer:: i, j, k  ! indices for fine mesh elements
        integer:: ijkf(4), ijkc(3)
        integer:: if1, if2, jf1, jf2, kf1, kf2  ! index bounds of fine mesh elements in a coarse one
        integer:: nmf      ! number of materials in fine mesh element

        real, allocatable:: fmgi(:, :) ! fine mesh gamma intensity for each time step
        character (len=200):: msg

        ! Write log
        if (.not. dryrun) then 
            write(msg, '("Starting coarse element ", 3i5, ". Completed fispact inventory runs: ", i6, f9.4" %")') ic, jc, kc, nfr, float(nfr)/nfirtot
            call print_log(trim(msg))
        end if

        ! Collapse should run only when there are materials in the coarse mesh element.
        ! THerefore, trigger only after having found any of them below.
        collapse_completed = .FALSE.

        ! Get subset of finemesh element in the current coarse mesh element
        if1 = count(xf .le. xc(ic))
        if2 = count(xf .le. xc(ic + 1))
        jf1 = count(yf .le. yc(jc))
        jf2 = count(yf .le. yc(jc + 1))
        kf1 = count(zf .le. zc(kc))
        kf2 = count(zf .le. zc(kc + 1))
        ijkc = (/ic, jc, kc/)
        if (.not. dryrun) then
            write(pr_log, '(a, 3(5x, 2i5))') 'Fine mesh indices:', if1, if2-1, jf1, jf2-1, kf1, kf2-1
        end if

        do i = if1, if2 - 1
            do j = jf1, jf2 - 1
                do k = kf1, kf2 - 1
                    if (.not. dryrun) write(pr_log, *) 'Fine mesh element', i, j, k

                    call run_inventory2(i, j, k,    &  ! in,  specify fine mesh element 
                                        inv_status, &  ! out, get whether inventory was actually run
                                        ic, jc, kc, &  ! in, specify coarse mesh element
                                        col_status, &  ! in/out, get whether collpase is needed and was actually run
                                        dryrun)        ! Flag to actually run fispact
                end do
            end do
        end do
        return

    end subroutine process_coarse_element
end program adriver


