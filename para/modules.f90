!Module to allocate arrays
MODULE AllocateArrays

  IMPLICIT NONE

  INTEGER :: nT,nsite,M
  DOUBLE PRECISION,POINTER :: totE(:)
  INTEGER,POINTER :: spin0(:), spin(:), totM(:)

CONTAINS
SUBROUTINE AllocValues
  nsite=1000
  nT=100

  ALLOCATE(spin0(nsite))
  ALLOCATE(spin(nsite))
  ALLOCATE(totE(nT))
  ALLOCATE(totM(nT))

  !initially all spins are aligned
  spin0=1

  spin=0
  totE=0.d0
  totM=0
END SUBROUTINE AllocValues

SUBROUTINE GetM

  IMPLICIT NONE

  INTEGER :: i

  M=0
  DO i=1,nsite
     M=M+spin(i)
  END DO

END SUBROUTINE GetM

END MODULE AllocateArrays
