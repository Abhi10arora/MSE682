#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "random.h"

int main()
{
  FILE *f;
  f = fopen("output.dat", "w");

  int x, y, T, i, total_steps = 1000000, nx = 30, ny = 30, nT = 50;
  int x_temp, y_temp, left, right, up, down;
  double KT = 0.0, Jext = 1.0, Bext = 0.0, ene = 0.0, ene_0 = 0.0, mm_0 = 0, mm = 0, de = 0.0;
  double avene, avmm;
  long int *seed;
  long int a;
  seed = &a;
  *seed = -2;

  double** spin = (double**)malloc((nx)*sizeof(double*));
  for(x = 0; x<nx; x++)
  {
    spin[x] = (double*)malloc((ny)*sizeof(double));
    for(y = 0; y<ny; y++)
    {
      spin[x][y] = 1;
    }
  }
  for(x = 0; x<nx; x++)
  {
    left = (x-1+nx)%nx;
    right = (x+1+nx)%nx;
    for(y = 0; y<ny; y++)
    {
      up = (y+1+ny)%ny;
      down = (y-1+ny)%ny;
      mm_0 = mm_0 + spin[x][y];
      ene_0 = ene_0 - 0.5*Jext*spin[x][y]*(spin[left][y] + spin[right][y] + spin[x][up] + spin[x][down]) - Bext*spin[x][y];
    }
  }

  for(T = 1; T<nT; T++)
  {
    KT = KT + 0.005*T;
    for(i = 1; i<total_steps; i++)
    {
      x_temp = round(ran2(seed)*(nx-1));
      y_temp = round(ran2(seed)*(ny-1));
      spin[x_temp][y_temp] = -1*spin[x_temp][y_temp];
      ene = 0.0; mm = 0.0;

      for(x = 0; x<nx; x++)
      {
        left = (x-1+nx)%nx;
        right = (x+1+nx)%nx;
        for(y = 0; y<ny; y++)
        {
          up = (y+1+ny)%ny;
          down = (y-1+ny)%ny;
          mm = mm + spin[x][y];
          ene = ene - 0.5*Jext*spin[x][y]*(spin[left][y] + spin[right][y] + spin[x][up] + spin[x][down]) - Bext*spin[x][y];
        }
      }
      de = ene - ene_0;
      if(de < 0)
      {
        mm_0 = mm;
        ene_0 = ene;
      }
      else if(ran2(seed)*exp(-de/KT) >= ran2(seed))
      {
        mm_0 = mm;
        ene_0 = ene;
      }
      else
      spin[x_temp][y_temp] = -1*spin[x_temp][y_temp];

      if(total_steps - i < 100000)
      {
        avene = avene + ene_0/(nx*ny);
        avmm = avmm + mm_0;
      }
    }
    fprintf(f, "%lf\t%lf\t%lf\n", KT, avmm/100000.0, avene/100000.0);
    avene = 0.0; avmm = 0.0;
  }

  fclose(f);
  return 0;
}
