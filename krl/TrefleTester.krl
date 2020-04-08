ruleset TrefleTester {
  meta {
    shares __testing, getPlants, getPlantDetails
    use module TrefleKeys
    use module TrefleModule alias trefle with
        authToken = keys:trefle_keys{"token"}
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "getPlants", "args": ["commonName"]  }
      , { "name": "getPlantDetails", "args": ["id"] }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    
    getPlants = function(commonName) {
      trefle:getPlants(commonName)
    }
    
    getPlantDetails = function(id) {
      trefle:getPlantDetails(id)
    }
  }
}
