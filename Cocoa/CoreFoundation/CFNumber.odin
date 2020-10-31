package CoreFoundation;

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import core_foundation "system:CoreFoundation.framework" 

CFNumberRef :: distinct rawptr;
CFBooleanRef :: distinct CFNumberRef;

CFNumberType :: enum CFIndex {
    kCFNumberSInt8Type = 1,
    kCFNumberSInt16Type = 2,
    kCFNumberSInt32Type = 3,
    kCFNumberSInt64Type = 4,
    kCFNumberFloat32Type = 5,
    kCFNumberFloat64Type = 6,	
    kCFNumberCharType = 7,
    kCFNumberShortType = 8,
    kCFNumberIntType = 9,
    kCFNumberLongType = 10,
    kCFNumberLongLongType = 11,
    kCFNumberFloatType = 12,
    kCFNumberDoubleType = 13,
    kCFNumberCFIndexType = 14,
    kCFNumberNSIntegerType = 15,
    kCFNumberCGFloatType = 16,
    kCFNumberMaxType = 16
};

YES := kCFBooleanTrue;
NO  := kCFBooleanFalse;


@(default_calling_convention="c")
foreign core_foundation { 

kCFBooleanTrue  : CFBooleanRef;
kCFBooleanFalse : CFBooleanRef;

kCFNumberPositiveInfinity : CFNumberRef;
kCFNumberNegativeInfinity : CFNumberRef;
kCFNumberNaN              : CFNumberRef;

CFBooleanGetTypeID :: proc() -> CFTypeID ---;
CFBooleanGetValue  :: proc(boolean: CFBooleanRef) -> Boolean ---;

CFNumberGetTypeID   :: proc() -> CFTypeID ---;
CFNumberCreate      :: proc(allocator: CFAllocatorRef, theType: CFNumberType, valuePtr: rawptr) -> CFNumberRef ---;
CFNumberGetType     :: proc(number: CFNumberRef) -> CFNumberType ---;
CFNumberGetByteSize :: proc(number: CFNumberRef) -> CFIndex ---;
CFNumberIsFloatType :: proc(number: CFNumberRef) -> Boolean ---;
CFNumberGetValue    :: proc(number: CFNumberRef, theType: CFNumberType, valuePtr: rawptr) -> Boolean ---;
CFNumberCompare     :: proc(number: CFNumberRef, otherNumber: CFNumberRef, ctx: rawptr) -> CFComparisonResult ---;
}

CFNUM :: proc(value: $T) -> CFNumberRef {
    cValue := value;
    when T == i8 {
        type : CFNumberType = .kCFNumberSInt8Type;
    } else when T == i16 {
        type : CFNumberType = .kCFNumberSInt16Type;
    } else when T == i32 {
        type : CFNumberType = .kCFNumberSInt32Type;
    } else when T == i32 {
        type : CFNumberType = .kCFNumberSInt64Type;
    } else when T == f32 {
        type : CFNumberType = .kCFNumberFloat32Type;
    } else when T == f64 {
        type : CFNumberType = .kCFNumberFloat64Type;
    } else when T == int && ODIN_ARCH == "amd64" {
        type : CFNumberType = .kCFNumberSInt64Type;
    } else when T == int {
        type : CFNumberType = .kCFNumberSInt32Type;
    }

    return CFNumberCreate(kCFAllocatorMalloc, type, cast(rawptr)&cValue);
}

CFNumberGeti8 :: proc(number: CFNumberRef) -> i8 {
  valuePtr : i8 = 0;
  if CFNumberGetType(number) == .kCFNumberSInt8Type {
    CFNumberGetValue(number, .kCFNumberSInt8Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFNumberGeti16 :: proc(number: CFNumberRef) -> i16 {
  valuePtr : i16 = 0;
  if CFNumberGetType(number) == .kCFNumberSInt16Type {
    CFNumberGetValue(number, .kCFNumberSInt16Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFNumberGeti32 :: proc(number: CFNumberRef) -> i32 {
  valuePtr : i32 = 0;
  if CFNumberGetType(number) == .kCFNumberSInt32Type {
    CFNumberGetValue(number, .kCFNumberSInt32Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFNumberGeti64 :: proc(number: CFNumberRef) -> i64 {
  valuePtr : i64 = 0;
  if CFNumberGetType(number) == .kCFNumberSInt64Type {
    CFNumberGetValue(number, .kCFNumberSInt64Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFNumberGetf32 :: proc(number: CFNumberRef) -> f32 {
  valuePtr : f32 = 0;
  if CFNumberGetType(number) == .kCFNumberFloat32Type {
    CFNumberGetValue(number, .kCFNumberFloat32Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFNumberGetf64 :: proc(number: CFNumberRef) -> f64 {
  valuePtr : f64 = 0;
  if CFNumberGetType(number) == .kCFNumberFloat64Type {
    CFNumberGetValue(number, .kCFNumberFloat64Type, cast(rawptr)&valuePtr);
  }
  return valuePtr;
}

CFBoolCompare :: proc(bool1: CFBooleanRef, bool2: CFBooleanRef, ctx: rawptr) -> CFComparisonResult {
  return CFNumberCompare(cast(CFNumberRef)bool1, cast(CFNumberRef)bool2, ctx);
};
