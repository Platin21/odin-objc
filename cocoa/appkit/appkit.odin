package appkit;

foreign import appkit "system:AppKit.framework"

@(default_calling_convention="c")
foreign appkit {
 NSWindowWillCloseNotification : rawptr;
 NSWindowWillEnterFullScreenNotification : rawptr;
 NSWindowDidResizeNotification : rawptr;
 NSWindowDidMoveNotification : rawptr;
 NSWindowDidMiniaturizeNotification : rawptr;
 NSWindowDidDeminiaturizeNotification : rawptr;
}