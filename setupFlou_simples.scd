(
Server.default = s = Server.local;
s.latency = 0.05;
s.options
	.numAudioBusChannels_(1024)	 // for proxy usage: lots of ar bus space
	.memSize_(8192 * 64)		 // 512 MB memory for buffers, soundfiles!
	.maxNodes_(1024 * 16)		 // lots of synth nodes
	.numWireBufs_(64*8)			 // fat synthdefs need lots of interconnects
;
q = q ? ();
)
(
s.waitForBoot({
	q.postServerOptions;
	s.dump;
});
)
(
s.recChannels_(2);	// record stereo out only
s.scope(2);
p = Ndef.dictFor(s); p.push;

~kaos = 0.1;        // so far for bubble's strum
~bpm = 120.0;
~bpm.fadeTime = 1;
~div = 4;
~ampL = 0.5;        // for bubble's amp
~dist = 0.1;
)

//           ////  here are the instruments  ////
(
p.makeTempoClock(~bpm.source/60); p.quant = (60/~bpm.source *4);

//    V– the folder where the instruments must live.
"instruments/griloucos*".loadRelative;
"instruments/riscos*".loadRelative;
"instruments/bolhas*".loadRelative;
);

//                 ////  GUI! ////
(
y = Window.new("FLOU OU OU", Rect(600, 0, 1360, 700),scroll:true);
q.guiFlou = y.addFlowLayout(10@10, 5@10);

//                         **** grilos ****
q.grilosGui = {
	q.gKtl = KtlLoop(\grilos);
	q.gKtl.paramsToRecord_([\lx, \ly, \rx, \ry, \llx, \lly]);
	q.gKtl.object_(Ndef(\grilos));
	q.gKtl.ktlMap_((lx: \freq0, ly: \freq1, rx: \muladd, ry: \lagg, llx: \num2, lly: \freq));
	// make an eventloopgui for KtlLoop
	KtlLoopGui(q.gKtl, parent: y, bounds: 370@200);
	Slider2D(y, 190@190)
	.action_({ |sl|
		// put params into an event,
		var event = (lx: sl.x, ly: sl.y);
		// store it,
		q.gKtl.recordEvent(event.put(\type, \set));
		// and set the object from it
		q.gKtl.setuObj(event);
	});
	Slider2D(y, 190@190)
	.action_({ |sl|
		var event = (rx: sl.x, ry: sl.y);
		q.gKtl.recordEvent(event.put(\type, \set));
		q.gKtl.setuObj(event);
	});
	Slider2D(y, 190@190)
	.action_({ |sl|
		var event = (llx: sl.x, lly: sl.y);
		q.gKtl.recordEvent(event.put(\type, \set));
		q.gKtl.setuObj(event);
	});
	NdefGui(Ndef(\grilos), 9,y);
};
q.grilosGui;

//                        **** riscos ****
q.guiRiscos = {
	q.rKtl = KtlLoop(\rasgo);
	q.rKtl.paramsToRecord_([\lx, \ly, \rx, \ry]);
	q.rKtl.object_(Ndef(\rasgo));
	q.rKtl.ktlMap_((lx: \trig, ly: \rabisco, rx: \cf, ry: \rq));
	// make an eventloopgui for KtlLoop
	KtlLoopGui(q.rKtl, parent: y, bounds:370@200);

	Slider2D(y, 286@190)
	.action_({ |sl|
		// put params into an event,
		var event = (lx: sl.x, ly: sl.y);
		// store it,
		q.rKtl.recordEvent(event.put(\type, \set));
		q.rKtl.setuObj(event);
	});
	Slider2D(y, 286@190)
	.action_({ |sl|
		var event = (rx: sl.x, ry: sl.y);
		q.rKtl.recordEvent(event.put(\type, \set));
		q.rKtl.setuObj(event);
	});
	/*		EZRanger(q.ndgwin, 400@16,Ndef(\rasgo), \freq, { |v| v.value.postln }, [50,2000], unitWidth:30);*/

	NdefGui(Ndef(\rasgo), 5, y);
};
q.guiRiscos;

//                      ***** BOLHAS *******

q.guiBolhas = PdefGui(Pdef(\bobolhas), 1, y, bounds:370@40);
q.guiBolhas;

q.guiFlou.nextLine;

//amp
q.ampSlider = EZSlider( y,
	370@20,
	label:"amp",
	controlSpec:ControlSpec(0.01, 1, \lin, 0.01, 0.5),
	action: {|obj| ~ampL =  obj.value},
	labelWidth:30,
	gap:4@0,
	margin:0@0,
);
q.ampSlider;

// parágrafo
q.guiFlou.nextLine;

//bpm
q.bpmSlider = EZSlider( y,
	370@20,
	label:"bpm",
	controlSpec:ControlSpec(24, 240, \lin, 1, 120),
	action: {|obj| ~bpm = obj.value},
	labelWidth:30,
	gap:4@0,
	margin:0@0,
);
q.bpmSlider;

// parágrafo
q.guiFlou.nextLine;

//div
q.divSlider = EZSlider( y,
	370@20,
	label:"div",
	controlSpec:ControlSpec(1, 16, \lin, 1, 4),
	action: {|obj| ~div = obj.value},
	labelWidth:30,
	gap:4@0,
	margin:0@0,
);
q.divSlider;

// parágrafo
q.guiFlou.nextLine;

//strum
q.strumSlider = EZSlider( y,
	370@20,
	label:"strum",
	controlSpec:ControlSpec(0.03, 2, \lin, 0.033, 0.33),
	action: {|obj| ~kaos = obj.value},
	labelWidth:30,
	gap:4@0,
	margin:0@0,
);
q.strumSlider;

// parágrafo
q.guiFlou.nextLine;

//distort
q.distSlider = EZSlider( y,
	370@20,
	label:"distr",
	controlSpec:ControlSpec(0.0001, 2, \exp, 0.0001, 0.0001),
	action: {|obj| ~dist = obj.value},
	labelWidth:30,
	gap:4@0,
	margin:0@0,
);
q.distSlider;

// parágrafo
q.guiFlou.nextLine;

//root
q.rootBtn = Button(y, 75@30)
.states_([["root"]])
.action_({ /*|obj|*/
	t = (-7..9).choose;
	Pdefn(\root, t)
});
q.rootBtn;

//scale
q.scaleBtn = Button(y, 75@30)
.states_([["scale"]])
.action_({ |obj|
	a = Scale.choose(7, 12).tuning_(Tuning.choose(12));
	Pdefn(\scale, Pfunc({ a.source }, inf))
});
q.scaleBtn;

//degree
q.degreeBtn = Button(y, 75@30)
.states_([["degree"]])
.action_({ /*|obj|*/
	d = [
		Prand(#[[[0,-5],[5,-5]],[[-3,7],3,-3],-5,11,[0,9],[7,-9,[-3,3]],[11,0,3],-3,[5,-5,10,-7], 5,11,0,-3], inf),
		Prand(#[[[2,-2],[3,-3]],[[-4,6],4,-7],-4,10,[0,8],[6,-8,[-2,4]],[10,-3,4],-4,[4,-4,0,-6], 6,10,0,-2], inf),
		Prand(#[[-9,-6,[-7,-4]],[-5,-2,[-3,0],[-1,2]],[1,4,0,3],[[2,5],4,7],6,9,[8,11],[10,7,5],3, 0,-2], inf),
		Pn(#[[5, 3], [-3, -5]],inf),
		Pseq(#[[0,1,2,3],[-9,0,-7]],inf),
		Pn([-9,9])
	].choose;
	Pdefn(\degree, d);
	//	Pdefn(\degree, Pfunc({ d }, inf));
});
q.degreeBtn;

//dur
q.durBtn = Button(y, 75@30)
.states_([["ritmo"]])
.action_({ /*|obj|*/
	r = [
		Pseq([Pn((1),1)/Pwhite(0.95,1.05), Pn((1/2),6)/Pwhite(0.95,1.05)],inf),
		Pwrand([1, 1/3, 1/2, 1/6, 1/4, 1/8, 1/2], [1, 1/3, 1/2, 1/6, 1/4, 1/8, 1/2].normalizeSum, inf)/Pwhite(0.98,1.02),
		Prand([Pn((1/3),2), Pn((2/3),6), Pn((1),3)],inf)/Pwhite(0.95,1.05),
		Pseq([Pwhite(1/8, 1/6), Pn(Pswitch1([Pwhite(1/3, 2/3), Pwhite(1, 2)], Pfunc{ 0.1.coin.binaryValue}),6)],inf),
	].choose;
	Pdefn(\dur, r);
	//	Pdefn(\degree, Pfunc({ d }, inf));
});
q.durBtn;

q.serverGui = Server.default.makeGui;
y.front;
);
s.meter;
//b = AllGui(12);


