PROGRAM main

  USE param
  USE initialize
  USE WF

  IMPLICIT NONE

  INTEGER:: i,j,tnn
  REAL(dp)::tmp,xtmp
  CHARACTER(40)::outfile

  NAMELIST/inputdata/nn,outfile !nn=number of nodes
  nn=1
  outfile='ho.dat'
  READ(*,inputdata)

  IF(nn.NE.0)THEN
     tnn=nn-NINT(DBLE(nn)/2.d0)
  ELSE
     tnn=0
  END IF

  CALL allocarray
  CALL vpot_ho

  DO j=1,100

     CALL calcg
     CALL integrateout

     IF(ncross.LE.tnn)THEN    !raise the lower bound
        emax=emax
        emin=ene
     ELSE                     !lower the uppdr bound
        emax=ene
        emin=emin
     END IF

     IF ((emax-emin).LT.1.d-10)THEN
        WRITE(*,*)"Energy of ",nn," excited state ", ene
        EXIT
     END IF

  END DO


  CALL normalizewf

  !Output data
  OPEN(UNIT=2,FILE=outfile)
  DO i=0,gs
     xtmp=xmin+DBLE(i)*dx
     WRITE(2,'(f7.3,3E16.6)')xtmp,psi(i),psi(i)*psi(i),v(i)
  END DO

END PROGRAM main
