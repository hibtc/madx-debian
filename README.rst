MAD-X debian package
--------------------

This repository contains templates needed to create a ``libmadx-dev``
ubuntu source package for a shared library installation of MAD-X_. The
suffix ``-dev`` indicates that the package also contains all necessary
files to link against the shared library.

.. _MAD-X: http://cern.ch/mad


Disclaimer
==========

This is an unofficial build of MAD-X that is not supported by CERN, i.e. in
case of problems you will not get help there.


Usage
=====

The result is uploaded to a personal package archive (PPA) `on launchpad`_
which builds a binary (.deb) package from it. If you are running ubuntu,
you can use this PPA as follows:

.. code-block:: bash

    # add repository:
    sudo add-apt-repository ppa:coldfix/madx

    # install library:
    sudo apt-get install libmadx-dev

The main purpose of this PPA is to speed up testing of cpymad_ on Travis_.
Therefore, only the default `Travis CI environment`_ is supported for now,
i.e. ubuntu 12.04 LTS 64bit (precise pangolin).

.. _on launchpad: https://launchpad.net/~coldfix/+archive/ubuntu/madx/
.. _cpymad: https://github.com/hibtc/cpymad
.. _Travis: https://travis-ci.org/hibtc/cpymad
.. _Travis CI environment: http://docs.travis-ci.com/user/ci-environment/#CI-environment-OS


Updating
========

This section contains information for anyone (Hi, to you too, *future-me*!)
who wants to create their own MAD-X package or update this package to a
newer MAD-X version. This assumes you are running on a reasonably
up-to-date version of ubuntu.

To get going, first install packaging tools:

.. code-block:: bash

    # technical requirements:
    sudo apt-get install build-essential devscripts debhelper

    # OR if you don't care about lots installed packages that are
    # unnecessary at this point but may come in handy later, you can just
    # do the following:
    sudo apt-get install packaging-dev

Now you may edit the contents of the ``debian/`` folder (in particular the
files ``changelog`` and ``control``) as well as the ``Makefile`` according
to your needs. From there on, there might be multiple things you might want
to do:

.. code-block:: bash

    # make sure, there are no left-overs from previous attempts:
    make clean

    # download and extract MAD-X into build/ subdirectory:
    make prepare
    cd build/libmadx-dev-*

    # create source package and upload
    debuild -S -sa
    dput ppa:coldfix/madx libmadx-dev-*_source.changes

    # OR create and install .deb package
    debuild
    sudo dpkg -i ../libmadx-dev-*.deb


Resources
=========

Debian packaging is quite complicated. These are some of the resources that
helped creating this repository:

http://www.infodrom.org/Debian/doc/maint/Maintenance-pkgbuild.html

http://packaging.ubuntu.com/html/

https://www.debian.org/doc/manuals/maint-guide/

https://www.debian.org/doc/manuals/developers-reference/best-pkging-practices.html

https://wiki.debian.org/IntroDebianPackaging

http://developer.ubuntu.com/publish/apps/other-forms-of-submitting-apps/ppa/

http://askubuntu.com/questions/28562/how-do-i-create-a-ppa-for-a-working-program
