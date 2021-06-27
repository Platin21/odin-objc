package objc_tests

import "core:c"
import "core:testing"

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