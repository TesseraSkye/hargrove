s.boot;


(
b = Buffer.readChannel(s,"Q:/1 SkyeData/1 Projects/Timeless/hgExtra/samples/woah.wav",channels:[0],bufnum:1010);
)


(
	SynthDef.new(\samp2, {
		arg sampBuffer, paramX = 0.75, paramY = 0, paramZ = 1, cpsPitch=263.5;
		var ratioPitch, rate, start, duration, frames, loopStart, loopEnd, loopLength, sig, deltaTrig;

		rate = (paramX-0.5)*4;
		start = paramY;
		duration = paramZ**3;
		ratioPitch = rate * (2**((cpsPitch.cpsmidi / 12) - 5));

		duration = duration.clip(0.001,1);

		frames = BufFrames.kr(sampBuffer);

		deltaTrig = Changed.ar(LeakDC.ar(start.asAudioRateInput),0);
		deltaTrig = Trig1.ar(deltaTrig,0.25);
		deltaTrig = deltaTrig * (0-1) + 1;

		loopStart = start * frames;
		loopStart = loopStart.clip(0,frames-1);
		loopLength = duration * frames;
		loopLength = loopLength.clip(128, loopLength+20);
		loopEnd = loopStart + loopLength;
		loopEnd = loopEnd.clip(loopStart + 128, frames);

		sig = LoopBuf.ar(1, sampBuffer, ratioPitch, deltaTrig, loopStart, loopStart, loopEnd);

		Out.ar(0, (sig!2));

	}).add;
);



(
// Atonal Sampler. Rate control is through zero
SynthDef.new(\sampler, {

	/* Start and length are in percentage of total. Length longer than 1 will just wrap
	When trig crosses 0, it will restart the sample
	When loop is true, the sample loops
	Voice num is a selector from 0 - 8 that sets the output of the synth
	*/

	arg sampBuffer, paramX = 0.75, paramY = 0, paramZ = 1, cpsPitch=263.5, loop = 1, trig = -1, voiceNum = 0;

	var loopStart, loopLength, loopEnd, loopRate, loopPos, sig, sigMono, out, frames, freeTrig, deltaTrig, ratioPitch, rate, start, duration;

	rate = (paramX-0.5)*4;
	start = paramY;
	duration = paramZ**3;
	ratioPitch = rate * (2**((cpsPitch.cpsmidi / 12) - 5));

	//prevents overflow or underflow
	duration = duration.clip(0.001,1);
	//convert positional args to samples
	frames = BufFrames.kr(sampBuffer);
	deltaTrig = Changed.ar(LeakDC.ar(start.asAudioRateInput),0);
	deltaTrig = Trig1.ar(deltaTrig,0.25);
	deltaTrig = deltaTrig * (0-1) + 1;
	// deltaTrig.poll(20,deltaTrig);
	loopStart = start * frames;
	loopLength = duration * frames;
	loopLength = loopLength.clip(128,loopLength+20);
	//positive rate is forward playback, negative is reversed. +-1 is initial speed
	loopRate = BufRateScale.kr(sampBuffer) * (ratioPitch);
	//Positional driver
	loopPos = Phasor.ar(trig, loopRate, 0, loopLength);
	sig = BufRd.ar(1, sampBuffer, Wrap.ar((loopPos + loopStart)*deltaTrig,0, frames), 0, 4);
	//output!
	Out.ar(0, [sig,sig]);
	//frees self at end if loop is off
	freeTrig = loopPos > (loopLength - 100 + (1000 * (loop)));
	FreeSelf.kr(freeTrig);
}).add;
);

(
//Granular Engine
SynthDef.new(\granular, {

	// grain rate is grains / second (kinda), density is ratio of grain rate : grain length
	arg sampBuffer, paramX=0, paramY=1, paramZ=0, cpsPitch=440, env= -1, ktr=1, voiceNum=0;

	var grainTrig, duration, frames, sig, out, grainRate, density, startPos, ratioPitch;

	grainRate = paramX*8;
	density = paramY*8;
	startPos = paramZ;
	ratioPitch = 2**((cpsPitch.cpsmidi / 12) - 5);

	//scales the vales from 0
	grainRate = 2**grainRate;

	duration = density/grainRate;

	grainTrig = Impulse.ar(grainRate);

	sig = GrainBuf.ar(1, grainTrig, duration, sampBuffer, ratioPitch, startPos, envbufnum:env, maxGrains:512);

	Out.ar(0, [sig,sig]);
}
).add;

);