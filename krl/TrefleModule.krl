ruleset TrefleModule {
  meta {
    shares __testing, getPlants, getPlantDetails
    configure using authToken = ""
    provide getPlants, getPlantDetails
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }, { "name": "getPlants" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    
    getPlants = function(commonName) {
      plants = (commonName.isnull() || commonName == "") => http:get(<<https://trefle.io/api/plants?token=#{authToken}>>, parseJSON=true) | http:get(<<https://trefle.io/api/plants?token=#{authToken}&common_name=#{commonName}>>, parseJSON=true);
      plants
    }
    
    getPlantDetails = function(id) {
      plant = http:get(<<https://trefle.io/api/plants/#{id}?token=#{authToken}>>, parseJSON=true);
      plant
    }
    
  }

}
