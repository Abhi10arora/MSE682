WORKLOC=$PWD
for i in `seq 25 5 50`
do
mkdir $WORKLOC/$i
cd $WORKLOC/$i
for j in `seq 4.6 0.1 5.6`
do
mkdir $WORKLOC/$i/$j
cd $WORKLOC/$i/$j
cat << EOF >> $WORKLOC/$i/$j/Ar.in
#LAMMPS input script for Lattice parameter of solid Ar

units       	metal
variable    	T equal $i
variable	dt equal 0.001
variable	lp equal $j
variable 	E equal etotal

# setup problem

dimension    	3
boundary     	p p p
atom_style	atomic
lattice      	fcc \${lp} orient x 1 0 0 orient y 0 1 0 orient z 0 0 1
region       	box block 0 4 0 4 0 4
create_box   	1 box
create_atoms 	1 box
mass      	1 39.948
pair_style   	lj/smooth 7.5125 8.5125
pair_coeff   	* * 0.0104 3.405
timestep     	\${dt}
dump            1 all atom 50000 config.dump

# equilibration and thermalization

variable	2T equal 2*\$T
velocity     	all create \${2T} 23426753 mom yes rot yes dist gaussian
#fix             pressure all press/berendsen iso 0.0 0.0 10
fix             NVT all nvt temp \$T \$T 0.1
variable	lat_param equal (lx+ly+lz)/12
fix		average all ave/time 1000 10 10000 v_lat_param v_E file data.dat ave running
thermo_style    custom step temp press vol ke pe etotal
thermo		2000
run          	100000
EOF
/usr/bin/lmp_daily < $WORKLOC/$i/$j/Ar.in > $WORKLOC/$i/$j/Ar.out
cd $WORKLOC/$i
done
cd $WORKLOC
done
