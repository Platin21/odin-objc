package selector_generator;

import "core:fmt"
import "core:reflect"
import "core:strings"
import "core:runtime"
import "../objc"

type_to_objc_type :: proc(tp: ^reflect.Type_Info) -> string {
	#partial switch info in tp.variant {
	case reflect.Type_Info_Named:
		switch tp.variant.(reflect.Type_Info_Named).name {
		case "id":
			return "@";
		case "sel":
			return ":";
		case "class":
			return "#";
		case:
			fmt.printf("%v", info.base); // struct base needs to be handled here!
			return "?";
		}
	case reflect.Type_Info_Integer:
		switch tp.id {
		case int:
			return "l";
		case uint:
			return "L";
		case uintptr: 
			return "^v";
		case:
			if info.signed {
				switch i64(8*tp.size) {
				case 8:
					return "c";
				case 16:
					return "s";
				case 32:
					return "l";
				case 64:
					return "q";
				}
			} else {
				switch i64(8*tp.size) {
				case 8:
					return "C";
				case 16:
					return "S";
				case 32:
					return "L";
				case 64:
					return "Q";
				}
			}
		}
	case reflect.Type_Info_Float:
		switch i64(8*tp.size) {
			case 32:
				return "f";
			case 64: 
				return "d";
		}
	case reflect.Type_Info_Boolean:
		return "B";
	}
	
	return "?";
}


objc_selector_from_proc_id :: proc (pr: typeid) -> string {
	selector_bstr := strings.make_builder(len=1024);
	info         := type_info_of(pr);
	proc_info    := info.variant.(reflect.Type_Info_Procedure);
	param_info   := proc_info.params.variant.(reflect.Type_Info_Tuple);
	return_info  := proc_info.results;

	if proc_info.convention == .CDecl {
		if return_info != nil {
			tuple_info := return_info.variant.(reflect.Type_Info_Tuple);
			
			if(len(tuple_info.types) > 1) {
				return "";
			}

			strings.write_string(&selector_bstr, type_to_objc_type(tuple_info.types[0]));
		} else {
			strings.write_string(&selector_bstr, "v");
		}
	
		for t, i in param_info.types {
			strings.write_string(&selector_bstr, type_to_objc_type(t));
		}

		return strings.to_string(selector_bstr);
	} else {
		return "";
	}
}

main :: proc() {

	custom_proc :: proc "c" (self: objc.id, cmd: objc.sel, other: objc.id) -> bool { return true; }
	fmt.printf("Result: %v\n", objc_selector_from_proc_id(typeid_of(type_of(custom_proc))));
	
}