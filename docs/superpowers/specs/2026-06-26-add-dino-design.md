# Add Dino XMPP Client

Date: 2026-06-26
Status: Approved (pending implementation)

## Goal

Make the [Dino XMPP/Jabber chat client](https://github.com/dino/dino) available on every host managed by this NixOS flake, in line with the existing minimal-app pattern used for `discord` and `thunderbird`.

## Scope

In scope:

- A new home-manager module that installs the `dino` package from nixpkgs.
- Wiring the new module into the home-manager imports list so it applies to every host.

Out of scope:

- Account, server, credential, plugin, or theme configuration.
- Changes to any host's `default.nix`.
- Changes to `modules/core/`.
- New keybindings, waybar entries, or rofi entries.
- Wallpapers, scripts, or other unrelated modules.

## Approach

Create a new file `modules/home/dino.nix` that mirrors `modules/home/discord.nix` exactly, then import it from `modules/home/default.nix` in alphabetical order. No new overlay, no services, no extra runtime packages — `dino` in nixpkgs ships everything GTK4-based it needs.

This was preferred over the two alternatives:

- Inline into `discord.nix`: rejected — the filename would be misleading because dino is XMPP, not Discord, and the file would no longer have a single purpose.
- Use `programs.dino.enable`: rejected — heavier than needed when no declarative configuration is being added, and inconsistent with the existing minimal pattern used by `discord.nix` and `thunderbird.nix` in this repo.

## Changes

### New file: `modules/home/dino.nix`

```nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dino
  ];
}
```

### Edit: `modules/home/default.nix`

Insert a single line in the `imports` list, alphabetically placed between `./discord.nix` (line 11) and `./easyeffects.nix` (line 12):

```nix
    ./dino.nix                         # dino (XMPP client)
```

## Why this fits the repo

- `modules/home/default.nix` is imported once by `modules/core/user.nix` via `./../home`, which means every host (`desktop`, `laptop`, `p14s`, `vm`) gets the new module automatically. No host-specific changes needed.
- `discord.nix` and `thunderbird.nix` already establish the "one small `home.packages` module per app" convention. Following it keeps the module list scannable.
- No services, no firewall ports, no D-Bus rules, no overlays — pure package install.

Testing and validation are performed by the user out-of-band; no verification steps are defined in this spec.

## Risks

- Low. The `dino` package is mature and in nixpkgs.
- If nixpkgs ever drops `dino` (unlikely), the build will fail with an obvious missing-package error pointing at this module — easy to diagnose and fix.
- No security or privacy surface added: no accounts, no secrets, no network services.

## Implementation order

1. Create `modules/home/dino.nix`.
2. Add the import line in `modules/home/default.nix`.
3. `nh os test` against at least one host.
4. `nh os switch`.
5. Smoke-test `dino` launches under Hyprland.
