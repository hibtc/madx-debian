
PACKAGE  = libmadx-dev
VERSION  = 5.04.01

RELEASES = https://github.com/MethodicalAcceleratorDesign/MAD-X/archive
DOWNLOAD = $(VERSION).tar.gz
EXTRACT  = MAD-X-$(VERSION)
UPSTREAM = $(RELEASES)/$(DOWNLOAD)

TEMP     = build
TARBALL  = $(TEMP)/$(PACKAGE)_$(VERSION).orig.tar.gz
BUILDDIR = $(TEMP)/$(PACKAGE)-$(VERSION)


all: prepare makepkg

# download + extract the MAD-X source code: 
$(TARBALL):
	mkdir -p $(TEMP)
	wget $(UPSTREAM)
	tar -xzf $(DOWNLOAD)
	mv $(EXTRACT) $(BUILDDIR)
	rm $(DOWNLOAD)
	tar -czf $(TARBALL) -C $(dir $(BUILDDIR)) $(notdir $(BUILDDIR))

download: $(TARBALL)

prepare: $(TARBALL)
	cp -r debian $(BUILDDIR)

makepkg:
	cd $(BUILDDIR) && debuild -S -sa

deb: clean prepare
	cd $(BUILDDIR) && debuild

install:
	dpkg -i $(TEMP)/*.deb

upload:
	dput ppa:coldfix/madx $(TEMP)/*_source.changes

clean:
	rm -rf $(TEMP)
