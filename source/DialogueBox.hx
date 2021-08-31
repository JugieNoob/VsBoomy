package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitSh:FlxSprite;
	var portraitGFBF:FlxSprite;
	var portraitBh:FlxSprite;



	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var sound:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'beatbox':
				sound = new FlxSound().loadEmbedded(Paths.music('Lunchbox'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
			case 'thorns':
				sound = new FlxSound().loadEmbedded(Paths.music('LunchboxScary'),true);
				sound.volume = 0;
				FlxG.sound.list.add(sound);
				sound.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'beatbox':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking','shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(250, 300);
		portraitLeft.frames = Paths.getSparrowAtlas('portraits/BoomyPortrait', 'shared');
		portraitLeft.animation.addByPrefix('enter', 'Boomy Enter Instance0003', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.075));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
				portraitBh = new FlxSprite(250, 300);
		portraitBh.frames = Paths.getSparrowAtlas('portraits/BoomyHappyPortrait', 'shared');
		portraitBh.animation.addByPrefix('enter', 'BoomyHappy Enter Instance0003', 24, false);
		portraitBh.setGraphicSize(Std.int(portraitBh.width * PlayState.daPixelZoom * 0.075));
		portraitBh.updateHitbox();
		portraitBh.scrollFactor.set();
		add(portraitBh);
		portraitBh.visible = false;

				portraitGFBF = new FlxSprite(750, 300);
		portraitGFBF.frames = Paths.getSparrowAtlas('portraits/GFandBFPortrait', 'shared');
		portraitGFBF.animation.addByPrefix('enter', 'GFandBF Enter Instance0003', 24, false);
		portraitGFBF.setGraphicSize(Std.int(portraitGFBF.width * PlayState.daPixelZoom * 0.075));
		portraitGFBF.updateHitbox();
		portraitGFBF.scrollFactor.set();
		add(portraitGFBF);
		portraitGFBF.visible = false;

				portraitSh = new FlxSprite(250, 300);
		portraitSh.frames = Paths.getSparrowAtlas('portraits/ShadowPortrait', 'shared');
		portraitSh.animation.addByPrefix('enter', 'Shadow Enter Instance0003', 24, false);
		portraitSh.setGraphicSize(Std.int(portraitSh.width * PlayState.daPixelZoom * 0.075));
		portraitSh.updateHitbox();
		portraitSh.scrollFactor.set();
		add(portraitSh);
		portraitSh.visible = false;

		portraitMiddle = new FlxSprite(500, 300);
		portraitMiddle.frames = Paths.getSparrowAtlas('portraits/GFPortrait', 'shared');
		portraitMiddle.animation.addByPrefix('enter', 'GF Enter Instance0003', 24, false);
		portraitMiddle.setGraphicSize(Std.int(portraitMiddle.width * PlayState.daPixelZoom * 0.1));
		portraitMiddle.updateHitbox();
		portraitMiddle.scrollFactor.set();
		add(portraitMiddle);
		portraitMiddle.visible = false;

		portraitRight = new FlxSprite(750, 300);
		portraitRight.frames = Paths.getSparrowAtlas('portraits/BFPortrait', 'shared');
		portraitRight.animation.addByPrefix('enter', 'BF Enter Instance0003', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.075));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitMiddle.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Roboto-Black';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Roboto-Black';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue)
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'beatbox')
						sound.fadeOut(2.2, 0);
						
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

	switch (curCharacter)
		{
			case 'boomy':
				portraitRight.visible = false;
				portraitMiddle.visible = false;
				portraitSh.visible = false;
				portraitGFBF.visible = false;
				portraitBh.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			
		   case 'gf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				portraitSh.visible = false;
				portraitGFBF.visible = false;
				portraitBh.visible = false;
				if (!portraitMiddle.visible)
				{
					portraitMiddle.visible = true;
					portraitMiddle.animation.play('enter');
				}
			case 'bf':
				portraitMiddle.visible = false;
				portraitLeft.visible = false;
				portraitSh.visible = false;
				portraitGFBF.visible = false;
				portraitBh.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
							case 'shadow':
				portraitMiddle.visible = false;
				portraitGFBF.visible = false;
				portraitBh.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if (!portraitSh.visible)
				{
					portraitSh.visible = true;
					portraitSh.animation.play('enter');
				}
							case 'bfandgf':
				portraitMiddle.visible = false;
				portraitMiddle.visible = false;
				portraitBh.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitGFBF.visible)
				{
					portraitGFBF.visible = true;
					portraitGFBF.animation.play('enter');
				}
							case 'boomyhappy':
				portraitMiddle.visible = false;
				portraitGFBF.visible = false;
				portraitSh.visible = false;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if (!portraitBh.visible)
				{
					portraitBh.visible = true;
					portraitBh.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
