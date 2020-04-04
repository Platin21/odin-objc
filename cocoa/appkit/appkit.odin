package appkit;

import "core:fmt"
import "cocoa:objc"
import "cocoa:foundation"

@force foreign import appkit "system:AppKit.framework"

/*===========================================================================================*
	Package type aliases
 *===========================================================================================*/
application :: distinct objc.id;

/*===========================================================================================*
	Package variables
 *===========================================================================================*/

app : application = shared_application();

/*===========================================================================================*
	Foreign procedures 
 *===========================================================================================*/
@(default_calling_convention="c")
foreign appkit {
  
 @(link_name = "NSWindowWillCloseNotification")
 window_will_close_notification : foundation.nsstring;
 
 @(link_name = "NSWindowWillEnterFullScreenNotification")
 window_will_enter_full_screen_notification : foundation.nsstring;
 
 @(link_name = "NSWindowDidResizeNotification")
 window_did_resize_notification : foundation.nsstring;
 
 @(link_name = "NSWindowDidMoveNotification")
 window_did_move_notification : foundation.nsstring;
 
 @(link_name = "NSWindowDidMiniaturizeNotification")
 window_did_miniaturize_notification : foundation.nsstring;
 
 @(link_name = "NSWindowDidDeminiaturizeNotification")
 window_did_deminiaturize_notification : foundation.nsstring;
}

/*===========================================================================================*
	Private Package procedures 
 *===========================================================================================*/
@private
shared_application :: proc() -> application {
  sig_class_sel :: #type proc "c" (cls_app: objc.class, sel: objc.sel) -> application;
  
  cls_ns_application     := objc.get_class("NSApplication");
  sel_shared_application := objc.get_method_selector("sharedApplication");
  fnc_shared_application := cast(sig_class_sel)objc.call_method;
  
  return fnc_shared_application(cls_ns_application, sel_shared_application);
};

/*===========================================================================================*
	Package procedures 
 *===========================================================================================*/