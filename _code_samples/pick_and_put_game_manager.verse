using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

pick_and_put_game_manager := class(creative_device):
    @editable
    SpawnAndStoreDevices : []spawn_and_store_device = array{}

    # The marker prop shoud be positioned above SpawnAndStoreDevices[0] 
    @editable
    MarkerProp : creative_prop = creative_prop{}

    # MarkerPropIndex-th item in SpawnAndStoreDevices is shown by the marker prop
    @editable
    MarkerPropIndex : int = 0

    @editable
    GameScore : game_score = game_score{}

    var MarkerPosition : int = 0

    StateChangedEventLoop(SpamAndStoreDevice: spawn_and_store_device)<suspends>: void =
        loop:
            # Await an event
            Agent := SpamAndStoreDevice.StateChangedEvent.Await()

            # Process the event
            if(IsSolved[]):
                GameScore.AwardScore(Agent, 10)
                NewRandomMarkerPosition()

    NewRandomMarkerPosition() : void =
        L := SpawnAndStoreDevices.Length
        if:
            set MarkerPosition = Mod[MarkerPosition + 1 , L]
            # set MarkerPosition = Mod[MarkerPosition + GetRandomInt(1, L - 1) , L]
            var T : transform = MarkerProp.GetTransform()
            set T.Translation.Y = SpawnAndStoreDevices[MarkerPosition].GetTransform().Translation.Y
            MarkerProp.TeleportTo[T]

    IsSolved()<transacts><decides>: void =
        for(I -> S: SpawnAndStoreDevices):
            if(I = MarkerPosition):
                S.ItemIndex = MarkerPropIndex 
            else:
                S.ItemIndex <> -1 and S.ItemIndex <> MarkerPropIndex

    OnBegin<override>()<suspends>:void=
        for(SpamAndStoreDevice: SpawnAndStoreDevices):
            spawn{ StateChangedEventLoop(SpamAndStoreDevice) }