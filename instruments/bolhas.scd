a = Scale.choose(7, 12).tuning_(Tuning.choose(12)); Pdefn(\scale, Pfunc({ a.source }, inf));
d = Prand(#[[[2,-2],[3,-3]],[[-4,6],4,-7],-4,10,[0,8],[6,-8,[-2,4]],[10,0,4],-4,[4,-4,0,-6], 6,10,0,-2], inf);  Pdefn(\degree, d);
t = (1..5).choose; Pdefn(\root, t);
Pdefn(\stretch, Pfunc({ 60/~bpm.source *4 / ~div.source}, inf));
Pdefn(\strum, Pwrand([1/6,1/12,1/24,1/4,2/5,-1/12],[6,8,1,3/2,1,2].normalizeSum, inf) / (Pfunc({ ~kaos.source.reciprocal}, inf) * Pwhite(0.95,1.05)));
r = Pseq([Pn((1),1)/Pwhite(0.95,1.05), Pn((1/2),6)/Pwhite(0.95,1.05)],inf); Pdefn(\dur, r);
Pdefn(\detune, Pwhite(0.0, 2.0));
Pdefn(\distort, ~dist.source);
Pdefn(\amp, 0.5);

(
SynthDef(\bolhas, {|out=0, curvelen=0.25, freq=440.0, dens=16, t_trig=1, pan=0, amp=1, detune = 0.2, distort=10|
	var pitch, sig, scale, ampli;

	curvelen =(33/(freq/2));
	pitch = EnvGen.ar(
		Env([0.01,2,0.1,1], [0.015,0.018,1], [5,-5,\sin]).exprange(1, 2.2718),
		t_trig, timeScale:(curvelen)
	);
	ampli = EnvGen.ar(
		Env([0.0001,amp,0.0001],[0.013,curvelen],-5 ),
		t_trig, timeScale:pitch, doneAction:2
	);
	amp = amp * (curvelen*2).lag2(0.1);
	sig = HPF.ar(SinOscFB.ar(freq*pitch, curvelen*distort*pi) * ampli, 30);
	sig = Pan2.ar(sig, pan) * amp;
	OffsetOut.ar(out, sig)
}).add;
);

(
Pdef(\bobolhas,
	Pbind(
		\instrument, \bolhas,
		\stretch, Pdefn(\stretch),
		\strum, Pdefn(\strum),
		\legato,1.0,
		\t_trig,1,
		\dur, Pdefn(\dur),
		\scale, Pfunc({ a.source }, inf),
		\degree, Pdefn(\degree),
		\root, Pdefn(\root),
		\detune, Pdefn(\detune),
		\distort, Pfunc({ ~dist.source }, inf),
		\amp, Pfunc({ ~ampL.source }, inf),
		\pan, Pwhite(-0.8, 0.8)
	);
).quant_(60/~bpm.source *4);
);
