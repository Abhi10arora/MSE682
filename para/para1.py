import math
import random

f = open('output.txt','w')
n = 1000
nT = 100
nloop = 1000000
dT = 0.1
spin = [0 for i in range(n)]
spin_0 = [1 for i in range(n)]
M = 0
ene = 0
ene_0 = 0
de = 0

for T in range(1,nT):
    sum_ene = 0
    for i in range(nloop):
#        spin = list(spin_0)
        ene_0 = -1*sum(spin_0)

        temp = random.randint(0,n-1)
        spin_0[temp] = -1*spin_0[temp]
        ene = -1*sum(spin_0)
        de = ene - ene_0

        if de < 0:
            spin_0 = list(spin)
            M = sum(spin)
        elif math.exp(-de/(T*dT)) > random.random():
            spin_0 = list(spin)
            M = sum(spin)
        else:
            M = sum(spin_0)

        if nloop - i < 100000:
            sum_ene = sum_ene - M

    f.write("%f \t %f \t %f \n" % (dT*T, (sum_ene/100000), -(sum_ene/100000)))

f.close()
