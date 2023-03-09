import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Position;


class ChooseStopMenuDelegate extends WatchUi.Menu2InputDelegate {


    function initialize() {
        Menu2InputDelegate.initialize();
    }


    function onSelect(item as WatchUi.MenuItem) as Void {

        System.println(item.getId());
        System.println("Your mother!!");
    }

}