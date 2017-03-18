
# sed

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
