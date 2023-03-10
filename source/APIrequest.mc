using Toybox.System;
using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.Communications;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.Timer;

// Purpose of this class is to mediate API request to download data about when the public transport lines depart from
// particular stops. Request for each stop should be a separate instance of this class.
class APIrequest {
    
    var ids;  // Array if ids. Initially this was supposed to be the parameter of API.
    var name = "";  // Name of the stop.

    var url;  // URL of a request.
    var parameters;  // Parameters of a request.
    var options;  // Opstions of a request.

    // Constructor.
    function initialize(stopName){
        name = stopName;
    }

    // This function parses the downloaded infoboard for further manipulation. Is called in case of succesful request.
    function parseInfoboard(infoBoard){
        Application.getApp().myViewDelegate.setDepartureBoard(name, infoBoard);
    }

    // Method passed as parameter of request.
    // In case of succesfull request first digest data and then parse to the app.
    function onReceive(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void {

        System.println("===========================================================================\n I made a request with stop:" + name);

        if (responseCode == 200) {
            System.println("Request Successful");  // Print success.
            var infoBoard = digestData(data);
            parseInfoboard(infoBoard);
        }
        else if (responseCode == -101) {  // Too many requests.                      
            System.println("Too many requests. Trying again.");  // Print too many requests.
            var myTimer = new Timer.Timer();
            myTimer.start(method(:makeRequest), 400, false);  // Try again after 400 miliseconds.
        }
        else {
            System.println("Response: " + responseCode);            // print response code
        }
    }

    // Make request function.
    function makeRequest() as Void {
        // name = "I. P. Pavlova";
        System.println("===========================================================================\n I am making a request with stop:" + name);
        var url = "https://api.golemio.cz/v2/pid/departureboards";  // set the url

        var params = {                                              // set the parameters
                "names" => name
        };

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                    //"Content-Type" => "aplication/json",
                    "accept" => "aplication/json",
                    "x-Access-Token" => "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNhbWtvLnNpdGluYTQwODhAZ21haWwuY29tIiwiaWQiOjE4MDgsIm5hbWUiOm51bGwsInN1cm5hbWUiOm51bGwsImlhdCI6MTY3ODIxNTQwNiwiZXhwIjoxMTY3ODIxNTQwNiwiaXNzIjoiZ29sZW1pbyIsImp0aSI6IjNiMGI0NGNjLTg0YTYtNDc4NC1iODVlLWMyZDFkYWZlOTJlYiJ9.HJ1AtfsJAsSsiOL3XWydKK8krh2BODWMSxj680WypcM"
                        },

            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON  // set response type to Json
        };

        var responseCallback = method(:onReceive);                  // set responseCallback to onReceive() method

        Communications.makeWebRequest(url, params, options, method(:onReceive));  // Put it all together and make
                                                                                  // the request. 
    }

    // Digest data because the data come in some specific format. It is already a dictionary, but it contains too much
    // (for us) useless information. We only need names of the lines, name of their destination and predicted times
    // of departure.
    function digestData(data){
        data = data["departures"];  // Select departures - now data should be an array of departures.
        var size = data.size();  // Save size.
        var departures = [];  // Declare an array of departures that will be passed to the application.

        // For each departure in data save name, direction and time.
        for (var i = 0; i < size; i+=1){

            var departure = data[i];  // Take one deparure

            var time = departure["departure_timestamp"]["predicted"];  // Save time (it is in ISO 8601 format)
            var name = departure["route"]["short_name"];  // Save name of the line
            var direction = departure["trip"]["headsign"];  // Save name of the final destination.
            
            var departsIn = timeFromNowInMinutes(time);  // This is a string - time from now in minutes.
            //System.println(name + " --> " + direction + " ------ " + departsIn);

            // Create a dictionary of departure.
            departure = {
                "name" => name,
                "direction" => direction,
                "departs in" => departsIn
            };
            departures.add(departure);  // Add latest departure to 
        }
        return departures;
    }

    // Calculates difference in minutes from now to a given time passed as a parameter in ISO 8601 format.
    // Returns time in minutes as string. If the result is less than one minute, return "<1".
    function timeFromNowInMinutes(time) {
        var hour = time.substring(11, 13).toNumber();
        var minute = time.substring(14, 16).toNumber();
        var second = time.substring(17, 19).toNumber();

        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var timeDifference = (hour-now.hour)*3600 + (minute - now.min)*60 + (second-now.sec);
        if (timeDifference < 0) {
            timeDifference += 24*60*60;
        } else if (timeDifference < 60) {
            return "<1";
        }
        return Math.floor(timeDifference/60).toString();
    }
}