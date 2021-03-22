Scripts to generate and apply patches see in github.com/travleev/patch-scripts.


1. Get scripts::

    >git clone git@github.com:travleev/patch-scripts.git

2. Go to folder where a modified MCNP versions will be placed::

    >cd path/to/mcnp5_r2s

3. Apply patches::

    >patch_apply.sh   /path/to/MCNP_DIST/MCNP_CODE/MCNP5   MCNP5_r2s_mat     path/to/kit-materials.patch.5
    >patch_apply.sh   /path/to/MCNP_DIST/MCNP_CODE/MCNP5   MCNP5_r2s_gamma   path/to/kit-gamma.patch.5

These commands create two folders `MCNP5_r2s_mat` and `MCNP5_r2s_gamma` with
files copied from the original MCNP distribution (that need to be obtained
separately) and patched with necessary modifications. As with standard MCNP,
both can be compiled with ``Source/install`` script.

        
