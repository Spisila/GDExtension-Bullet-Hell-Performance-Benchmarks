#ifndef BULLET_MANAGER_H
#define BULLET_MANAGER_H

#include <vector>

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/multi_mesh_instance2d.hpp>
#include <godot_cpp/classes/multi_mesh.hpp>
#include <godot_cpp/classes/quad_mesh.hpp>
#include <godot_cpp/classes/random_number_generator.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/window.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/packed_float32_array.hpp>
#include <godot_cpp/classes/character_body2d.hpp>
#include <godot_cpp/classes/engine.hpp>

constexpr unsigned int max_projectiles = 500000;

constexpr int projectiles_per_spawn = 150;

constexpr float max_left_pos = -3000;
constexpr float max_right_pos = 3000;

constexpr float projectile_speed = 500;
constexpr float projectile_radius = 50;
constexpr float projectile_timeout_time = 50;

constexpr float check_collision_box_size = 100;

struct projectile
{
    bool active = false;
    float timer = projectile_timeout_time;
    godot::Vector2 position = godot::Vector2(9000, 9000);
};

// std::span<projectile> projectiles_span(projectiles);

namespace godot
{

    class BulletManager : public Node2D
    {
        GDCLASS(BulletManager, Node2D)

    protected:
        static void _bind_methods();

    public:
        BulletManager();
        ~BulletManager();

        Node *Globals;

        CharacterBody2D *player;

        RandomNumberGenerator *rng = nullptr;

        Ref<MultiMesh> multi;

        std::vector<projectile> projectiles;
        std::vector<Transform2D> transforms;

        int projectile_id = 0;
        int active_count = 0;

        void _ready() override;
        void _process(double delta) override;

        void deactive_projectile(int i, std::vector<projectile>&pjs, float* buffer, unsigned int &current_projectiles, int &active_count);
    };

}

#endif