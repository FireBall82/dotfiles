# Home Manager Improvements

## High priority

- [ ] Rotate and remove the Gemini API key in `home-manager/modules/fish.nix`.
- [ ] Replace the tracked credential with a secret-managed environment setup or user prompt.
- [ ] Fix `home.file."/.config/mako/config"` in `home-manager/modules/mako.nix` so it targets `.config/mako/config` in the user's home directory.
- [ ] Align monitor names across the desktop configurations:
  - Standard Hyprland and Hyprpaper use `HDMI-A-1`.
  - Minimal Hyprland and Hyprpaper use `HDMI-A-1` and `HDMI-A-5`.
  - Niri uses `HDMI-A-5`.
- [ ] Replace `HDMI-A-5` wallpaper and Niri output rules with the actual connector name or make them dynamically appropriate.
- [ ] Replace hard-coded wallpaper paths in the Hyprland, minimal Hyprland, and Niri-related configurations with variables or stable locations.
- [ ] Replace hard-coded `/home/diller` paths with `$HOME` or Home Manager variables to improve portability.
- [ ] Move personal Git user name and email to a private local override or a machine-specific Home Manager configuration.
- [ ] Add a secret-scanning check and prevent credentials from being committed again.

## Configuration correctness

- [ ] Add a Home Manager flake check/CI workflow for `nix flake check`.
- [ ] Add a test or local command that runs `nixfmt --check` on all Nix files.
- [ ] Validate generated configuration files with their native tools after activation.
- [ ] Remove or rewrite the unused `config`, `pkgs`, and `lib` function arguments where they are not used.
- [ ] Remove duplicate Mako, Dunst, and Waybar notification implementations or document which compositor uses each.
- [ ] Decide whether Niri and Hyprland should be mutually exclusive and document that choice.
- [ ] Enable Noctalia from a clean, reproducible module instead of commented-out Hyprland and import state.
- [ ] Remove stale commented-out Hyprland configuration blocks when no longer useful.
- [ ] Centralize shared variables such as terminal, launcher, monitor names, and keyboard layout.
- [ ] Add consistent workspace assignments for Niri and verify they do not conflict with Hyprland conventions.
- [ ] Verify that all packages referenced by scripts and key bindings are included in `home.packages` or module dependencies.
- [ ] Audit absolute executable and configuration paths in Hyprland, Niri, Fish, and shell scripts.
- [ ] Add XDG directory variables for screenshots, wallpapers, cache, and application state.
- [ ] Confirm Fish plugin declarations and package declarations do not duplicate each other unintentionally.
- [ ] Add shell aliases and scripts to activate the minimal Hyprland session explicitly.

## Reliability and maintenance

- [ ] Pin and document the required Nix/Home Manager versions for a reproducible setup.
- [ ] Document how to bootstrap, switch, test, rollback, and update the Home Manager configuration.
- [ ] Split the large `hyprland.nix` and Niri configuration files into focused modules.
- [ ] Add a machine/profile layer so laptop-only monitor and hardware settings are not applied to every host.
- [ ] Replace fixed display modes and scaling values with environment-specific profiles.
- [ ] Add `nix flake update` instructions or automation that opens reviewable dependency updates.
- [ ] Add a rollback or backup step before replacing generated configuration files.
- [ ] Add Home Manager activation assertions for required programs, directories, and monitor names.
- [ ] Add formatting and linting instructions to the repository's main documentation.
- [ ] Create a small smoke-test script for important configuration paths and executable references.

## Related issues already filed

- Issue #4: Rotate and remove the exposed Gemini API key.
- Issue #5: Fix the Mako Home Manager target path.
- Issue #6: Align Hyprpaper monitor names with Hyprland.
