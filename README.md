# wifiqr

> Generate QR codes of Wi-Fi networks

## Required software

_Eventually, all dependencies should become optional_

- the fish shell (will make a shell-agnostic binary later, in Go)

- ImageMagick (the `display` command)

- The `qrcode` command, install it like this:
  
  ```shell
  $ go install github.com/skip2/go-qrcode/qrcode@latest
  ```

## Optional software

- To leave out some arguments
  
  - _NetworkManager_ as the system's network manager
  
  If you don't have this, you can still use _wifiqr_, but you'll have to provide all arguments (the name, password and "WPA" or "WEP")

## Usage

```
wifiqr [<name> [<password> [WPA|WEP]]]
```

Any unspecified argument will be auto-detected from `/etc/NetworkManager/system-connections/<name>.nmconnection`.

If `<name>` is not specified, it is assumed to be the currently in-use network (see `nmcli dev wifi`)


