package objc_tests

import "core:c"
import "core:testing"
import "core:fmt"

import "../objc"

@test 
correct_package_version:: proc(t: ^testing.T) {
	testing.expect(t, objc.VERSION == "1.2.0", "Got incorrect version");
}

@test 
objc_get_class :: proc(t: ^testing.T) {
	ns_null     := objc.getClass("NSNull");
	ns_null_ptr := cast(rawptr)ns_null;

	testing.expect(t, ns_null_ptr == nil, "Got incorrect pointer value for NSNull");
}

@test 
objc_create_class :: proc(t: ^testing.T) {
	ns_null          := objc.getClass("NSNull");
	ns_null_ptr := cast(rawptr)ns_null;

	custom_class     := objc.create_class_definition("CustomClass");
	custom_class_ptr := cast(rawptr)custom_class;

	testing.expect(t, custom_class_ptr != ns_null_ptr, "Wasn't able to allocate a custom class");
}

@test 
objc_create_class_with_parent :: proc(t: ^testing.T) {
	custom_class     := objc.create_class_definition("CustomClass");
	custom_class_ptr := cast(rawptr)custom_class;

	custom_class_with_parent     := objc.create_class_definition_with_parent_class("CustomClass2", custom_class);
	custom_class_with_parent_ptr := cast(rawptr)custom_class_with_parent;

	testing.expect(t, custom_class_ptr != custom_class_with_parent_ptr, "Wasn't able to allocate a custom class with other custom class");
}

@test 
objc_create_class_and_get :: proc(t: ^testing.T) {
	custom_class     := objc.create_class_definition("CustomClass");
	custom_class_ptr := cast(rawptr)custom_class;

	objc.registerClassPair(custom_class);

	custom_class_from_get     := objc.getClass("CustomClass");
	custom_class_from_get_ptr := cast(rawptr)custom_class_from_get;

	testing.expect(t, custom_class_ptr == custom_class_from_get, "CustomClass didn't get registered");

	objc.disposeClassPair(custom_class);
}

@test 
objc_dispose_created_class :: proc(t: ^testing.T) {
	ns_null     := objc.getClass("NSNull");
	ns_null_ptr := cast(rawptr)ns_null;

	custom_class     := objc.create_class_definition("CustomClass");
	custom_class_ptr := cast(rawptr)custom_class;

	objc.registerClassPair(custom_class);
	objc.disposeClassPair(custom_class);

	custom_class_from_get     := objc.getClass("CustomClass");
	custom_class_from_get_ptr := cast(rawptr)custom_class_from_get;

	testing.expect(t, custom_class_ptr != custom_class_from_get_ptr, "CustomClass didn't get disposed");
	testing.expect(t, custom_class_from_get_ptr == ns_null_ptr, "CustomClass should have been NSNull");
}


@test 
objc_create_class_and_add_proc  :: proc(t: ^testing.T) {
	custom_class  := objc.create_class_definition("custom_class");
	custom_sel    := objc.create_selector_for_name("customMethod");

	custom_proc :: proc(self: objc.id , cmd: objc.sel) {
		fmt.printf("I got called man i got called!\n Self: %v Cmd: %v", self, cmd);
	}

	sucess := objc.class_addMethod(custom_class, custom_sel, cast(objc.imp)custom_proc, "v@:");
	testing.expect(t, sucess, "custom_class didn't get method added");

	objc.disposeClassPair(custom_class);
}

@test 
objc_add_proc_and_check :: proc(t: ^testing.T) {
	custom_class  := objc.create_class_definition("custom_class");
	custom_sel    := objc.create_selector_for_name("customMethod");

	custom_proc :: proc(self: objc.id , cmd: objc.sel) {
		fmt.printf("I got called man i got called!\n Self: %v Cmd: %v", self, cmd);
	}

	sucess := objc.class_addMethod(custom_class, custom_sel, cast(objc.imp)custom_proc, "v@:");
	testing.expect(t, sucess, "custom_class didn't get method added");

	objc.registerClassPair(custom_class);

	method_addr := objc.class_get_method_implementation_of_name(custom_class, "customMethod");
	testing.expect(t, rawptr(method_addr) == rawptr(custom_proc), "Method got wrong adress");

	objc.disposeClassPair(custom_class);
}

@test 
objc_create_class_and_create_instance :: proc(t: ^testing.T) {
	custom_class  := objc.create_class_definition("custom_class");
	objc.registerClassPair(custom_class);

	instance := objc.create_class_with_name("custom_class");
	fmt.printf("Instance: %v\n", instance);

	objc.destroy_class_instance_ref(&instance);
	objc.disposeClassPair(custom_class);
}

@test 
objc_create_class_and_create_instance_and_call_method :: proc(t: ^testing.T) {
	custom_class  := objc.create_class_definition("custom_class");
	custom_sel    := objc.create_selector_for_name("custom_method");

	custom_proc :: proc(self: objc.id , cmd: objc.sel) {
		fmt.printf("I got called man i got called self: %v cmd: %v\n", self, cmd);
	}
	objc.class_addMethod(custom_class, custom_sel, cast(objc.imp)custom_proc, "v@:");
	objc.registerClassPair(custom_class);


	custom_inst := objc.create_class_with_name("custom_class");
	custom_call := cast(type_of(custom_proc))objc.msgSend;	


	custom_call(custom_inst, custom_sel);


	objc.destroy_class_instance_ref(&custom_inst);
	objc.disposeClassPair(custom_class);
}