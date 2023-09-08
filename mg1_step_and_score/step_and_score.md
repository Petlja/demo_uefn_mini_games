# Step and score

## Gameplay

```{raw} html
<iframe  src="https://www.youtube.com/embed/-4ID9XRMbvo" 
style="width: 100%; aspect-ratio: 16 / 9;" title="YouTube video player" frameborder="0" 
allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
```

We can see a custom score printout on the left side of HUD. Score is used as an general mean of reward in all minigames here, but rewarding could be additionally tailored in the further development. The `game_score` device implementation is just techicaly in this minigame but may be covered as a separate topic in a later lesson, since the score is also visible in the scoreboard.

## UEFN

```{image} step_and_score_editor.svg
:width: 100%
```
Speech bubbles refers to the names of editable attributes in the Verse scripts below. Tiles are not visible in game.

## step_and_score_game_manager.verse
```{literalinclude} ../_code_samples/step_and_score_game_manager.verse
:linenos:
```

## game_score.verse
```{literalinclude} ../_code_samples/game_score.verse
:linenos:
```