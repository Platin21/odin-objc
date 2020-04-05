package main

import "core:fmt"
import "cocoa:objc"
import "cocoa:foundation"
import "cocoa:appkit"

main :: proc() {
  
  using foundation;
  
  fmt.printf("Application: %v\n", appkit.app);
  cf_str1  := new_cfstring("Äpfel!");
  
  str1_len := count(cf_str1);
  str2_len := count(cf_str1, .Utf32_Be);
  str3_len := count(cf_str1, .Utf16_Le);
  
  fmt.printf("str: {}, odin: {} utf8 len: {}, utf32 len: {}, utf16 len: {} \n", "Äpfel!", len("Äpfel!"), str1_len, str2_len, str3_len);
  
  cf_string_delete(cf_str1);
}