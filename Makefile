PROJECT = KCDFW
DESCRIPTION =
AUTHOR = nootshell

SOURCE_DIR = src
DIST_DIR = dist

INTER_DIR = intermediate
INTER_DIR_PAK = $(INTER_DIR)/pak
INTER_DIR_ZIP = $(INTER_DIR)/zip

INTER_MAN = $(INTER_DIR)/Intermediate.manifest
INTER_PAK = $(INTER_DIR)/Intermediate.pak
INTER_ZIP = $(INTER_DIR)/Intermediate.zip




.PHONY: $(INTER_MAN) meta default clean

default: $(DIST_DIR)/$(PROJECT).zip




clean:
	rm -rf "$(DIST_DIR)" "$(INTER_DIR)";




meta:
	mkdir -p "$(INTER_DIR)";

	rm -rf "$(INTER_DIR)/src";
	cp -a "$(SOURCE_DIR)" "$(INTER_DIR)/src";

	./intermeta.sh "$(INTER_DIR)/src" "$(INTER_MAN)" "$(PROJECT)" "$(AUTHOR)" "$(DESCRIPTION)";


$(INTER_MAN): meta




$(INTER_PAK): meta
	rm -rf "$(INTER_DIR_PAK)";
	mkdir -p "$(INTER_DIR_PAK)";

	cp -a "$(INTER_DIR)/src" "$(INTER_DIR_PAK)/Scripts";

	cd "$(INTER_DIR_PAK)" && 7za a -mx=0 -tzip `basename "$@"` * >/dev/null;
	mv "$(INTER_DIR_PAK)/`basename "$@"`" "$(INTER_PAK)";




$(INTER_ZIP): $(INTER_PAK) $(INTER_MAN)
	rm -rf "$(INTER_DIR_ZIP)";
	mkdir -p "$(INTER_DIR_ZIP)";

	mkdir -p "$(INTER_DIR_ZIP)/$(PROJECT)/Data";
	cp "$(INTER_PAK)" "$(INTER_DIR_ZIP)/$(PROJECT)/Data/Data.pak";

	cp "$(INTER_MAN)" "$(INTER_DIR_ZIP)/$(PROJECT)/mod.manifest";

	cd "$(INTER_DIR_ZIP)" && 7za a -tzip `basename "$@"` * >/dev/null;
	mv "$(INTER_DIR_ZIP)/`basename "$@"`" "$(INTER_ZIP)";




$(DIST_DIR)/$(PROJECT).zip: $(INTER_ZIP)
	mkdir -p "$(DIST_DIR)";
	cp "$(INTER_ZIP)" "$@";
