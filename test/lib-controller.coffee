assert = require 'assert'

controller = require '../src/controller.coffee'
controller.debug = yes

describe '#decodePulses()', ->
  tests = [
    {
      protocol: 'generic'
      pulseLengths: [671, 2051, 4346, 10220]
      pulses: [
        '020102010201020101020102010201020102020101020201020102010102020101020201010202010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201010202010201020102010201020102010201020102010201020102010201020102010201020102010102020102010102010201020201010202010201010203'
        '020102010201020101020102010201020102010202010201010201020102020101020201010202010201020102010201020102010201020102010201020102010102020102010201020102010102010202010201020101020102010202010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201020102010201020102010201020102010201020102010201020102010102020102010201020102010102010202010201020101020102010202010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010203'
      ]
      values: [
        { id: 1000, type: 10, positive: true, value: 1 }
        { id: 1000, type: 10, positive: true, value: 1257 }
        { id: 1011, type: 10, positive: true, value: 67129 }
        { id: 1000, type: 10, positive: false, value: 67129 }
        { id: 1000, type: 10, positive: true, value: 1073741823 }
      ]
    },
    {
      protocol: 'pir1'
      pulseLengths: [358, 1095, 11244]
      pulses: [
        '01100101011001100110011001100110011001010110011002'
        '01100110011001100110010101100110011001010110011002'
        '01100110011001010110011001100110010101100110011002'
      ]
      values: [
        { unit: 8, id: 1, presence: true }
        { unit: 0, id: 17, presence: true }
        { unit: 2, id: 2, presence: true }
      ]
    },
    {
      protocol: 'pir2'
      pulseLengths: [451, 1402, 14356]
      pulses: [
        '01100110010110011001010110100101010101011010010102'
      ]
      values: [
        { unit: 21, id: 21, presence: true }
      ]
    },
    {
      protocol: 'pir4'
      pulseLengths: [ 371, 1081, 5803 ]
      pulses: [
        '110100110101001101010011001010101012'
      ]
      values: [
        { id: 54099, unit: 21290, presence: true }
      ]
    },
    {
      protocol: 'weather1'
      pulseLengths: [456, 1990, 3940, 9236]
      pulses: [
        '01020102020201020101010101010102010101010202020102010101010102010101020103'
        '01020102010201010101020202020101010101020101010101020101010102020202010203'
        '01020102020201010102020102020101010101020101010101010101010102020202010103'
        '01020102010102020102020102020201010101010202020201020101010201010101020203'
      ]
      values: [
        { id: 208 ,channel: 2 ,lowBattery: true ,temperature: 23.2, humidity: 34 }
        { id: 67  ,channel: 1 ,lowBattery: false ,temperature: 26.0, humidity: 61 }
        { id: 198 ,channel: 1 ,lowBattery: false ,temperature: 25.6, humidity: 60 }
        { id: 54 ,channel: 3 ,lowBattery: false ,temperature: 24.4, humidity: 67 }
      ]
    },
    {
      protocol: 'weather2'
      pulseLengths: [492, 969, 1948, 4004]
      pulses: [
        '01010102020202010201010101010101020202010201020102020202010101010101010103'
        '01010102020202010201010101010101020202010201010202020202010101010101010103'
        '01010102020202010201010101010101020202010201010102020202010101010101010103'
        '01010101020201020201010101010102010101010202010102020202010101010101010103'
        '01010101020201020201010101010102010101010201010102020202010101010101010103'
        '02010102010102020201010102020202020102020102020102020202010101010202020103'
      ],
      values: [
        { temperature: 23.4 }
        { temperature: 23.3 }
        { temperature: 23.2 }
        { temperature: 26.8 }
        { temperature: 26.4 }
        { temperature: -7.4 }
      ]
    },
    {
      protocol: 'weather3'
      pulseLengths: [508, 2012, 3908, 7726]
      pulses: [
        '01010202020201020201010102010102020201020202010202010201010101010202010201010101020103'
        '01010202020201020201010102010201020201020202010202010201010101010202010201010202010103'
        '01010201020102020102010101010101010101020101010202010101010201020101010101010102010203'
        '01010201020102020102010101010102020201020101010202010101010201020101010101010102010103'
        '01010101010202020201010101020201010201010101010202010202020101010202010201010101010203'
        '01010101010202020201010101020102010201010102010202010202020201010202010101010202010103'
      ]
      values: [
        { id: 246, channel: 3, temperature: 24.2, humidity: 56 }
        { id: 246, channel: 3, temperature: 24.4, humidity: 56 }
        { id: 173, channel: 1, temperature: 21.1, humidity: 65 }
        { id: 173, channel: 1, temperature: 21.5, humidity: 65 }
        { id: 30,  channel: 2, temperature: 18.1, humidity: 62 }
        { id: 30,  channel: 2, temperature: 18.7, humidity: 63 }
      ]
    },
    {
      protocol: 'weather4'
      pulseLengths: [ 526, 990, 1903, 4130, 7828, 16076 ]
      pulses: [
        '11111111040303030203030302020302030203020302030302020202030302020202030303020202030202020305'
      ]
      values: [
        { id: 238, channel:1, temperature: 18.9, humidity: 71, battery: 2.5 }
      ]
    },
    {
      protocol: 'weather5'
      pulseLengths: [ 534, 2000, 4000, 9120  ]
      pulses: [
        '01020101010201020102010101020202020202010101010102020201010202010202020203'
        '01010101010101010102020102020101020202010201010101010101010101010101010203'
        '01020202010101020102020102020101020102020202010101010101010101010102020103'
        '01020202010202020101010102010201020202010101010102010102020101020201020103'
        '01020202010202020101020101020101020202020202020202010102010202010101010103'
      ]
      values: [
        { id: 162, temperature: 12.6, humidity: 67, lowBattery: false }
        { id: 0, rain: 5.75, lowBattery: false }
        { id: 142, rain: 15.25, lowBattery: false }
        { id: 238, temperature: 11.7, humidity: 99,  lowBattery: false }
        { id: 238, temperature: -1.4, humidity: 69,  lowBattery: false }
      ]
    },
    {
      protocol: 'weather7'
      pulseLengths: [ 444, 1992, 3955, 9330 ]
      pulses: [
        '010202010201010202010101010101010101010202020102020202010202010103'
      ]
      values: [
        { id: 105, temperature: 2.9, channel: 0, lowBattery: false }
      ]
    },
    {
      protocol: 'dimmer1'
      pulseLengths: [259, 1293, 2641, 10138]
      pulses: [
        '0200010001010000010001010000010001000101000100010001000100000101000100010000010001000100010001010001000001000101000001000100010001010001000100010003'
      ],
      values: [
        {id: 9565958, all: false, unit: 0, dimlevel: 15, state: true}
      ]
    },
    {
      protocol: 'switch1'
      pulseLengths: [268, 1282, 2632, 10168]
      pulses: [
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001000103'
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001010003'
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010001000100010001010003'
      ],
      values: [
        { id: 9390234, all: false, state: true, unit: 0 }
        { id: 9390234, all: false, state: true, unit: 1 }
        { id: 9390234, all: false, state: false, unit: 1 }
      ]
    },
    {
      protocol: 'switch2'
      pulseLengths: [306, 957, 9808]
      pulses: [
        '01010101011001100101010101100110011001100101011002'
      ],
      values: [
        { houseCode: 25, unitCode: 16, state: true }
      ]
    },
    { 
      protocol: 'switch4'
      pulseLengths: [ 295, 1180, 11210 ],
      pulses: [
        '01010110010101100110011001100110010101100110011002'
      ],  
      values: [
         { id: 2, unit: 20, state: true }
      ]
    },
    {
      protocol: 'switch5'
      pulseLengths: [295, 886, 9626]
      pulses: [
        '10010101101010010110010110101001010101011010101002'
        '10010101101010010110010110101001010101011010100102'
        '10010101101010010110010110101001010101011010011002'
        '10010101101010010110010110101001010101011010010102'
        '10010101101010010110010110101001010101011001101002'
        '10010101101010010110010110101001010101011001100102'
        '10010101101010010110010110101001010101010110101002'
        '10010101101010010110010110101001010101010110100102'
        '10010101101010010110010110101001010101010101011002'
        '10010101101010010110010110101001010101010101100102'
     ],
      values: [
        { id: 465695, unit: 1, all: false, state: on }
        { id: 465695, unit: 1, all: false, state: off }
        { id: 465695, unit: 2, all: false, state: on }
        { id: 465695, unit: 2, all: false, state: off }
        { id: 465695, unit: 3, all: false, state: on }
        { id: 465695, unit: 3, all: false, state: off }
        { id: 465695, unit: 4, all: false, state: on }
        { id: 465695, unit: 4, all: false, state: off }
        { id: 465695, unit: 0, all: true, state: off }
        { id: 465695, unit: 0, all: true, state: on }
      ]
    },
    { 
      protocol: 'switch6'
      pulseLengths: [ 150, 453, 4733],
      pulses: [
        '10101010101010101010010101100110011001100110010102'
        '10101010101010100110011001010110011001100110010102'
      ],  
      values: [
         { systemcode: 31, programcode: 1, state: true }
         { systemcode: 15, programcode: 2, state: true }
      ]
    },
    { 
      protocol: 'switch7'
      pulseLengths: [307, 944, 9712],
      pulses: [
        '01010101010101100110011001100110011001100110011002'
        '01010101010101100101010101010110011001100110011002'
        '10100101011001100101010101010110011001100110011002'
      ],  
      values: [
         { id: 0, unit: 3, state: true }
         { id: 7, unit: 3, state: true }
         { id: 7, unit: 1, state: false }
      ]
    },
    { 
      protocol: 'switch8'
      pulseLengths: [ 173, 563, 5740],
      pulses: [
        '01010101010101010110011001100110101001011010010102'
        '01010101010101010110011001101010010101010101101002'
      ],  
      values: [
         { systemcode: 30, programcode: 'B1', state: false }
         { systemcode: 30, programcode: 'C3', state: true }
      ]
    },
    { 
      protocol: 'switch9'
      pulseLengths: [ 305, 615, 23020],
      pulses: [
        '0110100101100110011010101001101010101001011012'
        '0110100101100110011010101001101010101001101012'
        '0110100101100110011010101001101010101010011012'
        '0110100101100110011010101001101010010101100112'
      ],  
      values: [
         { id: 2472, unit: 65, state: true }
         { id: 2472, unit: 65, state: false }
         { id: 2472, unit: 64, state: true }
         { id: 2472, unit: 71, state: false }
      ]
    },
    { 
      protocol: 'switch10'
      pulseLengths: [ 271, 1254, 10092 ],
      pulses: [
        '01010000000101010100000100010101010000000101010100000101000100000101000101010001000100010001010001000101000000010102'
      ],  
      values: [
         { id:3162089194, unit:35, all:false, state:false }
      ]
    },
    { 
      protocol: 'switch11'
      pulseLengths: [ 566, 1267, 6992 ],
      pulses: [
        '100101010110011010101001101001010101100110010110011010100110011002'
        '100101011010011010101001101001010101100110010110011010100110011002'
        '100101101001011010101001101001010101100110010110011010100110011002'
        '100101100110011010101001101001010101100110010110011010100110011002'
      ],  
      values: [
         { id: 34037, unit: 1, state: true }
         { id: 34037, unit: 1, state: false }
         { id: 34037, unit: 0, state: true }
         { id: 34037, unit: 0, state: false }
      ]
    },
    { 
      protocol: 'switch12'
      pulseLengths: [ 564, 1307, 3237, 51535 ],
      pulses: [
        '1202021212021212121212121212021212121212121212121203'
        '1202021212021212121212121212121212121202121202021203'
        '1202021212021212121212121212121212021212121202120213'
        '1202021212021212121212121212121202121212121202120203'
      ],  
      values: [
         { id: 9983, unit: 1, state: true }
         { id: 9983, unit: 1, state: false }
         { id: 9983, unit: 2, state: true }
         { id: 9983, unit: 3, state: true }
      ]
    },
    { 
      protocol: 'switch13'
      pulseLengths: [ 700, 1400, 81000 ]
      pulses: [
        '001100110101001010101010101010110010101102'
        '001100110101001010101010101010101010101012'
        '001100110101001010101010101010101100110012'
        '001100110101001010101010101010110100110102'
      ],  
      values: [
         { id:1472, unit:0, all:false, state:true,  dimm:false}
         { id:1472, unit:0, all:false, state:false, dimm:false}
         { id:1472, unit:0, all:false, state:false, dimm:true }
         { id:1472, unit:0, all:false, state:true,  dimm:true }
      ]
    },
    { 
      protocol: 'switch14'
      pulseLengths: [ 208, 624, 6556 ]
      pulses: [
        '01010101010101010101010101010101010101011010101002'
        '01010101010101010101010101010101010101011010100102'
        '01010101010101010101010101010101010101010110101002'
        '01010101010101010101010101010101010101011010010102'
      ],  
      values: [
         { id:0, unit:1, all:false, state:true }
         { id:0, unit:1, all:false, state:false}
         { id:0, unit:2, all:false, state:true }
         { id:0, unit:1, all:true , state:false}
      ]
    },
    { 
      protocol: 'switch15'
      pulseLengths: [ 300, 914, 9624 ]
      pulses: [
        '01101001011001100110010110011010101001011010101002'
        '01101001011001100110010110011010101001010110101002'
        '01101001011001100110010110011010101001011001101002'
        '01101001011001100110010110011010101001011001010102'
      ],  
      values: [
         { id:414908, unit:1, all:false, state:true }
         { id:414908, unit:1, all:false, state:false}
         { id:414908, unit:2, all:false, state:true }
         { id:414908, unit:0, all:true , state:false }
      ]
    },
    { 
      protocol: 'rolling1'
      pulseLengths: [500, 1000, 3000, 7250],
      pulses: [
        '01101010100101011001101010010110100110100101100123'
        '01101010011010011010011010010101100110011010100123'
        '01101010011010011010011010010101100110011010010123'
      ],  
      values: [
         { code: "011110001011100110110010"}
         { code: "011101101101100010101110"}
         { code: "011101101101100010101100"}
      ]
    },
    {
      protocol: 'contact1'
      pulseLengths: [268, 1282, 2632, 10168]
      pulses: [
        '0200010001010001000001000100010100010000010100010001000100010000010100000100010001010001000001010001000001000101000100000100010100000101000001000103'
        '020001000101000100000100010001010001000001010001000100010001000001010000010001000101000100000101000100000100010001010000010001010003'
      ],
      values: [
        { id: 13040182, all: false, contact: false, unit: 9 }
        { id: 13040182, all: false, contact: true, unit: 9 }
      ]
    },
    {
      protocol: 'contact2'
      pulseLengths: [295, 886, 9626]
      pulses: [
        '10010110100101011010101010011001010101011001010102'
        '10010110100110011010010101101001010101011001010102'
     ],
      values: [
        { id: 421983, contact: false }
        { id: 414623, contact: false }
      ]
    },
    {
      protocol: 'led1'
      pulseLengths: [ 350, 1056, 10904 ]
      pulses: [
        '01100110100101011001100110101001010110010101011002'
        '01011010010101100110011010101001010110010101011002'
        '01100110100101011001100110101001010110010110010102'
        '01100110100101011001100110101001010110010101100102'
     ],
      values: [
        { id: 22702, command: "on/off" }
        { id: 12638, command: "on/off" }
        { id: 22702, command: "up" }
        { id: 22702, command: "down" }
      ]
    },
    {
      protocol: 'led2'
      pulseLengths: [ 434, 1227, 13016 ]
      pulses: [
        '01010110101001101010100110011001010101100101011002'
        '01010110101001101010100110011001010101011001011002'
        '01010110101001101010100110011001010101010110101002'
        '01010110101001101010100110011001010101010101011002'
        '01010110101001101010100110011001010110010101011002'
     ],
      values: [
        { id: 7658, command: "mode-" }
        { id: 7658, command: "25%" }
        { id: 7658, command: "100%" }
        { id: 7658, command: "on/off" }
        { id: 7658, command: "code:00100001" }
      ]
    },
    {
      protocol: 'led4'
      pulseLengths: [ 346, 966, 9476 ] 
      pulses: [
        '01010101010110100101011010100101100101010110011102'
        '01010101010110100101011010100101100101010101101102'
        '01010101010110100101011010100101100101010110100102'
        '01010101010110100101011010100101010101101010011102'
        '01010101010110100101011010100101010101010110010102'
     ],
      values: [
        { id: 796, command: "on/off" }
        { id: 796, command: "bright+" }
        { id: 796, command: "color+" }
        { id: 796, command: "code:00011101" }
        { id: 796, command: "code:00000100" }
      ]
    }
  ]

  runTest = ( (t) ->
    it "#{t.protocol} should decode the pulses", ->
      for pulses, i in t.pulses
        results = controller.decodePulses(t.pulseLengths, pulses)
        assert(results.length >= 1, "pulse of #{t.protocol} should be detected.")
        result = null
        for r in results
          if r.protocol is t.protocol
            result = r
            break
        assert(result, "pulse of #{t.protocol} should be detected as #{t.protocol}.") 
        assert.deepEqual(result.values, t.values[i])
  )

  runTest(t) for t in tests

  it "should decode fixable pulses", ->
    pulseLengths =[ 258, 401, 1339, 2715, 10424 ]
    pulses = '030002000202000200000202000002020000020002020000020002020000020201020000020200020000020201020002000200000200020002000200020002000204' 
    results = controller.decodePulses(pulseLengths, pulses)
    assert(results.length >= 1, "fixable pulses should be fixed.")


describe '#compressTimings()', ->
  tests = [
    {
      protocol: 'switch2'
      timings: [
        [ 288, 972, 292, 968, 292, 972, 292, 968, 292, 972, 920, 344, 288, 976, 920, 348, 
          284, 976, 288, 976, 284, 976, 288, 976, 288, 976, 916, 348, 284, 980, 916, 348, 
          284, 976, 920, 348, 284, 976, 920, 348, 284, 980, 280, 980, 284, 980, 916, 348, 
          284, 9808
        ],
        [
          292, 968, 292, 972, 292, 972, 292, 976, 288, 976, 920, 344, 288, 976, 920, 348, 
          284, 976, 288, 976, 288, 976, 284, 980, 284, 976, 920, 348, 284, 976, 916, 352, 
          280, 980, 916, 352, 280, 980, 916, 348, 284, 980, 284, 976, 284, 984, 912, 352, 
          280, 9808
        ],
        [
          292, 976, 288, 972, 292, 972, 292, 920, 288, 976, 920, 344, 288, 980, 916, 344, 
          288, 980, 284, 980, 284, 972, 288, 980, 284, 976, 920, 344, 288, 976, 916, 352, 
          280, 980, 916, 348, 284, 980, 916, 348, 284, 980, 284, 976, 288, 976, 916, 352, 
          280, 9804
        ],
        [
          288, 972, 292, 968, 296, 972, 296, 976, 288, 976, 920, 344, 288, 976, 920, 344, 
          292, 972, 288, 976, 288, 976, 284, 976, 288, 976, 920, 344, 288, 976, 920, 344, 
          284, 980, 916, 348, 284, 980, 916, 348, 284, 980, 284, 976, 288, 980, 912, 352, 
          280, 9808
        ]
      ]
      results: [
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002'
        }
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002'
        }
        { 
          buckets: [ 304, 957, 9804 ],
          pulses: '01010101011001100101010101100110011001100101011002' 
        }
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002' 
        }
      ]
    },
    {
      protocol: 'switch4'
      timings: [
        [
          295, 1180, 295, 1180, 295, 1180, 1180, 295, 295, 1180, 295, 1180, 295, 1180, 1180, 295, 
          295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 
          295, 1180, 295, 1180, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 
          295, 11210
        ]
      ]
      results: [
        {  
          buckets: [ 295, 1180, 11210 ],
          pulses: '01010110010101100110011001100110010101100110011002'
        }
      ]
    }
  ]

  runTest = ( (t) ->
    it 'should compress the timings', ->
      for timings, i in t.timings
        result = controller.compressTimings(timings)
        assert.deepEqual(result, t.results[i]) 
  )

  runTest(t) for t in tests

describe '#encodeMessage()', ->
  tests = [
    {
      protocol: 'switch1'
      message: { id: 9390234, all: false, state: true, unit: 0 }
      pulses: '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001000103'
    },
    {
      protocol: 'switch2'
      message: { houseCode: 25, unitCode: 16, state: true }
      pulses: '01010101011001100101010101100110011001100101011002'
    },
    {
      protocol: 'switch5'
      message: { id: 465695, unit: 2, all: false, state: on }
      pulses: '10010101101010010110010110101001010101011010011002'
    },
    {
      protocol: 'switch6'
      message: {systemcode: 15, programcode: 2, state: true }
      pulses: '10101010101010100110011001010110011001100110010102'
    },
    {
      protocol: 'switch7'
      message: {id: 7, unit: 3, state: true }
      pulses: '01010101010101100101010101010110011001100110011002'
    },
    {
      protocol: 'switch8'
      message: {systemcode: 30, programcode: 'C3', state: true }
      pulses: '01010101010101010110011001101010010101010101101002'
    },
    {
      protocol: 'switch9'
      message: {id: 2472, unit: 65, state: true }
      pulses: '0110100101100110011010101001101010101001011012'
    },
    {
      protocol: 'switch10'
      message: {id:3162089194, unit:35, all:false, state:false }
      pulses: '01010000000101010100000100010101010000000101010100000101000100000101000101010001000100010001010001000101000000010102'
    },
    {
      protocol: 'switch12'
      message: {id: 9983, unit: 1, state: true }
      pulses: '1202021212021212121212121212021212121212121212121203'
    },
    {
      protocol: 'switch13'
      message: { id:1472, unit:0, all:false, state:true,  dimm:false}
      pulses: '001100110101001010101010101010110010101102'
    },
    {
      protocol: 'switch14'
      message: { id:0, unit:4, all:false, state:false}
      pulses: '01010101010101010101010101010101010101010101100102'
    },
    {
      protocol: 'switch15'
      message: { id:414908, unit:1, all:false, state:true }
      pulses: '01101001011001100110010110011010101001011010101002'
    },
    {
      protocol: 'led3'
      message: {id:14152, command:"cyan" }
      pulses: '01011010011010100110010110010101010101100110010102'
    },
    {
      protocol: 'led4'
      message: {id:796, command:"on/off" }
      pulses: '01010101010110100101011010100101100101010110011002'
    },
    {
      protocol: 'rolling1'
      message: {
        codeOn: [
          "011111110000111001011100",
          "011101101101100010101100",
          "011111011110001001101100",
          "011110011010111100011100"
        ],
        codeOff: [
          "011110001011100110111100",
          "011110101001110001111100",
          "011100010001011100101100",
          "011101110011101010001100"
        ],
        state: true }
      pulses: '01101010101010100101010110101001011001101010010123'
    }
  ]

  runTest = ( (t) ->
    it "should create the correct pulses for #{t.protocol}", ->
      result = controller.encodeMessage(t.protocol, t.message)
      assert.equal result.pulses, t.pulses
  )

  runTest(t) for t in tests


describe '#fixPulses()', ->
  tests = [
    {
      pulseLengths: [ 258, 401, 1339, 2715, 10424 ],
      pulses: '030002000202000200000202000002020000020002020000020002020000020201020000020200020000020201020002000200000200020002000200020002000204'
      result: { 
        pulseLengths: [ 329, 1339, 2715, 10424 ],
        pulses: '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103'
      }
    },
    { 
      pulseLengths: [ 239, 320, 1337, 2717, 10359 ],
      pulses: '030002000202000201010202010002020101020102020101020102020101020201020101020201020101020201020102010201010201020102010201020112000204'
      result: { 
        pulseLengths: [ 279, 1337, 2717, 10359 ],
        pulses: '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103' 
      }
    }
  ]

  runTest = ( (t) ->
    it "should fix the pulses", ->
      result = controller.fixPulses(t.pulseLengths, t.pulses)
      assert.deepEqual result.pulseLengths, t.result.pulseLengths
      assert.equal result.pulses, t.result.pulses
  )

  runTest(t) for t in tests

  it "should not change correct pulses", ->
    pulseLengths = [ 279, 1337, 2717, 10359 ]
    pulses = '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103'
    result = controller.fixPulses(pulseLengths, pulses)
    assert(result is null)



