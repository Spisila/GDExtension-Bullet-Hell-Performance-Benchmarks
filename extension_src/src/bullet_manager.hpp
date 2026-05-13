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

constexpr unsigned int max_projectiles = 250000;

constexpr int projectiles_per_spawn = 350;

constexpr float projectile_radius = 50;
constexpr float projectile_timeout_time = 50;

constexpr float check_collision_box_size = 100;

struct projectile
{
    godot::Vector2 position = godot::Vector2(9000, 9000);
    bool active = false;
};

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
        Camera2D *camera;

        RandomNumberGenerator *rng = nullptr;

        Ref<MultiMesh> multi;

        std::vector<projectile> projectiles;
        std::vector<Transform2D> transforms;

        std::vector<int> available;
        std::vector<int> active;

        float projectile_speed = 500;
        int increase_speed_counter = 0;

        int projectile_id = 0;
        int active_count = 0;

        int OFFSET_X = 3;
        int OFFSET_Y = 7;

        float max_left_pos = 0;
        float max_right_pos = 0;
        float max_up_pos = 0;
        float max_down_pos = 0;

        float pathfinder_x = 0;
        float pathfinder_y = 0;
        float pathfinder_radius = 55000;
        float pathdinder_speed = 25;
        int pathfinder_direction = 0;

        void _ready() override;
        void _process(double delta) override;

        void deactive_projectile(int i, std::vector<projectile> &pjs, float *buffer, unsigned int &current_projectiles, int &active_count);
    };

}

#endif