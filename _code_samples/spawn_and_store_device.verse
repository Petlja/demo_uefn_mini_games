using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

spawn_and_store_device := class(creative_device):
    @editable
    CaptureArea : capture_area_device = capture_area_device {}

    @editable
    Spawners : []item_spawner_device = array{}

    # There shoud be same nuber of ConditionalButtons as Spawners  
    # and the same item shoud be set in n-th ConditionalButton and n-th Spawner
    @editable
    ConditionalButtons : []conditional_button_device = array{}

    @editable
    InitialItemIndex : int = -1

    var ItemIndex : int = -1

    StateChangedEvent: event(agent) = event(agent) {}

    ItemPickedUpEventLoop(Spawner: item_spawner_device)<suspends>: void =
        loop:
            # Await an event
            Agent := Spawner.ItemPickedUpEvent.Await()

            # Process the event
            SetItemIndex(-1, option{Agent})

    OnAgentEnters(Agent:agent): void =
        if(ItemIndex = -1):
            for:
                ItemIndex2 := 0..(Spawners.Length - 1)
                ConditionalButton := ConditionalButtons[ItemIndex2]
                ConditionalButton.IsHoldingItem[Agent]
            do:
                ConditionalButton.Activate(Agent)
                SetItemIndex(ItemIndex2, option{Agent})
                return

    SetItemIndex(I : int, OptAgent: ?agent): void =
        set ItemIndex = I
        if(Spawner := Spawners[I]):
            CaptureArea.Disable()
            spawn{ DelayedSpawnItem(Spawner) }
        else:
            spawn { DelayedCaptureAreaEnable() }
        if(Agent := OptAgent?):
            StateChangedEvent.Signal(Agent)
    
    DelayedSpawnItem(Spawner:item_spawner_device)<suspends>: void =
        Sleep(0.5)
        Spawner.SpawnItem()

    DelayedCaptureAreaEnable()<suspends>: void =
        Sleep(0.5)
        CaptureArea.Enable()
    
    OnBegin<override>()<suspends>:void=
        SetItemIndex(InitialItemIndex, false)
        CaptureArea.AgentEntersEvent.Subscribe(OnAgentEnters)
        for(Spawner: Spawners):
            spawn { ItemPickedUpEventLoop(Spawner) }
        