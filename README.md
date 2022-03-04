# Advanced Scripts

This repository contains all my best GSC scripts over the years that I never shared with anyone.<br>
Each of these is individually usable and can be configured from within the GSC.<br>
Contributions are welcome.

## Scripts and Features:

Each of them also includes necessary files and installation method in case you want just one of them.<br>
I suggest using `zoro\_eventhandler` even if you're not running any of the other scripts. Although all the scripts work even without it.

Repo contains:
- [AFK-Plus](#afk-plus-script)
- [Spray](#spray-script)
- [Ping](#ping-script)

# AFK-Plus Script 

## Features:

- Classy looks
- Auto forcespectate and/or forcekick AFK players
- Players are switched to `TEAM_NONE`, ensuring they can't even spectate while AFK
- Different techniques for SND/SNR and DM/TDM

## Installation:

#### Asset List:
```
materials:
    statusicon_afk
images:
    statusicon_afk
    death_crush
```

- Copy and Paste `zoro/_afkplus.gsc` in your mod.
- Open `maps/mp/gametypes/_globallogic.gsc` and in the last line of `init()`, paste:<br>
    ```
    thread zoro\_afkplus::init();
    ```
- Copy and Paste `materials/statusicon_afk`, `material_properties/statusicon_afk`, `images/statusicon_afk.iwi`, `techsets/hud_statusicon_afk.techset`, `techsets/sm2/hud_statusicon_afk.techset`, `techniques/tech_statusicon_afk.tech`, `shader_bin/shader_src/ps_3_0_2d_statusicon.hlsl`, `shader_bin/shader_src/vs_3_0_2d_statusicon.hlsl` and `statemaps/default2d_alpha.sm` in `cod4/raw/`
- Compile `.hlsl` file pair using [this](https://github.com/Zoro-6191/cod4-2d-shaders/wiki/How-to-Install-1-shader#%EF%B8%8F-just-having-the-materials-wont-work-you-need-to-have-required-files-in-folders-statemaps-techsets-techsetssm2-techniques-and-must-compile-hlsl-file-pair-in-rawshader_binshader_src) guide. Command will be `shader_tool 2d_statusicon_afk`.
- Add this in `mod.csv` and compile<br>
    ```
    material,statusicon_afk
    ```
- Add `images/statusicon_afk.iwi` and `images/death_crush.iwi` in your IWD.

## Screenshots:

![image](https://user-images.githubusercontent.com/52291201/148081046-d83410c4-07a1-402d-a962-91790a723508.png)
![image](https://user-images.githubusercontent.com/52291201/148093271-4d71c318-7eed-4693-81ff-0356c61f248a.png)
![image](https://user-images.githubusercontent.com/52291201/148093029-b3fc3626-c765-4e24-a16f-80af171e482b.png)


# Spray Script

#### Asset List:
```
materials:
    all materials containing "spray" in their name
images:
    all images containing "spray" in their name
sounds:
    spray/sprayer.wav
```

## Features:

- Players can choose to render the sprays or not
- Customizable button to spray
- Cooldown between each spray
- Can have any number of sprays
- Sprays are preserved and re-rendered for all currently playing players every round
- Spray sound also included

## Installation:

- Copy and paste `zoro\_spray.gsc`
- Open `maps/mp/gametypes/_globallogic.gsc` and in the last line of `init()`, paste:<br>
    ```
    thread zoro\_spray::init();
    ```
- Copy and Paste `fx/spray`, `images/<spray>`, `materials/<spray>`, `material_properties/<spray>`, `mp/sprayTable.csv`, `soundalias/spray`, `sound/spray/sprayer.wav`, `ui_mp/scriptmenus/vfspray.menu` into your `cod4/raw/`
- Copy and paste all items from `mod.txt` to `mod.csv`
- Add a button preferably in `class.menu` to open the spray menu
    ```
    CHOICE_BUTTON( 2, "Spray Settings", close self;open "spray"; )
    ```
- Compile mod
- Add `images/<spray>` and `sound/spray/sprayer.wav` into IWD

## Screenshots:
![sprayingame](https://user-images.githubusercontent.com/52291201/148189768-79d27e5a-cd88-4d84-88cf-3c8095fd0814.jpg)
![spraymenu](https://user-images.githubusercontent.com/52291201/148189775-a2a17b5b-db16-4e7d-a004-4f13e3882e8d.png)


# Ping Script

#### Asset List:
```
materials:
    all materials containing "spray" in their name
images:
    statusicon_afk
    death_crush
sounds:
    spray/sprayer.wav
```
## Features:

- Pings only visible to teammates
- Pinging player is highlighted in the minimap
- Players can only ping if they're alive
- Visible to spectators and in killcams
- Pings appear through wall and across map
- Pings are marked in minimap

## Installation:

- Copy and paste `zoro\_ping.gsc`
- Open `maps/mp/gametypes/_globallogic.gsc` and in the last line of `init()`, paste:<br>
    ```
    thread zoro\_ping::init();
    ```
- Copy and paste `images/headicon_dead.iwi`, `images/compass_ping`, `materials/compass_ping`, material_properties/compass_ping`
- Add a bind button anywhere
    ```
    CHOICE_BIND( 5, "Ping", "openscriptmenu vf ping", ; )
    ```
- Add this in `mod.csv` and compile:
    ```
    material,compass_ping
    ```
- Add `images/headicon_dead.iwi` and `images/compass_ping` to IWD

## Screenshots:
[![Image from Gyazo](https://i.gyazo.com/af108e4996e2d89ad681bd90ed73a1b9.gif)](https://gyazo.com/af108e4996e2d89ad681bd90ed73a1b9)

