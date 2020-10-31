/*	CFBase.h */
package CoreFoundation;

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import core_foundation "system:CoreFoundation.framework" 

/*===========================================================================================*
	Package type aliases
 *===========================================================================================*/
Boolean              :: u8;
UInt8                :: u8;
SInt8                :: i8;
UInt16               :: u16;
SInt16               :: i16;
UInt32               :: u32;
SInt32               :: i32;
UInt64               :: u64;
SInt64               :: i64;
OSStatus             :: SInt32;
Float32              :: f32;
Float64              :: f64;
UniChar              :: u16;
UniCharCount         :: u32;
StringPtr            :: ^u8;
ConstStringPtr       :: ^u8;
Str255               :: [255]u8;
ConstStr255Param     :: ^u8;
OSErr                :: SInt16;
RegionCode           :: SInt16;
LangCode             :: SInt16;
ScriptCode           :: SInt16;
FourCharCode         :: UInt32;
OSType               :: FourCharCode;
Byte                 :: UInt8;
SignedByte           :: SInt8;
UTF32Char            :: UInt32;
UTF16Char            :: UInt16;
UTF8Char             :: UInt8;

/*===========================================================================================*
	CFBase types
 *===========================================================================================*/
CFType             :: distinct rawptr;
CFTypeID           :: distinct u64;
CFOptionFlags      :: distinct u64;
CFHashCode         :: distinct u64;
CFIndex            :: distinct i64;
CFAllocatorRef     :: distinct rawptr;

CFStringRef        :: distinct rawptr;
CFMutableStringRef :: distinct CFStringRef;


CFTypeRef          :: CFType;

/*===========================================================================================*
	CFBase Enums
 *===========================================================================================*/
VersionNumber10_15_4	      : f64 = 1675.129;
VersionNumber10_0	          : f64 = 196.40;
VersionNumber10_0_3	        : f64 = 196.50;
VersionNumber10_1	          : f64 = 226.00;
VersionNumber10_1_1	        : f64 = 226.00; 
VersionNumber10_1_2	        : f64 = 227.20;
VersionNumber10_1_3	        : f64 = 227.20;
VersionNumber10_1_4	        : f64 = 227.30;
VersionNumber10_2	          : f64 = 263.00;
VersionNumber10_2_1	        : f64 = 263.10;
VersionNumber10_2_2	        : f64 = 263.10;
VersionNumber10_2_3	        : f64 = 263.30;
VersionNumber10_2_4	        : f64 = 263.30;
VersionNumber10_2_5	        : f64 = 263.50;
VersionNumber10_2_6	        : f64 = 263.50;
VersionNumber10_2_7	        : f64 = 263.50;
VersionNumber10_2_8	        : f64 = 263.50;
VersionNumber10_3	          : f64 = 299.00;
VersionNumber10_3_1	        : f64 = 299.00;
VersionNumber10_3_2	        : f64 = 299.00;
VersionNumber10_3_3	        : f64 = 299.30;
VersionNumber10_3_4	        : f64 = 299.31;
VersionNumber10_3_5	        : f64 = 299.31;
VersionNumber10_3_6	        : f64 = 299.32;
VersionNumber10_3_7	        : f64 = 299.33;
VersionNumber10_3_8	        : f64 = 299.33;
VersionNumber10_3_9	        : f64 = 299.35;
VersionNumber10_4	          : f64 = 368.00;
VersionNumber10_4_1	        : f64 = 368.10;
VersionNumber10_4_2	        : f64 = 368.11;
VersionNumber10_4_3	        : f64 = 368.18;
VersionNumber10_4_4_Intel	  : f64 = 368.26;
VersionNumber10_4_4_PowerPC	: f64 = 368.25;
VersionNumber10_4_5_Intel	  : f64 = 368.26;
VersionNumber10_4_5_PowerPC	: f64 = 368.25;
VersionNumber10_4_6_Intel	  : f64 = 368.26;
VersionNumber10_4_6_PowerPC	: f64 = 368.25;
VersionNumber10_4_7	        : f64 = 368.27;
VersionNumber10_4_8	        : f64 = 368.27;
VersionNumber10_4_9	        : f64 = 368.28;
VersionNumber10_4_10	      : f64 = 368.28;
VersionNumber10_4_11	      : f64 = 368.31;
VersionNumber10_5	          : f64 = 476.00;
VersionNumber10_5_1	        : f64 = 476.00;
VersionNumber10_5_2	        : f64 = 476.10;
VersionNumber10_5_3	        : f64 = 476.13;
VersionNumber10_5_4	        : f64 = 476.14;
VersionNumber10_5_5	        : f64 = 476.15;
VersionNumber10_5_6	        : f64 = 476.17;
VersionNumber10_5_7	        : f64 = 476.18;
VersionNumber10_5_8	        : f64 = 476.19;
VersionNumber10_6	          : f64 = 550.00;
VersionNumber10_6_1	        : f64 = 550.00;
VersionNumber10_6_2	        : f64 = 550.13;
VersionNumber10_6_3	        : f64 = 550.19;
VersionNumber10_6_4	        : f64 = 550.29;
VersionNumber10_6_5	        : f64 = 550.42;
VersionNumber10_6_6	        : f64 = 550.42;
VersionNumber10_6_7	        : f64 = 550.42;
VersionNumber10_6_8	        : f64 = 550.43;
VersionNumber10_7           : f64 = 635.00;
VersionNumber10_7_1         : f64 = 635.00;
VersionNumber10_7_2         : f64 = 635.15;
VersionNumber10_7_3         : f64 = 635.19;
VersionNumber10_7_4         : f64 = 635.21;
VersionNumber10_7_5         : f64 = 635.21;
VersionNumber10_8           : f64 = 744.00;
VersionNumber10_8_1         : f64 = 744.00;
VersionNumber10_8_2         : f64 = 744.12;
VersionNumber10_8_3         : f64 = 744.18;
VersionNumber10_8_4         : f64 = 744.19;
VersionNumber10_9           : f64 = 855.11;
VersionNumber10_9_1         : f64 = 855.11;
VersionNumber10_9_2         : f64 = 855.14;
VersionNumber10_10          : f64 = 1151.16;
VersionNumber10_10_1        : f64 = 1151.16;
VersionNumber10_10_2        : f64 = 1152;
VersionNumber10_10_3        : f64 = 1153.18;
VersionNumber10_10_4        : f64 = 1153.18;
VersionNumber10_10_5        : f64 = 1153.18;
VersionNumber10_10_Max      : f64 = 1199;
VersionNumber10_11          : f64 = 1253;
VersionNumber10_11_1        : f64 = 1255.1;
VersionNumber10_11_2        : f64 = 1256.14;
VersionNumber10_11_3        : f64 = 1256.14;
VersionNumber10_11_4        : f64 = 1258.1;
VersionNumber10_11_Max      : f64 = 1299;

VersionNumber_iPhoneOS_2_0 : f64 = 478.23;
VersionNumber_iPhoneOS_2_1 : f64 = 478.26;
VersionNumber_iPhoneOS_2_2 : f64 = 478.29;
VersionNumber_iPhoneOS_3_0 : f64 = 478.47;
VersionNumber_iPhoneOS_3_1 : f64 = 478.52;
VersionNumber_iPhoneOS_3_2 : f64 = 478.61;
VersionNumber_iOS_4_0      : f64 = 550.32;
VersionNumber_iOS_4_1      : f64 = 550.38;
VersionNumber_iOS_4_2      : f64 = 550.52;
VersionNumber_iOS_4_3      : f64 = 550.52;
VersionNumber_iOS_5_0      : f64 = 675.00;
VersionNumber_iOS_5_1      : f64 = 690.10;
VersionNumber_iOS_6_0      : f64 = 793.00;
VersionNumber_iOS_6_1      : f64 = 793.00;
VersionNumber_iOS_7_0      : f64 = 847.20;
VersionNumber_iOS_7_1      : f64 = 847.24;
VersionNumber_iOS_8_0      : f64 = 1140.1;
VersionNumber_iOS_8_1      : f64 = 1141.14;
VersionNumber_iOS_8_2      : f64 = 1142.16;
VersionNumber_iOS_8_3      : f64 = 1144.17;
VersionNumber_iOS_8_4      : f64 = 1145.15;
VersionNumber_iOS_8_x_Max  : f64 = 1199;
VersionNumber_iOS_9_0      : f64 = 1240.1;
VersionNumber_iOS_9_1      : f64 = 1241.11;
VersionNumber_iOS_9_2      : f64 = 1242.13;
VersionNumber_iOS_9_3      : f64 = 1242.13;
VersionNumber_iOS_9_4      : f64 = 1280.38;
VersionNumber_iOS_9_x_Max  : f64 = 1299;


CFComparisonResult :: enum i32 {
    CompareLessThan = -1,
    CompareEqualTo = 0,
    CompareGreaterThan = 1
};

/*===========================================================================================*
	CFBase aux structs
 *===========================================================================================*/
CFRange :: struct {
  location: CFIndex,
  length: CFIndex,
};

/*===========================================================================================*
	CFBase func ptrs
 *===========================================================================================*/
CFComparatorFunction :: proc (val1: rawptr, val2: rawptr, contex: rawptr);

CFAllocatorRefRetainCallBack          :: proc(info: rawptr) -> rawptr;
CFAllocatorRefReleaseCallBack         :: proc(info: rawptr);
CFAllocatorRefCopyDescriptionCallBack :: proc(info: rawptr) -> CFStringRef;
CFAllocatorRefAllocateCallBack        :: proc(allocSize: CFIndex ,hint: CFOptionFlags , info: rawptr) -> rawptr;
CFAllocatorRefReallocateCallBack      :: proc(ptr: rawptr, newsize: CFIndex ,hint: CFOptionFlags, info: rawptr) -> rawptr;
CFAllocatorRefDeallocateCallBack      :: proc(ptr: rawptr, info: rawptr);
CFAllocatorRefPreferredSizeCallBack   :: proc(size: CFIndex , hint: CFOptionFlags, info: rawptr) -> CFIndex;

CFAllocatorRefContext :: struct {
    version: CFIndex,
    info: rawptr,
    retain: CFAllocatorRefRetainCallBack,
    release: CFAllocatorRefReleaseCallBack,
    copyDescription: CFAllocatorRefCopyDescriptionCallBack,
    allocate: CFAllocatorRefAllocateCallBack,
    reallocate: CFAllocatorRefReallocateCallBack,
    deallocate: CFAllocatorRefDeallocateCallBack,
    preferredSize: CFAllocatorRefPreferredSizeCallBack,
};

/*===========================================================================================*
	CFBase Macros
 *===========================================================================================*/
//TODO(Platin): Think about this inline here
CFRangeMake :: inline proc (loc: CFIndex , len: CFIndex) -> CFRange {
    range: CFRange;
    range.location = loc;
    range.length = len;
    return range;
}

CFNotFound : CFIndex = -1;

/*===========================================================================================*
	CFBase foreign functions
 *===========================================================================================*/
@(default_calling_convention="c")
foreign core_foundation { 
  
  kCFCoreFoundationVersionNumber : f64;
  
  /* This is a synonym for NULL, if you'd rather use a named constant. */
  kCFAllocatorDefault : CFAllocatorRef;
  
  /* Default system allocator; you rarely need to use this. */
  kCFAllocatorSystemDefault : CFAllocatorRef;
  
  /* This allocator uses malloc(), realloc(), and free(). This should not be
     generally used; stick to kCFAllocatorDefault whenever possible. This
     allocator is useful as the "bytesDeallocator" in CFData or
     "contentsDeallocator" in CFString where the memory was obtained as a
     result of malloc() type functions.
  */
  kCFAllocatorMalloc : CFAllocatorRef;
  
  /* This allocator explicitly uses the default malloc zone, returned by
     malloc_default_zone(). It should only be used when an object is
     safe to be allocated in non-scanned memory.
   */
  kCFAllocatorMallocZone : CFAllocatorRef;
  
  /* Null allocator which does nothing and allocates no memory. This allocator
     is useful as the "bytesDeallocator" in CFData or "contentsDeallocator"
     in CFString where the memory should not be freed. 
  */
  kCFAllocatorNull : CFAllocatorRef;
  
  /* Special allocator argument to CFAllocatorCreate() which means
     "use the functions given in the context to allocate the allocator
     itself as well". 
  */
  kCFAllocatorUseContext : CFAllocatorRef;
  
  CFAllocatorGetTypeID :: proc() -> CFTypeID ---;
  
  CFAllocatorSetDefault :: proc(allocator: CFAllocatorRef) ---;
  
  CFAllocatorGetDefault :: proc() -> CFAllocatorRef ---;
  
  CFAllocatorCreate :: proc(allocator: CFAllocatorRef , allocator_context: ^CFAllocatorRefContext) -> CFAllocatorRef ---;
  
  CFAllocatorAllocate :: proc(allocator: CFAllocatorRef, size: CFIndex, hint: CFOptionFlags) -> rawptr ---;
  
  CFAllocatorReallocate :: proc(allocator: CFAllocatorRef, ptr: rawptr, newsize: CFIndex, hint: CFOptionFlags) ---;
  
  CFAllocatorDeallocate :: proc(allocator: CFAllocatorRef, ptr: rawptr) ---;
  
  CFAllocatorGetPreferredSizeForSize :: proc(allocator: CFAllocatorRef , size: CFIndex, hint: CFOptionFlags) -> CFIndex ---;
  
  CFAllocatorGetContext :: proc(allocator: CFAllocatorRef , allocator_context: ^CFAllocatorRefContext) ---;
  
  CFNullGetTypeID :: proc() -> CFTypeID ---;
  
  CFGetTypeID :: proc(cf: CFType) -> CFTypeID ---;
  
  CFCopyTypeIDDescription :: proc(type_id: CFTypeID) -> CFStringRef ---;
  
  CFRetain :: proc(cf: CFType) -> CFType ---;
  
  CFRelease :: proc(cf: CFType) ---;
  
  CFAutoRelease :: proc(arg: CFType) -> CFType ---;
  
  CFGetRetainCount :: proc(cf: CFType) -> CFIndex ---;
  
  CFEqual :: proc(rhs: CFType, lhs: CFType) -> Boolean ---;
  
  CFHash :: proc(cf: CFType) -> CFHashCode ---;
  
  CFCopyDescription :: proc(cf: CFType) -> CFStringRef ---;
  
  CFGetAllocator :: proc(cf: CFType) -> CFAllocatorRef ---;
  
  CFMakeCollectable :: proc(cf: CFType ) -> CFType ---;
}