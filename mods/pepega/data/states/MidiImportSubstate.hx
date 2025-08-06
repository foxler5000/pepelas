import flixel.FlxSprite;
import funkin.editors.charter.Charter;
import funkin.backend.system.Conductor;
import flixel.math.FlxMath;
import funkin.editors.charter.Charter.CharterChange;
import funkin.editors.charter.CharterNote;
import funkin.editors.charter.CharterEvent;
import funkin.editors.ui.UIContextMenu;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIFileExplorer;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIWindow;
import funkin.editors.ui.UISlider;

var loadedMidi = null;
var midiExplorer = null;
var midiInfo = null;
var saveButton = null;

var sectionStartStepper = null;
var strumlineDropDown = null;
var fairChartingCheckbox = null;

var trackStepper = null;

var previewWindow = null;
var previewCamera = null;
var previewSlider = null;

function postCreate() {
	importScript("data/scripts/midi");

	function addLabelOn(ui:UISprite, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));

	midiExplorer = new UIFileExplorer(windowSpr.x + 35, windowSpr.y + 80, null, null, "mid", function (res) {
		loadedMidi = loadMidiFromBytes(res);
		updateMidiInfo();
	});
	add(midiExplorer);
	add(addLabelOn(midiExplorer, "Midi File (.mid)"));

	midiInfo = new UIText(midiExplorer.x + midiExplorer.bWidth + 32, midiExplorer.y-24, 300, "", 20);
	add(midiInfo);

	previewWindow = new UIWindow(midiInfo.x, midiInfo.y + 100, 300, 256, "Preview");
	add(previewWindow);

	

	previewCamera = new FlxCamera(Std.int(previewWindow.x), Std.int(previewWindow.y+30), 300, 256-30-1);
	FlxG.cameras.add(previewCamera, false);
	previewCamera.bgColor = 0;

	sectionStartStepper = new UINumericStepper(midiExplorer.x, midiExplorer.y + midiExplorer.bHeight + 32, 0, 1, 0.001, 0, 9999, 82);
	add(sectionStartStepper);
	addLabelOn(sectionStartStepper, "Measure Offset");

	strumlineDropDown = new UIDropDown(midiExplorer.x, sectionStartStepper.y + sectionStartStepper.height + 64, 320, 32, [for(k=>s in Charter.instance.strumLines.members) 'Strumline #'+(k+1)+ ' ('+s.strumLine.characters[0]+')'], 0);
	add(strumlineDropDown);
	addLabelOn(strumlineDropDown, "Target Strumline");

	fairChartingCheckbox = new UICheckbox(midiExplorer.x+5, strumlineDropDown.y + strumlineDropDown.height + 48, "Fair Charting", true);
	add(fairChartingCheckbox);
	//addLabelOn(fairChartingCheckbox, "Fair Charting");

	trackStepper = new UINumericStepper(midiExplorer.x, fairChartingCheckbox.y + fairChartingCheckbox.height + 48, -1, 1, 1, -1, 9999, 82);
	add(trackStepper);
	addLabelOn(trackStepper, "Track Index (-1 = all)");

	saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20 - 125, windowSpr.y + windowSpr.bHeight - 16 - 32, "Confirm", function() {
		
		load(sectionStartStepper.value, strumlineDropDown.index, fairChartingCheckbox.checked);
		close();
	}, 125);
	add(saveButton);

	var closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Close", function() {
		close();
	}, 125);
	add(closeButton);
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
}
var previewNotes = [];
var specificTrackID = -1;
var specificChannelID = -1;
function updateMidiInfo() {
	var t:String = "Loaded Midi:";
	t += "\nTrack Count: " + loadedMidi.tracks.length;
	t += "\nTicks per Quarter: " + loadedMidi.ticksPerQuarterNote;
	for (n in previewNotes) {
		remove(n);
	}
	previewNotes = [];
	var totalNotes:Int = 0;
	var highestTick:Int = 0;
	var lastSpr:FlxSprite = null;

	var trackID = 0;
	for (track in loadedMidi.tracks) {
		if (specificTrackID == -1 || trackID == specificTrackID) {
			for (event in track.events) {
				if (specificChannelID == -1 || event.channel == specificChannelID) {
					if (event.type == 0x90) {
						totalNotes++;
						lastSpr = new FlxSprite(event.time*0.5, 256-(event.param1*2));
						lastSpr.makeGraphic(1,2);
						lastSpr.cameras = [previewCamera];
						add(lastSpr);
						previewNotes.push(lastSpr);
						//if (event.time > highestTick) highestTick = event.time;
					} else if (event.type == 0x80) {
						if (lastSpr != null) {
							lastSpr.scale.x = event.delta*0.5;
							lastSpr.updateHitbox();
						}
						if (event.time > highestTick) highestTick = event.time;
					}
				}
			}
		}
		trackID++;
	}
	var measureTickTime = loadedMidi.ticksPerQuarterNote*16;
	var measureCount = Math.ceil(highestTick / measureTickTime);

	if (previewSlider != null)
		remove(previewSlider);

	previewSlider = new UISlider(previewWindow.x, previewWindow.y+280, 300, 0.0, [{start: 0.0, end: 1, size: 0.01}], false);
	previewSlider.scrollFactor.set();
	add(previewSlider);

	t += "\nNote Count: " + totalNotes;

	midiInfo.text = t;
}
function update(elapsed) {
	previewWindow.visible = previewCamera.visible = saveButton.selectable = midiExplorer.file != null;
	if (midiExplorer.file == null) midiInfo.text = "";
	previewCamera.x = previewWindow.x - subCam.scroll.x;
	previewCamera.y = previewWindow.y - subCam.scroll.y;

	if (previewSlider != null) {
		previewSlider.visible = previewWindow.visible;
		previewSlider.x = previewWindow.x - subCam.scroll.x;
		previewSlider.y = 280 + previewWindow.y - subCam.scroll.y;
		previewSlider.startText.visible = false;
		previewSlider.endText.visible = false;
		previewSlider.valueStepper.visible = false;
		if (previewNotes[previewNotes.length-1] != null) {
			var lastNote = previewNotes[previewNotes.length-1];
			previewCamera.scroll.x = FlxMath.lerp(0, lastNote.x, previewSlider.__barProgress);
		}
	}

	if (specificTrackID != Std.int(trackStepper.value)) {
		specificTrackID = Std.int(trackStepper.value);
		if (midiExplorer.file != null) updateMidiInfo();
	}
}

var lastStrumID = -1;
var lastLastStrumID = -1;
var fairPlacements = false;
function getStrumIDFromNote(note) {
	var n = note%4;

	if (fairPlacements) {
		if (n == lastStrumID) {
			n = (n+1)%4;
		}
		if (n == lastLastStrumID) {
			n = ((n-1)+4)%4;
		}
		lastLastStrumID = lastStrumID;
		lastStrumID = n;
	}

	return n;
}

function load(sectionOffset, strumLineID, fairCharting) {

	var midi = loadedMidi;
	var lastNote:CharterNote;
	var lastNoteID = -1;
	fairPlacements = fairCharting;

	var startOffset = convertMillisecondsToTicks(Conductor.crochet*4*sectionOffset, Conductor.bpm, midi.ticksPerQuarterNote);

	var trackID:Int = 0;
	for (track in midi.tracks) {
		if (specificTrackID == -1 || trackID == specificTrackID) {
			for (event in track.events) {
				if (specificChannelID == -1 || event.channel == specificChannelID) {
					if (event.type == 0x90) {
	
						var t = Conductor.getStepForTime(convertTicksToMilliseconds((event.time)+startOffset, Conductor.bpm, midi.ticksPerQuarterNote));
						if (lastNote != null && lastNote.step == t && lastNoteID == event.param1) {
							continue; //prevent stacked notes
						}
		
						var n = new CharterNote();
						n.updatePos(t, getStrumIDFromNote(event.param1), 0, "", Charter.instance.strumLines.members[strumLineID]);
						lastNote = n;
						lastNoteID = event.param1;
						Charter.instance.notesGroup.add(n);
					} else if (event.type == 0x80) {
						if (lastNote != null) {
							var l = Conductor.getStepForTime(convertTicksToMilliseconds(event.delta, Conductor.bpm, midi.ticksPerQuarterNote));
							if (l > 2) {
								lastNote.susLength = l-1;
							}
						}
							
					}
				}
			}
		}
		trackID++;
	}
}

function destroy() {

	if(previewCamera != null) {
		if (FlxG.cameras.list.contains(previewCamera))
			FlxG.cameras.remove(previewCamera);
		previewCamera = null;
	}
}