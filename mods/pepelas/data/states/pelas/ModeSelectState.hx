package;

class ModeSelectState extends MusicBeatState
{
    public var worldID:String;
    var modes:Array<String> = ["Modo Historia", "Freeplay"];
    var curSelected:Int = 0;

    public function new(world:String)
    {
        super();
        this.worldID = world;
    }

    override function create()
    {
        super.create();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        for (i in 0...modes.length)
        {
            var txt = new FlxText(0, 150 + i * 60, FlxG.width, modes[i], 32);
            txt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
            txt.ID = i;
            add(txt);
        }

        updateSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.UI_UP_P)
        {
            curSelected = (curSelected - 1 + modes.length) % modes.length;
            updateSelection();
        }
        else if (controls.UI_DOWN_P)
        {
            curSelected = (curSelected + 1) % modes.length;
            updateSelection();
        }

        if (controls.ACCEPT)
        {
            switch (curSelected)
            {
                case 0:
                    // Historia del mundo correspondiente
                    PlayState.loadSong("${worldID}_historia", 1);
                    FlxG.switchState(new PlayState());
                case 1:
                    // Freeplay del mundo correspondiente
                    FlxG.switchState(new FreeplayState(worldID)); // Solo si usas un FreeplayState modificado
            }
        }

        if (controls.BACK) FlxG.switchState(new WorldSelectState());
    }

    function updateSelection()
    {
        for (item in members)
        {
            if (Std.is(item, FlxText))
            {
                var txt:FlxText = cast item;
                txt.color = (txt.ID == curSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
            }
        }
    }
}
