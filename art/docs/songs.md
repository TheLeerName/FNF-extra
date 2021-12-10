# Tutorial of new system of difficulties FNF Extra
- Create file `songData.json` in folder of jsons of song and type this:

		{
			"offset": 0,
			"uses": {
				"modchart": false,
				"events": false,
				"characters": [],
				"stages": [],
				"notetypes": []
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

1. Offset - its audio offset of the song
2. uses.modchart, uses.events - for proof existence of `modchart.lua` and `events.json`
3. uses.characters, uses.stages, uses.notetypes - type in it needed song files
4. difficulty.names - for difficulty names and difficulty count
5. difficulty.needUpperCase - for uppercasing of difficulty names
- Add song json files for 1 difficulty `song_name-1.json`, for 2 difficulty `song_name-2.json` and etc

![ImgAnvOlRs](https://user-images.githubusercontent.com/85291330/145648303-96c74e5f-92d3-4d72-891f-1575e607c5ba.png)
