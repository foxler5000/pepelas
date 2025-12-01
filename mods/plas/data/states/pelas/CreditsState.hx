package;

class CreditsState extends MusicBeatState
{
    override function create()
    {
        super.create();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        var txt = new FlxText(0, 100, FlxG.width, "Créditos\n\n- Tú\n- Otro autor\n- Música por XYZ\n\nPresiona [ESC] para volver", 24);
        txt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "center");
        add(txt);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK) FlxG.switchState(new MainModMenuState());
    }
}
