PACKAGE  = libmadx-dev
RELEASES = https://github.com/MethodicalAcceleratorDesign/MAD-X/archive

# auto-detect version from debian/changelog:
CODENAME = $(shell head -n1 debian/changelog | sed -n 's/.*([0-9a-zA-Z.+~-].*) \([a-z]*\); .*/\1/p')
VERSION  = $(shell head -n1 debian/changelog | sed -n 's/.*(\([0-9a-zA-Z.+~-]*\)-[0-9a-zA-Z.+~].*) .*/\1/p')
REVISION = $(shell head -n1 debian/changelog | sed -n 's/.*([0-9a-zA-Z.+~-]*-\([0-9a-zA-Z.+~].*\)) .*/\1/p')


# upstream version to download:
COMMIT   = 36769507dcfea517aff2f11c0e219c1ae37634cf
DOWNLOAD = build/$(COMMIT).tar.gz
EXTRACT  = MAD-X-$(COMMIT)
UPSTREAM = $(RELEASES)/$(COMMIT).tar.gz

# resulting package files:
TEMP     = build/$(CODENAME)
TARBALL  = $(TEMP)/$(PACKAGE)_$(VERSION).orig.tar.gz
UPLOAD   = $(TEMP)/$(PACKAGE)_$(VERSION)-$(REVISION)_source.changes
BUILDDIR = $(TEMP)/$(PACKAGE)-$(VERSION)

PPA      = https://launchpad.net/~coldfix/+archive/ubuntu/madx


all: prepare makepkg

# download + extract the MAD-X source code: 
$(DOWNLOAD):
	mkdir -p build
	wget --no-verbose $(UPSTREAM) -O $(DOWNLOAD)

$(TARBALL): $(DOWNLOAD)
	mkdir -p $(TEMP)
	cp -r $(DOWNLOAD) $(TARBALL)

$(BUILDDIR): $(TARBALL)
	tar -xzf $(TARBALL)
	mv $(EXTRACT) $(BUILDDIR)

download: $(DOWNLOAD)

prepare: $(TARBALL) $(BUILDDIR)
	cp -r debian $(BUILDDIR)

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

redownload:
	wget $(PPA)/+files/libmadx-dev_$(VERSION).orig.tar.gz
