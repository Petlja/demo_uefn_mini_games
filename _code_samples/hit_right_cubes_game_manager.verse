using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }

puzzle_state := enum{InProgress, Solved, Unsolvable}

hit_right_cubes_game_manager := class(creative_device):
    @editable
    CubeManipulators : []prop_manipulator_device = array{}

    @editable
    CubeProps: []creative_prop = array{}

    @editable
    ColumnCount: int = 3

    @editable
    BillboardDevice : billboard_device = billboard_device{}

    @editable
    ResetButton : button_device = button_device{}

    @editable
    StepDistance: float = 30.0

    @editable
    GameScore : game_score = game_score{}

    # Current cube positions
    var CubePositions : []int = array{}

    # Target cube positions
    var TargetPositions: []int = array{}

    # Initial Y coordinate for cubes
    var BaseY : float = NaN 

    CubeIsHitEventLoop(CubeIndex: int, CubeManipulator: prop_manipulator_device)<suspends>: void =
        loop:
            # Await event
            Agent := CubeManipulator.DamagedEvent.Await()

            # Process event
            if:
                NewPosition := CubePositions[CubeIndex] + 1
                NewPosition <= 3
            then:
                SetCubePosition(CubeIndex, NewPosition)
                State := UpdateBillboard()
                if(State = puzzle_state.Solved):
                    GameScore.AwardScore(Agent, 100)

    SetCubePosition(CubeIndex: int, Position: int): void =
        if:
            set CubePositions[CubeIndex] = Position
            Cube := CubeProps[CubeIndex]
        then:
            var T : transform = Cube.GetTransform()
            set T.Translation.Y = BaseY + Position * StepDistance
            if{Cube.TeleportTo[T]}

    BillboardMsg<localizes>(PosMatrix: string, StateMsg: string) : message = "Target layout:{PosMatrix}\n{StateMsg}"

    UpdateBillboard(): puzzle_state =
        Print("Update Billboard")
        var PosMatrix : string = ""
        var State: puzzle_state = puzzle_state.Solved

        for:
            Index -> TargetPosition: TargetPositions
            CurrentPosition := CubePositions[Index]
        do:
            if(CurrentPosition > TargetPosition):
                set State = puzzle_state.Unsolvable
            if(State <> puzzle_state.Unsolvable and CurrentPosition < TargetPosition):
                set State = puzzle_state.InProgress
            NewLineOrSpace := if(Mod[Index, ColumnCount] = 0) {"\n"} else {" "}
            set PosMatrix += "{NewLineOrSpace}{TargetPosition}"    
             
        StatusMsg := case(State):
                        puzzle_state.InProgress => "Go on!" 
                        puzzle_state.Solved => "Well done!"
                        puzzle_state.Unsolvable => "Better try again!"
        BillboardDevice.SetText(BillboardMsg(PosMatrix, StatusMsg))
        return State

    ResetButtonPressed(InPlayer: agent) : void =
        ResetPuzzle()

    ResetPuzzle(): void =
        set TargetPositions =
            for(CubeIndex := 0..CubeProps.Length - 1):
                SetCubePosition(CubeIndex, 0)
                GetRandomInt(0,2)
        UpdateBillboard()

    OnBegin<override>()<suspends>:void=
        set CubePositions = for(__:CubeManipulators) {0}
        for(CubeIndex -> CubeManipulator : CubeManipulators):
            spawn{ CubeIsHitEventLoop(CubeIndex, CubeManipulator) }
        if(set BaseY = CubeProps[0].GetTransform().Translation.Y):
            ResetPuzzle() 
            ResetButton.InteractedWithEvent.Subscribe(ResetButtonPressed)       