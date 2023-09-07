using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

step_and_score_game_manager := class(creative_device):
    @editable
    GameScore : game_score = game_score {}

    @editable
    TileG1 : color_changing_tiles_device = color_changing_tiles_device{}

    @editable
    TileG2: color_changing_tiles_device = color_changing_tiles_device{}

    @editable
    TileR: color_changing_tiles_device = color_changing_tiles_device{}

    @editable
    CubeG1 : creative_prop = creative_prop {}

    @editable
    CubeG2 : creative_prop = creative_prop {}

    OnActivatedG1(Agent: agent): void =
        GameScore.AwardScore(Agent, 10)
        TileG1.Disable()
        CubeG1.Hide()
        TileG2.Enable()
        CubeG2.Show()

    OnActivatedR(Agent: agent): void =
        GameScore.AwardScore(Agent, -20)

    OnActivatedG2(Agent: agent): void =
        GameScore.AwardScore(Agent, 10)
        TileG2.Disable()
        CubeG2.Hide()
        TileG1.Enable()
        CubeG1.Show()

    OnBegin<override>()<suspends>:void =
        TileG1.ActivatedEvent.Subscribe(OnActivatedG1)
        TileG2.ActivatedEvent.Subscribe(OnActivatedG2)
        TileR.ActivatedEvent.Subscribe(OnActivatedR)
        TileG2.Disable()
        CubeG2.Hide()