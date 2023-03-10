import Toybox.Lang;
import Toybox.WatchUi;


class mainViewDelegate extends WatchUi.BehaviorDelegate {

    var positionInfo;
    var stops;
    var departureBoards = {};
    

    function initialize() {
        BehaviorDelegate.initialize();
        stops = new Stops();
    }

    function setDepartureBoard(name, depBoard){
        departureBoards.put(name, depBoard);
    }

    (:typecheck(false))
    function getDepartureBoard(name){
        return departureBoards[name];
    }

    (:typecheck(false))
    function onSelect() {
        var ChooseStopMenu = new WatchUi.Menu2({:title=>"Choose a stop"});
        var delegate;
        if (positionInfo == null){
            return true;
        }
        var closestStops = stops.getClosestStops(positionInfo);

        //var apiRequest = new APIrequest();
        for( var i = 0; i < 5; i += 1 ) {
            var name = closestStops[i]["name"];
            var apiRequest = new APIrequest(name);

            ChooseStopMenu.addItem(
                new MenuItem(
                    name,
                    null,
                    name,
                    {}
                )
            );
            apiRequest.makeRequest();
        }
        delegate = new ChooseStopMenuDelegate();
        WatchUi.pushView(ChooseStopMenu, delegate, WatchUi.SLIDE_UP);
        return true;
    }

    function onMenu() as Boolean {
        var ChooseStopMenu = new WatchUi.Menu2({:title=>"Choose a stop"});
        var delegate;    
        
        ChooseStopMenu.addItem(
            new MenuItem(
                "Belehradská",
                null,
                "itemOneId",
                {}
            )
        );
        ChooseStopMenu.addItem(
            new MenuItem(
                "I.P. Pavlova",
                null,
                "itemTwoId",
                {}
            )
        );

            

        delegate = new ChooseStopMenuDelegate();
        WatchUi.pushView(ChooseStopMenu, delegate, WatchUi.SLIDE_UP);
        return true;
    }

    function setPosition(info) {
		positionInfo = info;
		// If we have a position for the first time, notify the user
		System.println("We have it!! We have it!!");
    }
	

}