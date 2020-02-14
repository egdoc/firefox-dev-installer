DESTDIR = $(HOME)/.local
OPTDIR = $(DESTDIR)/opt
BINDIR = $(DESTDIR)/bin
LAUNCHERDIR = $(DESTDIR)/share/applications
URL = https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64

.PHONY: all
all: clean install

.PHONY: clean
clean:
	rm -rf firefox firefox-dev.desktop

.PHONY: download
download:
	curl --location --silent "$(URL)" \
	  | tar --directory=$(CURDIR) --extract --bzip2

firefox-dev.desktop:
	sed \
	  -e "s_{{BINDIR}}_$(BINDIR)_g" \
	  -e "s_{{OPTDIR}}_$(OPTDIR)_g" \
	  -e "s_{{LAUNCHERDIR}}_$(LAUNCHERDIR)_g" \
	  data/launcher_template.desktop > firefox-dev.desktop

.PHONY: install
install: download firefox-dev.desktop
	mkdir -p $(OPTDIR)
	cp -R $(CURDIR)/firefox $(OPTDIR)
	ln -s $(OPTDIR)/firefox/firefox $(BINDIR)/firefox-dev
	cp firefox-dev.desktop $(LAUNCHERDIR)

.PHONY: uninstall
uninstall:
	rm -rf \
	  $(OPTDIR)/firefox \
	  $(LAUNCHERDIR)/firefox-dev.desktop \
	  $(BINDIR)/firefox-dev
