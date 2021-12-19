# Tutorial of new system of difficulties FNF Extra
- Create file `songData.json` in folder of jsons of song and type this:

		{
			"offset": 0,
			"description": "by KawaiSprite, ninjamuffin99, PhantomArcade and Evilsk8r",
			"colors": [165, 0, 77],
			"healthicon": "gf",
			"songName": "Tutorial",
			"uses": {
				"modchart": false,
				"events": true,
				"custom_events": [],
				"custom_notetypes": [],
				"characters": [],
				"stages": []
			},
			"difficulty": {
				"names": [
					"easy",
					"normal",
					"hard"
				],
				"needUpperCase": true
			}
		}

1. `offset` - its audio offset of the song
2. `description` - description of the song, displays in up of screen in song
3. `colors` - colors for background of song in Freeplay
4. `healthicon` - name of health icon which displays near name of song in Freeplay
5. `songName` - name of song which displays in Freeplay
6. `uses.modchart`, `uses.events` - for proof existence of `modchart.lua` and `events.json`
7. `uses.custom_events`, `uses.custom_notetypes`, `uses.characters`, `uses.stages` - type in it needed song files
9. `difficulty.names` - for difficulty names and difficulty count
10. `difficulty.needUpperCase` - for uppercasing of difficulty names
- Add song json files for 1 difficulty `song_name-1.json`, for 2 difficulty `song_name-2.json` and etc

![ImgAnvOlRs](https://user-images.githubusercontent.com/85291330/145648303-96c74e5f-92d3-4d72-891f-1575e607c5ba.png)
