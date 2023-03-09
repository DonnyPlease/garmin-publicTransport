import Toybox.Application;
using Toybox.Math;
using Toybox.Test;
using Toybox.System;

class Stops {
    var currentPosition;
    var stops;
    var firstStop;
    var initialized = false;
    var stopsWithDistances;

    function initialize(){
        stops = Application.loadResource(Rez.JsonData.jsonFile);
        stops = stops["stops"];
    }  

    function init(positionInfo){
        if (initialized == false){
            currentPosition = positionInfo.position.toDegrees();
            stopsWithDistances = calculateDistances();
            initialized = true;
        }
    }


    function calculateDistances(){
        var closestStops;
        var lon;
        var lat;
        var stop;
        var dist;
        var closest_stops = [];
        var n = 5;

        for (var j = 0; j < n; j+=1){
            stop = stops[j];
            lon = stop["coors"][0];
            lat = stop["coors"][1];
            dist = calculateDistance(lat, currentPosition[0], lon, currentPosition[1]);
            stop.put("distance", dist);   
            closest_stops.add(stop);
        }
        
        closest_stops = putLargestInFront(closest_stops);

        System.println(stops.size());

        for (var j = n; j < 1441; j+=1){ 
            stop = stops[j];
            lon = stop["coors"][0];
            lat = stop["coors"][1];
            dist = calculateDistance(lat, currentPosition[0], lon, currentPosition[1]);
            
            if (dist>closest_stops[0]["distance"]){
                continue;
            }
            // Potential time waster
            stop.put("distance", dist);
            closest_stops.add(stop);
            closest_stops = putLargestInFront(closest_stops);
            closest_stops = closest_stops.slice(1,6);
        }
        System.println("I finished calculating distances.");
        System.println(closest_stops.size());
        return closest_stops;
    }


    // 
    function getClosestStops(positionInfo){
        return stopsWithDistances;
    }


    // This function is an approximation of the Haversine formula for Prague
    // Approximation was needed for time-savings, but is should not have a huge 
    // impact on reliability of the app.
    function calculateDistance(lat1, lat2, lon1, lon2){
        var distance = (lat1-lat2)*(lat1-lat2)+0.41*(lon1-lon2)*(lon1-lon2);
        return distance;
    }


    // Simple bubbling algorithm to put the largest element in the beggining of the array.
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