package CoreFoundation;

//import "core:mem"
//import "core:strings"
//import "cocoa:foundation"

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
//@force foreign import cocoa_foundation "system:Foundation.framework" 

/*
/*===========================================================================================*
	Foreign functions
 *===========================================================================================*/
@(default_calling_convention="c")
foreign core_foundation {
  
  @(link_name="CFStringCreateWithBytes")
  cf_string_create_with_bytes :: proc(alloc: Cf_Allocator, 
                                      bytes: ^u8, 
                                      num_bytes: Cf_Index,
                                      encoding: Cf_String_Encoding,
                                      is_external_representation: i32) -> Cf_String ---;
  
  @(link_name="CFStringGetLength")                             
  cf_string_get_length_utf16 :: proc(theString: Cf_String) -> Cf_Index ---;
  
  @(link_name="CFStringGetBytes")
  cf_string_get_bytes :: proc(theString: Cf_String,
                              range: CFRange,
                              encoding: Cf_String_Encoding,
                              lossByte: u8,
                              isExternalRepresentation: i32,
                              buffer: ^u8,
                              maxBufLen: Cf_Index,
                              usedBufLen: ^Cf_Index) -> Cf_Index ---;
                              
  @(link_name="CFStringCompare")                           
  CFStringCompare :: proc(theString1: CFStringRef, theString2: CFStringRef, compareOptions: CFStringCompareFlags) -> CFComparisonResult ---;
}

/*===========================================================================================*
	Package procedures 
 *===========================================================================================*/

new_cfstring :: proc(odin_string: string) -> CFString {
  return cf_string_create_with_bytes(Cf_Allocator_Malloc, strings.ptr_from_string(odin_string), cast(Cf_Index)len(odin_string), .Utf8, 0);
}

count :: proc(cf_string: CFString, encoding := Cf_String_Encoding.Utf8) -> u64 {
  rlen : Cf_Index = 0;
  utf16_len := cf_string_get_length_utf16(cf_string);
  cf_string_get_bytes( cf_string, (CFRange){0, utf16_len}, encoding, 0, 0, nil, 9223372036854775807, &rlen); 
  return cast(u64)rlen;
}

to_odin_string :: proc(cf_string: Cf_String, allocator := context.allocator) -> string {
  utf8_len : Cf_Index = 0;
  utf16_len := cf_string_get_length_utf16(cf_string);
  
  cf_string_get_bytes( cf_string, (CFRange){0, utf16_len}, .Utf8, 0, 0, nil, 9223372036854775807, &utf8_len);
  
  bytes := cast(^u8)mem.alloc(cast(int)utf8_len);
  
  cf_string_get_bytes( cf_string, (CFRange){0, utf16_len}, .Utf8, 0, 0, bytes, 9223372036854775807, &utf8_len);
  return cast(string)(cast(cstring)bytes);
}

cf_string_delete :: proc(cf_string: Cf_String) {
  cf_release(cast(Cf_Type)cf_string);
}

compare :: proc(lhs: Cf_String, rhs: Cf_String) -> int {
  return cast(int)cf_string_compare(lhs, rhs, .No_Flags);
}
*/