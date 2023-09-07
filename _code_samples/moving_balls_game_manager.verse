using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

moving_balls_game_manager := class(creative_device):
    @editable
    GameScore : game_score = game_score{}

    @editable
    BallProps: []creative_prop = array{}

    @editable
    InitialArragment: string = ""

    @editable
    AllArrangementsCout: int = 1

    @editable
    ProgressBillboard : billboard_device = billboard_device{}

    var CurrentBalls: []creative_prop = array{}
    var Arrangement: string =  ""
    var Arrangements: [string]void = map{}

    @editable
    Marker0: creative_prop = creative_prop {}

    @editable
    Marker1: creative_prop = creative_prop {}

    var Marker0Transform : transform = transform{}
    var Marker1Transform : transform = transform{}
    var Marker : creative_prop = creative_prop{}

    var ActiveTriangle: int = 0

    @editable
    RemoteManager: signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    StepTime: float = 0.95

    OnPrimarySignal(Agent : agent): void = 
        if(ActiveTriangle = 0):
            spawn{ DoMove(Agent, 0, 1, 2) }
        else:
            spawn{ DoMove(Agent, 1, 2, 3) }

    OnSecondarySignal(Agent : agent) : void =
        if(ActiveTriangle = 0):
            set ActiveTriangle = 1
            spawn{ Marker.MoveTo(Marker1Transform, StepTime)} 
        else:
            set ActiveTriangle = 0
            spawn{ Marker.MoveTo(Marker0Transform, StepTime)}

    DoMove(Agent : agent, I0: int, I1: int, I2: int)<suspends>: void =
        if:
            Ball0 := CurrentBalls[I0]
            Ball1 := CurrentBalls[I1]
            Ball2 := CurrentBalls[I2]
        then:
            sync:
                Ball0.MoveTo(Ball1.GetTransform(), StepTime)
                Ball1.MoveTo(Ball2.GetTransform(), StepTime)
                Ball2.MoveTo(Ball0.GetTransform(), StepTime)
        if:
            B := CurrentBalls[I2]
            set CurrentBalls[I2] = CurrentBalls[I1]
            set CurrentBalls[I1] = CurrentBalls[I0]
            set CurrentBalls[I0] = B
            A := Arrangement[I2]
            set Arrangement[I2] = Arrangement[I1]
            set Arrangement[I1] = Arrangement[I0]
            set Arrangement[I0] = A
            set Arrangements[Arrangement] = void
        UpdateProgressBillboard()
        if(Arrangements.Length = AllArrangementsCout):
            GameScore.AwardScore(Agent, 100)
            set Arrangements = map{Arrangement => void}
            Sleep(2.0)
            UpdateProgressBillboard()
        
    ProgressMessage<localizes>(Current: int, Target: int): message = "{Current} / {Target}"

    UpdateProgressBillboard(): void =
        ProgressBillboard.SetText(ProgressMessage(Arrangements.Length, AllArrangementsCout))
        ProgressBillboard.UpdateDisplay()

    OnBegin<override>()<suspends>:void=
        RemoteManager.PrimarySignalEvent.Subscribe(OnPrimarySignal)
        RemoteManager.SecondarySignalEvent.Subscribe(OnSecondarySignal)
        set CurrentBalls = BallProps
        set Arrangement = InitialArragment
        set Arrangements = map{Arrangement => void} 
        set Marker0Transform = Marker0.GetTransform()
        set Marker1Transform = Marker1.GetTransform()
        Marker1.Hide()
        set Marker = Marker0;
        UpdateProgressBillboard()