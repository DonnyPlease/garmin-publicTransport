import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class publicTransportShortcutApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // TODO: here I need to start GPS and find 5 closest public transport stops and to each assign corresponding lines(bus, tram, metro...)
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new publicTransportShortcutView(), new publicTransportShortcutDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as publicTransportShortcutApp {
    return Application.getApp() as publicTransportShortcutApp;
}