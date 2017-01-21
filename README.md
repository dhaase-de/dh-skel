dh-skel
=======

Essential personal files to make `$HOME` feel like home.


Installation
------------

Symlinks for all files are created via

    ./install.sh

Existing files are backed up, nothing should be lost. See `install.sh` for details.


Packages
--------

* `core`: configs for *command line programs*
* `desktop`: configs for desktop programs (e.g. browser)


TODO
----

* only install files which are versioned in the Git repo (prevents installing garbage files)
* pass packages to be installed as arguments to `install.sh`
* add option to uninstall linked files (and/or revert to last backup)

