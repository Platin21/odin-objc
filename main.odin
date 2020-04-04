package main

import "core:fmt"
import "cocoa:objc"
import "cocoa:foundation"
import "cocoa:appkit"

main :: proc() {
  fmt.printf("Application: %v\n", appkit.app);
}