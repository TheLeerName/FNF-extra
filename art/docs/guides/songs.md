# Tutorial for an adding new songs in game

## Includes tutorial for a new system of difficulties FNF Extra

### Step 1
- Create folder `song_name` in path `assets/songs`
- Add **instrumental** of the song **rename** to `Inst.ogg`
- Add **vocals** of the song **rename** to `Vocals.ogg` (if in json file `"needsVoices":false`, then you do not need it)

![image](https://user-images.githubusercontent.com/85291330/139115334-bd434843-29fb-4f7a-929a-968e330595c9.png)

### Step 2
- Create folder `song_name` in path `assets/data`
- Create file `0.offset`, if your song has offset rename `0.offset` to `"VALUE".offset`
- Create file `diffNames.txt`, and type difficulty names of your song, split this by key ENTER
- Create file `songData.json`, and type `{ "difficultyCount": 3 }`, instead of `3` put the value you need of difficulty count
### NOTE: Currently no more than 10 difficulties are supported, if you put more than 10 and less than 1, then there will be an error!
- Add song json files for 1 difficulty `song_name-1.json`, for 2 difficulty `song_name-2.json` and etc
- (Optional) Create file `modchart.lua`, if you want a [modchart of your song](https://github.com/TheLeerName/FNF-extra/blob/main/art/docs/modchart.md)

![vJFWAWYSvD](https://user-images.githubusercontent.com/85291330/139118261-a979a041-d8ca-461f-9478-be192933022d.png)


### Step 3
- Add your song in file `freeplaySonglist.txt` in folder `assets/data`:

`"Song_name (starts with a capital letter)"`:`"name of character (display of icon)"`:`"week"`

Example: `Tutorial:gf:0`

<img src="https://user-images.githubusercontent.com/85291330/139119533-906e1b71-2bde-46b9-99cb-760a742d9cb2.png" width="60%"/>
