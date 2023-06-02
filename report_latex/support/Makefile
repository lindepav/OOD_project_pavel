#SUBDIRS+=fig
SUBDIRS+=dia
SUBDIRS+=pic
SUBDIRS+=eps
SUBDIRS+=pdf
#SUBDIRS+=dxf

.PHONY: subdirs $(SUBDIRS) copy clean 

ifeq ($(origin MAKECMDGOALS), undefined)
MAKECMDGOALS = all
endif

subdirs: $(SUBDIRS)

$(SUBDIRS):
	echo "Generate $(MAKECMDGOALS) in $@"
	$(MAKE) -C $@ $(MAKECMDGOALS)

generate: subdirs

clean: subdirs

copy: subdirs

all: generate copy
