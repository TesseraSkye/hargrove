import * as sc from 'supercolliderjs'
import path from 'path'

sc.server.boot({ scsynth: path.resolve('./src/sc/redist/scsynth.exe')}).then(async server => {
  //load the synthdefs
  const defLoadMsg = sc.server.msg.defLoadDir((path.resolve('./src/sc/defs')))
  await server.callAndResponse(defLoadMsg);
  const loadBufOne = await sc.server.msg.bufferAllocRead({bufferID: 1010, path: "Q:/4_Code/Projects/hargrove/src/samples/vocoder.wav"})
  console.log(loadBufOne)
  await sc.server.msg.synthNew({defName:'granular',args:['']})
  // console.log(await defLoadMsg.response)
  // await server.synth('granular')
    
  

})