nf       -- MCNP workplace for calculation of neutron flux distributions
md       -- modified MCNP workplace for calculation of material allocation
input    -- folder with input data for activation calculations
out, log -- results and log information from the activation calculations
dg       -- modifiec MCNP workplace for decay gamma transport.

To start:

1. Set environment variables
FISPACT -- to the fispact-II executable. 
FISPACT_DATA -- to the folder containing EAF2007 and EAF2010 data sets from the standard fispact-II distribution

2. Source "global" r2s settings:
>. ../scripts/r2s_env.sh 

3. Run adriver by $r2s_driver
