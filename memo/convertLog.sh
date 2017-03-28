#!/bin/bash
################################
### - ログ整形結合スクリプト
###     $1 ... ログzipファイルが設置されるディレクトリをフルパスで指定
###     $2 ... 整形結合処理を行った後のログファイルを保存するディレクトリをフルパスで指定
###
### - ログ整形処理の内容
###     1. TAB文字 "\t" を 半角スペース " " に変換する
###     2. 後段のCSV変換のため、現在のログファイルに含まれる カンマ "," を エイリアス文字列 "%comma%" に変換する
###     3. IWSSログのデリミタ "--------" をアンカーに、ログを1行のCSVにマージする
################################



################################
### 定数 (CONSTANT)
################################
### 一時ファイル出力用の作業ディレクトリを定義
declare C_WORK_DIR="/data/work"
### 結合するログの接頭文字列をログの種類毎に配列に格納
### 備考：結合対象のログである、ファイル名 ISALOG_YYYYmmdd_WEB_seq.iis および access_log.YYYY.mm.dd.seq の接頭文字列を格納しています。
declare -a A_LOG_PREFIX=("ISALOG_" "access.log.")
### 整形処理を実行するログファイルの接頭文字列を配列に格納
### 備考：IWSSのログである、ファイル名 access_log.YYYY.mm.dd.seq の接頭文字列を格納しています。
declare -a A_CONVERT_REQUIREMENTS=("access.log.")



################################
### 初期判定
################################
### スクリプト内でエラーが発生した場合、異常終了
set -e

### 引数 $1 がフルパス指定のディレクトリでない場合、標準エラー出力にログを出力し、異常終了
if [ ! -d "$1" -o -z "$(echo "$1" | grep ^/)" ]
then
    echo "$(date -Is) [ERROR] \$1 expect directory FULL path zipped logfile." >>/dev/stderr
    exit 1
fi

### 引数 $2 がフルパス指定のディレクトリでない場合、標準エラー出力にログを出力し、異常終了
if [ ! -d "$2" -o -z "$(echo $2 | grep ^/)" ]
then
    echo "$(date -Is) [ERROR] \$2 expect directory FULL path converted logfile." >>/dev/stderr
    exit 1
fi



################################
### 変数 (variable)
################################
declare v_zipfile_dir="$1"
declare v_converted_logfile_dir="$2"
declare v_zipfile_list="$(find "${v_zipfile_dir}" -name "*.zip")"
declare v_logfile_prefix=
declare v_converted_logfile_name_tmp=
declare v_converted_logfile_name=
declare v_converted_logfile=
declare i=
declare v_convert_requirements=



################################
### main
################################
### ログzipファイルが存在しない場合、標準エラー出力にログを出力し、異常終了
if [ -z "${v_zipfile_list}" ]
then
    echo "$(date -Is) [ERROR]: No log zipfile." >>/dev/stderr
    exit 1
fi

### ディレクトリ C_WORK_DIR に移動し、ログzipファイルを解凍
cd "${C_WORK_DIR}"
echo "${v_zipfile_list}" | while read LINE
do
    unzip -o "${LINE}" >/dev/null

    ### 配列 A_LOG_PREFIX に含まれるログファイルの接頭文字列に従いログを結合
    for v_logfile_prefix in "${A_LOG_PREFIX[@]}"
    do
        ### ディレクトリ内の昇順最上位のファイル名を取得
        v_converted_logfile_name_tmp="$(ls "${C_WORK_DIR}/${v_logfile_prefix}"* 2>/dev/null | head -n 1)"
        ### ディレクトリの中に接頭文字列が一致するログファイルが存在する場合
        if [ -f "${v_converted_logfile_name_tmp}" ]
        then
            ### 処理後ログファイルの名前を定義
            v_converted_logfile_name="$(basename "${v_converted_logfile_name_tmp}")"
            ### 処理後ログファイルの格納ディレクトリを定義＆作成
            v_converted_logfile_hostname_dir="${v_converted_logfile_dir}/$(basename `dirname ${LINE}`)"
            mkdir -p "${v_converted_logfile_hostname_dir}"
            ### 処理後ログファイルのフルパスを定義
            v_converted_logfile="${v_converted_logfile_hostname_dir}/${v_converted_logfile_name}"

            ### 処理後ログファイルを初期化
            cat /dev/null > "${v_converted_logfile}"
            
            ### ログの整形結合処理を実行
            v_convert_requirements="$(for i in "${A_CONVERT_REQUIREMENTS[@]}"; do echo -ne "$i|"; done | sed -r -e 's/\|$//g')"
            if echo "${v_logfile_prefix}" | egrep "${v_convert_requirements}" >/dev/null
            then
                cat "${C_WORK_DIR}/${v_logfile_prefix}"* | perl -p -e 's/\t/ /g; s/,/%comma%/g; s/\r\n/,/g; s/^-+,$/\r\n/g' | perl -p -e 's/,\r\n/\r\n/g'> "${v_converted_logfile}"
            else
                cat "${C_WORK_DIR}/${v_logfile_prefix}"* > "${v_converted_logfile}"
            fi

            ### ゴミ掃除
            \rm "${C_WORK_DIR:?}/${v_logfile_prefix:?}"*
        else
            ### ディレクトリの中に接頭文字列が一致するログファイルが存在しない場合、次のループへ
            continue
        fi
    done
done
cd - >/dev/null


### 正常終了
exit 0
