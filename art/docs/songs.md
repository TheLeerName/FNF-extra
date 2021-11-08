# Tutorial for an adding new songs in FNF Extra

## Includes tutorial for a new system of difficulties FNF Extra

### Step 1
- Create folder `song_name` in path `mods/songs`
- Add **instrumental** of the song **rename** to `Inst.ogg`
- Add **vocals** of the song **rename** to `Vocals.ogg` (if in json file `"needsVoices":false`, then you do not need it)

![image](https://user-images.githubusercontent.com/85291330/139115334-bd434843-29fb-4f7a-929a-968e330595c9.png)

### Step 2
- Create folder `song_name` in path `mods/data`
- Create file `songData.json` and type this:

      {
        "offset": 0,
        "difficultyCount": 3,
        "difficultyNames": [
          "easy",
          "normal",
          "hard"
        ]
      }

1. If you want change **offset** of song, put the value you need instead of `0`
2. If you want change **difficulty count**, put the value **from 1 to 10** instead of `3`
3. If you want change **difficulty names**, put the value you need instead of `"easy", "normal", "hard"`
### Be sure to write a name for each difficulty!
- Add song json files for 1 difficulty `song_name-1.json`, for 2 difficulty `song_name-2.json` and etc
- (Optional) Create file `modchart.lua`, if you want a [modchart of your song](https://github.com/ShadowMario/FNF-PsychEngine/wiki/Lua-Script-API)

![vJFWAWYSvD](https://user-images.githubusercontent.com/85291330/139118261-a979a041-d8ca-461f-9478-be192933022d.png)

### Step 3
- Create file `your_week.json` in folder `mods/weeks` and type this:

      {
        "songs": [
		        ["Bopeebo", "dad", [146, 113, 253]],
		        ["Fresh", "dad", [146, 113, 253]],
		        ["Dad Battle", "dad", [146, 113, 253]]
	       ],

	       "weekCharacters": [
		        "dad",
		        "bf",
		        "gf"
	       ],
	       "weekBackground": "stage",

	       "storyName": "Daddy Dearest",
	       "weekBefore": "tutorial",
	       "weekName": "Week 1",
	       "startUnlocked": true,

	       "hideStoryMode": false,
	       "hideFreeplay": false
      }

- And type values you need

<img src="https://user-images.githubusercontent.com/85291330/139119533-906e1b71-2bde-46b9-99cb-760a742d9cb2.png" width="60%"/>
*lol this screenshot from ke version*