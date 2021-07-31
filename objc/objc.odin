package objc;

import "core:c"
import "core:mem"

VERSION :: "1.2.0";

// type overloads
id       :: distinct rawptr;
class    :: distinct rawptr;
sel      :: distinct rawptr;
method   :: distinct rawptr;
protocol :: distinct rawptr;
property :: distinct rawptr;

// - Note: Don't call anything with imp directly such a call is UB in objc, just cast it to the correct signature
imp      :: #type proc "c" (obj_id: id , sel: sel, args: u8) -> id;   

method_description :: struct { 
	name: sel,
	types: cstring,
};

property_attribute :: struct {
	name: cstring,
	value: cstring,
};


YES   :: true;
NO    :: false;

/*
	Some addtional information about type encoding:
	/*
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
	=> {name=type..} = struct {type..}; // name is optional!
	=> (type..) = union 
	=> b<num>   = bitfield of num bits
	=> ^type    = pointer of T
	=> ?        = unknown type / function pointers
	*/

	Method encoding:
	=> r = const
	=> n = in
	=> N = inout
	=> o = out
	=> O = bycopy
	=> R = byref
	=> V = oneway
*/
 object_ivar :: struct {
	name : cstring,
	type : cstring,
	offset : i32,
}

ivar :: distinct object_ivar;

AssociationPolicy :: enum uintptr {
  
  /* Specifies a weak reference to the associated object. */ 
  OBJC_ASSOCIATION_ASSIGN = 0,
  
  /* Specifies a strong reference to the associated object, and that the association is not made atomically. */ 
  OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,
  
  /* Specifies that the associated object is copied, and that the association is not made atomically. */ 
  OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
  
   /* Specifies that the associated object is copied, and that the association is made atomically. */ 
  OBJC_ASSOCIATION_COPY = 01403,
 
  /* Specifies a strong reference to the associated object, and that the association is made atomically. */
  OBJC_ASSOCIATION_RETAIN = 01401,
}


// foreign block
foreign import objc "system:objc"
@(default_calling_convention="c")
foreign objc {

/*
		Calls a objc method with all it's arguments 
    - Note: This should never be used to call anything directly just cast it to the correct pointer
		- Parameter instance: the instance of the class you want to call this on
		- Parameter selector: the selector for the method you want to call
		- Parameter args: the arguments that the method needs addtionaly 
		- Returns: a id or a value on the stack which is the result of the method you called
*/
@(link_name="objc_msgSend")
msgSend :: proc(all: rawptr) -> id ---;

/*
  Calls a objc method and returns a structure
  - Note: This should never be use to call anything directly just cast it to the correct pointer
  - Returns: a id or a value on the stack which is the result of the method you called
*/
@(link_name="objc_msgSend_stret")
msgSend_stret :: proc(ret: rawptr, all: rawptr) -> int ---;


/*
  Calls objc method that returns a structure from super class
  - Note: This should never be use to call anything directly just cast it to the correct pointer
  - Returns: a id or a value on the stack which is the result of the method you called
*/
@(link_name="objc_msgSendSuper_stret")
msgSendSuper_stret :: proc(ret: rawptr, all: rawptr) -> int ---;

/*
  Calls objc method from the super class 
  - Note: This should never be use to call anything directly just cast it to the correct pointer
*/
@(link_name="objc_msgSendSuper")
msgSendSuper :: proc(all: rawptr) -> id ---;


/*
  Method that gives a list of classes in a certain lib
  - Parameter image: the name of the library or framework 
  - Parameter outCount: the amount of class names that where returned
  - Returns: all class names of a given library or framework
*/
@(link_name="objc_copyClassNamesForImage")
copyClassNamesForImage :: proc(image: cstring, outCount: ^u32) -> ^cstring ---;

/*
  Method that returns all names of dynamic libraries/frameworks with objc objects
  - Parameter outCount: the amount of library/framework names that where returned
*/
@(link_name="objc_copyImageNames")
copyImageNames :: proc(outCount: ^u32) -> ^cstring ---;


/*===========================================================================================*
	Global Protocol 
 *===========================================================================================*/

/*
  Registers a protocol so that it can be used by the objc runtime
*/
@(link_name="objc_registerProtocol")
registerProtocol :: proc(proto: ^protocol) ---;

/*
  Allocates a new empty protocol 
  - Returns: if the name already exists returns zero if not then a empty protocol
*/
@(link_name="objc_allocateProtocol")
allocateProtocol :: proc(name: cstring) -> ^protocol ---;

/*
  Method to get runtime registerd protocols
  - Parameter outCount: is used to define how many protocols are returned
  - Returns: a copy of all currently registerd protocols 
*/
@(link_name="objc_copyProtocolList")
copyProtocolList :: proc(outCount: ^u32) -> ^protocol ---;

/*
 Getter for protocols
  - Returns: the protocol that is registerd in the runtime with the given name. Or zero if there is no such proto
*/
@(link_name="objc_getProtocol")
getProtocol :: proc(name: cstring) -> ^protocol ---;

/*===========================================================================================*
	Global objects 
 *===========================================================================================*/

/*
  Used to remove associtations (properties that refer to other objects)
  - Parameter object: the id of the object from which you want to remove the associates
*/
@(link_name="objc_removeAssociatedObjects")
removeAssociatedObjects :: proc(object: id) ---;


/*
  Gets the assiociated object from a given key
  - Parameter object: the object you want to get the assosiate of
  - Parameter key: the thing that was used as key can be anything
  - Returns: id/object of assosiate 
*/
@(link_name="objc_getAssociatedObject")
getAssociatedObject :: proc(object: id, key: rawptr) -> id ---;


/*
  Adds assosiate to class instance (object)
  - Parameter object: the object you want to set the assosiate of
  - Parameter key: the thing that is used as key can be anything
  - Parameter value: the assosiate
  - Parameter policy: the constraints of the reletionship of the value
*/
@(link_name="objc_setAssociatedObject")
setAssociatedObject :: proc(object: id, key: rawptr, value: id, policy: AssociationPolicy) ---;

/*
  Global classes
*/

/*
  Returns the metaclass defintion of a given class by name
  - Parameter name: the name of the class from where to get the meta class
  - Returns: Metaclass for object if not existing it still returns but the value is then gabrage
*/
@(link_name="objc_getMetaClass")
getMetaClass :: proc(name: cstring) -> id ---; 

/*
  Does the same as objc.getClass but if the class doesn't exists it kills the process
*/
@(link_name="objc_getRequiredClass")
getRequiredClass :: proc(name: cstring) -> class ---;

/*
  Does the same as get class but doesn't lookup via registry callback
*/
@(link_name="objc_lookUpClass")
lookUpClass :: proc(name: cstring) -> class ---;

/*
  
  - Note: Classes need to be freed via free 
  - Parameter outCount: the amount of classes that was retrived
  - Returns: a null terminated array of classes
*/
@(link_name="objc_copyClassList")
copyClassList :: proc(outCount: ^u32) -> ^class ---;

/*
	Creates a new class template at runtime 
*/
@(link_name="objc_allocateClassPair")
allocateClassPair :: proc(parent: class, name: cstring, extra_bytes: c.uint) -> class ---;

/*
	Registers class in the global class registry
*/
@(link_name="objc_registerClassPair")
registerClassPair :: proc(cls: class) ---;

/*
	Removes class from global class registry
*/
@(link_name="objc_disposeClassPair")
disposeClassPair :: proc(cls: class) ---;

/*===========================================================================================*
	Selector
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

/* 
	Returns a Boolean value that indicates if two selectors are equal. 
	
	- Parameter lhs: The selector to compare with rhs
	- Parameter rhs: The selector to compare with lhs
*/
sel_isEqual :: proc(lhs: sel, rhs: sel) -> bool ---;

/*===========================================================================================*
	class (at runtime)
 *===========================================================================================*/

/*
	Gets the runtime class from objc 
	
	- Parameter className: the name of the class
  - Returns: the class you requested from the runtime
*/
@(link_name="objc_getClass")
getClass :: proc(className: cstring) -> class ---;

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
@(link_name="objc_getClassList")
getClassList :: proc(buffer: ^class, bufferCount: c.int) -> c.int ---;


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
	Gets the c function pointer from the objc class
	
	- Parameter class_obj: the class object from objc
	- Parameter selector: the selector which you want to get the c function for.
	- Returns: objc imp aka the c funtion pointer
*/
class_getMethodImplementation_stret :: proc(class_obj: class, selector: sel) -> imp ---;

/*
	Creates a instance of a class with the default heap allocator

	- Parameter class_obj: the objc class you want to create on the heap
	- Parameter extra_bytes: addtional bytes you may want for other stuff
	- Returns: id instance of the class 
*/
class_createInstance :: proc(class_obj: class, extra_bytes: c.int) -> id ---;

/* 
	Returns the name of the dynamic library a class originated from.

	- Parameter class_obj: The class you are inquiring about.
*/
class_getImageName :: proc(class_obj: class) -> cstring ---;

/*
	Adds a new instance variable to a class.
*/
class_addIvar :: proc(cls: class, name: cstring, size: u64, alignment: u8, types: cstring) -> bool ---;

/*
	Describes the instance variables declared by a class.
*/
class_copyIvarList :: proc(cls: class, outCount: ^u32) -> ^ivar ---;

/*
	Returns a description of the Ivar layout for a given class.
*/
class_getIvarLayout :: proc(cls: class) -> ^u8 ---;

/*
	Sets the Ivar layout for a given class.
*/
class_setIvarLayout :: proc(cls: class, layout: ^u8) ---;

/*
	Returns a description of the layout of weak Ivars for a given class.
*/
class_getWeakIvarLayout :: proc(cls: class) -> ^u8 ---;

/*
	Sets the layout for weak Ivars for a given class.
*/
class_setWeakIvarLayout :: proc(cls: class, layout: ^u8) ---;

/*
	Returns a property with a given name of a given class.
*/
class_getProperty :: proc(cls: class, name: cstring) -> property ---;

/*
	Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
*/
class_respondsToSelector :: proc(cls: class, sel: sel) -> bool ---;

/*
	Adds a protocol to a class.
*/
class_addProtocol :: proc(cls: class, protocol: ^protocol) -> bool ---;


/*
	Adds a property to a class.
*/
class_addProperty :: proc (cls: class, name: cstring, attributes: ^property_attribute, attributeCount: uint) -> bool ---;


/*
	Describes the properties declared by a class
*/
class_copyPropertyList  :: proc(cls: class, outCount: ^uint) -> ^property ---;

/*
	Adds a new method to a class with a given name and implementation.
*/
class_addMethod :: proc(cls: class, name: sel, imp: imp, types: cstring) -> bool ---;

/*
	In place constructs a class and registers it in the runtime
	
	- Parameter class_obj: the objc class you want to create
	- Parameter bytes: the place where you want to create it
	- Returns: id instance of the class
*/
@(link_name="objc_constructInstance")
constructInstance :: proc(class_obj: class, bytes: rawptr) -> id ---;

/*
	In place destroys a instance of a class and unregisters it in the runtime 
	
	- Parameter obj: the object you want to destruct
	- Returns: rawptr the pointer to the memory where the class was
*/
@(link_name="objc_destructInstance")
destructInstance :: proc(obj: id) -> rawptr ---;

/*===========================================================================================*
	method 
 *===========================================================================================*/

/*
	Returns the name of a method.

	- Parameter sel: the selector from which you want the name
	- Returns: cstring the name of the method the the selector describes
*/
method_getName :: proc(selector: sel) -> cstring ---;

/*
	Calls the implementation of a specified method.

	@INFO: Apple docs say it's faster than getting the implementation..
*/
method_invoke :: proc() ---;

/*
	Calls the implementation of a specified method that returns a data-structure.
*/
method_invoke_stret :: proc() ---;

/*
	Returns the implementation of a method.
*/
method_getImplementation :: proc(m: method) -> imp ---;

/*
	Returns a string describing a method's parameter and return types.
*/
method_getTypeEncoding :: proc(m: method) -> cstring ---;

/*
	Returns a string describing a method's return type.

	@INFO: This string must be freed!
*/
method_copyReturnType :: proc(m: method) -> cstring ---;

/*
	Returns a string describing a single parameter type of a method.
	@INFO: Can either return null or a string that needs to be freed
*/
method_copyArgumentType :: proc(m: method, index: u32) -> cstring ---;

/*
	Returns by reference a string describing a method's return type.
*/
method_getReturnType :: proc(m: method, dst: cstring, dst_len: int) ---;

/*
	Returns the number of arguments accepted by a method.
*/
method_getNumberOfArguments :: proc(m: method) -> c.uint ---;

/*
	Returns by reference a string describing a single parameter type of a method.
*/
method_getArgumentType :: proc(m: method, index: c.uint, dst: cstring, dst_len: int) ---;

/*
	Returns a method description structure for a specified method.
*/
method_getDescription :: proc(m: method) -> ^method_description ---;

/*
	Sets the implementation of a method.
*/
method_setImplementation :: proc(m: method, implmentation: imp) -> imp ---;

/*
	Exchanges the implementations of two methods.
*/
method_exchangeImplementations :: proc(m1: method, m2: method) ---;

/*===========================================================================================*
	protocol 
 *===========================================================================================*/

/*
	Adds a method to a protocol.
*/
protocol_addMethodDescription :: proc(proto: ^protocol, name: sel, types: cstring, isRequiredMethod: bool, isInstanceMethod: bool) ---;

/*
	Returns an array of the protocols adopted by a protocol.
*/
protocol_copyProtocolList :: proc(proto: ^protocol, outCount: ^c.uint) -> ^^protocol ---;

/*
	Adds a registered protocol to another protocol that is under construction.
*/
protocol_addProtocol :: proc(proto: ^protocol, addition: ^protocol) ---;

/*
	Adds a property to a protocol that is under construction.
*/
protocol_addProperty :: proc(proto: ^protocol, name: cstring, attributes: ^property_attribute, attributeCount: c.uint, isRequiredProperty: bool, isInstanceProperty: bool) ---;

/*
	Returns a the name of a protocol.
*/
protocol_getName :: proc(proto: ^protocol) -> cstring ---;

/*
	Checks wether two protocols are equal
*/
protocol_isEqual :: proc(proto1: ^protocol, proto2: ^protocol) -> bool ---;

/*
	Returns a method description structure for a specified method of a given protocol.
*/
protocol_getMethodDescription :: proc(proto: ^protocol, aSel: sel, isRequiredMethod: bool, isInstanceMethod: bool) -> method_description ---; 

/*
	Returns an array of the properties declared by a protocol.
*/
protocol_copyPropertyList :: proc(proto: ^protocol, outCount: c.uint) -> ^property ---;

/*
	Returns the specified property of a given protocol.
*/
protocol_getProperty :: proc(proto: ^protocol, name: cstring, isRequiredProperty: bool, isInstanceProperty: bool) -> ^property ---;


/*
	Checks if a certain class is conformant to a protocol 
*/
protocol_conformsToProtocol :: proc(Class: class, proto: ^protocol) -> bool ---;

/*===========================================================================================*
	PROPERTY
 *===========================================================================================*/

/*
	Returns the name of a property.	
*/
property_getName :: proc(prop: property) -> cstring ---;

/*
	Returns the attribute string of a property.
*/
property_getAttributes :: proc(prop: property) -> cstring ---;

/*
	Returns the value of a property attribute given the attribute name.
*/
property_copyAttributeValue :: proc(prop: property, attributeName: cstring) -> cstring ---;

/*
	Returns an array of property attributes for a given property.
*/
property_copyAttributeList :: proc(prop: ^property, outCount: ^c.uint) -> ^property_attribute ---;

/*===========================================================================================*
	Instance Variable
 *===========================================================================================*/

/*
	Retrives the name of a ivar
*/
ivar_getName         :: proc(v: ivar) -> cstring ---;

/*
	Gets the objc type endcoding from a ivar
*/
ivar_getTypeEncoding :: proc(v: ivar) -> cstring ---; 

/*
	Gets the offset of a ivar inside a class
*/
ivar_getOffset       :: proc(v: ivar) -> uint ---;


/*===========================================================================================*
	Object
 *===========================================================================================*/

/*
  Sets the class of a object and returns the old class
*/
object_setClass :: proc(obj: id, cls: class) -> class ---;

/*
  Getter for class of object
  - Returns: the class of a object 
*/
object_getClass :: proc(obj: id) -> class ---;

/*
  Get for class name of the object
*/
object_getClassName :: proc(obj: id) -> cstring ---;

/*
  Sets a instance variable to a certain value 
*/
object_setIvar :: proc(obj: id, var: ivar, value: id) ---;

/*
  Gets a ivar of a certain object
*/
object_getIvar :: proc(obj: id, var: ivar) -> id ---;

/*
  This proc returns a ptr to any extra bytes allocated on the id
*/
object_getIndexedIvars :: proc(obj: id) -> rawptr ---;

/*
  Get the value of a instance variable from an object
*/
object_getInstanceVariable :: proc(obj: id, name: cstring, outValue: ^rawptr) -> ivar ---;

/*
  Set the value of a instance variable from an object
*/
object_setInstanceVariable :: proc(obj: id, name: cstring, value: rawptr) -> ivar ---;

/*
  Free's the given object returns empty id
*/
object_dispose :: proc(obj: id) -> id ---;

/*
  Creates a copy of a certain object
  - Note: this needs to have the size match or be more than the given object
*/
object_copy :: proc(obj: id, size: u64) -> id ---;

}

/*===========================================================================================*
	CUSTOM OVERLOADS 
 *===========================================================================================*/

create_class_instance :: proc(class_obj: class, allocator := context.allocator) -> id {
	class_size := class_getInstanceSize(class_obj);
	instance_memory : rawptr = mem.alloc(size=int(class_size),allocator=allocator);
	return  constructInstance(class_obj, instance_memory);
}

create_class_with_name :: proc(class_name: cstring, allocator := context.allocator) -> id {
	objc_class :=  getClass(class_name);
	class_size := class_getInstanceSize(objc_class);
	instance_memory : rawptr = mem.alloc(size=int(class_size),allocator=allocator);
	return  constructInstance(objc_class, instance_memory);
}

create_class_definition :: proc(class_name: cstring, extra_bytes : c.uint = 0) -> class {
	ns_object := getClass("NSObject");
	return allocateClassPair(ns_object, class_name, extra_bytes);
}

create_class_definition_with_parent_class :: proc(class_name: cstring, class_parent: class, extra_bytes : c.uint = 0) -> class {
	return allocateClassPair(class_parent, class_name, extra_bytes);
}

create_class_definition_with_parent :: proc(class_name: cstring, class_name_parent: cstring, extra_bytes : c.uint = 0) -> class {
	cls := getClass(class_name_parent);
	return allocateClassPair(cls, class_name, extra_bytes);
}

create_selector_for_name :: proc(selector_name: cstring) -> sel {
	return sel_registerName(selector_name);
}

destroy_class_instance :: proc(obj: id, allocator := context.allocator) {
	instance_memory :=  destructInstance(obj);
	free(instance_memory, allocator);
}
 
destroy_class_instance_ref :: proc(obj: ^id, allocator := context.allocator) {
	instance_memory :=  destructInstance(obj^);
	free(instance_memory, allocator);
  obj^ = nil;
}

class_get_method_implementation_of_name :: proc(class_obj: class, method_name: cstring) -> imp {
	return class_getMethodImplementation(class_obj, sel_registerName(method_name));
}

class_with_name_get_method_implementation_of_selector :: proc(class_name: cstring, method_sel: sel) -> imp {
	return class_getMethodImplementation( getClass(class_name), method_sel);
}

class_with_name_get_method_implementation_of_name :: proc(class_name: cstring, method_name: cstring) -> imp {
	return class_getMethodImplementation( getClass(class_name), sel_registerName(method_name));
}

