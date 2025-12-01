package;

class WorldSelectState extends MusicBeatState
{
    var worlds:Array<String> = ["Mundo 1", "Mundo 2"];
    var curSelected:Int = 0;
    var textList:Array<FlxText> = [];

    override function create()
    {
        super.create();

        var bg = new FlxSprite().loadGraphic(Paths.image("worldBG")); // Imagen de fondo opcional
        add(bg);

        for (i in 0...worlds.length)
        {
            var txt = new FlxText(0, 150 + i * 60, FlxG.width, worlds[i], 32);
            txt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
            txt.ID = i;
            add(txt);
            textList.push(txt);
        }

        updateSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.UI_UP_P)
        {
            curSelected = (curSelected - 1 + worlds.length) % worlds.length;
            updateSelection();
        }
        else if (controls.UI_DOWN_P)
        {
            curSelected = (curSelected + 1) % worlds.length;
            updateSelection();
        }

        if (controls.ACCEPT)
        {
            switch (curSelected)
            {
                case 0: FlxG.switchState(new ModeSelectState("mundo1"));
                case 1: FlxG.switchState(new ModeSelectState("mundo2"));
            }
        }

        if (controls.BACK) FlxG.switchState(new MainModMenuState());
    }

    function updateSelection()
    {
        for (i in 0...textList.length)
        {
            textList[i].color = (i == curSelected) ? FlxColor.YELLOW : FlxColor.WHITE;
        }
    }
}
