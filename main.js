const sc = require("supercolliderjs")

//set up new server with async
sc.server.boot().then(async server => {
  // construct synthdef in SCCode
  const samplerAtonal = await server.synthDef(
    "samplerAtonal",
    `
    {
      arg rate = 1, path, start = 0, length = 1, loop = 0, trig = -1;

      var loopStart, loopLength, loopEnd, loopRate, loopFull, sig;

      // check and see if the buffer has already been initialized. If not, instantiate
      ~sampBuffer = Buffer.read(s, path);

      //convert positional args to samples
      loopStart = start * BufFrames.kr(~sampBuffer);
      loopLength = length * BufFrames.kr(~sampBuffer);
      loopEnd = loopStart + loopLength;
      //positive rate is forward playback, negative is reversed. +-1 is initial speed
      loopRate = BufRateScale.kr(~sampBuffer.bufnum) * rate + fm;
      loopFull = Phasor.ar(trig, loopRate, 0, loopLength);
      
      sig = BufRd.ar(1, ~sampBuffer, (Wrap((loopFull + loopStart),0, BufFrames.kr(~sampBuffer))), 0, 4);
      //If loop is false, kills at end of cycle
      if ((loop == 0), {
        FreeSelf(loopFull.value - (loopLength - 1))
      },
      {});

      Out.ar(0, sig);
    }
    `
  )
})