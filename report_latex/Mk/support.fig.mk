#
# Date:      2007/04/18 10:14
# Author:    Jan Faigl
#
# Makefile to support generating figures from fig (xfig) files 

-include $(MK_DIR)/paths.mk

FIG=$(wildcard *.fig)
EPS=$(patsubst %.fig,%.eps,$(wildcard *.fig))
PDF=$(patsubst %.fig,%.pdf,$(wildcard *.fig))

DEST_DIR=../../fig/

CZECHFILE="cestina.txt"


copy_targets=copy_pdf

ifndef WITHOUT_PS
targets+=eps 
pdf_target=pdf_from_eps
copy_targets+=copy_eps
echo "SHIT SHIT SHIT SHIT"
else
pdf_target=pdf_only
endif


DEST_PDF=$(addprefix $(DEST_DIR),$(PDF))
DEST_EPS=$(addprefix $(DEST_DIR),$(EPS))

targets+=$(pdf_target)

all: $(targets)

eps: $(EPS)

pdf: $(pdf_target)

%.eps: %.fig
	$(FIGURECMD) -L eps $< $@
	$(CPCXFIG) $(CZECHFILE) $@

pdf_only: $(PDF)

pdf_from_eps: $(EPS) $(PDF)


%.pdf: %.eps
	$(EPS2PDF) $<

%.pdf: %.fig
	$(FIGURECMD) -L eps $< $(basename $@).eps
	$(CPCXFIG) $(CZECHFILE) $(basename $@).eps
	$(EPS2PDF) $(basename $@).eps
	$(RM) $(basename $@).eps

clean:
	$(RM) $(EPS) $(PDF)

.PHONY: $(DEST_PDF) $(DEST_EPS)

copy: $(copy_targets)

copy_pdf: pdf $(DEST_PDF)

copy_eps: eps $(DEST_EPS)

$(DEST_PDF): $(DEST_DIR)%.pdf: %.pdf
	@$(ECHO) Start copy $< to $@$(shell $(TEST) -L $@ && $(UNLINK) $@ && $(ECHO) ", but remove existing link in $(DEST_DIR) at first") 
	@$(CP) $< $@

$(DEST_EPS): $(DEST_DIR)%.eps: %.eps
	@$(ECHO) Start copy $< to $@$(shell $(TEST) -L $@ && $(UNLINK) $@ && $(ECHO) ", but remove existing link in $(DEST_DIR) at first") 
	@$(CP) $< $@
