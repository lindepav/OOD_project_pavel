#
# Data:		2006/04/19 12:00
# Author:	Jan Faigl
#
# General Makefile

ifdef MK_DIR
-include $(MK_DIR)/paths.mk
else
-include ../Mk/paths.mk
-include ../../Mk/paths.mk
endif

LATEXPDFTESTFLAGS=-halt-on-error -file-line-error

MAKECONFIG="makeconfig.tex"
ifeq ($(BUILD_GLREPORT),yes)
CONFIGURATIONS+="\let\glreport=1"
endif

ifeq ($(NO_COLOR_LINKS),yes)
CONFIGURATIONS+="\def\clinks{false}"
endif

SUPPORTDIR = support

DEPENDS+=version
DEPENDS+=pre-build

ifndef WITHOUT_PS
name_target=ps
else
name_target=pdf
endif

$(NAME): $(name_target)

ps:  dvi $(DEPENDS)
	$(DVI2PS) $(DVINAME) -o $(NAME).ps

dvi:	pic $(DEPENDS)
	$(LATEX) $(NAME)

pdf:	pic $(DEPENDS)
	$(LATEXPDF) $(NAME)

buildtest: pic $(DEPENDS)
	$(LATEXPDF) $(LATEXPDFTESTFLAGS) $(NAME) >$(LOG_FILE)




$(NAME).aux:
	$(LATEX)  $(NAME)

bib:	$(NAME).aux
	$(BIBTEX) $(NAME)

idx:	$(NAME).idx

$(NAME).idx: $(NAME).ilg
	$(MAKEINDEX) $(NAME)

$(NAME).ilg:
	$(LATEX) $(NAME)


all:   ps pdf

pre-build: PRE_BUILD_CMD=$(MAKE) -C $@
pre-build: $(PRE_BUILD)

pre-build-clean: PRE_BUILD_CMD=$(MAKE) -C $@ clean
pre-build-clean: $(PRE_BUILD)

$(PRE_BUILD):
	$(PRE_BUILD_CMD)

pic: fig/.done	
	$(TOUCH) fig/.done

fig/.done:
	$(MAKE) -C $(SUPPORTDIR)/ copy

docarc:
	$(CP) $(NAME).aux $(DOCARC_TMP).aux
	$(DOCARC_CMD) -b $(DOCARC_BPPATH) fetch $(DOCARC_TMP)
	$(MV) $(DOCARC_TMP).bib $(NAME).bib
	$(RM) $(DOCARC_TMP).aux

TEX_SOURCES=$(wildcard *.tex)

.PHONY: $(PRE_BUILD)

clean: cleanmakeconfig pre-build-clean
	$(RM) *~ *# *.log *.aux *.toc *.dvi *.gz core *.ps *.pdf
	$(RM) fig/.done fig/*.png fig/*.eps fig/*.pdf *.bbl *.blg *.lol *.lof *.lot *.idx *.ilg *.ind *.out fig/*.jpg *.nav *.snm *.tbd

cleanmakeconfig: 
	$(RM) makeconfig.tex

cleanall: clean cleanmakeconfig
	$(MAKE) -C $(SUPPORTDIR)/ clean
	$(RM) *.snm *.out *.nav

config: configure version

configure:
	@$(ECHO) "configure $(MAKECONFIG)"
	@$(ECHO) $(CONFIGURATIONS) > $(MAKECONFIG)

glreport: 
	$(MAKE) BUILD_GLREPORT=yes config
	$(MAKE) BUILD_GLREPORT=yes

version: configure $(TEX_SOURCES)
#	@$(ECHO) "Retrieve directory SVN Revision"
#	@$(ECHO) "\newcommand{\SVNRevision}{" >> $(MAKECONFIG)
#	@$(SVN_INFO) | $(GREP) "Last Changed Rev" | $(AWK) -v FS=: '{print "Revision" $$2}' >> $(MAKECONFIG)
#	@\$(ECHO) "}" >> $(MAKECONFIG)
