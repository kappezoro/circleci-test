#!/bin/bash

# 改行コードチェックスクリプト

usage_exit() {
    echo "Usage: $0 [-p project] [-e development|staging|production] [-r]" 1>&2
    echo "  Options:" 1>&2
    echo "    -e                    extention type(ex. sql, java,...)" 1>&2
    echo "    -i                    irregular newline type(ex. LF, CRLF)" 1>&2
    echo "    -d                    target directory(optional. default:.)" 1>&2
    exit 1
}

EXTENTION_TYPE=""
IRREGULAR_NEWLINE=""
TARGET_DIRECTORY=.
while getopts e:i:d:h OPT
do
    case $OPT in
        e) EXTENTION_TYPE="${OPTARG}"
           ;;
        i) IRREGULAR_NEWLINE="${OPTARG}"
           ;;
        d) TARGET_DIRECTORY="${OPTARG}"
           ;;
        h) usage_exit
           ;;
    esac
done

if [ -z "${IRREGULAR_NEWLINE}" ]; then
  usage_exit
fi

if [ -z "${EXTENTION_TYPE}" ]; then
  usage_exit
fi

cnt=`find ${TARGET_DIRECTORY} -name "*.${EXTENTION_TYPE}" | xargs nkf --guess | grep \(${IRREGULAR_NEWLINE}\)  | wc -l`

echo $cnt

if [ $cnt -gt 0 ]; then
    echo "${EXTENTION_TYPE}ファイルの中に改行コードが ${IRREGULAR_NEWLINE} のコードが含まれています。"
    find ${TARGET_DIRECTORY} -name "*.${EXTENTION_TYPE}" | xargs nkf --guess | grep \(${IRREGULAR_NEWLINE}\)
    exit 1
fi

