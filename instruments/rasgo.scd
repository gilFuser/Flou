Ndef(\rasgo).ar(2);
(
Ndef(\rasgo,{|rabisco=4, trig=4, cf=400, rq=0.2|
	var tri, sig, modulator, papel, env;
//	modulator = LFSaw.ar(rabisco,0,amp,amp);
	modulator = LFNoise2.kr(rabisco + LFNoise1.kr(rabisco.reciprocal).lag(rabisco.reciprocal));
//	rugo = LFNoise2.kr(aspero)*1;
	cf = cf + LFNoise2.kr(0.5, rabisco);
	rq = (rq + LFNoise2.kr(1,rq).lag2(0.5))/2;
	tri = Dust.kr(trig);
	env = Env([0.001, TRand.kr(0.001,1,tri), TRand.kr(0.001,1,tri), TRand.kr(0.001,1,tri), 0.001],
		[TRand.kr(0.1,0.25,tri), TRand.kr(0.1,0.25,tri), TRand.kr(0.1,0.25,tri), TRand.kr(0.1,0.25,tri)],
		[TRand.kr(-5.0,5.0,tri), TRand.kr(-5.0,5.0,tri), TRand.kr(-5.0,5.0,tri), TRand.kr(-5.0,5.0,tri)]
	);
	papel = EnvGen.kr(env, tri);
	sig = WhiteNoise.ar()/*+Dust2.ar(cf, 0.5)*/ * modulator * papel;
	sig = BPF.ar(sig,
		cf,
		rq);
	sig = Pan2.ar(sig, LFNoise2.kr(trig/5+(rabisco/5), 0.8));
	sig = Compander.ar(sig, sig, 1, 0.75, 0.25, 0.002);
});
Ndef(\rasgo).addSpec(\rabisco, [1, 40, \exp]);
Ndef(\rasgo).addSpec(\trig, [1.0, 10, \lin, 0.1]);
Ndef(\rasgo).addSpec(\cf, [80, 1600, \exp]);
Ndef(\rasgo).addSpec(\rq, [0.2, 12, \exp]);
);
