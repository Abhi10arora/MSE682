F90 = ifort
CC =
FFLAGS = -O2 -assume byterecl -g -traceback -par-report0 -vec-report0
CFLAGS =
INCLUDE = #-I/usr/local/include
LIB = #-lfftw3 -lm #-L/home/somnath/Codes/math/lib/ -ltoms757
RM = rm -f

# clear out all suffixes
.SUFFIXES:
# list only those we use
.SUFFIXES: .o .f90

# define a suffix rule for .f90 -> .o and .c -> .o
.c.o 	:
		$(CC)  $(CFLAGS) $(INCLUDE) -c $<
.f90.o 	:
		$(F90) $(FFLAGS) $(INCLUDE) -c $<

TAGT =  md
#In correct order of dependencies
SRCS = modules.f90 main.f90
OBJS = ${SRCS:.f90=.o} 

all :	$(TAGT)

$(TAGT) : $(OBJS)
	  $(F90) -o $(TAGT) $(OBJS) $(LIB)

clean :
	 $(RM) *.o *.mod $(TAGT)
tarfile : 
	tar cvfz MultiSlice`date "+%d%h%Y"`.tgz *.f90 *.gnu *.in *.sh makefile	
