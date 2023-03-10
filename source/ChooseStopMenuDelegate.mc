import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Position;
using Toybox.Application;


class ChooseStopMenuDelegate extends WatchUi.Menu2InputDelegate {

    // Constructor
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    // What happens when an item is selected.
    (:typecheck(false))
    function onSelect(item as WatchUi.MenuItem) as Void {
        var name = item.getId();
        var infoBoard = Application.getApp().myViewDelegate.getDepartureBoard(name);
        var size = infoBoard.size();

        var ChooseLineMenu = new WatchUi.Menu2({:title=>"Infoboard"});
        var delegate;

        System.println(name);
        for (var i = 0; i<size; i+=1) {
            var departure = infoBoard[i];
            // System.println(departure["name"] + );
            
            var info = departure["name"] + " => " + departure["direction"] + " - " + departure["departs in"] + " min";
            System.println(info);

            ChooseLineMenu.addItem(
                new MenuItem(
                    info,
                    null,
                    i.toString(),
                    {}
                )
            );
        }

        delegate = new ChooseLineMenuDelegate();
        WatchUi.pushView(ChooseLineMenu, delegate, WatchUi.SLIDE_UP);
    }


}