package objc;

import "core:c"
import "core:mem"

// type overloads
id    :: opaque rawptr;
class :: opaque rawptr;
sel   :: opaque rawptr;
imp   :: #type proc "c" (obj_id: id , sel: sel, args: u8) -> id;   

/*
	Some addtional information about type encoding:
	=> c = i8
  => i = i32
	=> s = i16
	=> l = i32
	=> q = i64
	=> C = u8
  => I = u32
	=> S = u16
	=> L = u32
	=> Q = u64
	=> f = float
	=> d = double
	=> B = bool 
	=> v = void
  => * = cstring
	=> @ = id
	=> # = class
	=> : = sel
	=> [sizetype] = [S]T
	=> {name=type..} = struct {type..}; /* name is optional! */
	=> (type..) = union 
	=> b<num>   = bitfield of num bits
	=> ^type    = pointer of T
	=> ?        = unknown type / function pointers

	Method encoding:
	=> r = const
	=> n = in
	=> N = inout
	=> o = out
	=> O = bycopy
	=> R = byref
	=> V = oneway
*/
objc_ivar :: struct {
	name : cstring,
	type : cstring,
	offset : i32,
}

ivar :: distinct objc_ivar;

// foreign block
foreign import objc "system:objc"
@(default_calling_convention="c")
foreign objc {

/*
		Calls a objc method with all it's arguments 
		- Parameter instance: the instance of the class you want to call this on
		- Parameter selector: the selector for the method you want to call
		- Parameter args: the arguments that the method needs addtionaly 
		- Returns: a id or a object on the stack which is the result of the method you called
*/
objc_msgSend :: proc(all: rawptr) -> id ---;

/*===========================================================================================*
	Selector functions  
 *===========================================================================================*/

/*
	Gets a constant method from the objc class that was 
	not added by extensions to the class
	
	- Parameter name: is the name of the method
	- Returns: the selector for the method
*/
sel_getUid :: proc(name: cstring) -> sel ---;

/*
	Gets the selector of a specific method from the objc runtime 

	- Parameter name: the cstring that is the name of the method
	- Returns: the selector for the method
*/
sel_registerName :: proc(name: cstring) -> sel ---;

/*
  This method gives you the name of a selector as cstring

  - Parameter selector: the selector from which you want the name
  - Returns: cstring the name of the selector
*/
sel_getName :: proc(selector: sel) -> cstring ---;

/*===========================================================================================*
	Class Runtime Functions 
 *===========================================================================================*/

/*
	Gets the runtime class from objc 
	
	- Parameter className: the name of the class
  - Returns: the class you requested from the runtime
*/
objc_getClass :: proc(className: cstring) -> class ---;

/*
  Gets a list of all defined classes of the current process

  - Parameter buffer: on this location the classes that are avaialble will be stored 
                      if you just want to retrive the size pass here a nil and it will return   
                      the count of defined classes 

  - Parameter buffer_count: the count of empty objc.classes that will be filled if there are less
                            classes in the current process than the amount you passed the only the 
                            defined amount of classes will be filled in the buffer array

  - Returns: int indicating the total number of registered classes
*/
objc_getClassList :: proc(buffer: ^class, buffer_count: c.int) -> c.int ---;

/*
	Gets the name of a class as cstring

	- Parameter class_obj: the class object from objc
	- Returns: cstring that is the name of the object
*/
class_getName :: proc(class_obj: class) -> cstring ---;

/*
	Gets the super class of the class 

	- Parameter class_obj: the class object from objc
	- Returns: class that is the super of the class_obj
*/
class_getSuperclass :: proc(class_obj: class) -> class ---;

/*
	Checks if the class is a meta class 

	- Parameter class_obj: the class object from objc
	- Returns: true if the class is a metaclass false if it is not a metaclass
*/
class_isMetaClass :: proc(class_obj: class) -> bool ---;

/*
	Gets the size of a objc class 

	- Parameter class_obj: the class object from objc
	- Returns: the size of a instance of the class 
*/
class_getInstanceSize :: proc(class_obj: class) -> u32 ---;

//@TODO(Platin): Add a description what it really does??
class_getInstanceVariable :: proc (class_obj: class, name: cstring) -> ivar ---;

//@TODO(Platin): Add a description what it really does??
class_getClassVariable :: proc(class_obj : class, name : cstring) -> ivar ---;

/*
	Gets the c function pointer from the objc class
	
	- Parameter class_obj: the class object from objc
	- Parameter selector: the selector which you want to get the c function for.
	- Returns: objc imp aka the c funtion pointer
*/
class_getMethodImplementation :: proc(class_obj: class, selector: sel) -> imp ---;

/*
	Creates a instance of a class with the default heap allocator

	- Parameter class_obj: the objc class you want to create on the heap
	- Parameter extra_bytes: addtional bytes you may want for other stuff
	- Returns: id instance of the class 
*/
class_createInstance :: proc(class_obj: class, extra_bytes: c.int) -> id ---;

/*
	In place constructs a class and registers it in the runtime
	
	- Parameter class_obj: the objc class you want to create
	- Parameter bytes: the place where you want to create it
	- Returns: id instance of the class
*/
objc_constructInstance :: proc(class_obj: class, bytes: rawptr) -> id ---;

/*
	In place destroys a instance of a class and unregisters it in the runtime 
	
	- Parameter obj: the object you want to destruct
	- Returns: rawptr the pointer to the memory where the class was
*/
objc_destructInstance :: proc(obj: id) -> rawptr ---;

/*
  - Parameter sel: the selector from which you want the name
  - Returns: cstring the name of the method the the selector describes
*/
method_getName :: proc(selector: sel) -> cstring ---;

/* 
	TODO(platin): add the rest of the calls! (there might be some objects duplicated here)

  object_copy
  object_dispose
  object_setInstanceVariable
  object_getInstanceVariable
  object_getIndexdIvars
  object_getIvar
  object_setIvar
  object_getClassName*
  object_getClass
	object_setClass
  objc_getClassList*
	objc_copyClassList
  objc_lookUpClass
  objc_getClass*
	objc_getRequiredClass 
  objc_getMetaClass
  objc_setAssociatedObject
  objc_getAssociatedObject
  objc_removeAssociatedObjects
	objc_msgSend_stret
	objc_msgSendSuper
	objc_msgSendSuper_stret
	objc_copyImageNames
	objc_copyClassNamesForImage
	objc_getProtocol 
	objc_copyProtcolList
	objc_allocateProtocol
	objc_registerProtocol
	
	ivar_getName
  ivar_getTypeEncoding
  ivar_getOffset
 	
	method_invoke
	method_invoke_stret
	method_getName
	method_getImplementation
  method_getTypeEncoding
  method_copyReturnType
	method_copyArgumentType
	method_getReturnType
  method_getNumberOfArguments
	method_getArgumentType
	method_getDescription
	method_setImplementation
	method_exchangeImplementations

	class_getImageName
	
	sel_getName+
	sel_registerName+
	sel_getUid+
	sel_isEqual

	protocol_addMethodDescription
	protocol_copyProtocolList
	protocol_addProtocol
	protocol_addProperty
	protocol_getName
	protocol_isEqual
	protocol_getMethodDescription
	protocol_copyPropertyList
	protocol_getProperty
	protocol_copyProtocolList
	protocol_conformsToProtocol

	property_getName
	property_getAttributes
	property_copyAttributeValue
	property_copyAttributeList
*/

}

/*===========================================================================================*
	CUSTOM OVERLOADS 
 *===========================================================================================*/

create_class_instance :: proc(class_obj: class, allocator := context.allocator) -> id {
	class_size := get_size_of_class(class_obj);
	instance_memory : rawptr = mem.alloc(size=int(class_size),allocator=allocator);
	return construct_class(class_obj, instance_memory);
}

create_class_with_name :: proc(class_name: cstring, allocator := context.allocator) -> id {
	objc_class := get_class(class_name);
	class_size := get_size_of_class(objc_class);
	instance_memory : rawptr = mem.alloc(size=int(class_size),allocator=allocator);
	return construct_class(objc_class, instance_memory);
}

destroy_class_instance :: proc(obj: id, allocator := context.allocator) {
	instance_memory := destruct_class(obj);
	free(instance_memory, allocator);
}

/*
	Gets the c function pointer from the objc class but with a name for the method
	
	- Parameter class_obj: the class object from objc
	- Parameter method_name: the name of the function that you want to get
	- Returns: objc imp aka the c funtion pointer
*/
get_function_from_class_with_name :: proc(class_obj: class, method_name: cstring) -> imp {
	return get_function_from_class(class_obj, get_method_selector(method_name));
}

/*
	Gets the c function pointer from the objc class name and that with a name for the method
	
	- Parameter class_obj: the class object from objc
	- Parameter method_name: the name of the function that you want to get
	- Returns: objc imp aka the c funtion pointer
*/
get_function :: proc(class_name: cstring, method_name: cstring) -> imp {
	return get_function_from_class(get_class(class_name), get_method_selector(method_name));
}
