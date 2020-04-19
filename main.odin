package main

import "core:fmt"
import "cocoa:CoreFoundation"

main :: proc() {
  using CoreFoundation;
    
  typed := CFMutableArrayCreateTyped(([]CFNumberRef){ CFNUM(1), CFNUM(2), CFNUM(3) });
    
  fmt.printf("Count of Typed array: {}\n", CFArrayGetCount(cast(CFArrayRef)typed));
  fmt.printf("Value at index 0: {}\n", CFNumberGeti64(cast(CFNumberRef)CFArrayGetValueAtIndex(cast(CFArrayRef)typed, 0)));
  fmt.printf("Value at index 1: {}\n", CFNumberGeti64(cast(CFNumberRef)CFArrayGetValueAtIndex(cast(CFArrayRef)typed, 1)));
  fmt.printf("Value at index 2: {}\n", CFNumberGeti64(cast(CFNumberRef)CFArrayGetValueAtIndex(cast(CFArrayRef)typed, 2)));
    
  fmt.printf("Version: {}\n", kCFCoreFoundationVersionNumber);
  
  value := CFNumberGeti64(cast(CFNumberRef)CFArrayGetValueAtIndex(cast(CFArrayRef)typed, 1));
  fmt.printf("Value: {}\n", value);
  
  CFRelease(cast(CFType)typed);
}