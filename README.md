# Flameshot Wrapper for Wayland & Sway

A lightweight Bash utility script designed to overcome known integration issues between **Flameshot** and **Wayland** (specifically `wlroots`-based compositors such as Sway, Hyprland, and COSMIC Desktop), ensuring that screenshot capture, cropping, annotation, and clipboard copying work reliably every time.

---

## 📌 Why Was This Script Created?

While Flameshot is a powerful screenshot and annotation tool, its native integration with Wayland still encounters several frequent issues:

1. **Clipboard Drop (Empty `Ctrl+V`):** In Wayland, due to window security isolation, the clipboard buffer is often lost the moment Flameshot's GUI window closes.
2. **Portal & Environment Conflicts:** Flameshot frequently fails to recognize or connect to the correct screencopy portal (`xdg-desktop-portal-wlr`) without explicit desktop environment variables.
3. **Stuck / Zombie Processes:** Previous aborted or failed screenshot attempts can leave orphan Flameshot processes running in the background, blocking any subsequent capture requests.

---

## ⚙️ What Does This Script Solve?

- **Persistent Clipboard via `wl-copy`:** Forces Flameshot to save the edited capture to a temporary file (`/tmp/screenshot_edit.png`) and immediately injects it into the Wayland clipboard buffer using native `wl-clipboard`, guaranteeing that `Ctrl+V` works in any application.
- **Enforced Wayland Environment:** Explicitly exports `XDG_CURRENT_DESKTOP=sway`, `XDG_SESSION_TYPE=wayland`, and `SDL_VIDEODRIVER=wayland` before invoking the GUI.
- **Zombie Process Cleanup:** Silently runs `killall flameshot` prior to execution to clear any hanging background instances.
- **Visual Desktop Feedback:** Emits a native desktop notification via `notify-send` when the screenshot has been successfully copied to the clipboard.

### 🖥️ Multi-Monitor Behavior
On Sway, multi-display screenshots frequently suffer from coordinate mismatch or black screens. Through this portal-based workflow, **the compositor merges all active displays into a single continuous canvas projected onto the main screen**. 

While this may visually span or stretch displays during the initial selection overlay, **it is currently one of the most reliable methods to capture any region across any monitor without crashes or blank outputs**.

---

## 📦 Dependencies

Make sure the following packages are installed on your system:

### Debian / Ubuntu / Pop!_OS / Kali
```bash
sudo apt update && sudo apt install -y flameshot wl-clipboard libnotify-bin xdg-desktop-portal-wlr
```

### Arch Linux / Manjaro
```bash
sudo pacman -S flameshot wl-clipboard libnotify xdg-desktop-portal-wlr
```

### Fedora
```bash
sudo dnf install flameshot wl-clipboard libnotify xdg-desktop-portal-wlr
```

---

## 🚀 Installation & Usage

### 1. Clone the Repository
```bash
git clone https://github.com/Carlos-HDO/flameshot-wayland.git
cd flameshot-wayland
```

### 2. Make Scripts Executable
```bash
chmod +x flameshot-wayland.sh install.sh
```

### 3. Quick Install (Recommended)
Run the bundled installer to symlink the script directly to your `~/.local/bin`:
```bash
./install.sh
```

This creates the following global commands:
* `flameshot-wayland`
* `flameshot-sway`

> [!TIP]
> Ensure that `~/.local/bin` is in your `PATH`. If it is not, add this line to your `~/.bashrc` or `~/.zshrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

### 4. Direct Manual Execution
If you prefer running the script without installing it globally:
```bash
./flameshot-wayland.sh
```

---

## ⌨️ Setting Up Keyboard Shortcuts

### Sway (`~/.config/sway/config`)
Add either of the following rules to bind the capture to your `PrintScreen` key or a custom combination:

```text
# Capture using PrintScreen key
bindsym Print exec flameshot-wayland

# Alternative shortcut (Mod4/Super + Shift + S)
bindsym $mod+Shift+s exec flameshot-wayland
```

Reload your Sway configuration:
```bash
swaymsg reload
```

### Hyprland (`~/.config/hypr/hyprland.conf`)
```text
bind = , Print, exec, flameshot-wayland
bind = $mainMod SHIFT, S, exec, flameshot-wayland
```

### COSMIC Desktop (Pop!_OS)
1. Navigate to **Settings** > **Keyboard** > **Custom Shortcuts**.
2. Click **Add Shortcut**:
   - **Name**: Flameshot Wayland
   - **Command**: `flameshot-wayland` *(or the full path to `flameshot-wayland.sh`)*
   - **Shortcut**: Press the desired key (e.g., `Print`).

---

## 📄 License

Distributed under the [MIT](LICENSE) License. Feel free to use, modify, and contribute!
