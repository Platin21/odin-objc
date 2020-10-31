package CoreFoundation;

import "core:mem"
import "core:strings"

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import core_foundation "system:Foundation.framework" 


CFStringEncoding :: enum u32 {
  
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
};

CFStringCompareFlags :: enum CFIndex {
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


/*===========================================================================================*
	Foreign functions
 *===========================================================================================*/
@(default_calling_convention="c")
foreign core_foundation {
  
  CFStringCreateWithBytes :: proc(alloc: CFAllocatorRef, 
                                  bytes: ^u8, 
                                  num_bytes: CFIndex,
                                  encoding: CFStringEncoding,
                                  is_external_representation: i32) -> CFStringRef ---;
                            
  CFStringGetLength :: proc(theString: CFStringRef) -> CFIndex ---;
  
  CFStringGetBytes :: proc(theString: CFStringRef,
                              range: CFRange,
                              encoding: CFStringEncoding,
                              lossByte: u8,
                              isExternalRepresentation: i32,
                              buffer: ^u8,
                              maxBufLen: CFIndex,
                              usedBufLen: ^CFIndex) -> CFIndex ---;
                         
  CFStringCompare :: proc(theString1: CFStringRef, theString2: CFStringRef, compareOptions: CFStringCompareFlags) -> CFComparisonResult ---;
}

from_odin_string :: proc(odin_string: string, allocator := context.allocator) -> CFStringRef {
  ptr := strings.ptr_from_string(odin_string);
  return CFStringCreateWithBytes(kCFAllocatorDefault, ptr, CFIndex(len(odin_string)), .Utf8, 0);
}

to_odin_string :: proc(cf_string: CFStringRef, allocator := context.allocator) -> string {
  utf8_len : CFIndex = 0;
  utf16_len := CFStringGetLength(cf_string);
  
  CFStringGetBytes( cf_string, (CFRange){0, utf16_len}, .Utf8, 0, 0, nil, 9223372036854775807, &utf8_len);
  
  bytes := cast(^u8)mem.alloc(cast(int)utf8_len);
  
  CFStringGetBytes( cf_string, (CFRange){0, utf16_len}, .Utf8, 0, 0, bytes, 9223372036854775807, &utf8_len);
  return cast(string)(cast(cstring)bytes);
}


