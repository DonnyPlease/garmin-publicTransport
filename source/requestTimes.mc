using Toybox.System;
using Toybox.Communications;

class requestTimes {

    var ids;

    function initialize(arrayOfIds) {
        ids = arrayOfIds;
    }

    function makeRequest(){
        var data = [];
        // TODO: make request and save to data
        var stopsAndTimes;
        stopsAndTimes = digestData(data);
        return stopsAndTimes;
    }

    function digestData(data){
        // TODO: implement digestion of the data so that we can return it to the app and create a menu of lines
        return data;
    }


}