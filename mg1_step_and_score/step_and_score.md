# Step and score

## Gameplay

```{raw} html
<iframe  src="https://www.youtube.com/embed/-4ID9XRMbvo" 
style="width: 100%; aspect-ratio: 16 / 9;" title="YouTube video player" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
```

We can see a custom score printout on the left side of the HUD. Score is used as an general mean of reward in all minigames here, but that could be additionally tailored in the further development. The `game_score` device implementation is just techicaly in this minigame but may be addressed in a separate lesson later, since the score is anyway visible in the scoreboard.

## UEFN

```{image} step_and_score_editor.svg
:width: 100%
```
Speech bubbles refers to the names of editable attributes in the Verse scripts below. We use a `color_changing_tiles_device` as a touch sensor rather than a `trigger_device` for better accuracy while being just as easy to use. Tiles are not visible in game.

## step_and_score_game_manager.verse
```{literalinclude} ../_code_samples/step_and_score_game_manager.verse
:linenos:
```

## game_score.verse
```{literalinclude} ../_code_samples/game_score.verse
:linenos:
```