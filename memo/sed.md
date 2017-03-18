
# sed

### memo
```
sed -r -e 's/[ \t]*(%wheel[ \t]+ALL=\(ALL\)[ \t]+ALL)/# \1/g' -e 's/[ \t]*#[ \t]*(%wheel[ \t]+ALL=\(ALL\)[ \t]+NOPASSWD:[ \t]*ALL)/\1/g' /etc/sudoers
```

```
sed -n -r -e '/^[ \t]*<Directory .*>/,/^[ \t]*<\/Directory>/p' /etc/httpd/conf/httpd.conf
```

|文字クラス|備考|
|--|--|
|[:alnum:]|英数字 [a-z A-Z 0-9]|
|[:alpha:]|英字 [a-z A-Z]|
|[:blank:]|スペースまたはタブ|
|[:cntrl:]|制御文字|
|[:digit:]|数字 [0-9]|
|[:graph:]|すべての可視文字 (空白文字でないもの)|
|[:lower:]|小文字 [a-z]|
|[:print:]|非制御文字|
|[:punct:]|句読文字|
|[:space:]|空白文字|
|[:upper:]|大文字 [A-Z]|
|[:xdigit:]|十六進数字 [0-9 a-f A-F]|



### Documents
[実例でわかる sed 第 1 回 - 2000年09月01日 - 強力な UNIX テキスト・エディターを使ってみる](https://www.ibm.com/developerworks/jp/linux/library/l-sed1/)<br>
[実例でわかる sed 第 2 回 - 2000年10月01日 - UNIX テキスト・エディターのより有効な利用法](https://www.ibm.com/developerworks/jp/linux/library/l-sed2/)<br>
[実例でわかる sed 第 3 回 - 2000年11月01日 - 次のレベルへ sed 流のデータ加工](https://www.ibm.com/developerworks/jp/linux/library/l-sed3/)<br>

