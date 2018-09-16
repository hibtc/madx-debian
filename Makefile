
PACKAGE  = libmadx-dev
VERSION  = 5.04.01
REVISION = 4

RELEASES = https://github.com/MethodicalAcceleratorDesign/MAD-X/archive
DOWNLOAD = $(VERSION).tar.gz
EXTRACT  = MAD-X-$(VERSION)
UPSTREAM = $(RELEASES)/$(DOWNLOAD)

TEMP     = build
TARBALL  = $(TEMP)/$(PACKAGE)_$(VERSION).orig.tar.gz
UPLOAD   = $(TEMP)/$(PACKAGE)_$(VERSION)-$(REVISION)_source.changes
BUILDDIR = $(TEMP)/$(PACKAGE)-$(VERSION)


all: prepare makepkg

# download + extract the MAD-X source code: 
$(TARBALL):
	mkdir -p $(TEMP)
	wget $(UPSTREAM)
	mv $(DOWNLOAD) $(TARBALL)

$(BUILDDIR): $(TARBALL)
	tar -xzf $(TARBALL)
	mv $(EXTRACT) $(BUILDDIR)

download: $(TARBALL)

prepare: $(BUILDDIR)
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
