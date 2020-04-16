package CoreFoundation;

/*===========================================================================================*
	Foreign import 
 *===========================================================================================*/
@force foreign import core_foundation "system:CoreFoundation.framework" 

/*===========================================================================================*
	CFArray aux structs
 *===========================================================================================*/
/*
  Structure containing the callbacks of a CFArray.
	- Field version: The version number of the structure type being passed in as a parameter to the CFArray creation functions
	- Field retain: The callback used to add a retain for the array on values as they are put into the array
	- Field release: The callback used to remove a retain previously added for array elements
	- Field copyDescription: The callback used to create a descriptive string representation of each value in the array
	- Field equal: The callback used to compare values in the array for equality for some operations.
*/
CFArrayCallBacks :: struct {
    version: CFIndex,
    retain: CFArrayRetainCallBack,	
    release: CFArrayReleaseCallBack,
    copyDescription: CFArrayCopyDescriptionCallBack,
    equal: CFArrayEqualCallBack,
};

/*===========================================================================================*
	CFArray func ptrs
 *===========================================================================================*/
CFArrayRetainCallBack          :: proc(allocator: CFAllocatorRef, value: rawptr) -> rawptr;
CFArrayReleaseCallBack         :: proc(allocator: CFAllocatorRef, value: rawptr);
CFArrayCopyDescriptionCallBack :: proc(value: rawptr) -> CFStringRef;
CFArrayEqualCallBack           :: proc(value1: rawptr, value2: rawptr) -> Boolean;

/*
	Type of the callback function used by the apply functions of CFArrays.
	- Parameter value: The current value from the array 
	- Parameter rawptr: context The user-defined context parameter given to the apply function
*/
CFArrayApplierFunction         :: proc(value: rawptr, ctx: rawptr);

/*===========================================================================================*
	CFArray types
 *===========================================================================================*/
/* This is the type of a reference to immutable CFArrays  */
CFArrayRef        :: distinct rawptr;
/* This is the type of a reference to mutable CFArrays */
CFMutableArrayRef :: distinct CFArrayRef;

/*===========================================================================================*
	CFArray foreign functions
 *===========================================================================================*/
@(default_calling_convention="c")
foreign core_foundation { 
 
 /* Predefined CFArrayCallBacks structure containing a set of callbacks appropriate for use when the values in a CFArray are all CFTypes. */
 kCFTypeArrayCallBacks : CFArrayCallBacks; 
 
 /* - Returns: the type identifier of all CFArray instances. */
 CFArrayGetTypeID               :: proc() -> CFTypeID ---;
 
 /*
  Creates a new immutable array with the given values.
 
	- Parameter allocator: The CFAllocator which should be used to allocate memory for the array and its storage for values. 
	- Parameter values: A C array of the pointer-sized values to be in the array the order of the elements is equal to the c array. 
	- Parameter numValues: The number of values to copy from the values C array into the CFArray. This number will be the count of the array.
	- Parameter callBacks: A pointer to a CFArrayCallBacks structure initialized with the callbacks for the array to use on each value in the array. 
	- Returns: a reference to the new immutable CFArray.
 */
 CFArrayCreate                  :: proc(allocator := kCFAllocatorMalloc, values: ^rawptr, numValues: CFIndex, callBacks: ^CFArrayCallBacks) -> CFArrayRef ---;
 
 /*
	Creates a new immutable array with the values from the given array.
	- Parameter allocator: The CFAllocator which should be used to allocate memory for the array and its storage for values.
	- Parameter theArray: The array which is to be copied. 
	- Returns: A reference to the new immutable CFArray.
 */
 CFArrayCreateCopy              :: proc(allocator := kCFAllocatorMalloc, theArray: CFArrayRef) -> CFArrayRef ---;
 
 /*
  Creates a new empty mutable array
	- Parameter allocator: The CFAllocator which should be used to allocate memory for the array and its storage for values 
	- Parameter capacity: A hint about the number of values that will be held by the CFArray
	- Parameter callBacks: initializes the callbacks for the array to use on each value in the array
  - Returns: A reference to the new mutable CFArray.
 */
 CFArrayCreateMutable           :: proc(allocator := kCFAllocatorMalloc, capacity: CFIndex, callBacks: ^CFArrayCallBacks) -> CFMutableArrayRef ---;
 
 /*
	Creates a new mutable array with the values from the given array
	- Parameter allocator: The CFAllocator which should be used to allocate emory for the array and its storage for values
  - Parameter capacity: A hint about the number of values that will be held by the CFArray
	- Parameter theArray: The array which is to be copied. The values from the array are copied by value
  - Returns: result A reference to the new mutable CFArray
 */
 CFArrayCreateMutableCopy       :: proc(allocator := kCFAllocatorMalloc, capacity: CFIndex, theArray: CFArrayRef) -> CFMutableArrayRef ---;
 
 /*
  Returns the number of values currently in the array
  - Parameter theArray: The array to be queried
  - Returns: The number of values in the array
 */                              
 CFArrayGetCount                :: proc(theArray: CFArrayRef) -> CFIndex ---;
 
 /*
  Counts the number of times the given value occurs in the array 
	- Parameter theArray: The array to be searched 
	- Parameter range: The range within the array to search 
	- Parameter value: The value for which to find matches in the array
	- Returns: The number of times the given value occurs in the array in the range
 */
 CFArrayGetCountOfValue         :: proc(theArray: CFArrayRef, range: CFRange, value: rawptr) -> CFIndex ---;
 
 /*
  Reports whether or not the value is in the array 
	- Parameter theArray: The array to be searched  
	- Parameter range: The range within the array to search 
	- Parameter value: The value for which to find matches in the array 
	- Returns: true, if the value is in the specified range of the array otherwise false
 */
 CFArrayContainsValue           :: proc(theArray: CFArrayRef, range: CFRange, value: rawptr) -> Boolean ---;
 
 /*
  Retrieves the value at the given index
	- Parameter theArray: The array to be queried
	- Parameter idx: The index of the value to retrieve 
	- Returns: The value with the given index in the array
 */
 CFArrayGetValueAtIndex         :: proc(theArray: CFArrayRef, idx: CFIndex) -> rawptr ---;
 
 /*
  Fills the buffer with values from the array
	- Parameter theArray: The array to be queried
	- Parameter range: The range of values within the array to retrieve
	- Parameter values: A C array of pointer-sized values to be filled with values from the array
 */
 CFArrayGetValues               :: proc(theArray: CFArrayRef, range: CFRange, values: ^rawptr) ---;
 
 /*
  Calls a function once for each value in the array
	- Parameter theArray: The array to be operated upon
	- Parameter range: The range of values within the array to which to apply the function
	- Parameter applier: The callback function to call once for each value in the given range in the array
	- Parameter context: A pointer-sized user-defined value, which is passed as the second parameter to the applier function 
 */
 CFArrayApplyFunction           :: proc(theArray: CFArrayRef, range: CFRange, applier: CFArrayApplierFunction, ctx: rawptr) ---;
 
 /*
  Searches the array for the value
	- Parameter theArray: The array to be searched
	- Parameter range: The range within the array to search
	- Parameter value: The value for which to find a match in the array
	- Returns: The lowest index of the matching values in the range, or kCFNotFound if no value in the range matched
 */
 CFArrayGetFirstIndexOfValue    :: proc(theArray: CFArrayRef, range: CFRange, value: rawptr) -> CFIndex ---;
 
 /*
  Searches the array for the value
	- Parameter theArray: The array to be searched
	- Parameter range: The range within the array to search
	- Parameter value: The value for which to find a match in the array
	- Returns: The highest index of the matching values in the range, or kCFNotFound if no value in the range matched
 */
 CFArrayGetLastIndexOfValue     :: proc(theArray: CFArrayRef, range: CFRange, value: rawptr) -> CFIndex ---;
 
 /*
  Searches the array for the value using a binary search algorithm.
	- Parameter theArray: The array to be searched
	- Parameter range: The range within the array to search.
	- Parameter value: The value for which to find a match in the array
	- Parameter comparator: used in the binary search operation to compare values in the array with the given value
	- Parameter context: A pointer-sized user-defined value, which is passed as the third parameter to the comparator function
	- Returns: 1) the index of a value that matched 
             2) greater than or equal to the end point of the range
             3) the index of the value greater than the target value 
 */
 CFArrayBSearchValues           :: proc(theArray: CFArrayRef, range: CFRange, value: rawptr, comparator: CFComparatorFunction, ctx: rawptr) -> CFIndex ---;
 
 /*
  Adds the value to the array giving it a new largest index
	- Parameter theArray: The array to which the value is to be added
	- Parameter value: The value to add to the array
 */
 CFArrayAppendValue             :: proc(theArray: CFMutableArrayRef, value: rawptr) ---;
 
 /*
  Adds the value to the array, giving it the given index
	- Parameter theArray: The mutable array to which the value is to be added
	- Parameter idx: The index to which to add the new value
	- Parameter value: The value to add to the array
 */
 CFArrayInsertValueAtIndex      :: proc(theArray: CFMutableArrayRef, idx: CFIndex, value: rawptr) ---;
 
 /*
  Changes the value with the given index in the array
	- Parameter theArray: The array in which the value is to be changed
	- Parameter idx: The index to which to set the new value
	- Parameter value: The value to set in the array
 */
 CFArraySetValueAtIndex         :: proc(theArray: CFMutableArrayRef, idx: CFIndex, value: rawptr) ---;
 
 /*
  Removes the value with the given index from the array
	- Parameter theArray: The array from which the value is to be removed
	- Parameter idx: The index from which to remove the value
 */
 CFArrayRemoveValueAtIndex      :: proc(theArray: CFMutableArrayRef, idx: CFIndex) ---;
 
 /*
  Removes all the values from the array, making it empty.
	- Parameter theArray: The array from which all of the values are to be removed
 */
 CFArrayRemoveAllValues         :: proc(theArray: CFMutableArrayRef) ---; 
 
 /*
   Replaces a range of values in the array.
 	 - Parameter theArray: The array from which all of the values are to be removed 
 	 - Parameter range: The range of values within the array to replace
 	 - Parameter newValues: A C array of the pointer-sized values to be placed into the array
 	 - Parameter newCount: The number of values to copy from the values C array into the CFArray. 
  */
 CFArrayReplaceValues           :: proc(theArray: CFMutableArrayRef, range: CFRange, newValues: ^rawptr, newCount: CFIndex) ---;
 
 /*
  Exchanges the values at two indices of the array.
	- Parameter theArray: The mutable array of which the values are to be swapped
	- Parameter idx1: The first index whose values should be swapped. 
	- Parameter idx2: The second index whose values should be swapped.
 */
 CFArrayExchangeValuesAtIndices :: proc(theArray: CFMutableArrayRef, idx1: CFIndex, idx2: CFIndex) ---;
 
 /*
  Sorts the values in the array using the given comparison function.
	- Parameter theArray: The array whose values are to be sorted
	- Parameter range: The range of values within the array to sort
	- Parameter comparator: used in the sort operation to compare values in the array with the given value
	- Parameter context: A pointer-sized user-defined value, which is passed as the third parameter to the comparator function
 */
 CFArraySortValues              :: proc(theArray: CFMutableArrayRef, range: CFRange, comparator: CFComparatorFunction, ctx: rawptr) ---;
 
 /*
  Adds the values from an array to another array.
	- Parameter theArray: The array to which values from the otherArray are to be added
	- Parameter otherArray: The array providing the values to be added to the array
	- Parameter otherRange: The range within the otherArray from which to add the values to the array
 */
 CFArrayAppendArray             :: proc(theArray: CFMutableArrayRef, otherArray: CFArrayRef, otherRange: CFRange) ---;

}
