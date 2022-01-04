# Advanced Scripts

This repository contains all my best GSC scripts over the years that I never shared with anyone.<br>
Each of these is individually usable and can be configured from within the GSC.<br>
Contributions are welcome.

## Scripts and Features:

Each of them also includes necessary files and installation method in case you want just one of them.<br>
I suggest using `zoro/_eventhandler` even if you're not running any of the other scripts.

# AFK-Plus Script 

## Features:

- Classy looks
- Auto forcespec and/or forcekick
- Players are switched to `TEAM_NONE`, ensuring they can't even spectate while AFK
- Different techniques for SND/SNR and DM/TDM

## Installation

- Copy and Paste `zoro/_afkplus.gsc` in your mod.
- Open `maps/mp/gametypes/_globallogic.gsc` and in the last line of `init()`, paste:<br>
    ```
    thread zoro\_afkplus::init();
    ```
- Copy and Paste `materials/statusicon_afk`, `material_properties/statusicon_afk, `images/statusicon_afk.iwi`, `techsets/hud_statusicon_afk.techset`, `techsets/sm2/hud_statusicon_afk.techset`, `techniques/tech_statusicon_afk.tech`, `shader_bin/shader_src/ps_3_0_2d_statusicon.hlsl`, `shader_bin/shader_src/vs_3_0_2d_statusicon.hlsl` and `statemaps/default2d_alpha.sm` in `cod4/raw/`
- Compile `.hlsl` file pair using [this](https://github.com/Zoro-6191/cod4-2d-shaders/wiki/How-to-Install-1-shader#%EF%B8%8F-just-having-the-materials-wont-work-you-need-to-have-required-files-in-folders-statemaps-techsets-techsetssm2-techniques-and-must-compile-hlsl-file-pair-in-rawshader_binshader_src) guide.
- Add this in `mod.ff` and compile<br>
    ```
    material,statusicon_afk
    ```
- Add `images/statusicon_afk.iwi` and `images/death_crush.iwi` in your IWD.

## Screenshots:
    ![image](https://user-images.githubusercontent.com/52291201/148081046-d83410c4-07a1-402d-a962-91790a723508.png)
