#ifndef MY_EXTENSION_REGISTER_TYPES_H
#define MY_EXTENSION_REGISTER_TYPES_H

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

// Called when the extension is initialized
void initialize_my_extension(ModuleInitializationLevel p_level);

// Called when the extension is terminated
void uninitialize_my_extension(ModuleInitializationLevel p_level);

#endif 