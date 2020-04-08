ruleset bingmaps.route {
  meta {
    shares __testing, getRoute, getDistance
    configure using API_TOKEN = ""
    provide getDistance
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }, { "name": "getMessages", "args": [ "toPhone", "fromPhone", "pagination" ] }
      , { "name": "getDistance", "args": [ "originLat" "originLong", "destinationLat", "destinationLong" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    baseUrl = "http://dev.virtualearth.net/REST/V1"

    request = function(url, params = {}) {
      http:get(baseUrl + url, qs = params.put("key": API_TOKEN));
    }

    getRoute = function(originLat, originLong, destinationLat, destinationLong) {
      params = {
        "wp.0": <<#{originLat},#{originLong}>>,
        "wp.1": <<#{destinationLat},#{destinationLong}>>
      };
      request("/Routes/Driving", params);
    }

    getDistance = function(originLat, originLong, destinationLat, destinationLong) {
      route = getRoute(originLat, originLong, destinationLat, destinationLong);
      route{"resourceSets"}[0]{"resources"}[0]{"travelDuration"}
    }
  }

}
