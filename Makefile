
MADX_VERSION  = 5.02.04
MADX_RELEASES = http://madx.web.cern.ch/madx/releases
MADX_TARBALL  = madx-$(MADX_VERSION).tgz
MADX_RENAME   = madx_$(MADX_VERSION).orig.tar.gz
MADX_UPSTREAM = $(MADX_RELEASES)/$(MADX_VERSION)/$(MADX_TARBALL)
MADX_SOURCES  = madx-$(MADX_VERSION)


all: prepare makepkg

# download + extract the MAD-X source code: 
prepare:
	mkdir -p spkg
	wget $(MADX_UPSTREAM)
	tar -xzf $(MADX_TARBALL)
	mv $(MADX_TARBALL) spkg/$(MADX_RENAME)
	mv $(MADX_SOURCES) spkg/$(MADX_SOURCES)
	cp -r debian spkg/$(MADX_SOURCES)

makepkg:
	cd spkg/$(MADX_SOURCES) && debuild -S -sa

deb: clean prepare
	cd spkg/$(MADX_SOURCES) && debuild

install:
	dpkg -i spkg/*.deb

upload:
	dput ppa:coldfix/madx spkg/madx_$(MADX_VERSION)-1_source.changes

clean:
	rm -rf spkg

