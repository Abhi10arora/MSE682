#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
  FILE *f;
  f = fopen("output.dat", "w");
  int i, j, nsteps = 7000, ntemp = 7;
  double dt = 0.001, x0, x1, v0, v1, a0, a1, kt0, kt1;

  for(i = 1; i<=ntemp; i++)
  {
    kt1 = i*0.1;
    x0 = 0.0;
    v0 = 0.1;
    kt0=v0*v0;
    v0=v0*sqrt(kt1/kt0);
    for(j = 1; j<nsteps; j++)
    {
      fprintf(f, "%lf\t%lf\n", x0, v0);
      a0 = -2*x0 + x0*x0 + x0*x0*x0;
      x0 = x0 + v0*dt + 0.5*a0*dt*dt;
      v0 = v0 + a0*dt;
    }
  }
  fclose(f);
  return 0;
}
