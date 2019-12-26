package objc;

// type overloads
id    :: opaque rawptr;
class :: opaque rawptr;
sel   :: opaque rawptr;
imp   :: #type proc "c" (obj_id: id , sel: sel, #c_vararg args: ..any) -> id;  

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
@(link_name="objc_msgSend")
call_method :: proc(instance: id, selector: sel, #c_vararg args: ..any) -> id ---;

/* 
	Calls a method that is static from a class 
	
	- Parameter instance: the instance of the class you want to call this on
	- Parameter selector: the selector for the method you want to call
	- Parameter args: the arguments that the method needs addtionaly 
	- Retunrs: a id or a object on the stack which is the result of the method you called
*/
@(link_name="objc_msgSend")
call_static_method :: proc(class_obj: class, selector: sel, #c_vararg args: ..any) -> id ---;

/*===========================================================================================*
	Selector functions  
 *===========================================================================================*/

/*
	Gets a constant method from the objc class that was 
	not added by extensions to the class
	
	- Parameter name: is the name of the method
	- Returns: the selector for the method
*/
@(link_name="sel_getUid")
get_constant_method_selector :: proc(name: cstring) -> sel ---;

/*
	Gets the selector of a specific method from the objc runtime 

	- Parameter name: the cstring that is the name of the method
	- Returns: the selector for the method
*/
@(link_name="sel_registerName")
get_method_selector :: proc(name: cstring) -> sel ---;

/*===========================================================================================*
	Class Runtime Functions 
 *===========================================================================================*/

/*
	Gets the runtime class from objc 
	
	- Parameter className: the name of the class
  - Returns: the class you requested from the runtime
*/
@(link_name="objc_getClass")
get_class :: proc(className: cstring) -> class ---;

/*
	Gets the name of a class as cstring

	- Parameter class_obj: the class object from objc
	- Returns: cstring that is the name of the object
*/
@(link_name="class_getName") 
get_class_name :: proc(class_obj: class) -> cstring ---;

/*
	Gets the super class of the class 

	- Parameter class_obj: the class object from objc
	- Returns: class that is the super of the class_obj
*/
@(link_name="class_getSuperclass") 
get_super_class_of_class :: proc(class_obj: class) -> Class ---;

/*
	Checks if the class is a meta class 

	- Parameter class_obj: the class object from objc
	- Returns: true if the class is a metaclass false if it is not a metaclass
*/
@(link_name="class_isMetaClass")
is_metaclass :: proc(class_obj: class) -> bool ---;

/*
	Gets the size of a objc class 

	- Parameter class_obj: the class object from objc
	- Returns: the size of a instance of the class 
*/
@(link_name="class_getInstanceSize")
get_size_of_class :: proc(class_obj: class) -> u32 ---;

@(link_name="class_getInstanceVaribale")
get_static_variable_from_class :: proc (class_obj: class, name: cstring) -> ivar ---;

@(link_name="class_getClassVariable")
get_variable_from_class :: proc(class_obj : class, name : cstring) -> ivar ---;

/*
	Gets the c function pointer from the objc class
	
	- Parameter class_obj: the class object from objc
	- Parameter selector: the selector which you want to get the c function for.
	- Returns: objc imp aka the c funtion pointer
*/
@(link_name="class_getMethodImplementation")
get_function_from_class :: proc(class_obj: class, selector: sel) -> imp ---;

/*
	Creates a instance of a class with the default heap allocator

	- Parameter class_obj: the objc class you want to create on the heap
	- Parameter extra_bytes: addtional bytes you may want for other stuff
	- Returns: id instance of the class 
*/
@(link_name="class_createInstance")
create_instance_of_class :: proc(class_obj: class, extra_bytes: c.int) -> id ---;

/*
	In place constructs a class and registers it in the runtime
	
	- Parameter class_obj: the objc class you want to create
	- Parameter bytes: the place where you want to create it
	- Returns id: instance of the class
*/
@(link_name="objc_constructInstance")
construct_class :: proc(class_obj: class, bytes: rawptr) -> id ---;

/*
	In place destroys a instance of a class and unregisters it in the runtime 
	
	- Parameter obj: the object you want to destruct
	- Returns rawptr: the pointer to the memory where the class was
*/
@(link_name="objc_destructInstance")
destruct_class :: proc(obj: id) -> rawptr ---;

/* 
	TODO(platin): add the rest of the calls! (there might be some objects duplicated here)

  object_copy
  object_dispose
  object_setInstanceVariable
  object_getInstanceVariable
  object_getIndexdIvars
  object_getIvar
  object_setIvar
  object_getClassName
  object_getClass
	object_setClass
  objc_getClassList
	objc_copyClassList
  objc_lookUpClass
  objc_getClass
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
	
	sel_getName
	sel_registerName
	sel_getUid
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

create_class_instance :: proc(class_obj: class) -> id {
	class_size := get_size_of_class(class_obj);
	instance_memory := context.alloc(class_size);
	return construct_class(class, instance_memory);
}

create_class_with_name :: proc(class_name: cstring) -> id {
	objc_class := get_class(class_name);
	class_size := get_size_of_class(class_obj);
	instance_memory := context.alloc(class_size);
	return construct_class(class, instance_memory);
}

destroy_class_instance :: proc(obj: id) {
	instance_memory := destruct_class(id);
	context.free(instance_memory);
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
