
PACKAGE  = libmadx-dev
VERSION  = 5.02.05

RELEASES = http://madx.web.cern.ch/madx/releases
DOWNLOAD = madx-src.tgz
EXTRACT  = madx-$(VERSION)
UPSTREAM = $(RELEASES)/$(VERSION)/$(DOWNLOAD)

TEMP     = build
TARBALL  = $(TEMP)/$(PACKAGE)_$(VERSION).orig.tar.gz
BUILDDIR = $(TEMP)/$(PACKAGE)-$(VERSION)


all: prepare makepkg

# download + extract the MAD-X source code: 
prepare:
	mkdir -p $(TEMP)
	wget $(UPSTREAM)
	tar -xzf $(DOWNLOAD)
	mv $(EXTRACT) $(BUILDDIR)
	rm $(DOWNLOAD)
	tar -czf $(TARBALL) -C $(dir $(BUILDDIR)) $(notdir $(BUILDDIR))
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
