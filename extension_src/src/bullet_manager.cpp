// #include <span>
#include <random>
#include <cmath>
#include <vector>

#include "bullet_manager.hpp"

using namespace godot;

void BulletManager::_bind_methods() {}

BulletManager::BulletManager() {}

BulletManager::~BulletManager() 
{
  if (rng) 
  {
    memdelete(rng);
  }
}

void BulletManager::_ready()
{
  if (Engine::get_singleton()->is_editor_hint())
    return;

  rng = memnew(RandomNumberGenerator);

  projectiles.resize(max_projectiles);
  transforms.resize(max_projectiles);

  Node *MMI2D_Node = get_child(0);

  if (!MMI2D_Node)
  {
    print_line("MMI2D_Node is null");
    return;
  }

  MultiMeshInstance2D *MMI2D = Object::cast_to<MultiMeshInstance2D>(MMI2D_Node);

  if (!MMI2D)
  {
    print_line("MMI2D_Node is null");
    return;
  }

  multi = MMI2D->get_multimesh();

  if (multi.is_null())
  {
    print_line("No multi inside MMI2D");
    return;
  }

  Globals = get_tree()->get_root()->get_node<Node>("Globals");

  if (Globals == nullptr)
  {
    print_line("Globals is null");
    return;
  }

  Variant player_node = Globals->get("player");

  player = Object::cast_to<CharacterBody2D>(player_node);

  if (player == nullptr)
  {
    print_line("Player is null");
    return;
  }

  multi->set_instance_count(max_projectiles);
  multi->set_visible_instance_count(active_count);
  print_line("Set instance count");
  Ref<Mesh> multi_mesh = multi->get_mesh();

  if (multi_mesh.is_null())
  {
    print_line("Mesh is null");
    return;
  }

  Ref<QuadMesh> quad = Object::cast_to<QuadMesh>(multi_mesh.ptr());

  if (quad.is_null())
  {
    print_line("Quad is null");
    return;
  }

  print_line(quad->get_class());

  Ref<Texture2D> tex = MMI2D->get_texture();

  if (tex.is_null())
  {
    print_line("Texture null");
    return;
  }

  Vector2 tex_size = Vector2(20, 20);
  quad->set_size(tex_size);

  rng->randomize();
}

void BulletManager::_process(double delta)
{

  if (Engine::get_singleton()->is_editor_hint())
    return;

  bool spawning = Globals->get("spawning");
  unsigned int current_projectiles = Globals->get("current_projectiles");

  if (spawning == true)
  {

    if (current_projectiles < max_projectiles)
    {
      for (int i = 0; i < projectiles_per_spawn; i++)
      {

        projectile &projectile_i = projectiles[projectile_id];
        Transform2D &transform_i = transforms[projectile_id];

        float random_x = rng->randf_range(max_left_pos, max_right_pos);

        projectile_i.position = Vector2(random_x, -2000);
        projectile_i.active = true;

        transform_i.set_origin(Vector2(random_x, -2000));

        multi->set_instance_transform_2d(projectile_id, transform_i);

        projectile_id = (projectile_id + 1) % max_projectiles;

        current_projectiles += 1;
      }
      active_count += projectiles_per_spawn;
    }
  }

  if (active_count > 0)
  {

    PackedFloat32Array bf = multi->get_buffer();

    float *bf_ptr = bf.ptrw();
    
    Vector2 player_pos = player->get_global_position();

    for (int i = 0; i < active_count; i++)
    {
      projectile &projectile_i = projectiles[i];

      if (projectile_i.active == true)
      {
        bf_ptr[(i * 8) + 7] += projectile_speed * delta;

        projectile_i.timer -= delta;

        if (projectile_i.timer <= 0)
        {
          deactive_projectile(i, projectiles, bf_ptr, current_projectiles, active_count);
        }

        Vector2 p_i_pos = Vector2(projectile_i.position.x, bf_ptr[(i * 8) + 7]);

        Vector2 cbox_upleft_corner = Vector2(player_pos.x - check_collision_box_size, player_pos.y - check_collision_box_size);
        Vector2 cbox_downright_corner = Vector2(player_pos.x + check_collision_box_size, player_pos.y + check_collision_box_size);

        bool inside_box_x = p_i_pos.x > cbox_upleft_corner.x && p_i_pos.x < cbox_downright_corner.x;
        bool inside_box_y = p_i_pos.y > cbox_upleft_corner.y && p_i_pos.y < cbox_downright_corner.y;

        if (inside_box_x && inside_box_y)
        {

          float distance = (player_pos.x - p_i_pos.x) * (player_pos.x - p_i_pos.x) + 
                           (player_pos.y - p_i_pos.y) * (player_pos.y - p_i_pos.y);

          if (distance <= 7500)
          {

            deactive_projectile(i, projectiles, bf_ptr, current_projectiles, active_count);

          }
        }
      }
    }

    multi->set_visible_instance_count(active_count);
    multi->set_buffer(bf);
  }

  Globals->set("current_projectiles", current_projectiles);
}

void BulletManager::deactive_projectile(int i, std::vector<projectile>&pjs, float* buffer, unsigned int &current_projectiles, int &active_count)
{

  projectile &projectile_i = pjs[i];

  projectile_i.active = false;
  buffer[(i * 8) + 7] = 9000;
  current_projectiles -= 1;
  active_count -= 1;
}