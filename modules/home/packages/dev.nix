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

    ## JavaScript / Node.js
    nodejs
    devbox
    bruno
    code-cursor
    aider-chat-full
    gemini-cli-bin
    codex
    antigravity
    litellm
    google-chrome
    ungoogled-chromium

    ## Security
    burpsuite

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
