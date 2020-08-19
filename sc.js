const sc = require("supercolliderjs")

//set up new server with async
sc.server.boot().then(async server => {
  const defs = await server.callAndResponse(sc.server.msg.defLoadDir("./sc/synthdefs/"));
  console.log("Registered Wavetable Prep Function...");
});

// function prepTables(srcBuf, newBuf, tableNum, frameSize){
//   let floatArr, sig, outBuff;

//   // build frame offset from
//   let frameOffset = ((tableNum * frameSize)-1).clip(0,(256*frameSize)-1);

//   sc.Signal.getToFloatArray()

//   //builds float array from buffer
//   srcBuf.getToFloatArray(frameOffset, frameSize, action:{arg floatArr; {

//     //converts float array to signal
//     sig = Signal.newClear(frameSize).waveFill({ arg x, old, index;
//       //This offsets the sample a bit so it doesn't have overruns or whatev. It removes some weird aliasing
//       floatArr[x];
//       // if(x+10<frameSize,if(x>10,floatArr[x],floatArr[x+10]),floatArr[x-10]);
//     },0,frameSize);
//     //to wavetable format
//     sig = sig.asWavetable;

//     // send collection streams an array (this time it's a signal) to the server and into a buffer.
//     newBuf.sendCollection(sig, wait:0.08);

//     //free the signal and array
//     floatArr.free;
//     sig.free;
//   }.defer;});
//   newBuf;
// };
// "".postln;