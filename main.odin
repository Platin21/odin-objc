package main;

import "cocoa:objc"
import "cocoa:appkit"
import "core:fmt"

main :: proc() {
	ns_application_class  := objc.get_class("NSApplication");
	ns_application_shared := objc.get_constant_method_selector("sharedApplication");
	ns_application := objc.call_static_method(ns_application_class,ns_application_shared);
		
	fmt.print("Class: ", ns_application_class,
	          "\nShared: ", ns_application_shared,
						 "\nApp: ", ns_application, "\n");
}