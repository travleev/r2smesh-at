# This Makefile requires GNU Make

#--------------------------------------------------------------------------
## revision information
##      $Date: 2011/04/01 19:36:30 $
##      $Name: Release-2-20-01 $
##      $RCSfile: Makefile,v $
##      $Revision: 1.6 $
#--------------------------------------------------------------------------
include config.inc

# If building ouside of the source tree copy this Makefile to
# the build directory together with a config.inc file and change
# TOPDIR to the path to the source directory.
# Set to default location, if TOPDIR has not been set in the
# config file.
TOPDIR?=..

include $(TOPDIR)/config/sources.inc
MAIN=fispact
MAINF=$(addsuffix .f90,$(MAIN))
MAINO=$(MAINF:.f90=.o)
ARLIB=$(addprefix lib,$(MAINF:.f90=.a))

SOURCE_PATHS = $(SOURCES) 

F77_SOURCE_PATHS = $(F77SOURCES)

SOURCE_FULL_PATHS=$(addprefix $(TOPDIR)/,$(SOURCE_PATHS))
SOURCE_FILES=$(notdir $(SOURCE_FULL_PATHS))
SOURCE_DIRS=$(sort $(dir $(SOURCE_FULL_PATHS)))
OBJECTS=$(SOURCE_FILES:.f90=.o)
MODULES=$(SOURCE_FILES:.f90=.mod)

F77_SOURCE_FULL_PATHS=$(addprefix $(TOPDIR)/,$(F77_SOURCE_PATHS))
F77_SOURCE_FILES=$(notdir $(F77_SOURCE_FULL_PATHS))
F77_SOURCE_DIRS=$(sort $(dir $(F77_SOURCE_FULL_PATHS)))
F77_OBJECTS=$(F77_SOURCE_FILES:.f=.o)

DISTDIR=./distribution
DIST_FILES=$(SOURCE_FILES) $(MAINF) $(F77_SOURCE_FILES)
DIST_FULL_PATH=$(addprefix $(DISTDIR)/,$(DIST_FILES))
DIST_TGZ=$(addsuffix .tar.gz,$(MAIN))

vpath %.f90 $(SOURCE_DIRS) 
vpath %.f $(F77_SOURCE_DIRS)

#-----------------------------------------------------------------------
# compile and link FISPACT
fispact: $(OBJECTS) $(F77_OBJECTS) $(MAINO)
	ar -ruvs $(ARLIB)  $(OBJECTS) $(F77_OBJECTS)
	$(F90) $(F90FLAGS) -o $(MAIN) $(MAINO) $(ARLIB) $(LIBS)

$(MAINO) : %.o : %.f90
	$(F90) $(F90FLAGS) -c $<

$(OBJECTS) : %.o : %.f90
	$(F90) $(F90FLAGS) -c $<

$(F77_OBJECTS) : %.o : %.f
	$(F90) $(F77FLAGS) -c $<
#-----------------------------------------------------------------------
# create static library of fispact modules
lib:  $(OBJECTS) $(F77_OBJECTS)
	ar -ruvs $(ARLIB) $(OBJECTS) $(F77_OBJECTS) 
#-----------------------------------------------------------------------
# create dependencies file
depend: depend.inc

depend.inc:  $(SOURCE_FULL_PATHS)
	$(PERL) $(TOPDIR)/build/sfmakedepend -f depend.inc $(SFMDFLAGS) $(SOURCE_FULL_PATHS)
#-----------------------------------------------------------------------
# clean up
clean:
	rm -f $(OBJECTS) $(F77_OBJECTS) $(MAINO) *$(MOD) $(EXTRA_CLEAN_FILES)
	$(EXTRA_CLEAN)

distclean: clean
	rm -f $(MAIN) $(ARLIB) $(DIST_TGZ) depend.inc
	rm -fr $(DISTDIR)
#-----------------------------------------------------------------------
# create source distribution file
$(DIST_FULL_PATH): $(DISTDIR)/% : %
	ln -s ../$< $(DISTDIR)

$(DIST_TGZ): $(DISTDIR) $(DIST_FULL_PATH)
	tar -czh -C $(DISTDIR) -f $@ $(DIST_FILES)

$(DISTDIR):
	mkdir $@

dist: $(DIST_TGZ)
#-----------------------------------------------------------------------
.PHONY : depend clean distclean  dist

include depend.inc
