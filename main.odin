package main

import "core:c"
import "core:fmt"


import "Cocoa:CoreFoundation"
import "Cocoa:objc"


CFNumberDescriptionWithLocale :: proc(number: CoreFoundation.CFNumberRef, locale: objc.id = nil) -> CoreFoundation.CFStringRef {
  function :: proc(instance: objc.id, sel: objc.sel, locale: objc.id) -> CoreFoundation.CFStringRef;
  
  @thread_local objc_msg : function = {};
  if objc_msg == nil {
     objc_msg := cast(function)objc.class_with_name_get_method_implementation_of_name("NSNumber", "descriptionWithLocale:");
  }
 
  return objc_msg(cast(objc.id)number, nil, locale);
}


kern_return_t :: c.int;

mach_timebase_info_type :: struct {
  numer: u32,
	denom: u32,
};

foreign {
  mach_timebase_info :: proc(info: ^mach_timebase_info_type) -> kern_return_t ---;
  mach_absolute_time :: proc() -> u64 ---;
}

ns_to_s :: proc(nanosecond: u64) -> u64 {
  return nanosecond / 1000000000;
}

ns_to_ms :: proc(nanosecond: u64) -> u64 {
  return nanosecond / 1000000;
}

ns_to_mc :: proc(nanosecond: u64) -> u64 {
  return nanosecond / 1000;
} 

main :: proc() {
  using CoreFoundation;
  
}