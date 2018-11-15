!This is a code to generate the phase space trajectory of a harmonic/anharmonic oscillator. It clearly shows that we need the anharmonic term to get thermal expansion.
PROGRAM main

  USE param
  USE dynamics

  IMPLICIT NONE

  INTEGER:: i,j,nstep,ntemp

  nstep=7000
  ntemp=7
  dt=0.001d0

   DO i=1,ntemp
     kt1=DBLE(i)*0.1d0
     x0=0.d0
     v0=0.1d0
     kt0=v0*v0
     CALL thermostat
     DO j=1,nstep
        PRINT *,x0,v0
        CALL ft
        x0=x1
        v0=v1
     END DO
  END DO

END PROGRAM main
