PROGRAM main

  USE param
  USE lat
  USE energy
  USE magmom

  IMPLICIT NONE

  INTEGER:: i,j,k,itmp,itmp1,nstep,iseed,ikt
  REAL(dp)::tmp,de,tene0,tmm0,avene,avmm

  NAMELIST/inputdata/nx,ny,nstep,Jex,Bext
  nx=100
  ny=100
  nstep=1000000
  Jex=1.d0
  Bext=0.d0
  READ(*,inputdata)

  CALL latgen
  CALL fnneib

  !allocate spin randomly
  !  j=456789
  !  DO iseed=1,20
  !     j=j+10
  !     DO i=1,ns
  !        tmp= RAN(j)
  !        IF(tmp.GT.0.5)THEN
  !           spin(i)=1
  !        ELSE
  !           spin(i)=-1
  !        END IF
  !     END DO

  !plotting the initial configuration
  !     OPEN(UNIT=2, FILE='spin0.plt')
  !     DO i=1,nx
  !        DO j=1,ny
  !           itmp=sidx(i,j)
  !           WRITE(2,'(3I8)')i,j,spin(itmp)
  !        END DO
  !        WRITE(2,*)
  !     END DO
  !     CLOSE(2)

  kt=0.d0
  DO ikt=1,100
     kt=kt+0.005d0*DBLE(ikt)

     !all the spins are aligned
     spin=1

     CALL getene
     CALL getmm
     tene0=tene
     tmm0=tmm
     spin0=spin

     avene=0.d0
     avmm=0.d0

     !select a site randomly and flip spin of neighbors
     j=789123
     DO i=1,nstep
        tmp=RAN(j)
        itmp=1+NINT(tmp*(ns-1))

        spin(itmp)=spin(itmp)*m1
        CALL getene
        CALL getmm
        de=tene-tene0
        IF(de.LT.0.d0)THEN
           spin0=spin
           tene0=tene
           tmm0=tmm
!        ELSEIF(RAN(j)*EXP(-de/kt).GE.RAN(j))THEN
        ELSEIF(EXP(-de/kt).GE.RAN(j))THEN
           spin0=spin
           tene0=tene
           tmm0=tmm
        ELSE
           spin=spin0
           tene=tene0
           tmm=tmm0
        END IF

        IF(nstep-i.LT.100000)THEN
           avene=avene+tene/DBLE(ns)
           avmm=avmm+tmm
        END IF

        !     IF(MOD(i,2000).EQ.0)THEN
        !        WRITE(*,*)i,tene,tmm
        !     END IF
     END DO
     WRITE(*,*)kt,avene/DBLE(100000),ABS(avmm/DBLE(100000))
  END DO
  !  END DO

  !  OPEN(UNIT=2, FILE='spin.plt')
  !  DO i=1,nx
  !     DO j=1,ny
  !        itmp=sidx(i,j)
  !        WRITE(2,'(3I8)')i,j,spin(itmp)
  !     END DO
  !     WRITE(2,*)
  !  END DO
  !  CLOSE(2)

END PROGRAM main
