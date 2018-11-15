PROGRAM ParaMagnet

  USE AllocateArrays

  IMPLICIT NONE

  INTEGER :: nstep,i,j,k,itmp,ene,ene0,de
  DOUBLE PRECISION :: dT,T,tmp,avene

  dT=0.1
  nstep=1000000
  ene=0
  ene0=0
  de=0

  CALL AllocValues

  spin=spin0
  CALL GetM
  ene0=-M

  k=123456

  !Temperature loop

  DO i=1,nT
     T=DBLE(i)*dT
     avene=0.d0

     !Equilibration at a given temperature
     !select a site randomly and flip spin of neighbors
     DO j=1,nstep
        tmp=RAN(k)
        itmp=1+NINT(tmp*(nsite-1))

        spin(itmp)=spin(itmp)*-1      !Flip the spin
        CALL GetM
        ene=-M
        de=ene-ene0
        IF(de.LT.0)THEN
           spin0=spin
           ene0=ene
!        ELSEIF(RAN(k)*EXP(-de/kt).GE.RAN(k))THEN
        ELSEIF(EXP(-de/T).GE.RAN(k))THEN
           spin0=spin
           ene0=ene
        ELSE
           spin=spin0
           CALL GetM
           ene0=-M
        END IF

        !calculate average energy
        IF(nstep-j.LT.100000)THEN
           avene=avene+ene/DBLE(nsite)
        END IF
     END DO
     print *,T,avene/DBLE(100000),-avene/DBLE(100000)
  END DO

END PROGRAM ParaMagnet
