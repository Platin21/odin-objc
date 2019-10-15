package main;

import "cocoa:objc"
import "cocoa:appkit"
import "core:fmt"

main :: proc() {
	ns_application_class  := objc.get_class("NSApplication");	
	fmt.print("Class: ", ns_application_class);
	fmt.print("OString: ", appkit.NSWindowWillCloseNotification);
}