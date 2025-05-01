## Overview

[Hyprland](https://github.com/vaxerski/Hyprland) is a dynamic tiling Wayland compositor based on wlroots that doesn't sacrifice on its looks.

- **Operating System** : `Archcraft`
- **Window Manager** : `Hyprland (0.27.2)`
- **Status Bar** : `Waybar`
- **Launcher** : `Rofi` / `Wofi`
- **Session Manager** : `Rofi` / `Wlogout`
- **Notifications** : `Mako / Dunst`
- **Terminal** : `Kitty`
- **File Manager** : `Thunar`
- **Text Editor** : `Geany / Kate`
- **Web Browser** : `Brave / Firefox`

## Config Structure
```
~/.config
└── hypr               : Hyprland config directory
    ├── foot           : Terminal config
    ├── mako           : Notification daemon config
    │   └── icons      : Notification icons
    ├── rofi           : Rofi config files
    ├── scripts        : Scripts for functionality
    ├── wallpapers     : Wallpapers
    ├── waybar         : Statusbar config
    ├── wlogout        : Wlogout config
    │   └── icons      : Session icons
    ├── wofi           : Launcher config
    ├── hyprland.conf  : Hyprland config file
    └── hyprtheme.conf : Colors and theme elements file
```

## NVIDIA
If you're on `Archcraft` and install the provided package, There's nothing else you need to do to run it on NVIDIA machine. The package's post_installation script does it all, And the compositor should work fine.

If you're running any other distribution and want to install this setup on your Nvidia machine, You need to do some tweaking. In this guide, I'm assuming you're using **Arch Linux**. Follow the steps below to make this Wayland compositor work on NVIDIA :

- Install **NVIDIA Drivers** on your system. [NVIDIA](https://wiki.archlinux.org/title/NVIDIA) 
- Edit `/etc/mkinitcpio.conf` file and add **`nvidia`** kernel modules
```
MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
```

- In the same file, Remove `kms` hook from hooks array if present.
- Rebuild your initrd file with : `sudo mkinitcpio -P linux`
- Edit `/etc/default/grub` file and add **`nvidia_drm.modeset=1`** kernel parameter for NVIDIA
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia_drm.modeset=1 ..."
```

- Update your grub config file with : `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- Reboot your NVIDIA Machine and login to your Wayland compositor, It should work now.

More Information: [NVIDIA#Installation](https://wiki.archlinux.org/title/NVIDIA#Installation), [NVIDIA#DRM_kernel_mode_setting](https://wiki.archlinux.org/title/NVIDIA#DRM_kernel_mode_setting)

## Keybindings

|					Keys					|						Action						|
|-------------------------------------------|---------------------------------------------------|
| Super + Return         					| Open terminal            							|
| Super + Shift + Return 					| Open floating terminal							|
| Super + Alt + Return   					| Open terminal with selected geometry 				|
| Super + Shift + F 						| Open file manager 								|
| Super + Shift + E 						| Open text editor 									|
| Super + Shift + W 						| Open web browser									|
| Super , Super + D 						| Run app launcher 									|
| Super + X 								| Run powermenu 									|
| Super + N 								| Open network manager 								|
| Super + P 								| Run colorpicker 									|
| Super + C/Q 								| Kill active window 								|
| Super + L     							| Run lockscreen 									|
| Ctrl  + Alt + Delete 						| Exit Hyprland instantly 							|
| Super + F 								| Toggle fullscreen mode 							|
| Super + Space 							| Toggle floating mode 								|
| Super + S 								| Toggle pseudo mode 								|
| Super + Left / Right / Up / Down 			| Change focus of the container 					|
| Super + Shift + Left / Right / Up / Down 	| Move active container directionally 				|
| Super + Ctrl + Left / Right / Up / Down 	| Resize active container 							|
| Super + Alt + Left / Right / Up / Down 	| Move floating container directionally 			|
| Super + Tab 								| Cycle between container 							|
| Super + 1,2..12 							| Change Workspace/Tag from 1 to 12					|
| Super + Ctrl + 1,2..12 					| Move active window and follow to Workspace/Tag	|
| Super + Shift + 1,2..12 					| Move active window to Workspace/Tag				|
| Super + Ctrl + F 							| Toggle All floating mode 							|
| Super + Ctrl + S 							| Toggle All pseudo mode 							|
| Super + Shift + P 						| Pin floating container 							|
| Super + Shift + S 						| Swap next container 								|
| Super + G 								| Toggle Group Mode 								|
| Super + H 								| Change active group container to left 			|
| Super + L 								| Change active group container to right 			|
|-------------------------------------------|---------------------------------------------------|
