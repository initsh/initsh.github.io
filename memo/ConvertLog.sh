#!/bin/bash

### ログ整形スクリプト
### $1 ... ログファイル

# 変数 (variable)
v_logfile="$1"
v_output_logfile="$1".formatted.log

# アウトプットログファイルを初期化する。
cat /dev/null > "${v_output_logfile}"

# アウトプットログファイルの初期化に失敗した場合、標準エラー出力にログを出力し、異常終了する。
if [ ! -f "${v_output_logfile}" ]
then
    echo "$(date -Is) [ERROR]: Failed to initialize output log file \"${v_output_logfile}\"." > /dev/stderr
    exit 1
fi

# ログ整形を実施する。
perl -p -e 's/([^-].*[^-])\n/\1\t/g' "${v_logfile}" > "${v_output_logfile}"

# 正常終了する。
exit 0
