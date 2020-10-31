package CoreAnimation;

_next_drawable :: proc (layer: ^CAMetalLayer) -> objc.id {
  
}

Metal_Layer_VTable :: struct {
  class_ca_metal_layer     : objc.class;
  
  // internal methods 
  objc_layer_next_drawable : #type proc "c" (layer: objc.id, sel: objc.sel) -> objc.id;
  objc_next_layer          : #type proc "c" (layer: objc.id, sel: objc.sel) -> objc.id;
  objc_set_device          : #type proc "c" (layer: objc.id, sel: objc.sel, device: objc.id); 
  objc_set_pxlFmt          : #type proc "c" (layer: objc.id, sel: objc.sel, pxlFmt: MTLPixelFormat);
  objc_set_frmBfO          : #type proc "c" (layer: objc.id, sel: objc.sel, value: u64);
  objc_set_frm             : #type proc "c" (layer: objc.id, sel: objc.sel, frame: CoreGraphics.CGRect);
};

/*

*/
@thread_local
_mtl_layer_vtable: ^Metal_Layer_VTable;

MetalLayer :: struct {
  // internal vtable
  _vtl : ^Metal_Layer_VTable;
  
  
  
  
  // id self
  self: objc.id;
};