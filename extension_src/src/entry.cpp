#include <godot_cpp/godot.hpp>
#include "register_types.h"

using namespace godot;

extern "C" {

GDExtensionBool GDE_EXPORT my_extension_init(
    GDExtensionInterfaceGetProcAddress p_get_proc_address,
    const GDExtensionClassLibraryPtr p_library,
    GDExtensionInitialization *r_initialization) {

    GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

    init_obj.register_initializer(initialize_my_extension);
    init_obj.register_terminator(uninitialize_my_extension);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}

}