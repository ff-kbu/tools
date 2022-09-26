#!/usr/bin/env bash
# Ubiquiti firmware flasher - by Julian Zielke <freifunk@databunker.eu>

# settings
DEVICE_IP="192.168.1.20"
DEVICE_USR="ubnt"
DEVICE_PASSWORD="ubnt"
GLUON_VERSION="2021.1.2"
FW_BASE_URL="https://images.ffkbu.de/multihood/stable/Wireguard/sysupgrade"
FW_UAP_AC_PRO_GEN2_SRC_URL="$FW_BASE_URL/gluon-ffkbu-v$GLUON_VERSION-Wireguard-ubiquiti-unifi-ac-pro-sysupgrade.bin"

# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING!

_log() {
  if [ "$TERM" == "xterm-256color" ]; then
    textRed=$(tput setaf 1)
    textYellow=$(tput setaf 3)
    textNormal=$(tput sgr0)
  fi

  if [ "${1}" == "WARN" ]; then
    printf '%-7s %s\n' "${textYellow}[$1]${textNormal}" "$2" >&2
    return 0
  elif [ "${1}" == "ERROR" ]; then
    printf '%-7s %s\n' "${textRed}[$1]${textNormal}" "$2" >&2
    exit 1
  else
    echo "$1"
  fi
}

function ctrl_c() {
  _log ""
  _log "ERROR" "Aborted!"
}

_waitForDevice() {
  trap ctrl_c INT
  i=0
  printf "%s" "Waiting for reponse from $DEVICE_IP..."
  while ! ping -c1 -n -W1 "$DEVICE_IP" &> /dev/null
  do
      printf "%c" "."
      ((i=i+1))
      if [ $i -eq 60 ]; then
        printf "\n%s\n"  ""
        _log "ERROR" "Connection timeout!"
        exit 1
      fi
  done
  printf "%s\n" "OK"
}

_waitForReboot() {
  trap ctrl_c INT
  i=0
  printf "%s" "Waiting for device to reboot..."
  while ping -c1 -n -W1 "$DEVICE_IP" &> /dev/null
  do
      printf "%c" "."
      ((i=i+1))
      if [ $i -eq 60 ]; then
        printf "\n%s\n"  ""
        _log "ERROR" "Timeout!"
        exit 1
      fi
  done
  printf "\n%s\n" "OK"
}

_log "
Ubiquiti firmware flasher - by Julian Zielke <freifunk@databunker.eu>
"

_log "Checking prerequisites..."
command -v sshpass > /dev/null || _log "ERROR" "sshpass not found - please install it first!"
command -v wget > /dev/null || _log "ERROR" "wget not found - please install it first!"
_log "WARN" "Make sure your computer is able to connect to your device at $DEVICE_IP (check network settings)!"

sshCmd="sshpass -e ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o LogLevel=ERROR -o UserKnownHostsFile=/dev/null $DEVICE_USR@$DEVICE_IP"
export SSHPASS="$DEVICE_PASSWORD"

while true; do
  _log ""
  read -rp "Proceed? (yes/no) " yn
  case $yn in
    yes|y) break;;
     no|n) _log "ERROR" "Aborted!";;
       * ) _log "Invalid response!";;
  esac
done

_waitForDevice

$sshCmd echo "test" &> /dev/null || _log "ERROR" "SSH connection failed!"
hwModel=$($sshCmd mca-cli-op info | awk '/Model/{ print $2 }')

case $hwModel in
  "UAP-AC-Pro-Gen2") firmwarSrcURL="$FW_UAP_AC_PRO_GEN2_SRC_URL";;
                  *) _log "ERROR" "Identified model '$hwModel' not supported!" ;;
esac

_log "Identified model: $hwModel"
_log "Firmware: ${firmwarSrcURL##*/}"

while true; do
  _log ""
  read -rp "Ready to flash firmware - proceed? (yes/no) " yn
  case $yn in
    yes|y) break;;
     no|n) _log "ERROR" "Aborted!";;
       * ) _log "Invalid response!";;
  esac
done


kernel0Block=$($sshCmd cat /proc/mtd | awk -F  ':' '/"kernel0"$/{ print substr($1,4)}')
[ -z "$kernel0Block" ] && _log "ERROR" "kernel0 not found!"
_log "Kernel 0 found at mtdblock$kernel0Block"

kernel1Block=$($sshCmd cat /proc/mtd | awk -F  ':' '/"kernel1"$/{ print substr($1,4)}')
[ -z "$kernel1Block" ] && _log "ERROR" "kernel1 not found!"
_log "Kernel 1 found at mtdblock$kernel1Block"

bsBlock=$($sshCmd cat /proc/mtd | awk -F  ':' '/"bs"$/{ print substr($1,4)}')
[ -z "$bsBlock" ] && _log "ERROR" "bsBlock not found!"
_log "BS found at mtdblock$bsBlock"

_log "Uploading Firmware ${firmwarSrcURL##*/}..."
wget -q -t1 --timeout=10 -O- "$firmwarSrcURL" | $sshCmd "cat > /tmp/firmware.bin" || _log "ERROR" "Error while uploading firmware to device!"

# see: https://forum.freifunk.net/t/scp-tftp-downgrade-bei-unifi-ac-ab-firmware-4-3-x-geht-nicht-mehr/23422/10?u=tux1984
_log "Probing for locked kernels..."
$sshCmd "if [ -f /proc/ubnthal/.uf ]; then echo '5edfacbf' > /proc/ubnthal/.uf; fi"
sleep 1

_log "Writing firmware to mtdblock$kernel0Block..."
$sshCmd dd if=/tmp/firmware.bin of=/dev/mtdblock$kernel0Block &>/dev/null || _log "ERROR" "Error writing mtdblock$kernel0Block!"

_log "Writing firmware to mtdblock$kernel1Block..."
$sshCmd dd if=/tmp/firmware.bin of=/dev/mtdblock$kernel1Block &>/dev/null || _log "ERROR" "Error erasing mtdblock$kernel1Block!"

_log "Erasing mtd$bsBlock..."
$sshCmd dd if=/dev/zero bs=1 count=1 of=/dev/mtd$bsBlock &>/dev/null || _log "ERROR" "Error erasing mtd$bsBlock!"

_log "Flashing complete! Rebooting to gluon..."
$sshCmd reboot || _log "ERROR" "Error while rebooting!"
_log "After your device has rebooted, hold the reset button until it reboots again. Then it should be accessible at 192.168.1.1!"

unset $SSHPASS
exit 0
