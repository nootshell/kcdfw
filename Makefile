PROJECT = KCDFW
DESCRIPTION =
AUTHOR = nootshell

SOURCE_DIR = src
DIST_DIR = dist

INTER_DIR = intermediate




.PHONY: default clean

default: $(DIST_DIR)/$(PROJECT).zip




clean:
	rm -rf "$(DIST_DIR)" "$(INTER_DIR)";




$(DIST_DIR)/$(PROJECT).zip:
	mkdir -p "$(DIST_DIR)";
	scripts/mkmod.sh \
		-i "$(INTER_DIR)" \
		-s "$(SOURCE_DIR)" \
		-a "$(AUTHOR)" \
		-n "$(PROJECT)" \
		-D "$(DESCRIPTION)" \
		-o "$@";
