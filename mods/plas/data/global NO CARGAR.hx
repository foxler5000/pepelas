static var redirectStates:Map<FlxState, String> = [
    MainMenuState => 'pelas/MainMenu'
];

function preStateSwitch()
{
    for(redirectState in redirectStates.keys())
        if(Std.isOfType(FlxG.game._requestedState, redirectState))
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
    
} //fr de verdad