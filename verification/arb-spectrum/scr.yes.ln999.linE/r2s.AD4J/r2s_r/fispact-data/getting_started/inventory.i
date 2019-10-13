<< -----set initial switches and get nuclear data----- >>
NOHEAD
MONITOR 1  
GETXS 0 
GETDECAY 0 
FISPACT
* IRRADIATION OF TI EEF FW 1.0 MW/M2

<< -----set initial conditions----- >>
MASS 1.0 1
TI 100.0
FLUX 4.27701E+14
MIND 1.E5
GRAPH 2 2 1 1 4
UNCERT 2
ATOMS
HAZARDS
HALF 
ATWO 

<< -----irradiation phase----- >>
TIME 2.5 YEARS 
ATOMS

<< -----cooling phase----- >>
FLUX 0.
ZERO
TIME 1 MINS ATOMS
TIME 1 HOURS ATOMS
TIME 1 DAYS ATOMS
TIME 7 DAYS ATOMS
TIME 1 YEARS ATOMS
END
* END
