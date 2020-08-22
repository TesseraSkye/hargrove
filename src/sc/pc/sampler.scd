(
			// BufRd Sampler. Rate control is through zero
			SynthDef.new('sampler', {

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
				//prevents dropouts by forcing the synth quiet
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
				//set up panning to all 8 outputs
				out=sig;
				if(~fullIO == true, {
					out = PanAz.ar(8, sig, voiceNum/4, 1, 1, 0);
					Out.ar(0, out);
				}, {Out.ar(0, [out,out]);});
				//Here to make life good for debug
				// Out.ar(0, [sig,sig]);
				//frees self at end if loop is off
				freeTrig = loopPos > (loopLength - 100 + (1000 * (loop)));
				FreeSelf.kr(freeTrig);
			// });
			}).add;
		);