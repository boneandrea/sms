# What

Send and receive SMS using usb gsm modem (SORACOM AK-020)

# Usage

Setup:
```bash
echo "phone_number='your_phone_number'" > .env
```
https://users.soracom.io/ja-jp/guides/devices/general/raspberry-pi-dongle/

Run:
```bash
bundle install --path vendor/bundle
bundle exec ruby recv.rb  
bundle exec ruby send.rb 本日は海老天なり
```
# How

.envに`device=/dev/ttyUSB1`などと設定する。  
デバイス名は`wvdialconf`で取得する。

```
sudo wvdialconf # 使えるモデム /dev/ttyUSB* を発見してもらう
cu -l /dev/ttyUSB1 # ttyUSB1が見つかったとする
echo "device='/dev/ttyUSB1'" > .env

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


# 関連URL

- https://qiita.com/miiiiiiika/items/0284123d270ef90a4105
