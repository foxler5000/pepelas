// Coded by: @NebulaStellaNova
var vineBoom:FlxSound;
function postCreate() {
	for (event in events)
		if (event.name == 'Vine Boom Image') {
            new FlxSprite().loadGraphic(Paths.image(event.params[0]));
            vineBoom = FlxG.sound.load(Paths.sound('vineBoom'));
        }
}

function onEvent(event) {
	switch (event.event.name) {
		case 'Vine Boom Image':
			var image = new FlxSprite().loadGraphic(Paths.image(event.event.params[0]));
            image.updateHitbox();
            image.screenCenter();
            image.cameras = [camHUD];
            image.scale.set(FlxG.height/image.height, FlxG.height/image.height);
            add(image);

            FlxTween.tween(image, {alpha: 0}, event.event.params[1], { startDelay: event.event.params[2] }); 
            if (event.event.params[3]) {
                var newSound = FlxG.sound.load(Paths.sound('vineBoom'));
                newSound.play();
            }
	}
}

/* Scrapped Code

if (image.width < image.height) {
    image.scale.set(FlxG.width/image.width, FlxG.width/image.width);
} else if (image.width > image.height) {
    image.scale.set(FlxG.height/image.height, FlxG.height/image.height);
} */