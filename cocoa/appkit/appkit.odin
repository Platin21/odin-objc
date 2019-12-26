package appkit;

import "cocoa:objc"
import "cocoa:foundation"

@force foreign import appkit "system:AppKit.framework"

@(default_calling_convention="c")
foreign appkit {
 NSWindowWillCloseNotification : foundation.nsstring;
 NSWindowWillEnterFullScreenNotification : foundation.nsstring;
 NSWindowDidResizeNotification : foundation.nsstring;
 NSWindowDidMoveNotification : foundation.nsstring;
 NSWindowDidMiniaturizeNotification : foundation.nsstring;
 NSWindowDidDeminiaturizeNotification : foundation.nsstring;
}