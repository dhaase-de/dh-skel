dh-skel
=======

Essential personal files to make `$HOME` feel like home.


Installation
------------

Symlinks for all files are created via

    ./install.sh [package1] [package2] [...]

If no packages are specified, all valid packages are considered (see below).
Existing files are backed up, nothing should be lost. See `install.sh` for details.


Uninstallation
--------------

Similar to installation

    ./install.sh -u [package1] [package2] [...]

If no packages are specified, all valid packages are considered (see below).


Packages
--------

* `core`: config files for command line programs
* `utils`: small helper scripts and programs


TODO
----

* only install files which are versioned in the Git repo (prevents installing garbage files)

