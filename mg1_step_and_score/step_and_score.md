# Step and score

## Gameplay

```{raw} html
<iframe  src="https://www.youtube.com/embed/RyqRgW1mQA4"
style="width: 100%; aspect-ratio: 16 / 9;" title="YouTube video player" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
```

We can see a custom score printout on the left side of the HUD. In the technical sense the `game_score` device is introduced in the implementation of this minigame, but this device is equally used in all other minigames. The first lesson may avoid introducing the `game_score` device implementation and rely upon the score being visible on the scoreboard.

The score is used as a general mean of reward in all minigames here, but more diverse means of rewarding can be applied in the further development. 

(step_and_score_uefn)=
## UEFN

Note: Speech bubbles refer to the names of editable attributes in the Verse scripts below. 

```{thumbnail} step_and_score.png
```

We use a `color_changing_tiles_device` as a touch sensor rather than a `trigger_device` for better accuracy while being just as easy to use. Tiles are not visible in the game.

## step_and_score_game_manager.verse
```{literalinclude} ../_code_samples/step_and_score_game_manager.verse
:linenos:
```

(game_score)=
## game_score.verse
```{literalinclude} ../_code_samples/game_score.verse
:linenos:
```