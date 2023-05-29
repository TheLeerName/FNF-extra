# Building Friday Night Funkin' Extra

- **Also note**: you should be familiar with the commandline. If not, read this [quick guide by ninjamuffin](https://ninjamuffin99.newgrounds.com/news/post/1090480).
- **Also also note**: To build for *Windows*, you need to be on *Windows*. To build for *Linux*, you need to be on *Linux*. Same goes for macOS. You can build for html5/browsers on any platform.
## Dependencies
1. [Install Haxe 4.2.5](https://haxe.org/download/version/4.2.5/).
2. Install `git`.
   - Windows: install from the [git-scm](https://git-scm.com/downloads) website.
   - Linux: install the `git` package: `sudo apt install git` (ubuntu), `sudo pacman -S git` (arch), etc... (you probably already have it)
3. Install and set up the necessary libraries:
```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install hxCodec 2.5.1
haxelib install hscript
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib run lime setup
haxelib run lime setup flixel
haxelib run flixel-tools setup
haxelib install hxcpp 4.2.1
```
4. Dependencies for platforms.
	- Windows: You need to install **[VS Community](https://visualstudio.microsoft.com/downloads/)**. While installing it, *don't click on any of the options to install workloads*. Instead, go to the **individual components** tab and choose the following:
		-   MSVC v142 - VS 2019 C++ x64/x86 build tools
		-   Windows SDK (10.0.17763.0)
		This will install about 4 GB of crap, but is necessary to build for Windows.
	- Any other platform (including html5): go to next step
5. Run `lime test <target>`, replacing `<target>` with the platform you want to build to (`windows`, `mac`, `linux`, `html5`) (i.e. `lime test windows`)
   - The build will be in `FNF-extra/export/release/<target>/bin`, with `<target>` being the target you built to in the previous step. (i.e. `FNF-extra/export/release/windows/bin`)
   - Incase you added the -debug flag the files will be inside `FNF-extra/export/debug/<target>/bin`
   - Only the `bin` folder is necessary to run the game. The other ones in `export/release/<target>` are not.

## Cloning the repository
Since you already installed `git` in a previous step, we'll use it to clone the repository.
1. `cd` to where you want to store the source code (i.e. `C:\Users\username\Desktop` or `~/Desktop`)
2. `git clone https://github.com/TheLeerName/FNF-extra.git`
3. `cd` into the source code: `cd FNF-extra`