using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

item_exchange_game_manager := class(creative_device):
    @editable
    GameScore : game_score = game_score{}

    @editable
    MushroomSpawner1: item_spawner_device = item_spawner_device{}
    
    @editable
    MushroomSpawner2: item_spawner_device = item_spawner_device{}

    @editable
    GoldSpawner: item_spawner_device = item_spawner_device {}

    @editable
    ConditionalButtonExchange1 : conditional_button_device = conditional_button_device {}

    @editable
    ConditionalButtonExchange2 : conditional_button_device = conditional_button_device {}

    @editable
    ConditionalButtonBlue : conditional_button_device = conditional_button_device {}

    @editable
    ConditionalButtonRed : conditional_button_device = conditional_button_device {}

    @editable
    ConditionalButtonYellow : conditional_button_device = conditional_button_device {}

    @editable
    ConditionalButtonGold : conditional_button_device = conditional_button_device {}

    @editable
    GoldBar: creative_prop = creative_prop{}

    OnMushroomPickedUp(Agent: agent): void =
        if(ConditionalButtonBlue.HasAllItems[Agent]): # 2 blue items
            ConditionalButtonBlue.Activate(Agent)
        if(ConditionalButtonYellow.HasAllItems[Agent]): # 2 yellow items
            ConditionalButtonYellow.Activate(Agent)
        if(ConditionalButtonRed.HasAllItems[Agent]): # 1 red item
            ConditionalButtonRed.Activate(Agent)
            GameScore.AwardScore(Agent, -20)

    OnButton1Activated(Agent: agent): void =
        GoldSpawner.SpawnItem()
        GoldBar.Hide()
        ConditionalButtonExchange1.Disable()

    OnGoldPickedUp(Agent: agent): void =
        spawn { DelayedAfterGokdPickedUp(Agent) }

    DelayedAfterGokdPickedUp(Agent:agent)<suspends>: void =
        Sleep(2.0)
        GoldBar.Show()
        ConditionalButtonExchange1.Enable()

    OnButton2Activated(Agent: agent): void =
        GameScore.AwardScore(Agent, 100)

    OnBegin<override>()<suspends>:void=
        MushroomSpawner1.ItemPickedUpEvent.Subscribe(OnMushroomPickedUp)
        MushroomSpawner2.ItemPickedUpEvent.Subscribe(OnMushroomPickedUp)
        ConditionalButtonExchange1.ActivatedEvent.Subscribe(OnButton1Activated)
        GoldSpawner.ItemPickedUpEvent.Subscribe(OnGoldPickedUp)
        ConditionalButtonExchange2.ActivatedEvent.Subscribe(OnButton2Activated)
