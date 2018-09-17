# You must specify the debian release CODENAME on the command line
# for different releases (using, e.g. `make RELEASE=xenial`):
CODENAME ?= trusty
CODEDATE ?= 14.04

PACKAGE  = libmadx-dev
VERSION  = 5.04.01+post1
REVISION = 1
SUFFIX   = ~ppa1~ubuntu$(CODEDATE)

RELEASES = https://github.com/MethodicalAcceleratorDesign/MAD-X/archive
COMMIT   = 36769507dcfea517aff2f11c0e219c1ae37634cf
DOWNLOAD = build/$(COMMIT).tar.gz
EXTRACT  = MAD-X-$(COMMIT)
UPSTREAM = $(RELEASES)/$(DOWNLOAD)

TEMP     = build/$(CODENAME)
TARBALL  = $(TEMP)/$(PACKAGE)_$(VERSION).orig.tar.gz
UPLOAD   = $(TEMP)/$(PACKAGE)_$(VERSION)-$(REVISION)$(SUFFIX)_source.changes
BUILDDIR = $(TEMP)/$(PACKAGE)-$(VERSION)


all: prepare makepkg

# download + extract the MAD-X source code: 
$(DOWNLOAD):
	mkdir -p build
	wget $(UPSTREAM) -O $(DOWNLOAD)

$(TARBALL): $(DOWNLOAD)
	mkdir -p $(TEMP)
	cp -r $(DOWNLOAD) $(TARBALL)

$(BUILDDIR): $(TARBALL)
	tar -xzf $(TARBALL)
	mv $(EXTRACT) $(BUILDDIR)

download: $(DOWNLOAD)

prepare: $(TARBALL) $(BUILDDIR)
	cp -r debian $(BUILDDIR)
	sed -i 's/) UNRELEASED/$(SUFFIX)) $(CODENAME)/' $(BUILDDIR)/debian/changelog

makepkg:
	cd $(BUILDDIR) && debuild -S

deb: clean prepare
	cd $(BUILDDIR) && debuild

install:
	dpkg -i $(TEMP)/*.deb

upload:
	dput ppa:coldfix/madx $(UPLOAD)

clean:
	rm -rf $(BUILDDIR)
