using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }

drop_and_catch_game_manager := class(creative_device):
    @editable
    AppleMovers: []prop_mover_device = array{}

    @editable
    ScoreManager: score_manager_device = score_manager_device{}

    @editable
    Basket: creative_prop = creative_prop{}

    @editable
    RemoteManager: signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    GameScore: game_score = game_score{}

    @editable
    BasketStep: float = 256.0

    var CurrentPosition: int = 2
    var BasketBaseY : float = NaN
    var LastScheduledDropTime : float = NaN
    var Paused : logic = true
    var CurrentAgent : ?agent = false
    var MissesInRow : int = 0

    AppleCatchedEventLoop(AppleMover: prop_mover_device)<suspends>: void =
        loop:
            # Await an event
            AppleMover.PropHitEvent.Await()

            # Process the event
            set MissesInRow = 0
            if(Agent := CurrentAgent?):
                GameScore.AwardScore(Agent,5)
                AppleMover.Reset()
                spawn{ ScheduleNextDrop(AppleMover) }

    AppleMissedEventLoop(AppleMover: prop_mover_device)<suspends>: void =
        loop:
            # Await an event
            AppleMover.FinishedEvent.Await()

            # Process the event
            set MissesInRow += 1
            if(MissesInRow = 2):
                ResetAllAndPause()
            else if(Agent := CurrentAgent?):
                GameScore.AwardScore(Agent, -20)
                AppleMover.Reset()
                spawn{ ScheduleNextDrop(AppleMover) }
    
    ScheduleNextDrop(AppleMover: prop_mover_device)<suspends>: void =
        CurrentTime := GetSimulationElapsedTime()
        RandomWait := GetRandomFloat(0.8,3.0)
        ScheduledTime := 
            if(LastScheduledDropTime = NaN):
                CurrentTime
            else:
                Max(CurrentTime, LastScheduledDropTime) + RandomWait
        set LastScheduledDropTime = ScheduledTime
        Sleep(ScheduledTime-CurrentTime)
        if(not Paused?):
            AppleMover.Advance()
    
    ResetAllAndPause(): void =
        set Paused = true
        set LastScheduledDropTime = NaN
        set CurrentAgent = false
        for(AppleMover: AppleMovers):
            AppleMover.Reset()

    OnPrimarySignal(Agent : agent): void = 
        StartIfPaused(Agent)
        if(CurrentPosition > 0):
            set CurrentPosition -= 1
            MoveBasket()

    OnSecondarySignal(Agent : agent) : void =
        StartIfPaused(Agent)
        if(CurrentPosition < 4):
            set CurrentPosition += 1
            MoveBasket() 
    
    StartIfPaused(Agent:agent): void =
        if(Paused?):
            set Paused = false
            set CurrentAgent = option{Agent}
            for(AppleMover : Shuffle(AppleMovers)):
                spawn{ ScheduleNextDrop(AppleMover) }

    MoveBasket(): void =
        var T : transform = Basket.GetTransform()
        set T.Translation.Y = BasketBaseY + (CurrentPosition - 2) * BasketStep
        spawn { Basket.MoveTo(T, 0.25) }

    OnBegin<override>()<suspends>:void=
        set BasketBaseY = Basket.GetTransform().Translation.Y
        RemoteManager.PrimarySignalEvent.Subscribe(OnPrimarySignal)
        RemoteManager.SecondarySignalEvent.Subscribe(OnSecondarySignal)
        for(AppleMover: AppleMovers):
            spawn{ AppleCatchedEventLoop(AppleMover) }
            spawn{ AppleMissedEventLoop(AppleMover) }