{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Lsp
    nixd # nix

    ## formating
    shfmt
    treefmt
    nixfmt

    ## C / C++
    gcc
    gdb
    gef
    cmake
    gnumake
    valgrind
    llvmPackages_20.clang-tools

    ## Python
    python3
    python312Packages.ipython

    ## Kotlin
    kotlin

    ## JavaScript / Node.js
    nodejs
    pnpm
    devbox
    bruno
    google-chrome
    ungoogled-chromium

    ## Security
    burpsuite

    ## JetBrains IDEs
    jetbrains.gateway
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains-toolbox

    ## Android / Mobile
    scrcpy
    android-studio

    ## ESP32 / Embedded
    platformio # project management and build workflow
    esptool # Espressif serial flasher
    espflash # fast Rust-based flashing utility
    cargo-espmonitor # serial monitor for Espressif targets
    espup # installs Rust ESP toolchain pieces
    openocd # JTAG / on-chip debugging
    dfu-util # DFU flashing for supported boards/adapters
  ];
}
