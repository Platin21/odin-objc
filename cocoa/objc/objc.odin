package objc;
foreign import objc "system:objc"

id    :: opaque rawptr;
class :: opaque rawptr;
sel   :: opaque rawptr;
imp   :: #type proc "c" (obj_id: id , sel: sel, #c_vararg args: ..any) -> id;  

@(default_calling_convention="c")
foreign objc {

/*
		Calls a objc method with all it's arguments 
		
		- Parameter instance: the instance of the class you want to call this on
		- Parameter selector: the selector for the method you want to call
		- Parameter args: the arguments that the method needs addtionaly 
		- Retunrs: a id or a object on the stack which is the result of the method you called
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

/*
	Gets the runtime class from objc 
	
	- Parameter className: the name of the class
  - Returns: the class you requested from the runtime
*/
@(link_name="objc_getClass")
get_class :: proc(className: cstring) -> class ---;

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

/*
	Gets the c function pointer from the objc class
	
	- Parameter class_obj: the class object from objc
	- Parameter selector: the selector which you want to get the c function for.
	- Returns: objc imp aka the c funtion pointer
*/
@(link_name="class_getMethodImplementation")
get_function_from_class :: proc(class_obj: class, selector: sel) -> imp ---;

/* 
	TODO(platin): add the rest of the calls! 
*/

}

/*===========================================================================================*
	CUSTOM OVERLOADS 
 *===========================================================================================*/

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

/*
	@INFO(platin): There are more methods but we don't need them. todo all the things we want.
*/