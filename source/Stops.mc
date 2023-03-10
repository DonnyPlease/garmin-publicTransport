import Toybox.Application;
using Toybox.Math;
using Toybox.System;

// This class exist for separation of the app from the data it works with.
// It also contains methods that calculate which stops are closest to the current location.
class Stops {

    //Declaration of various variables
    var currentPosition;  // Position given by GPS
    var stops;  // Array of stops-each stop is a dictionary with "name" (string), 
                // "position" (array of doubles of size 2), "ids" (array of stops "id", 
                // because each stop name represents many actual stops which are classified differently
                // in online API of Prague public transport)

    var initialized = false;  // This is boolean variable. It is used in initialization of the current position info,
                              // but there might be a better way to solve the issue of changing position in case
                              // the user is moving. If GPS is not too much of, there is little benefit of knowing
                              // the precise, the most recent position.
    var closestStops;


    // A constructor
    (:typecheck(false))
    function initialize(){
        System.println("Now loading!");
        stops = Application.loadResource(Rez.JsonData.jsonFile);
        stops = stops["stops"];
    }  

    // Initialization of current position. Once the position is known we call the function that finds out some small
    // number of stops that are closest to the current position of the user.
    function init(positionInfo){
        // The condition is met only once. When the device first actually knows the location.
        if (initialized == false){
            currentPosition = positionInfo.position.toDegrees();  // Converts the received GPS information into
                                                                  // an array of decimal degrees.
                                                                  // position 0  --> latitude
                                                                  // position 1  --> longitude
            closestStops = calculateClosestStops();  // Array of 5 stops that are closest to the current location. 
            initialized = true;  // Finish initialization so that we do not calculate the same thing over and over, 
                                 // because small change in position would most likely not make any difference.
            stops = null;
        }
    }

    // Get the array of the stops that are closest to the current location.
    function getClosestStops(positionInfo){
        return closestStops;
    }

    // This function calculates and returns which stops are closest to hte current location.
    (:typecheck(false))
    function calculateClosestStops(){

        var n = 6;  // Number of stops we want to return.

        var lon;  // Longitude
        var lat;  // latitdude
        var stop;  // Here will be stored an instance of dictionary which represents a stop.
        var dist;  
        var closest_stops = [];  // Array to be filled with closest stops and to be returned.
        
        // Fill the array with the first 'n' stops and make sure that they are in descending order.
        for (var j = 0; j < n; j+=1){
            stop = stops[j];
            lon = stop["coors"][0];
            lat = stop["coors"][1];
            dist = calculateDistance(lat, currentPosition[0], lon, currentPosition[1]);
            stop.put("distance", dist);   
            closest_stops.add(stop);
            closest_stops = putLargestInFront(closest_stops);  // Make sure that the stops are in descending order.
        }
        
        // For the rest of the stops calculate the distance and if it is closer than the furthest one yet,
        // put it on the end of the array. Then remove the largest one (by slice mehtod). At last, traverse 
        // the array from the back and find place for the new stop.
        for (var j = n; j < 1441; j+=1){ 

            // Make data local so we save time by not accessing the big dictionary.
            stop = stops[j];
            lon = stop["coors"][0];
            lat = stop["coors"][1];

            dist = calculateDistance(lat, currentPosition[0], lon, currentPosition[1]);  // Calculate distance 

            // Check whether a stop is close enough to be considered.
            if (dist>closest_stops[0]["distance"]){
                continue;
            }
            stop.put("distance", dist);  // Save information about the distance.
            closest_stops.add(stop);  // Add to the array.
            closest_stops = closest_stops.slice(1,n+1);  // Remove the first one, as it is too far.
            closest_stops = putLargestInFront(closest_stops);  // Put array in descending order again. 
        }

        System.println("I found which stops are the closest to the current location.");
        System.println(closest_stops.size());
        return closest_stops;
    }

    // This function is an approximation of the Haversine formula for Prague
    // Approximation was needed for time-savings, but is should not have a huge 
    // impact on reliability of the app.
    function calculateDistance(lat1, lat2, lon1, lon2){
        var distance = (lat1-lat2)*(lat1-lat2)+0.41*(lon1-lon2)*(lon1-lon2);
        return distance;
    }


    // Simple bubbling algorithm to put the largest element in the beggining of the array. In our case,
    // where we pass an array that is in descending order, except the last element, it is enough to traverse it once
    // to put the array in descending order.
    (:typecheck(false))
    function putLargestInFront(array){
        var size = array.size();
        for (var i = size-1; i > 0; i-=1){
            var hold;
            if (array[i]["distance"]>array[i-1]["distance"]){
                hold = array[i];
                array[i] = array[i-1];
                array[i-1] = hold;
            }
        }
        return array;
    }
}