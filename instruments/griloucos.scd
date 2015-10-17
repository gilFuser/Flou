(
Ndef( \grilos, { |freq0=1.43, freq1=3, muladd=0.5, lagg=0.2, num2=40.6, freq=3147|
	var modul0, modul1, modula, mod1, mod2, mod3, trigLag;
	freq0 = freq0.lag2(0.3);
	freq1 = freq1.lag2(0.3);
	trigLag = Dust.kr(lagg, 0.5, 1.0);
	modul0 = LFNoise1.kr([freq0, freq0*{TRand.kr(0.8, 1.2,Changed.kr(freq0))}], freq1, freq1+0.1);
	modula = LFSaw.ar(modul0, 1, muladd, 0).lag2(lagg*{TRand.kr(0.5, 1.0,Changed.kr(trigLag))});
	mod2 = (modula * num2.lag2(0.3) * 2pi).cos.squared;
	mod3 = modula * freq.lag2(0.3);
	mod3 = (mod3 * 2pi).cos + ((mod3 * 2 * 2pi).cos * 0.3);
//	mod1 = ((Fold.ar(modulator.min(0.1714) * 5.84) - 0.5)) * (mod2 * mod3).squared * (-4) + 1;
	mod1 = ((Fold.ar(modula.min(0.1714) * 5.84) - 0.5).squared * (-4) + 1) * (mod2 * mod3);
	mod1 = Compander.ar(mod1, mod1, 0.75, 0.75, 0.25, 0.002);
	mod1 = HPF.ar(mod1, 40);
	mod1 = (mod1 * 0.5);
}
);
Ndef( \grilos).addSpec(\freq0, [0.1, 10, \exp]);
Ndef( \grilos).addSpec(\freq1, [0.1, 200.0, \exp]);
Ndef( \grilos).addSpec(\muladd, [0.01, 10.0, \exp]);
Ndef( \grilos).addSpec(\lagg, [0.2, 8.0, \exp]);
Ndef( \grilos).addSpec(\num2, [10.0, 10000.0, \exp]);
);
