MAD-X debian package
--------------------

This repository contains utilities to create a ``libmadx-dev`` debian package
for a static library build of MAD-X_.

.. _MAD-X: http://cern.ch/mad

This is an unofficial build of MAD-X that is not supported by CERN, i.e. in
case of problems you will not get help there.

The main purpose of this PPA is to speed up testing of cpymad_ on Travis_.
Therefore, only the default `Travis CI environment`_ is supported for now.
Email me if you want to use this package on another version of ubuntu.


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


Files
~~~~~

Now edit the contents of the ``debian/`` folder as well as the ``Makefile``
according to your needs. In particular the following files need to be updated:

- ``debian/changelog``: add a new entry (``dch -v VERSION``), see also
  `Version numbers`_ for the targeted ubuntu release.

- ``Makefile``: update the ``COMMIT`` variable. It should usually be set to
  ``COMMIT=$(VERSION)`` unless doing a post-release.

Less frequently you may also need to change:

- ``debian/control``: dependencies, conflicts, description

- ``debian/rules``: build recipe: cmake parameters


Trigger package build
~~~~~~~~~~~~~~~~~~~~~

Pushing a new commit will trigger Travis CI to build a new source package. If
this succeeds, create a tag and push it to make travis upload the source
package, e.g.::

   git tag 5.04.01-2
   git push --tag


In order to add another ubuntu release that is available on travis, add a
corresponding entry in ``.travis.yml`` under the ``matrix:`` section.


Version numbers
~~~~~~~~~~~~~~~

The version format is assumed to be ``upstream_version-revision``, where
``upstream_version`` is the MAD-X version number and ``revision`` starts at 1
and is incremented in every package revision for the same upstream release.

If building manually, you should add a suffix ``~ubuntuYY.MM`` with the
release date of the targeted ubuntu release after the revision number.

For example, for the second revision of MAD-X 5.04.02, the full version targeted
on ubuntu 14.04 (trusty) is::

    5.04.02-2~ubuntu14.04

It is important to uphoald this format, otherwise launchpad may reject your
present or future uploads (see Troubleshooting_).

See Version_ on how debian version numbers are formed.

.. _Version: https://www.debian.org/doc/debian-policy/ch-controlfields.html#version


Building manually
=================

Setup environment
~~~~~~~~~~~~~~~~~

To get going, first install packaging tools:

.. code-block:: bash

    # technical requirements:
    sudo apt-get install build-essential devscripts debhelper

    # OR if you don't care about lots installed packages that are
    # unnecessary at this point but may come in handy later, you can just
    # do the following:
    sudo apt-get install packaging-dev

Create and publish a gnupg key:

.. code-block:: bash

    gpg --full-generate-key
    gpg --send-keys --keyserver keyserver.ubuntu.com <KEY-ID>

It is important to use exactly the same name and email address as in the
changelog. Furthermore, the *comment* field counts towards the name and is
therefore best avoided.

Import the key at: https://launchpad.net/~coldfix/+editpgpkeys

Configure your name and email to be used for packaging in your ``~/.bashrc``:

.. code-block:: bash

    export DEBEMAIL=t_glaessle@gmx.de
    export DEBFULLNAME="Thomas Gläßle"

Then reload the file (``source ~/.bashrc``) or simply restart your terminal.


Build and upload
~~~~~~~~~~~~~~~~

From there on, proceed as follows:

.. code-block:: bash

    # make sure, there are no left-overs from previous attempts:
    make clean

    # download MAD-X and make source package:
    make

    # upload final source package:
    make upload

After uploading, add one entry at a time for all older supported ubuntu
versions via ``dch -v`` and ``make && make upload`` each time. The changelog
text for these entries should be ``* backport of version XXXX``.

Currently, the targeted ubuntu versions are::

    xenial (16.04)
    trusty (14.04)

The default make target is actually composed of two steps:

.. code-block:: bash

    # download and extract MAD-X into build/ subdirectory:
    make prepare

    # create the source archive:
    make makepkg

If there is need to things manually, I also want to mention these
lower-level commands:

.. code-block:: bash

    cd build/trusty/libmadx-dev-*

    # create source package and upload. `-sa` means force upload
    # the `.orig.tar.gz` file
    debuild -S -sa
    dput ppa:coldfix/madx ../libmadx-dev-*_source.changes

    # OR create and install .deb package
    debuild
    sudo dpkg -i ../libmadx-dev-*.deb


Troubleshooting
~~~~~~~~~~~~~~~

When uploading a new package revision for the same upstream release, the
uploaded source tarball (``.orig.tar.gz``) must be exactly the same, or
else the upload will be rejected. Normally, this shouldn't happen. If it
does, however, the options are:

- add a ``+postN`` suffix in the ``upstream_version`` part and reupload.
  This is the preferred route if the previous tarball was corrupted, or
  if doing a post-release (i.e. a release on a later commit than the
  upstream release), the full version number becomes, e.g.::

    5.04.01+post1-1~ubuntu14.04

- if the source tarball in the current directory is corrupted, instead
  redownload the source tarball from launchpad::

    make redownload


Resources
=========

Debian packaging is quite complicated. These are some of the resources that
helped creating this repository:

http://www.infodrom.org/Debian/doc/maint/Maintenance-pkgbuild.html

http://packaging.ubuntu.com/html/

https://www.debian.org/doc/debian-policy/

https://www.debian.org/doc/manuals/maint-guide/

https://www.debian.org/doc/manuals/developers-reference/best-pkging-practices.html

https://wiki.debian.org/IntroDebianPackaging

http://developer.ubuntu.com/publish/apps/other-forms-of-submitting-apps/ppa/

http://askubuntu.com/questions/28562/how-do-i-create-a-ppa-for-a-working-program
