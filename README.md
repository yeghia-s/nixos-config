# nixos-config

My NixOS configuration for a **ThinkPad T14 Gen 4**, managed with flakes, Home Manager, and sops-nix.

## System

| | |
|---|---|
| **Machine** | Lenovo ThinkPad T14 Gen 4 |
| **Architecture** | x86_64-linux |
| **Channel** | nixos-unstable |
| **WM** | Hyprland (via UWSM) |
| **Display Manager** | greetd + tuigreet |
| **Terminal** | Alacritty |
| **Bar** | Waybar |
| **Shell** | Zsh |

## Features

- **Flakes** with a locked `flake.lock` for reproducibility
- **Home Manager** integrated as a NixOS module
- **sops-nix** for secrets management (age encryption) — credentials for vdirsyncer/khal are encrypted at rest
- **Fingerprint authentication** via fprintd with the `goodix-550a` driver (see note below)
- **Animated wallpaper** via mpvpaper
- **Google Calendar sync** via vdirsyncer + khal, configured through Home Manager with sops-nix
- **Dev shells** for Flutter/Dart (Stoat client) and OpenGL/C++ (game engine)

## Structure

```
.
├── configuration.nix        # Core system configuration
├── fingerprint.nix          # Fingerprint auth (goodix-550a driver)
├── flake.nix                # Flake inputs and outputs
├── hardware-configuration.nix
├── .sops.yaml               # sops-nix key configuration
├── secrets/                 # Age-encrypted secrets
└── home/                    # Home Manager configuration
    └── default.nix          # Entry point for user environment
```

## Dev Shells

Two dev shells are defined in `flake.nix`:

```bash
# Flutter/Dart development (Stoat client)
nix develop

# OpenGL/C++ development (game engine)
nix develop .#opengl
```

## Fingerprint Auth (goodix-550a)

The T14 Gen 4 uses a Goodix 550a fingerprint sensor that requires a specific driver not in the standard fprintd package. This is handled in `fingerprint.nix`. If you have the same hardware, this file is the relevant piece — stock fprintd will not work.

To enroll a finger after applying the config:

```bash
fprintd-enroll
```

## Secrets

Secrets are managed with [sops-nix](https://github.com/mic92/sops-nix) and encrypted with [age](https://github.com/FiloSottile/age). The private key is **not** in this repository. To use this config on a new machine, generate a new age key and re-encrypt the secrets with your key added to `.sops.yaml`.

```bash
# Generate an age key
age-keygen -o ~/.config/sops/age/keys.txt

# Re-encrypt secrets after adding your public key to .sops.yaml
sops updatekeys secrets/secrets.yaml
```

## Applying

```bash
# Clone the repo
git clone https://github.com/yeghia-s/nixos-config
cd nixos-config

# Apply system configuration
sudo nixos-rebuild switch --flake .#nixos

# Home Manager is applied as part of nixos-rebuild
```

## Notes

- `config.allowUnfree = true` is set in the flake for packages that require it
- This config is specific to my hardware — `hardware-configuration.nix` in particular should be regenerated for a different machine with `nixos-generate-config`
