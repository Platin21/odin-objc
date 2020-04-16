package main

import "core:fmt"
import "cocoa:CoreFoundation"

main :: proc() {
  using CoreFoundation;
  
  array := CFArrayCreate(kCFAllocatorMalloc, nil, 0, &kCFTypeArrayCallBacks);
  
  fmt.print("Version: ", kCFCoreFoundationVersionNumber);
  
  CFRelease(cast(CFType)array);
}