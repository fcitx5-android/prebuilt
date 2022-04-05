#!/usr/bin/env bash

set -euxo pipefail

OUT_DIR="./chinese-addons-data"
if [ -f "$OUT_DIR" ]; then
    echo "$OUT_DIR is a file"
    exit 1
fi
if [ -d "$OUT_DIR" ]; then
    rm -r "$OUT_DIR"
fi
mkdir -p "$OUT_DIR/pinyin"
mkdir -p "$OUT_DIR/pinyinhelper"

# translated from https://github.com/fcitx/fcitx5-chinese-addons/blob/v5.0.9/im/pinyin/CMakeLists.txt

CHINESE_ADDONS_REPO="https://raw.githubusercontent.com/fcitx/fcitx5-chinese-addons/"
CHINESE_ADDONS_TAG="5.0.9"

DICT_TXT_FILES=(emoji.txt chaizi.txt)

for DICT_TXT_FILE in "${DICT_TXT_FILES[@]}"; do
    curl -LO "$CHINESE_ADDONS_REPO/$CHINESE_ADDONS_TAG/im/pinyin/$DICT_TXT_FILE"
    DICT_FILE="${DICT_TXT_FILE/.txt/.dict}"
    libime_pinyindict "$DICT_TXT_FILE" "$OUT_DIR/pinyin/$DICT_FILE"
done

# https://github.com/fcitx/fcitx5-chinese-addons/blob/v5.0.9/modules/pinyinhelper/CMakeLists.txt

PY_STROKE_VER=20121124
PY_STROKE_TGT="py_stroke.mb"
PY_STROKE_TAR="py_stroke-${PY_STROKE_VER}.tar.gz"
PY_STROKE_URL="http://download.fcitx-im.org/data/${PY_STROKE_TAR}"

curl -LO $PY_STROKE_URL
tar xf $PY_STROKE_TAR
mv $PY_STROKE_TGT "$OUT_DIR/pinyinhelper/$PY_STROKE_TGT"

PY_TABLE_VER=20121124
PY_TABLE_TGT="py_table.mb"
PY_TABLE_TAR="py_table-${PY_TABLE_VER}.tar.gz"
PY_TABLE_URL="http://download.fcitx-im.org/data/${PY_TABLE_TAR}"

curl -LO $PY_TABLE_URL
tar xf $PY_TABLE_TAR
mv $PY_TABLE_TGT "$OUT_DIR/pinyinhelper/$PY_TABLE_TGT"
