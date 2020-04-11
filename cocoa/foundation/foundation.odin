package foundation;

import "core:mem"
import "core:c"
import "core:strings"
import "cocoa:objc"

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import foundation "system:Foundation.framework" 
@force foreign import core_foundation "system:CoreFoundation.framework" 

/*===========================================================================================*
	Package type aliases
 *===========================================================================================*/
Cf_String :: distinct rawptr;

Cf_Allocator_Ref :: distinct rawptr; 
Cf_Index         :: distinct c.long;
Cf_Option_Flags  :: distinct c.ulong;

Cf_String_Encoding :: enum u32 {
  
  Mac_Roman       = 0x0,        // An encoding constant that identifies the Mac Roman encoding.
  
  Windows_Latin_1 = 0x0500,     // An encoding constant that identifies the Windows Latin 1 encoding (ANSI codepage 1252).
  
  Iso_Latin_1     = 0x0201,     // An encoding constant that identifies the ISO Latin 1 encoding (ISO 8859-1)
  
  Nextstep_Latin  = 0x0B01,     // An encoding constant that identifies the NextStep/OpenStep encoding.
  
  Ascii           = 0x0600,     // An encoding constant that identifies the ASCII encoding (decimal values 0 through 127).
  
  Unicode         = 0x0100,     // An encoding constant that identifies the Unicode encoding.
  
  Utf8            = 0x08000100, // An encoding constant that identifies the UTF 8 encoding.
  
  Non_Lossy_Ascii = 0x0BFF,     // An encoding constant that identifies non-lossy ASCII encoding.
  
  Utf16           = 0x0100,     // An encoding constant that identifies kTextEncodingUnicodeDefault
                                // + kUnicodeUTF16Format encoding (alias of kCFStringEncodingUnicode).
                                
  Utf16_Be        = 0x10000100, // An encoding constant that identifies kTextEncodingUnicodeDefault
                                // + kUnicodeUTF16BEFormat encoding. This constant specifies big-endian byte order.
                                
  Utf16_Le        = 0x14000100, // An encoding constant that identifies kTextEncodingUnicodeDefault 
                                // + kUnicodeUTF16LEFormat encoding. This constant specifies little-endian byte order.
                                
  Utf32           = 0x0c000100, // An encoding constant that identifies kTextEncodingUnicodeDefault + kUnicodeUTF32Format encoding.
  
  Utf32_Be        = 0x18000100, // An encoding constant that identifies kTextEncodingUnicodeDefault 
                                // + kUnicodeUTF32BEFormat encoding. This constant specifies big-endian byte order.
                                
  Utf32_Le        = 0x1c000100  // An encoding constant that identifies kTextEncodingUnicodeDefault 
                                // + kUnicodeUTF32LEFormat encoding. This constant specifies little-endian byte order.
}

Cf_Comparison_Result :: enum Cf_Index {
  LessThan = -1,
  EqualTo = 0,
  GreaterThan = 1,
};

Cf_String_Compare_Flags :: enum Cf_Index {
  Forced_Ordering = 512, //Specifies that the comparison is forced to return either kCFCompareLessThan or kCFCompareGreaterThan if the strings are equivalent but not strictly equal.
  Width_Insensitive = 256, // Specifies that the comparison should ignore width differences.
  Diacritic_Insensitive = 128, // Specifies that the comparison should ignore diacritic markers.
  Numerically = 64, // Specifies that represented numeric values should be used as the basis for comparison and not the actual character values.
  Localized = 32,  // Specifies that the comparison should take into account differences related to locale, such as the thousands separator character.
  Non_Literal = 16, // Specifies that loose equivalence is acceptable, especially as pertains to diacritical marks.
  Anchored = 8, // Performs searching only on characters at the beginning or end of the range.
  Backwards = 4, // Specifies that the comparison should start at the last elements of the entities being compared (for example, strings or arrays).
  Case_Insensitive = 1, // Specifies that the comparison should ignore differences in case between alphabetical characters.
  No_Flags = 0, // If you want the default comparison behavior, pass 0
}; 

Cf_Range :: struct {
  location: Cf_Index,
  length: Cf_Index,
};

/*===========================================================================================*
	Foreign functions
 *===========================================================================================*/
@(default_calling_convention="c")
foreign core_foundation {
  
  @(link_name="CFStringCreateWithBytes")
  cf_string_create_with_bytes :: proc(alloc: Cf_Allocator_Ref, 
                                      bytes: ^u8, 
                                      num_bytes: Cf_Index,
                                      encoding: Cf_String_Encoding,
                                      is_external_representation: i32) -> Cf_String ---;
  
  @(link_name="CFStringGetLength")                             
  cf_string_get_length_utf16 :: proc(theString: Cf_String) -> Cf_Index ---;
  
  @(link_name="CFStringGetBytes")
  cf_string_get_bytes :: proc(theString: Cf_String,
                              range: Cf_Range,
                              encoding: Cf_String_Encoding,
                              lossByte: u8,
                              isExternalRepresentation: i32,
                              buffer: ^u8,
                              maxBufLen: Cf_Index ,
                              usedBufLen: ^Cf_Index) -> Cf_Index ---;
  @(link_name="CFStringCompare")                           
  cf_string_compare :: proc(theString1: Cf_String, theString2: Cf_String, compareOptions: Cf_String_Compare_Flags) -> Cf_Comparison_Result ---;
  
  @(link_name="CFRelease")
  cf_release :: proc(ref: rawptr) ---; 
                 
  @(link_name="CFAllocatorDeallocate")             
  cf_allocator_deallocate :: proc(allocator: Cf_Allocator_Ref, ptr: rawptr) ---;
                              
  /* This is a synonym for NULL, if you'd rather use a named constant. */
  @(link_name="kCFAllocatorDefault")
  Allocator_Default : Cf_Allocator_Ref;

  /* Default system allocator; you rarely need to use this. */
  @(link_name="kCFAllocatorSystemDefault")
  Allocator_System_Default : Cf_Allocator_Ref;

  /* This allocator uses malloc(), realloc(), and free(). This should not be
     generally used; stick to kCFAllocatorDefault whenever possible. This
     allocator is useful as the "bytesDeallocator" in CFData or
     "contentsDeallocator" in CFString where the memory was obtained as a
     result of malloc() type functions.
  */
  @(link_name="kCFAllocatorMalloc")
  Allocator_Malloc : Cf_Allocator_Ref;

  /* This allocator explicitly uses the default malloc zone, returned by
     malloc_default_zone(). It should only be used when an object is
     safe to be allocated in non-scanned memory.
   */
  @(link_name="kCFAllocatorMallocZone")
  Allocator_Malloc_Zone : Cf_Allocator_Ref;

  /* Null allocator which does nothing and allocates no memory. This allocator
     is useful as the "bytesDeallocator" in CFData or "contentsDeallocator"
     in CFString where the memory should not be freed. 
  */
  @(link_name="kCFAllocatorNull")
  Allocator_Null : Cf_Allocator_Ref;

  /* Special allocator argument to CFAllocatorCreate() which means
     "use the functions given in the context to allocate the allocator
     itself as well". 
  */
  @(link_name="kCFAllocatorUseContext")
  Allocator_UseContext : Cf_Allocator_Ref;
}

/*===========================================================================================*
	Package procedures 
 *===========================================================================================*/

new_cfstring :: proc(odin_string: string) -> Cf_String {
  return cf_string_create_with_bytes(Allocator_Malloc, strings.ptr_from_string(odin_string), cast(Cf_Index)len(odin_string), .Utf8, 0);
}

count :: proc(cf_string: Cf_String, encoding := Cf_String_Encoding.Utf8) -> u64 {
  rlen : Cf_Index = 0;
  utf16_len := cf_string_get_length_utf16(cf_string);
  cf_string_get_bytes( cf_string, (Cf_Range){0, utf16_len}, encoding, 0, 0, nil, 9223372036854775807, &rlen); 
  return cast(u64)rlen;
}

to_odin_string :: proc(cf_string: Cf_String, allocator := context.allocator) -> string {
  utf8_len : Cf_Index = 0;
  utf16_len := cf_string_get_length_utf16(cf_string);
  
  cf_string_get_bytes( cf_string, (Cf_Range){0, utf16_len}, .Utf8, 0, 0, nil, 9223372036854775807, &utf8_len);
  
  bytes := cast(^u8)mem.alloc(cast(int)utf8_len);
  
  cf_string_get_bytes( cf_string, (Cf_Range){0, utf16_len}, .Utf8, 0, 0, bytes, 9223372036854775807, &utf8_len);
  return cast(string)(cast(cstring)bytes);
}

cf_string_delete :: proc(cf_string: Cf_String) {
  cf_release(cast(rawptr)cf_string);
}

compare :: proc(lhs: Cf_String, rhs: Cf_String) -> int {
  return cast(int)cf_string_compare(lhs, rhs, .No_Flags);
}
