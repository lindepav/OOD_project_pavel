#
# Date:      2007/06/26 10:45
# Author:    Jan Faigl
#

ifdef MK_DIR
-include $(MK_DIR)/paths.mk
else
-include ../../Mk/paths.mk
-include ../Mk/paths.mk
endif


link_files: $(LINK_FILES)


link_files: LINK_FILES_CMD=$(file-link)
link_files: ECHO_MSG=link
link_files: $(LINK_FILES)

.PHONY: $(LINK_FILES)

$(LINK_FILES):
	@$(ECHO) "$(ECHO_MSG) file '$(notdir $@)'"
	@$(LINK_FILES_CMD)

link_files_clean: LINK_FILES_CMD=$(file-unlink)
link_files_clean: ECHO_MSG=unlink
link_files_clean: $(LINK_FILES)

TARGETS_BUILD=$(addsuffix -build-target,$(XSLT_TARGETS))
TARGETS_CLEAN=$(addsuffix -clean-target,$(XSLT_TARGETS))

ifdef TARGET
XSLT=$($(addprefix TARGET_XSLT_,$(TARGET)))
XML=$($(addprefix TARGET_XML_,$(TARGET)))
OUT=$($(addprefix TARGET_OUT_,$(TARGET)))
  .DEFAULT_GOAL=$(TARGET)
else
  .DEFAULT_GOAL=targets
endif

define get-target-clean-out
$($(addprefix TARGET_OUT_,$(patsubst %-clean-target,%,$@)))
endef

define get-target-xslt
$($(addprefix TARGET_XSLT_,$(patsubst %-build-target,%,$@)))
endef
define get-target-xml
$($(addprefix TARGET_XML_,$(patsubst %-build-target,%,$@)))
endef
define get-target-out
$($(addprefix TARGET_OUT_,$(patsubst %-build-target,%,$@)))
endef

define get-target
$(patsubst %-build-target,%,$@)
endef

clean: clean_targets link_files_clean


targets: link_files $(TARGETS_BUILD)

$(TARGETS_BUILD): 
	$(MAKE) TARGET=$(get-target) $(get-target)

clean_targets: $(TARGETS_CLEAN)

$(TARGETS_CLEAN):
	$(RM) $(get-target-clean-out)


$(TARGET): $(OUT)

$(OUT): $(XLST) $(XML)
	@$(ECHO) "Processing $(XML) by $(XSLT)"
	$(xslt-processing)
