LATEX	= cslatex
LATEXPDF = pdfcslatex
BIBTEX	= bibtex
DVI2PS	= dvips
COMPRESS = gzip
MAKEINDEX = makeindex
SVN=svn


ifdef MK_DIR
-include $(MK_DIR)/paths.mk
else
-include ../Mk/paths.mk
-include ../../Mk/paths.mk
endif

#must be set in upper Makefiles
#COMMON_DIR = ../common


COMMON_LST = $(COMMON_DIR)/lst
COMMON_FIGURES  = $(COMMON_DIR)/fig
COMMON_FIGURES_DONE  = $(COMMON_DIR)/fig/.done
COMMON_FIGURES_MAKEFILE = $(COMMON_DIR)

#for status 
MAKECONFIG="makeconfig.tex"
ifeq ($(BUILD_GLREPORT),yes)
CONFIGURATIONS+="\let\glreport=1"
endif


DOCARC_CMD=$(HOME)/programy/docarc/docarc-client-1.0.2/docarc
DOCARC_BPPATH=$(HOME)/programy/docarc/docarc-client-1.0.2/bp
DOCARC_TMP=docarc_tmp
STATUS=status
SUPPORTDIR = support
define test_support_dir
if test -d $(SUPPORTDIR); then $(MAKE) -C $(SUPPORTDIR)/ copy; fi
endef

$(NAME): ps

ps:  dvi $(DEPENDS)
	$(DVI2PS) $(DVINAME) -o $(NAME).ps

dvi:	pic $(DEPENDS)
	$(LATEX) $(NAME)

pdf:	pic $(DEPENDS)
	$(LATEXPDF) $(NAME)


$(NAME).aux:
	$(LATEX)  $(NAME)

bib:	$(NAME).aux
	$(BIBTEX) $(NAME)

idx:	$(NAME).idx

$(NAME).idx: $(NAME).ilg
	$(MAKEINDEX) $(NAME)

$(NAME).ilg:
	$(LATEX) $(NAME)


all:   common ps pdf

pic: common fig/.done	
	$(TOUCH) fig/.done

fig/.done:
	$(test_support_dir)
	#$(MAKE) -C $(SUPPORTDIR)/ copy

docarc:
	$(CP) $(NAME).aux $(DOCARC_TMP).aux
	$(DOCARC_CMD) -b $(DOCARC_BPPATH) fetch $(DOCARC_TMP)
	$(MV) $(DOCARC_TMP).bib $(NAME).bib
	$(RM) $(DOCARC_TMP).aux

COMMON_FIGURE_FILES= $(patsubst $(COMMON_FIGURES)/%,%,$(wildcard $(COMMON_FIGURES)/*.eps $(COMMON_FIGURES)/*.pdf $(COMMON_FIGURES)/*.png))
COMMON_LST_FILES= $(patsubst $(COMMON_LST)/%,%,$(wildcard $(COMMON_LST)/*))
.PHONY: $(COMMON_FIGURE_FILES) $(COMMON_LST_FILES)

COMMON_LINK_DONE=fig/.common


common: status $(COMMON_LINK_DONE)

$(COMMON_LINK_DONE): 
	$(MAKE) common_lst 
	$(MAKE) common_fig
	$(TOUCH) $(COMMON_LINK_DONE)

common_clean: common_fig_clean common_lst_clean
	$(RM) $(COMMON_LINK_DONE)


# COMMON FIGURES 
$(COMMON_FIGURES_DONE):
	$(MAKE) -C $(COMMON_DIR)

common_fig: COMMON_FIGURE_FILES_CMD=$(common-fig-link)
common_fig: ECHO_MSG=link
common_fig: $(COMMON_FIGURE_FILES)

common_fig_clean: COMMON_FIGURE_FILES_CMD=$(common-fig-clean)
common_fig_clean: ECHO_MSG=unlink
common_fig_clean: $(COMMON_FIGURE_FILES)

$(COMMON_FIGURE_FILES):
	@$(ECHO) "$(ECHO_MSG) common figure file '$@'"
	@$(COMMON_FIGURE_FILES_CMD)

# COMMON LST
common_lst: COMMON_LST_FILES_CMD=$(common-lst-link)
common_lst: ECHO_MSG=link
common_lst: $(COMMON_LST_FILES)

common_lst_clean: COMMON_LST_FILES_CMD=$(common-lst-clean)
common_lst_clean: ECHO_MSG=unlink
common_lst_clean: $(COMMON_LST_FILES)

$(COMMON_LST_FILES):
	@$(ECHO) "$(ECHO_MSG) common list file '$@'"
	@$(COMMON_LST_FILES_CMD)


status: $(TEX_SOURCES)
	@$(ECHO) "Retrieve directory status..."
	@$(ECHO) "\newcommand{\DocumentStatus} { $(shell $(SVN) pg $(STATUS)) }" > $(MAKECONFIG)
#	@$(ECHO) $(shell $(SVN) pg $(STATUS)) >> $(MAKECONFIG)
#	@\$(ECHO) "}" >> $(MAKECONFIG)


clean:
	$(RM) *~ *# *.log *.aux *.toc *.dvi *.gz core *.ps *.pdf makeconfig.tex
	$(RM) fig/.done fig/*.png fig/*.eps fig/*.pdf *.bbl *.blg *.lol *.lof *.lot *.idx *.ilg *.ind *.out fig/*.jpg *.nav *.snm *.tbd

cleanall: clean common_clean
	$(RM) *.snm *.out *.nav
