MODULE param

  IMPLICIT NONE

  INTEGER, PARAMETER :: dp = KIND(1.D0)

END MODULE param

MODULE initialize

  USE param

  IMPLICIT NONE

  INTEGER::gs,nn,icl,ncross
  REAL(dp)::xmin,xmax,dx,emax,emin,ene
  REAL(dp),POINTER::v(:),psi(:),g(:)

CONTAINS

  !Allocating array=====================================================
  SUBROUTINE allocarray

    IMPLICIT NONE

    xmax=6.0_dp
    gs=6000

    ALLOCATE(v(0:gs))
    ALLOCATE(g(0:gs))
    ALLOCATE(psi(0:gs))

    v=0.0_dp
    g=0.0_dp
    psi=0.0_dp

    xmin=0.0_dp
    dx=(xmax-xmin)/DBLE(gs)

  END SUBROUTINE allocarray

  !Harmonic  potential====================================================
  SUBROUTINE vpot_ho

    IMPLICIT NONE

    INTEGER::i
    REAL(dp)::xtmp

    !Harmonic oscillator potential
    DO i=0,gs
       xtmp=xmin+DBLE(i)*dx
       v(i)=0.5_dp*xtmp*xtmp
    END DO

    emax=MAXVAL(v)
    emin=MINVAL(v)

  END SUBROUTINE vpot_ho

END MODULE initialize

MODULE WF

  USE param
  USE initialize

  IMPLICIT NONE

CONTAINS

  !Calculate g and f, as required by the Numerov formula
  SUBROUTINE calcg

    IMPLICIT NONE

    INTEGER:: i

    ene=(emax+emin)/2.0_dp

    g(0)=2.0_dp*(ene-v(0))
    DO i=1,gs
       g(i)=2.0_dp*(ene-v(i))
       !avoid g(i)=0
       IF(g(i).EQ.0.0_dp) g(i)=1.d-20
       ! store the index 'icl' where the last change of sign has been found
       IF ( g(i) .NE. SIGN(g(i),g(i-1)) ) icl=i
    END DO

    g=1.0_dp+g*dx*dx/12.0_dp

    IF (icl .GE. gs-2) THEN
       DEALLOCATE ( v,g,psi )
       WRITE(*,*)'Last change of sign too far, reduce emax.'
       STOP
    ELSE IF (icl .LT. 1) then
       DEALLOCATE ( v,g,psi )
       WRITE(*,*)'No classical turning point? increase emin'
       STOP
    END IF

  END SUBROUTINE calcg

  !Calculate outward integration and number of crossing======================================================
  SUBROUTINE integrateout

    IMPLICIT NONE

    INTEGER:: i,tnn

    !Set the initial points depending on whether odd or even wf
    IF(MOD(nn,2).EQ.1)THEN
       psi(0)=0.0_dp
       psi(1)=dx
    ELSE
       psi(0)=1.0_dp
       psi(1)=0.5_dp*(12.0_dp-10.0_dp*g(0))*psi(0)/g(1)
    END IF

    !How many times does the wavefunction change sign or cross the zero line - helps to find the number of nodes
    ncross=0
    DO i=1,gs-1
       psi(i+1)=((12.0_dp-10.0_dp*g(i))*psi(i)-g(i-1)*psi(i-1))/g(i+1)
       IF ( psi(i) /= SIGN(psi(i),psi(i+1)) ) ncross=ncross+1
    END DO

  END SUBROUTINE integrateout

  SUBROUTINE normalizewf

    IMPLICIT NONE

    INTEGER:: i
    REAL(dp):: psi2,fac

    psi2=0.0_dp
    DO i=1,gs-1
       psi2=psi2+2.0_dp*psi(i)*psi(i)
    END DO

    psi2=psi2+psi(0)*psi(0)+psi(gs)*psi(gs)
    psi2=psi2*dx/2.0_dp

    psi2=2.0_dp*psi2
    fac=1.0_dp/SQRT(psi2)

    psi=psi*fac

    !Again calculate mod psi2 and check whether properly normalized
    psi2=0.0_dp
    DO i=1,gs-1
       psi2=psi2+2.0_dp*psi(i)*psi(i)
    END DO

    psi2=psi2+psi(0)*psi(0)+psi(gs)*psi(gs)
    psi2=psi2*dx/2.0_dp

    WRITE(*,*)"Mod psi square", psi2

  END SUBROUTINE normalizewf

END MODULE WF
