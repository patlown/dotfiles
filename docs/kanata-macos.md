# Kanata on macOS

This Mac is on macOS 15.5. Kanata is installed through Homebrew, but macOS support depends on Karabiner's virtual HID driver and system permissions.

## Current State

`kanata` is managed by Homebrew.

The shared config is stowed to:

```sh
~/.config/kanata/kanata.kbd
```

It currently includes common Apple built-in keyboard names and the `Adv360 Pro` keyboard in `macos-dev-names-include` so Kanata does not try to grab Karabiner's virtual keyboard.

Karabiner Elements is listed in the Brewfile because its package installs the virtual HID support Kanata needs on modern macOS. The package installer requires an interactive administrator password, so it is not expected to install cleanly from a non-interactive agent session.

## Known macOS Caveats

Kanata release notes for recent versions say macOS 11 and newer require Karabiner DriverKit VirtualHIDDevice v6.2.0, and macOS support is not directly validated by the maintainer.

GitHub issues/discussions show common failure modes:

- `IOHIDDeviceOpen error: (iokit/common) not permitted`
- no keyboard device can be registered
- launchd plist ownership must be `root:wheel`
- Karabiner Elements running at the same time can conflict with Kanata startup
- macOS updates can invalidate or disable Karabiner permissions/drivers

## Setup Rule

Do not enable Kanata as a background service until it works in the foreground.

Use this order:

1. Install Kanata.
2. Install Karabiner Elements interactively.
3. Approve the Karabiner system extension and required Privacy & Security prompts.
4. Test Kanata in a terminal with a minimal config.
5. Only then consider a launchd service.

Foreground test:

```sh
sudo kanata --no-wait --cfg ~/.config/kanata/kanata.kbd
```

If launchd is added later, create plist files outside the repo first, then install them with `sudo` so ownership is correct.
