rpath-replace script
--------------------

Small script to update embedded rpath data in a list of libraries.
If the files have the matching rpath info, replace that with a
different value.

Uses the `patchelf` utility and assumes several hardcodes inside
the script (namely: list of ELF binaries to update and  paths to
search/replace on).

This has only be lightly tested and has minimal error checking.

See also
--------
 - [Wiki: patchelf](https://github.com/naughtont3/techbits/wiki/patchelf)

