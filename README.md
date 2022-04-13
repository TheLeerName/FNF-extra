# Friday Night Funkin' Extra
FNF **Mod Loader** using **in-game** download. Builded on Psych Engine 0.5.2h ([tposejank's Extra Keys Mod](https://github.com/tposejank/FNF-PsychEngine-ExtraKeys)).

## Features
- Importing mods from GameBanana as web page inside engine! (scrolls on mouse wheel or on up and down buttons on keyboard)
- Supports 1-11 keys
- Lane Underlay
- Download menu with some mods (supports other GitHub repositories), for this **open** `manifest/downloads/downloadServer.txt` in game folder
- Supports importing mod from `.rar`, `.zip` and other pack formats
- Importing mod from direct links of file hosting websites (google drive and github). If you want support more file hosting websites, create issue
- Export mod to `.zip` pack
- Deleting mods
- Uses `7z.exe` console version for cool pack support
- Support of `keyCount` and `playerKeyCount` from Leather Engine

### To request new songs in official download menu, create issue or pull request in [this repository](https://github.com/TheLeerName/FNF-extra-docs)

## Changelogs and future updates:
### Planning 1.4 or 1.3.1:
- **Options in pause menu**
- **Opponent Mode**
- *???*

### (Latest) 1.3-EXPBUILD - Import mod v2 - BETA
- Importing mods from GameBanana as web page inside engine! (scrolls on mouse wheel or on up and down buttons on keyboard)
- Importing mod from direct links of file hosting websites (google drive and github). If you want support more file hosting websites, create issue
- Fixed textures of notes
- Fixed default strums in lua
- Support of `.rar` pack formats via using `7z.exe`

### 1.2 - Overhaul Update
- Updated to **Psych Engine 0.5.2-hotfix**
- Ability to import mod from `.zip` pack in **MODS**, click **Import** button
- Ability to export mod in `.zip` pack in **MODS**, click **Export** button
- Ability to delete mod in **MODS**, click **Delete** button
- Download menu in **MODS** now, click **Open Downloads** button
- Support of `keyCount` and `playerKeyCount` from Leather Engine
- Support of 1-11 keys

### 1.1.1 - Fix of Lane Underlay
- **Funny fix no access to lane underlay in lua**

### 1.1 - The Multi-Key Update
- **Multi-Key support!** *(maps/charts with 1, 2, 3, 5, 6, 7, 8, 9 keys)*, **ALL** code of it [**i stole**](https://github.com/tposejank/FNF-PsychEngine-ExtraKeys)
- **Updated to Psych Engine 0.5**
- New **category in download menu**: **Custom Events**
- **Scroll Speed option working ONLY in pause menu**
- **Hold UP or DOWN** to **fast-scroll keybind menu**
- **Removed Kade Input** option, due **its useless** in new PsychE version
- **Removed week and menu character editor**, its useless
- Little **redesign of debug menu** (https://i.imgur.com/NmL9XpV.png)
- `Weeks` folder **is useless**, all lines in `songData.json` of songs

### 1.0 - The First Release
- Download menu with songs, characters, stages and notetypes (press TAB in freeplay)
- Lane Underlay Option
- Scroll Speed Option
- Kade Input Option (just change hit windows)
- Fullscreen switches anywhere
- Volume setting saves now after closing game

## Tutorials: [Build instructions](art/docs/building.md) - [Modcharts](https://github.com/ShadowMario/FNF-PsychEngine/wiki/Lua-Script-API)

## This mod was builded on Psych Engine 0.5.2h
[Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine) originally used on [Mind Games Mod](https://gamebanana.com/mods/301107), intended to be a fix for the vanilla version's many issues while keeping the casual play aspect of it. Also aiming to be an easier alternative to newbie coders.

# Credits
## FNF Extra
* [**TheLeerName** (me!)](https://vk.com/theleername) - All in this project lol
## Psych Engine Extra Keys
* [**tposejank**](https://gamebanana.com/members/1834016) - Coder
## Psych Engine
* [**Shadow Mario**](https://twitter.com/Shadow_Mario_) - Coding
* [**RiverOaken**](https://twitter.com/RiverOaken) - Arts and Animations
* [**Keoiki**](https://twitter.com/Keoiki_) - Note Splash Animations

<img src="https://user-images.githubusercontent.com/85291330/140801284-4bf80649-49d3-4c31-a0ae-390bb70c580b.png" width="25%"/>