#
# Date:      2008/02/04 06:13
# Author:    Jan Faigl
#

parser_cmd=$(DOC_ROOT)/Mk/scripts/parse_include.rb

define get-include-search
$($(addprefix INCLUDE_SEARCH_,$(patsubst %-include-info,%,$@)))
endef

define get-include-dest
$($(addprefix INCLUDE_DEST_,$(patsubst %-include-info,%,$@)))
endef

define get-include-output
$(addsuffix .tex,$(addprefix ../,$(patsubst %-include-info,%,$@)))
endef

define get-include-input
$(addsuffix .tex,$(patsubst %-include-info,%,$@))
endef

define parser-clean
$(parser_cmd) clean -o $(get-include-output) -i $(get-include-input)  -s $(get-include-search)  -d $(get-include-dest)
endef

define parser-create
$(parser_cmd) create -o $(get-include-output) -i $(get-include-input)  -s $(get-include-search)  -d $(get-include-dest)
endef

define cleandepend
$(MAKE) -C $(get-include-search) clean
endef

define builddepend
$(MAKE) -C $(get-include-search) all
endef

define cleandepend
$(MAKE) -C $(get-include-search) clean
endef

INCLUDE_INFO=$(addsuffix -include-info,$(INCLUDE_DOCUMENTS))

#.PHONY: $(INCLUDE_INFO)

all: include

include-clean: parser=$(parser-clean)
include-clean: $(INCLUDE_INFO)

include-create: parser=$(parser-create)
include-create: $(INCLUDE_INFO)

depend-build: parser=$(builddepend)
depend-build: $(INCLUDE_INFO)

depend-clean: parser=$(cleandepend)
depend-clean: $(INCLUDE_INFO)

$(INCLUDE_INFO):
	$(parser)

include: .done .depend

.done: 
	$(MAKE) include-create
	touch .done

.depend:
	$(MAKE) depend-build
	touch .depend

clean: clean-include

clean-all: clean-include clean-depend 
	$(MAKE) include-clean
	$(MAKE) depend-clean

clean-include:
	$(RM) .done 

clean-depend:
	$(MAKE) depend-clean
	$(RM) .depend


#clean-depend: $ 

#clean-all: clean-depend clean

#targets:
#	$(parser_cmd) create  -o ../test_results.tex -i test_results.tex -s ../../experiments/hw_tests/ -d hw_tests/

#clean:
#	$(parser_cmd) clean -o ../test_results.tex -i test_results.tex -s ../../experiments/hw_tests/ -d hw_tests/
