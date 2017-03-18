
# sed

```
sed -r -e 's/[ \t]*(%wheel[ \t]+ALL=\(ALL\)[ \t]+ALL)/# \1/g' -e 's/[ \t]*#[ \t]*(%wheel[ \t]+ALL=\(ALL\)[ \t]+NOPASSWD:[ \t]*ALL)/\1/g' /etc/sudoers
```

```
sed -n -r -e '/^[ \t]*<Directory .*>/,/^[ \t]*<\/Directory>/p' /etc/httpd/conf/httpd.conf
```
