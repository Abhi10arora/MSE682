MODULE param

  IMPLICIT NONE

  INTEGER, PARAMETER :: dp = KIND(1.D0)

END MODULE param

MODULE dynamics

  USE param

  IMPLICIT NONE

  REAL(dp)::x0,x1,v0,v1,a0,a1,kt0,kt1,dt

CONTAINS
  SUBROUTINE ft

    IMPLICIT NONE

    a0=-2.d0*x0+x0*x0
    x1=x0+v0*dt+0.5d0*a0*dt*dt
    v1=v0+a0*dt

  END SUBROUTINE ft

  SUBROUTINE thermostat

    IMPLICIT NONE

    v0=v0*SQRT(kt1/kt0)

  END SUBROUTINE thermostat

END MODULE dynamics
