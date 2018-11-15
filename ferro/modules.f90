MODULE param

  IMPLICIT NONE

  INTEGER, PARAMETER :: dp = KIND(1.D0)
  INTEGER, PARAMETER :: m1 = -1
END MODULE param

!MODULE TO GENERATE SQUARE LATTICE AND GET THE NEIGHBORLIST=========================================
MODULE lat

  USE param

  IMPLICIT NONE

  !Size of the problem
  INTEGER :: nx,ny
  INTEGER :: ns

  !site index
  INTEGER,POINTER :: sidx(:,:)

  !first near neighbors
  INTEGER,POINTER :: fnn(:,:)

  !spin at site
  INTEGER,POINTER :: spin(:)
  INTEGER,POINTER :: spin0(:)

CONTAINS
  SUBROUTINE latgen

    IMPLICIT NONE
    INTEGER :: i,j,itmp

    ns=nx*ny

    ALLOCATE(sidx(nx,ny))
    ALLOCATE(fnn(4,ns))
    ALLOCATE(spin(ns))
    ALLOCATE(spin0(ns))

    sidx=0
    fnn=0
    spin=0
    spin0=0

    itmp=0
    DO i=1,nx
       DO j=1,ny
          itmp=itmp+1
          sidx(i,j)=itmp
       END DO
    END DO

  END SUBROUTINE latgen

SUBROUTINE fnneib

  IMPLICIT NONE

  INTEGER :: i,j,itmp,jtmp,idx

  DO i=1,nx
     DO j=1,ny

        !near neighbors
        idx=sidx(i,j)

        !right
        itmp=i+1
        jtmp=j
        IF(itmp.LT.nx)THEN
           fnn(1,idx)=sidx(itmp,jtmp)
        ELSE
           fnn(1,idx)=sidx(1,jtmp)
        END IF

        !left
        itmp=i-1
        jtmp=j
        IF(itmp.GT.0)THEN
           fnn(2,idx)=sidx(itmp,jtmp)
        ELSE
           fnn(2,idx)=sidx(nx,jtmp)
        END IF

        !up
        itmp=i
        jtmp=j+1
        IF(jtmp.LT.ny)THEN
           fnn(3,idx)=sidx(itmp,jtmp)
        ELSE
           fnn(3,idx)=sidx(itmp,1)
        END IF

        !down
        itmp=i
        jtmp=j-1
        IF(jtmp.GT.0)THEN
           fnn(4,idx)=sidx(itmp,jtmp)
        ELSE
           fnn(4,idx)=sidx(itmp,ny)
        END IF

     END DO
  END DO

!    DO i=1,ns
!       PRINT *,i,fnn(1,i),fnn(2,i),fnn(3,i),fnn(4,i)
!    END DO

END SUBROUTINE fnneib

END MODULE lat

!MODULE TO GET ENERGY=======================================================
MODULE energy

  USE param
  USE lat

  IMPLICIT NONE

  REAL(dp)::tene,kt,Jex,Bext

CONTAINS
  SUBROUTINE getene

    USE param
    USE lat

    IMPLICIT NONE

    INTEGER:: i,j,k

    tene=0.d0
    DO i=1,ns
       DO j=1,4
          k=fnn(j,i)
          tene=tene-0.5d0*Jex*DBLE(spin(i)*spin(k))
       END DO
       tene=tene-Bext*spin(i)
    END DO

    !  tene=tene/DBLE(ns)

  END SUBROUTINE getene

END MODULE energy

!MAGNETIC MOMENT MODULE================================================
MODULE magmom

  USE param

  IMPLICIT NONE

  REAL(dp)::tmm

CONTAINS
  SUBROUTINE getmm

    USE lat

    IMPLICIT NONE

    INTEGER:: i

    tmm=0.d0
    DO i=1,ns
       tmm=tmm+DBLE(spin(i))
    END DO

    tmm=tmm/DBLE(ns)

  END SUBROUTINE getmm

END MODULE magmom
