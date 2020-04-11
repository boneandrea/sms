# What

Send and receive SMS using usb gsm modem (SORACOM AK-020)

# How

bundle exec ruby recv.rb  
bundle exec ruby send.rb 本日は海老天なり

```
sudo wvdialconf
cu -l /dev/ttyUSB1
systemctl stop ModemManager

cu -l /dev/ttyUSB1
sudo udevadm control --reload-rules
cu -l /dev/ttyUSB1
usb_modeswitch -v 0x15eb -p 0x7d0e --reset-usb
sudo usb_modeswitch -v 0x15eb -p 0x7d0e --reset-usb
```

## Rakeでは
以下をやっている
- rubocop
- generate yardoc
