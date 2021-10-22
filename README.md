# Friday Night Funkin' Extra

FNF Modification in which there will be all sorts of improvements to the original game and mods (recharts, modcharts, gamemodes)

### In last commits i added feature to change scroll speed in lua modcharts, and here a tutorial on it

`setSpeed(2.8, true);` <- **sets speed to 2.8**, **if true** then **updates watermark**: `Speed: 2.8` (btw its not necessary to write true, since true is written in the function by default)

`addSpeed(0.5, false);` <- **adds 0.5 to speed**, **if false** then **not updates watermark**, *idk why it, but why not?*

> You can anyway change scroll speed via **function beatHit** in **PlayState.hx**, if you dont know Lua language

### Minor changes
Deleted **polymod, newgrounds, version check** and **caching** *(preload files)*; **numpad** able **to bind** now

## [Build instructions](art/docs/building.md)

![Kade Engine logo](assets/preload/images/KadeEngineLogo.png)

# This mod was builded on a Kade Engine
**Kade Engine** is a mod for Friday Night Funkin', including a full engine rework, replays, and more.

Links: **[GitHub repository](https://github.com/KadeDev/Kade-Engine) ⋅ [GameBanana mod page](https://gamebanana.com/gamefiles/16761) ⋅ [play in browser](https://funkin.puyo.xyz) ⋅ [latest stable release](https://github.com/KadeDev/Kade-Engine/releases/latest) ⋅ [latest development build (windows)](https://ci.appveyor.com/project/KadeDev/kade-engine-windows/branch/master/artifacts) ⋅ [latest development build (macOS)](https://ci.appveyor.com/project/KadeDev/kade-engine-macos/branch/master/artifacts) ⋅ [latest development build (linux)](https://ci.appveyor.com/project/KadeDev/kade-engine-linux/branch/master/artifacts)**

**REMEMBER**: This is a **mod**. This is not the vanilla game and should be treated as a **modification**. This is not and probably will never be official, so don't get confused.

## Website ([KadeDev.github.io/kade-engine/](https://KadeDev.github.io/Kade-Engine/))
If you're looking for documentation, changelogs, or guides, you can find those on the Kade Engine website.

# Credits
### Kade Engine
- [KadeDeveloper](https://twitter.com/KadeDeveloper) - Maintainer and lead programmer
- [The contributors](https://github.com/KadeDev/Kade-Engine/graphs/contributors)

### Friday Night Funkin'
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programming
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawai Sprite](https://twitter.com/kawaisprite) - Music

This game was made with love to Newgrounds and its community. Extra love to Tom Fulp.