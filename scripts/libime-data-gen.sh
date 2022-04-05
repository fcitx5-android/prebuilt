#!/usr/bin/env bash

# translated from https://github.com/fcitx/libime/blob/master/data/CMakeLists.txt

set -euxo pipefail

OUT_DIR="./libime"
if [ -f "$OUT_DIR" ]; then
    echo "$OUT_DIR is a file"
    exit 1
fi
if [ -d "$OUT_DIR" ]; then
    rm -r "$OUT_DIR"
fi
mkdir -p "$OUT_DIR/data"
mkdir -p "$OUT_DIR/table"

LIBIME_REPO="https://raw.githubusercontent.com/fcitx/libime"
LIBIME_TAG="1.0.7"

curl -LO "$LIBIME_REPO/$LIBIME_TAG/data/convert_open_gram_arpa.py"
curl -LO "$LIBIME_REPO/$LIBIME_TAG/data/convert_open_gram_dict.py"

OPENGRAM_LM_TAR="lm_sc.3gm.arpa-20140820.tar.bz2"
OPENGRAM_LM_URL="https://download.fcitx-im.org/data/$OPENGRAM_LM_TAR"
OPENGRAM_LM_HASH="751bab7c55ea93a2cedfb0fbb7eb09f67d4da9c2c55496e5f31eb8580f1d1e2f"

curl -LO "$OPENGRAM_LM_URL"
echo "$OPENGRAM_LM_HASH $OPENGRAM_LM_TAR" | sha256sum --check --status
tar xf "$OPENGRAM_LM_TAR"

OPENGRAM_LM_SRC="./kenlm_sc.arpa"
OPENGRAM_LM_OUTPUT="$OUT_DIR/data/zh_CN.lm"
OPENGRAM_LM_PREDICT_OUTPUT="$OUT_DIR/data/zh_CN.lm.predict"

python ./convert_open_gram_arpa.py ./lm_sc.3gm.arpa > "$OPENGRAM_LM_SRC"
libime_slm_build_binary -s -a 22 -q 8 trie "$OPENGRAM_LM_SRC" "$OPENGRAM_LM_OUTPUT"
libime_prediction "$OPENGRAM_LM_OUTPUT" "$OPENGRAM_LM_SRC" "$OPENGRAM_LM_PREDICT_OUTPUT"

OPENGRAM_DICT_TAR="dict.utf8-20211021.tar.xz"
OPENGRAM_DICT_URL="https://download.fcitx-im.org/data/$OPENGRAM_DICT_TAR"
OPENGRAM_DICT_HASH="300597e6f7f79f788480fd665de8a07bfe90227048b5a7e39f40f43a62a981df"

curl -LO "$OPENGRAM_DICT_URL"
echo "$OPENGRAM_DICT_HASH $OPENGRAM_DICT_TAR" | sha256sum --check --status
tar xf "$OPENGRAM_DICT_TAR"

OPENGRAM_DICT_SRC="./dict.converted"
OPENGRAM_DICT_OUTPUT="$OUT_DIR/data/sc.dict"

python ./convert_open_gram_dict.py ./dict.utf8 > "$OPENGRAM_DICT_SRC"
libime_pinyindict "$OPENGRAM_DICT_SRC" "$OPENGRAM_DICT_OUTPUT"

TABLE_DICT_TAR="table.tar.gz"
TABLE_DICT_URL="https://download.fcitx-im.org/data/$TABLE_DICT_TAR"
TABLE_DICT_HASH="6196053c724125e3ae3d8bd6b2f9172d0c83b65b0d410d3cde63b7a8d6ab87b7"
TABLE_TXT_FILES=(db.txt erbi.txt qxm.txt wanfeng.txt wbpy.txt wbx.txt zrm.txt cj.txt)

curl -LO "$TABLE_DICT_URL"
echo "$TABLE_DICT_HASH $TABLE_DICT_TAR" | sha256sum --check --status
tar xf "$TABLE_DICT_TAR"

for TABLE_TXT_FILE in "${TABLE_TXT_FILES[@]}"; do
    TABLE_DICT_FILE="${TABLE_TXT_FILE/.txt/.main.dict}"
    libime_tabledict "$TABLE_TXT_FILE" "$OUT_DIR/table/$TABLE_DICT_FILE"
done
