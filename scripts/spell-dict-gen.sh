#!/usr/bin/env bash

# translated from https://github.com/fcitx/fcitx5/blob/master/src/modules/spell/dict/CMakeLists.txt

set -euxo pipefail

OUT_DIR="./spell-dict"
if [ -f "$OUT_DIR" ]; then
    echo "$OUT_DIR is a file"
    exit 1
fi
if [ -d "$OUT_DIR" ]; then
    rm -r "$OUT_DIR"
fi
mkdir -p "$OUT_DIR"

SPELL_EN_DICT_VER=20121020
SPELL_EN_DICT_TAR="en_dict-${SPELL_EN_DICT_VER}.tar.gz"
SPELL_EN_DICT_URL="https://download.fcitx-im.org/data/${SPELL_EN_DICT_TAR}"

curl -LO "$SPELL_EN_DICT_URL"
tar xf "$SPELL_EN_DICT_TAR"

SPELL_EN_DICT="${OUT_DIR}/en_dict.fscd"
SPELL_EN_DICT_SRC="./en_dict.txt"
/usr/lib/fcitx5/libexec/comp-spell-dict --comp-dict "${SPELL_EN_DICT_SRC}" "${SPELL_EN_DICT}"
