package AppKit;

import "Cocoa:objc"
import "Cocoa:CoreFoundation"

@force foreign import appKit "system:AppKit.framework"

/*===========================================================================================*
	Package type aliases
 *===========================================================================================*/
Application :: distinct objc.id;

/*===========================================================================================*
	Package variables
 *===========================================================================================*/

app : Application = shared_application();

/*===========================================================================================*
	Foreign procedures 
 *===========================================================================================*/
@(default_calling_convention="c")
foreign appKit {
  
 @(link_name = "NSWindowWillCloseNotification")
 window_will_close_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowWillEnterFullScreenNotification")
 window_will_enter_full_screen_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowDidResizeNotification")
 window_did_resize_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowDidMoveNotification")
 window_did_move_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowDidMiniaturizeNotification")
 window_did_miniaturize_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowDidDeminiaturizeNotification")
 window_did_deminiaturize_notification : CoreFoundation.CFStringRef;
 
 @(link_name = "NSWindowDidUpdateNotification")
 window_did_update_notification : CoreFoundation.CFStringRef;
 
}

/*===========================================================================================*
	Private Package procedures 
 *===========================================================================================*/
@private 
shared_application :: proc() -> Application {
  sig_class_sel :: #type proc "c" (cls_app: objc.class, sel: objc.sel) -> Application;
  
  cls_ns_application     := objc.getClass("NSApplication");
  sel_shared_application := objc.sel_registerName("sharedApplication");
  fnc_shared_application := cast(sig_class_sel)objc.msgSend;
  
  return fnc_shared_application(cls_ns_application, sel_shared_application);
};

/*===========================================================================================*
	Package procedures 
 *===========================================================================================*/