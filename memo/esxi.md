boot option: <kbd>Shift</kbd> + <kbd>O</kbd> > `noIOMMU`

```
sed -i '/^kernelopt/s/$/ noIOMMU/g' /bootbank/boot.cfg
```
