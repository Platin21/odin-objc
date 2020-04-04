package foundation;

import "cocoa:objc"

/*===========================================================================================*
	Package type aliases
 *===========================================================================================*/
nsstring :: distinct objc.id;

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import appkit "system:Foundation.framework"

/*===========================================================================================*
	Package procedures 
 *===========================================================================================*/
to_nsstring :: proc(odin_string: string) -> nsstring {
  return auto_cast nil;
}

len :: proc(ns_string: nsstring) -> u64 {
  return 0;
}

nsstring_to_utf8 :: proc(ns_string : nsstring) -> cstring {
	sel_utf8_string := objc.get_method_selector("UTF8String");
  sig_id_sel_cstring :: #type proc "c"  (objc.id, objc.sel) -> cstring;
	return (cast(sig_id_sel_cstring)objc.call_method)(cast(objc.id)ns_string, sel_utf8_string);
}