<< Calculation of inventories, with libraries generated >>
<< at the collapse and condense stages                  >>

CLOBBER

MONITOR 1 << Echo keywords to output>>

<< Read collapsed and condensed data >>
GETXS 0
GETDECAY 0
FISPACT
* Inventory calculations for XXX 

<< Turn on generation of separate files >>
<< TAB1 10   material compositions >>
<< TAB2 10   activity in Bq and Sv/h >>
TAB4 10   << decay gamma spectra >>

<< Material definition >>
 DENSITY   1.000000    
 FUEL           2
 Fe054   5.3497874E+23
 Fe056   2.6748937E+23
<< Irradiation Scenario >> 
 
UNCERT 0 
SPECTRUM 
FLUX   1.0000000E+19
TIME 2 YEARS SPECTRUM 
FLUX   0.0000000E+00
ZERO 
TIME 0          SPECTRUM                                                                           
TIME 1 DAYS         SPECTRUM        <<  1 day    >>                                              
TIME 11 DAYS        SPECTRUM        << 12 days   >>                    
TIME 18 DAYS        SPECTRUM        << 30 days   >>                       
TIME 30 DAYS        SPECTRUM        << 60 days   >>  
TIME 122.625 DAYS   SPECTRUM        << 0.5 years >>  
TIME 0.5 YEARS      SPECTRUM        <<  1 year   >>                       
TIME 1 YEARS      SPECTRUM          <<  2 year   >> 
TIME 8 YEARS      SPECTRUM          <<  10 year   >> 
END                                                                              
* END of irradiation scenario for arb-flux test 
<< Flux normalized by 1.00000E+00 >>
