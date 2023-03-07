import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class publicTransportShortcutMenuDelegate extends WatchUi.MenuInputDelegate {

    


    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            System.println("item 1");
        } else if (item == :item_2) {
            System.println("item 2");
        } else if (item == :item_3) {
            System.println("item 3");
        } else if (item == :item_3) {
            System.println("item 4");
        } else if (item == :item_3) {
            System.println("item 5");
        }
    }

}