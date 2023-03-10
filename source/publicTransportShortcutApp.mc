import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System;
using Toybox.Position;

class publicTransportShortcutApp extends Application.AppBase {

    var myView;
    var myViewDelegate;
    var infoBoard;
    var myLocation;

    

    function initialize() {
        AppBase.initialize();

    }

    function setInfoboard(data){
        infoBoard = data;
    }

    function getInfoboard(){
        return infoBoard;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        // TODO: here I need to start GPS and find 5 closest public transport stops and to each assign corresponding lines(bus, tram, metro...)
    }

    // onStop() is called when application is exiting
    function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }


    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        myView = new mainView();
        myViewDelegate = new mainViewDelegate();
        return [ myView, myViewDelegate ] as Array<Views or InputDelegates>;

    }


    function onPosition(info as Toybox.Position.Info) as Void {
        // if (info.position == null) {
        //     System.println("no position info");
        //     return;
        // }
        System.println("something is happening");
        myLocation = info.position.toDegrees();
        myView.setPositionInfo(info);
        myViewDelegate.setPosition(info);
        myViewDelegate.stops.init(info);
        System.println("Latitude: " + myLocation[0]); // e.g. 38.856147
        System.println("Longitude: " + myLocation[1]); // e.g -94.800953
        // WatchUi.requestUpdate();
    }

    

    

}

function getApp() as publicTransportShortcutApp {
    return Application.getApp() as publicTransportShortcutApp;
}