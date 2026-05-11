{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libnfc
    mfoc
    mfoc-hardnested
    mfcuk
  ];

  environment.etc."nfc/libnfc.conf".text = ''
    # PN532 over HSU/UART on the USB serial adapter detected by `nfc-list`.
    # Keep this explicit so libnfc opens the known-good reader directly.
    allow_autoscan = false
    allow_intrusive_scan = false
    log_level = 1

    device.name = "PN532 HSU ttyUSB0"
    device.connstring = "pn532_uart:/dev/ttyUSB0"
  '';
}
