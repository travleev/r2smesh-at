!begin rubric
!******************************************************************************
!*                          COMMERCIAL IN CONFIDENCE                          *
!*                           UKAEA Culham Division                            *
!*                                                                            *
!*                                                                            *
!*                          FISPACT 2009 RELEASE 1.0                          *
!*                                                                            *
!******************************************************************************
!*                                                                            *
!* This is an unpublished work created in 2009, any copyright in which vests  *
!* in UKAEA and Culham Electromagnetics Limited. All rights reserved.         *
!*                                                                            *
!* The information contained in this software is proprietary to UKAEA Culham  *
!* Division and Culham Electromagnetics Ltd unless stated otherwise and is    *
!* made available in confidence; it must not be used or disclosed without the *
!* express written consent of UKAEA . This document may not be copied in whole*
!* or in part in any form without the express written consent of UKAEA.       *
!*                                                                            *
!* Authors: James Eastwood and Guy Morgan                                     *
! Copyright (c) 2009, UKAEA and Culham Electromagnetics Ltd.                  *
!******************************************************************************
!
!--------------------------------------------------------------------------
!! *Revision Information*
!!
!!     - $Date: 2009/05/29 15:58:08 $
!!     - $Name: Release-2-20-01 $
!!     - $RCSfile: template_m.f90,v $
!!     - $Revision: 1.1 $
!!
!--------------------------------------------------------------------------
!end rubric


!! *Type*
!!
!! The type should be defined by stating its logical and physical
!! characteristics.
!!
!! The logical characteristics should be stated by saying which of the
!! following categories the component belongs to (more may be added):
!!    - framework and infrastructure
!!    - control data input and checking
!!    - keyword input and checking
!!    - cross section data input and processing
!!    - regulatory data input and processing
!!    - abundance calculation
!!    - pathways analysis
!!    - sensitivity analysis
!!    - stiff ode solver
!!    - output
!!
!! The physical characteristics should be defined by stating which of
!! the following descriptions apply to the component (more than one
!! may apply):
!!   - main program unit
!!   - data module
!!   - execution module
!!   - object-oriented module
!!   - keyword input module
!!   - subroutine
!!   - function
!!   (other physical types may need to be added).
!!   NB the subroutine and function types _are_ required 
!!   for procedures which cannot be parts of modules eg
!!   when we supply _get_command_argument_ and _command_argument_count_
!!   for systems which do not include them.
!!
!! If we followed the ESA guidelines more strictly we would
!! have the following options instead:
!!   - (Fortran 95) module
!!   - main program unit
!!   - subroutine
!!   - function
!!
!!
!! *Purpose*
!!
!! This section describes the purpose of the component.
!! It traces back to the software requirements which justify the existence 
!! of the component either by explicitly by citing the software 
!! requirement number or implicitly by saying that this component is a 
!! subordinate of another module component, e.g.
!!  
!! This component satisfies software requirement xxx.
!! This component is a subordinate of component xxx.
!!
!! *Function*
!!
!! This section describes the function of the component.
!! It should describe what is does as opposed to how it does it
!! which should be described in the processing section.
!!
!! The comments should be compatible with f90doc (start with !!):
!!   - use dashes for itemised lists
!!   - use underscores for _emphasised_ (italic)
!!   - use stars for *strong* (bold)
!!   - use pluses for +keyboard+ (teletype)
!! 
!! More complex formatting may be achieved by explicitly including html mark-up 
!! in the double quoted comment lines. These can then be customised further by
!! using cascading style sheets to format the html output. 
!!
!! *Processing*
!!
!! This section describes the processing done by the component.
!! It should describe how the component does what it does.
!! The use of pseudocode is encouraged.
!!
!! *Dependencies*
!!
!! This section describes what needs to have been done before this
!! component and its subcomponents can be used.
!!
!!
!--------------------------------------------------------------------------

module template_m

  use another_m, only: another_var1 ! Use only another_var1 from this module
  use second_m,  second_var1 => v   ! Use all module with second_var renamed v
  use precision_m, only krb         ! Use base real precision

  implicit none
  private

  ! public subroutines

  public template_usersub

  ! public types

  !! Example type 1
  type, public :: template_xyz_t
     integer :: num = 0                !! Number of things
     integer, pointer :: ptr => null() !! Pointer to first thing
  end type template_xyz_t

  ! public variables

  !! The description of the first public variable in the module.
  !! Public variables will usually require a paragraph of
  !! description.
  !!

  integer, dimension(1:3), public :: template_eg1
  !! second public variable
  integer, dimension(:), allocatable, public :: template_eg2

  ! private variables

  integer, dimension(1:3) :: eg1 !! example variable 1
  !! Example variable 2 has a longer description
  !! which is too long to fit at the end of the line.
  integer, dimension(1:3) :: eg2 = 0
  integer, dimension(1:3) :: eg3 = 0            !! example variable 3
  integer, dimension(:), allocatable :: eg4     !! example variable 4
  integer, target                    :: eg5 = 0 !! example variable 5


contains

!--------------------------------------------------------------------------
  !! First user subroutine with a paragraph of description
  !! saying what it does.
  !!
  subroutine template_usersub(arg1)
    ! arguments
    real(krb), intent(in) :: arg1 !! argument 1
    ! local variables
    integer :: i ! local variable description
    integer :: j ! local variable description
    integer :: k ! local variable description 

    ! user code
    call module_xyz()

  end subroutine template_usersub
!--------------------------------------------------------------------------

end module template_m

