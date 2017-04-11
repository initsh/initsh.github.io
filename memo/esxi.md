boot option: <kbd>Shift</kbd> + <kbd>O</kbd> > `noIOMMU`

```bash
sed '/^kernelopt/s/$/ noIOMMU/g' /bootbank/boot.cfg -i
```
