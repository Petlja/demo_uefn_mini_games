using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors/NamedColors }

# Wrappes the score manager device to provide a simple way to display the score on the screen
game_score := class(creative_device):

    @editable
    ScoreManager : score_manager_device = score_manager_device{}

    # Text blocks created so far for the respective players
    var ScoreTextBoxes : [player]text_block = map{}

    ScoreMessage<localizes>(Score:int) : message = "Your score is {Score}"

    # Award the given amount of points to the given agent and display the new score on the screen
    AwardScore(Agent: agent, Awarded: int): void =
        # Print("Score awarded: {Awarded} points")
        ScoreManager.SetScoreAward(Awarded)
        ScoreManager.Activate(Agent)
        ShowCurrentScore(Agent)


    # Display the current score of the given agent on the screen
    ShowCurrentScore(Agent: agent): void =
        Score := ScoreManager.GetCurrentScore(Agent)
        if(Player := player[Agent], PlayerUI := GetPlayerUI[Player]): # common way to get the player's UI
            if(OldTextBlock:= ScoreTextBoxes[Player]):
                OldTextBlock.SetText(ScoreMessage(Score))
            else:
                NewTextBlock := text_block{DefaultText:= ScoreMessage(Score), DefaultTextColor := White}
                CanvasSlot := canvas_slot {Offsets := margin{Top := 250.0, Left := 30.0},Widget:= NewTextBlock}
                Canvas := canvas { Slots := array {CanvasSlot}}
                PlayerUI.AddWidget(Canvas)
                if {set ScoreTextBoxes[Player] = NewTextBlock}

    OnBegin<override>()<suspends>:void =
        for(Player : GetPlayspace().GetPlayers()): 
            ShowCurrentScore(Player)        
        GetPlayspace().PlayerAddedEvent().Subscribe(ShowCurrentScore)
