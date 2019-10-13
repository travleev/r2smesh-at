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
!!     - $RCSfile: oo_m.f90,v $
!!     - $Revision: 1.1 $
!!
!--------------------------------------------------------------------------
!end rubric

!!  *Type*
!!
!! This is a design pattern for object oriented modules.
!!
!!  *Purpose*
!!
!! This object oriented design pattern provides conventions
!! for interfaces for constructors, destructors, components
!! and methods.
!!
!!  *Function*
!!
!! The object orientated design pattern simulates objected oriented
!! features that are available in languages such as C++
!!
!! This is the simplest variation of the object oriented design pattern.
!! There are three main extensions to this pattern:
!!    - The non-static data for the object may be moved to a separate
!!      module (the +oo_t+ type is replaced by the +oo_data_t+ type in a
!!      companion +oo_data_m+ module. This avoids restrictions
!!      on circular dependencies of +use+ statements in Fortran 95.
!!    - The constructor and member functions may have generic interfaces,
!!      additional arguments, optional arguments and keyword arguments.
!!    - the +self+ dummy arguments in the constructors and destructors may
!!      have +pointer+ or +allocatable+ attributes that would allow the 
!!      constructor and destructor to allocate and deallocate all the storage 
!!      for the object.
!--------------------------------------------------------------------------

module oo_m

  ! use statements

  ! default to explicit typing and private
  implicit none
  private

  ! public subroutines

  public oo_init
  public oo_delete
  public oo_method1

  ! public types

  !! Type to contain non-static components of objects.
  !! All components should have default initial values.
  type, public :: oo_t
     integer :: comp1 = 0  !! component 1
     integer :: comp2 = 0  !! component 2
  end type oo_t

  ! public variables

  ! private types

  ! private variables

contains

!--------------------------------------------------------------------------
  !! Constructor for object.
  subroutine oo_init(self)
    ! arguments
    !! Variable to contain non-static data for self object must be first 
    !! argument and be called +self+.
    type(oo_t), intent(out) :: self
  end subroutine oo_init

!--------------------------------------------------------------------------
  !! First method for module.
  subroutine oo_method1(self,other_oo)
    ! arguments
    !! Data for self object must be first argument and be called
    !! +self+.
    type(oo_t), intent(inout) :: self
    !! Data for self object must be first argument and be called
    !! +self+.
    type(oo_t), intent(in) :: other_oo
  end subroutine oo_method1

!--------------------------------------------------------------------------
  !! Destructor for object.
  !!
  !! The destructor deallocates all storage which the object is
  !! responsible for. It is good programming style to make sure that the 
  !! object cannot be used after it has been deleted by invalidating
  !! all the data i.e. nullifying pointers and setting non-pointer
  !! variables to values which will generate an error if used.
  subroutine oo_delete(self)
    ! arguments
    type(oo_t), intent(inout) :: self !! data for self object
  end subroutine oo_delete
!--------------------------------------------------------------------------

end module oo_m

