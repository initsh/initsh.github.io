boot option: <kbd>Shift</kbd> + <kbd>O</kbd> > `noIOMMU`

```bash
sed '/^kernelopt/s/$/ noIOMMU/g' /bootbank/boot.cfg -i
```

```bash
ln -s /vmfs/volumes/datastore01/img /img
```

```
[root@localhost:~] cat /etc/profile.local
# profile.local
#
export PS1="[$(echo ${VI_USERNAME//'\'/'\\'})@\h:\w] "
# 20170417 #
alias ll='ls -l'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
```

