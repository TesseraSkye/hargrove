// - - - - - INIT - - - - -

//INSTRUCTIONS
/*
Press Ctrl Enter to execute code. Press Ctrl period to stop it if it gets stuck or is being weird.
Update the various paths with the paths to your samples. NEVER USE BACKSLASH "\", only ever forward "/".
Wavetables should be run through serum first to be compatible.

To turn it on, put your text cursor in the user params section and press ctrl enter. Do it again



*/
(

// USER PARAMS (RUN FIRST)

~activeSynth = \wavetable;
// Samples!
//This is for the sampler and granular..
~sampPath = "Q:/4_Code/Projects/HargroveOld/codebase-new/hargrove-sc/codebase/rev1/samples/woah.wav";

//..and this is for the wavetable synth. All of them should be filled and run through serum first.
~wtPath = ["","",""];
~wtPath.put(0,"Q:/4_Code/Projects/HargroveOld/codebase-new/hargrove-sc/codebase/rev1/samples/wt_shapes.wav");
~wtPath.put(1,"Q:/4_Code/Projects/HargroveOld/codebase-new/hargrove-sc/codebase/rev1/samples/wt_eguitar.wav");
~wtPath.put(2,"Q:/4_Code/Projects/HargroveOld/codebase-new/hargrove-sc/codebase/rev1/samples/wt_monster.wav");

//for dev stuff
~fullIO = false;

)



//boot the synth (RUN LAST)
~boot.value;



//(RUN SECOND)
(
~boot = {
	"Booting...".postln;
	s.boot;
	s.waitForBoot({
		fork {
			(
			);

			/*
			OSC3 Modes
			_0 - Sample Playback (PlayBuf) (low rate, osc rate) (Wrap)
			_1 - 3D Wavetable (VOsc) (allows recording)
			_2 - Granular (GrainBuf) (trig, dur, rate, pos)
			3 - Digital Oscilators (Osc) - Saw, sine, tri, pulse, supersaw, etc. Can be shaped with (Shaper)
			4 - Analog Sampled Oscillators - sampled from internal (VOsc ? maybe just Osc) Can be shaped with (Shaper)
			5 - Spring (Spring) - Spring Synthesis
			_6 - Resonators (DynKlank) - Bank modal resonator
			7 - Pluck (Pluck) - Karplus Pluck (variable source)
			*/

			~sampBuffer = Buffer.readChannel(s, ~sampPath,channels:[0],bufnum:1010);
			// b.postln;

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
				}).add;
			);

			/*	1.wait;
			~synth = Synth(\sampler, ["loop",1,'sampBuffer',b]);*/



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

					out=sig;
					if(~fullIO == true, {
						out = PanAz.ar(8, out, voiceNum/4, 1, 1, 0);
						Out.ar(0, out);
					}, {Out.ar(0, [out,out]);});
				}
				).add;

			);

			// ~synth = Synth(\granular, [\sampBuffer,b,\env,-1,\grainRate,7,\density,1,\ratioPitch,1,\startPos,0.2]);




			(
				//modal synthesis
				SynthDef.new(\resonator, {
					arg input, cpsPitch=440, paramX=0, paramY=1, paramZ=0, voiceNum=0,
					freqs (#[261.63, 523.26, 1048, 2096]),
					amps (#[0.8, 0.6, 0.4, 0.05]),
					rings (#[2, 1.5, 2, 0.8]);
					var sig, fOffset, dScale, ratioPitch, out;

					fOffset = paramX;
					dScale = paramY;
					ratioPitch = 2**((cpsPitch.cpsmidi / 12) - 5);

					fOffset = 600*(2**(fOffset))-600;
					sig = DynKlank.ar(`[freqs, amps, rings], input.asAudioRateInput, ratioPitch, fOffset, dScale);
					out=sig;
					out = Normalizer.ar(out);
					if(~fullIO == true, {
						out = PanAz.ar(8, sig, voiceNum/4, 1, 1, 0);
						Out.ar(0, out);
					}, {Out.ar(0, [out,out]);});
				}).add;
			);

			// ~synth = Synth(\resonator);


			(
				//hammer tube thing. idk, it's cool lol
				SynthDef.new(\tube, {
					arg cpsPitch = 440, paramX=0, paramY=0, paramZ=0, voiceNum=0;
					var sig, saw, modSaw, out;
					modSaw = Saw.ar(cpsPitch/(2**2));
					saw = Saw.ar(cpsPitch);

					sig = saw;

					sig = NTube.ar(sig,`[0.97,1.0,1.0,1.0,1.0,0.97],`[0.3,paramX-0.1,modSaw*paramZ,-0.4],`([0.01,0.02,0.01,0.005,0.05]*(paramY)))*0.1;
					sig = SineShaper.ar(sig, 0.5);

					sig = CombC.ar(sig,0.2, 1/(cpsPitch*(2**(paramZ*4))),0.1);
					sig = LeakDC.ar(sig);
					out=sig;
					out = Normalizer.ar(out);
					if(~fullIO == true, {
						out = PanAz.ar(8, out, voiceNum/4, 1, 1, 0);
						Out.ar(0, out);
					}, {Out.ar(0, [out,out]);});
				}).add;
			);

			// ~synth = Synth(\tube);


			1.wait;


			// W A V E T A B L E
			//makes wavetable out of buffer
			(
				~prepTables = {
					arg srcBuf, newBuf, tableNum, frameSize;
					var floatArr, sig, frameOffset, outBuff;

					// build frame offset from
					frameOffset = ((tableNum * frameSize)-1).clip(0,256*frameSize-1);
					//builds float array from buffer
					srcBuf.getToFloatArray(frameOffset, frameSize, action:{arg floatArr; {

						//converts float array to signal
						sig = Signal.newClear(frameSize).waveFill({ arg x, old, index;
							//This offsets the sample a bit so it doesn't have overruns or whatev. It removes some weird aliasing
							floatArr[x];
							// if(x+10<frameSize,if(x>10,floatArr[x],floatArr[x+10]),floatArr[x-10]);
						},0,frameSize);
						//to wavetable format
						sig = sig.asWavetable;

						// send collection streams an array (this time it's a signal) to the server and into a buffer.
						newBuf.sendCollection(sig, wait:0.08);

						//free the signal and array
						floatArr.free;
						sig.free;
					}.defer;});
					newBuf;
				};
				"".postln;
				"Registered Wavetable Prep Function...".postln;
			);

			1.wait;
			// Wavetable Prep
			(
				~buildTables = {
					//forked so delays work
					fork {
						"".postln;
						~frameSize = 2048;
						~tables = [];
						~wtRef = [];
						~tableFrames = [];
						~tableSamps = [];

						~wtPath.do({
							arg item, index;
							var loopDone, activeTableSamps, activeFrames, activeRef;
							~wtRef = ~wtRef.add(Buffer.read(s, ~wtPath[index],bufnum:1000+index));
							loopDone = Condition(false);
							fork{
								0.1.wait;
								"Calculating Frames...".postln;
								activeRef = ~wtRef[index];
								// activeRef.postln;
								activeRef.numFrames.postln;
								~tableSamps = ~tableSamps.add(activeRef.numFrames);
								// ~tableSamps.postln;
								activeTableSamps = ~tableSamps[index];
								// activeTableSamps
								// activeTableSamps.postln;
								~tableFrames = ~tableFrames.add(activeTableSamps / (~frameSize));
								// ~tableFrames.postln;
								activeFrames = ~tableFrames[index];
								// activeFrames.postln;
								"".postln;
								0.1.wait;
								("Wavetable build started for table" + (index+1)).postln;
								//get frames in wavetable
								~tables = ~tables.add(Buffer.allocConsecutive(activeFrames,s,~frameSize*2,bufnum:index*256););
								"".postln;
								0.1.wait;
								fork {
									~tables[index].do({
										arg data, num;
										// num.postln;
										// done twice to fix weird bug
										fork {
											//forces the execution to wait so there aren't overlaps
											(num/5).wait;
											AppClock.sched(0, {(~prepTables.value(~wtRef[index], data, num, ~frameSize));});
											AppClock.sched(0.05, {~tables[index] = ~tables[index].put(num,~prepTables.value(~wtRef[index], data, num, ~frameSize);)});
											(((num+1)/~tableFrames[index]*100).asInteger+"% done...").postln;
											(num+1 == ~tableFrames[index]).if({("___Table"+(index+1)+"Done!___").postln},{});
										};
									});
									// loopDone.unhang.wait(~tableFrames[index]*0.5 + 1);
								};
								loopDone.hang;
							};
							//
						});
					};
				};
			);


			/*	~activeDir.postln;
			~wtPath[0].postln;*/

			//build the tables
			~buildTables.value;


			//NEEDS CONFIG FOR WT LENGTH
			1.wait;
			((~tableFrames.maxItem) / 5).wait;

			(
				SynthDef.new(\wavetable, {
					arg rate=0, cpsPitch=110, frameSize = 2048, paramX=0, paramY=0, paramZ=0, frameCount = ~tableFrames, voiceNum = 0;
					var sig1, sig2, sig3, array, levels, out;
					// frameCount = frameCount - 1;
					// Uses HSV to RGB to make an even power mixer
					levels = levels.add(1-(paramY * ArrayMax.kr([0,ArrayMin.kr([((5 + (6*paramX))%6),4-(((5 + (6*paramX))%6)),1])])));
					levels = levels.add(1-(paramY * ArrayMax.kr([0,ArrayMin.kr([((3 + (6*paramX))%6),4-(((3 + (6*paramX))%6)),1])])));
					levels = levels.add(1-(paramY * ArrayMax.kr([0,ArrayMin.kr([((1 + (6*paramX))%6),4-(((1 + (6*paramX))%6)),1])])));


					// 3 sets of wavetables
					sig1 = VOsc.ar((paramZ * (~tableFrames[0]-1)).clip(0.001,(~tableFrames[0]-1)-0.001),cpsPitch,0,levels[0][0][0]);
					sig2 = VOsc.ar(256+(paramZ * (~tableFrames[1]-1)).clip(0.001,(~tableFrames[1]-1)-0.001),cpsPitch,0,levels[1][0][0]);
					sig3 = VOsc.ar(512+(paramZ * (~tableFrames[2]-1)).clip(0.001,(~tableFrames[2]-1)-0.001),cpsPitch,0,levels[2][0][0]);
					//combine them
					array = [sig1 , sig2, sig3];
					//remove any DC offset
					// array = LeakDC.ar(array);
					//sum them
					//reduced and normalized to prevent clipping
					out = Mix(array);

					if(~fullIO == true, {
						out = PanAz.ar(8, out, voiceNum/4, 1, 1, 0);
						Out.ar(0, out);
					}, {Out.ar(0, [out,out]);});
				}).add;
			);
			1.wait;
			// ~synth = Synth(\wavetable);


			// M I D I


			//!!!!!!!R A T I O   P I T C H   I S  2**((cpsPitch.cpsmidi / 12) - 5)
			(
				//done bc midi is blegh
				// MIDIClient.sources;
				MIDIClient.init(nil,nil,false);
				MIDIIn.connectAll(false);

				0.5.wait;

				MIDIdef.noteOn(\keybedOn, {
					arg val, note, chan, src;

					// note.postln;

					//Round robin steal voices n such
					//If it would be too many...
					if(((~voiceAge.size+1) > 8),{
						var ageMinIndex;
						ageMinIndex = ~voiceAge.minIndex;
						ageMinIndex.postln;
						//Free old synth..
						~voiceArray[ageMinIndex].free;
						//overwrite the oldest..
						~voiceArray.put(ageMinIndex,Synth(~activeSynth,[\sampBuffer, ~sampBuffer, \cpsPitch, note.midicps, \paramX, ~paramArray[0],\paramY, ~paramArray[1], \paramZ, ~paramArray[2]]));
						//overwrite the note number..
						~voiceNote.put(ageMinIndex, note);
						//... and overwrite the date object.
						~voiceAge.put(ageMinIndex, Date.getDate.rawSeconds);
					},
					{
						//add them nondestructively
						~voiceArray = ~voiceArray.add(Synth(~activeSynth,
							[\sampBuffer, ~sampBuffer, \cpsPitch, note.midicps, \paramX, ~paramArray[0],\paramY, ~paramArray[1], \paramZ, ~paramArray[2]]));
						~voiceAge = ~voiceAge.add(Date.getDate.rawSeconds);
						~voiceNote = ~voiceNote.add(note);
					});
				}).permanent_(true);

				MIDIdef.noteOff(\keybedOff, {
					arg val, note, chan, src;
					var index;

					// note.postln;

					//get freeing note
					index = ~voiceNote.indexOf(note);
					// if it exists, remove it. if not, assume it was freed
					if((index+2).booleanValue,{
						//Free synth..
						~voiceArray[index].free;
						//then remove it..
						~voiceArray.removeAt(index);
						//then overwrite the date object...
						~voiceAge.removeAt(index);
						//..then remove the note data.
						~voiceNote.removeAt(index);
					})
				}).permanent_(true);

				//CCs
				~paramArray=[0,0,0];
				MIDIdef.cc(\paramX,{
					arg val, num, chan, src;
					var newVal;
					newVal=(val/127);
					~paramArray = ~paramArray.put(0,newVal);
					~voiceArray.do({
						arg item, index;
						item.set(\paramX, newVal);
					});
				},1).permanent_(true);

				MIDIdef.cc(\paramY,{
					arg val, num, chan, src;
					var newVal;
					newVal=(val/127);
					~paramArray = ~paramArray.put(1,newVal);
					~voiceArray.do({
						arg item, index;
						item.set(\paramY, newVal);
					});
				},2).permanent_(true);

				MIDIdef.cc(\paramZ,{
					arg val, num, chan, src;
					var newVal;
					newVal=(val/127);
					~paramArray = ~paramArray.put(2,newVal);
					~voiceArray.do({
						arg item, index;
						item.set(\paramZ, newVal);
					});
				},3).permanent_(true);

				"Registered Midi Responders".postln;

			);

			0.5.wait;

			"Hargrove booted!".postln;



		};
	});
};
);
// at some point here, the outboard preset manager will read the osc3 controls and send them as OSC messages