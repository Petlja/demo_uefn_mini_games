
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }
using { /Verse.org/Random }


push_the_box_game_manager := class(creative_device):

    @editable
    CubeTrigger : trigger_device = trigger_device{}

    @editable
    CubeProp : creative_prop = creative_prop{}

    @editable
    MarkerProp : creative_prop = creative_prop{}

    @editable
    EdgeLength: float = 128.0

    @editable
    GameScore : game_score = game_score{}

    var BaseMarkerTr : vector3 = vector3{}

    OnCubeTriggered(AgentOpt:?agent) : void =
        if(Agent := AgentOpt?):
            spawn { DoTheMove(Agent) }

    DoTheMove(Agent: agent)<suspends>: void =
        if(ViewLocation := Agent.GetFortCharacter[].GetTransform().Translation):
            CubeTrigger.Disable()
            CubeLocation := CubeProp.GetTransform().Translation

            DX := (CubeLocation.X - EdgeLength / 2.0) - ViewLocation.X
            DY := (CubeLocation.Y - EdgeLength / 2.0) - ViewLocation.Y
            MoveVector := 
                if(Abs(DX) > Abs(DY)):
                    vector3{X := Sgn(DX) * EdgeLength} 
                else:
                    vector3{Y := Sgn(DY) * EdgeLength} 

            if(AnimCtrl := CubeProp.GetAnimationController[]):
                KeframeDeltas : [] keyframe_delta = array{
                    keyframe_delta {
                        DeltaLocation := MoveVector
                        DeltaRotation := rotation {}
                        Time := 1.0
                        Interpolation := EaseIn 
                    }
                }
                AnimCtrl.SetAnimation(KeframeDeltas, ?Mode := animation_mode.OneShot)
                AnimCtrl.Play()
                AnimCtrl.MovementCompleteEvent.Await()
                CubeTr := CubeProp.GetTransform().Translation
                MarkerTr := MarkerProp.GetTransform().Translation
                if:
                    IsAlmostEqual[CubeTr.X, MarkerTr.X, 1.0]
                    IsAlmostEqual[CubeTr.Y, MarkerTr.Y, 1.0]
                    var T : transform = MarkerProp.GetTransform()
                    set T.Translation.X = RandomJump[BaseMarkerTr.X, EdgeLength, 4, MarkerTr.X]
                    set T.Translation.Y = RandomJump[BaseMarkerTr.Y, EdgeLength, 4, MarkerTr.Y]
                    MarkerProp.TeleportTo[T]
                then:
                    GameScore.AwardScore(Agent, 10)
                CubeTrigger.Enable()
    
    RandomJump(Begin: float, Step: float, TotalSteps: int, Current: float)<transacts><decides>: float =
        Position := Round[(Current - Begin)/Step]
        return Begin + Mod[Position + GetRandomInt(1, TotalSteps - 1), TotalSteps] * Step
       
    OnBegin<override>()<suspends>:void=
        CubeTrigger.TriggeredEvent.Subscribe(OnCubeTriggered)
        set BaseMarkerTr = MarkerProp.GetTransform().Translation
