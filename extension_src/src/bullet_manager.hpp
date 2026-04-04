#ifndef BULLET_MANAGER_H
#define BULLET_MANAGER_H

#include <godot_cpp/classes/node2d.hpp>

namespace godot {

class BulletManager : public Node2D {
    GDCLASS(BulletManager, Node2D)

protected:
    static void _bind_methods();

public:
    BulletManager();
    ~BulletManager();
};

}

#endif