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
  {
    return;
  }

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

  Ref<Texture2D> tex = MMI2D->get_texture();

  if (tex.is_null())
  {
    print_line("Texture null");
    return;
  }

  max_left_pos = Globals->get("max_left");
  max_right_pos = Globals->get("max_right");
  max_up_pos = Globals->get("max_up");
  max_down_pos = Globals->get("max_down");

  projectiles.resize(max_projectiles);
  transforms.resize(max_projectiles);

  multi->set_instance_count(max_projectiles);

  Vector2 tex_size = Vector2(20, 20);
  quad->set_size(tex_size);

  rng = memnew(RandomNumberGenerator);
  rng->randomize();

  pathfinder_direction = rng->randi_range(-1, 1);
  pathfinder_y = max_up_pos;
}

void BulletManager::_process(double delta)
{

  if (Engine::get_singleton()->is_editor_hint())
  {
    return;
  }

  if (pathfinder_change_dir_timer >= pathfinder_change_dir_time)
  {

    int dir = rng->randi_range(0, 2);

    if (dir == 0)
    {
      pathfinder_direction = 0;
    }
    else if (dir == 1 || dir == 2)
    {
      float chance_to_turn = ((pathfinder_x - max_left_pos) / (max_right_pos - max_left_pos)) * 100;

      if (rng->randi_range(0, 100) <= chance_to_turn)
      {
        // Turn left
        pathfinder_direction = -1;
      }
      else
      {
        // Turn Right
        pathfinder_direction = 1;
      }

    }

    pathfinder_change_dir_timer = 0;

    pathfinder_change_dir_time = rng->randf_range(12, 35);
  }

  pathfinder_change_dir_timer++;

  // Increase projectiles speed
  // increase_speed_counter++;
  // if (increase_speed_counter >= 100)
  // {
  //   projectile_speed += 50;
  //   projectiles_per_spawn += 20;
  //   increase_speed_counter = 0;
  // }

  pathfinder_x = std::clamp(pathfinder_x + (pathfinder_direction * pathdinder_speed), max_left_pos, max_right_pos);

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

        projectile_i.position = Vector2(random_x, max_up_pos);
        projectile_i.active = true;

        transform_i.set_origin(Vector2(random_x, max_up_pos));

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

    float cbox_up = player_pos.y - check_collision_box_size;
    float cbox_left = player_pos.x - check_collision_box_size;
    float cbox_down = player_pos.y + check_collision_box_size;
    float cbox_right = player_pos.x + check_collision_box_size;

    for (int i = 0; i < max_projectiles; i++)
    {
      projectile &projectile_i = projectiles[i];

      if (projectile_i.active == true)
      {
        // Update Position
        bf_ptr[(i * 8) + OFFSET_Y] += projectile_speed * delta;

        Vector2 p_i_pos = Vector2(projectile_i.position.x, bf_ptr[(i * 8) + 7]);
        // Check pathfinder collision

        float pathfidner_distace = (pathfinder_x - p_i_pos.x) * (pathfinder_x - p_i_pos.x) +
                                   (pathfinder_y - p_i_pos.y) * (pathfinder_y - p_i_pos.y);

        if (pathfidner_distace <= pathfinder_radius)
        {
          deactive_projectile(i, projectiles, bf_ptr, current_projectiles, active_count);
        }

        // Check collision player

        bool inside_box_x = p_i_pos.x > cbox_left && p_i_pos.x < cbox_right;
        bool inside_box_y = p_i_pos.y > cbox_up && p_i_pos.y < cbox_down;

        if (inside_box_x && inside_box_y)
        {

          float distance = (player_pos.x - p_i_pos.x) * (player_pos.x - p_i_pos.x) +
                           (player_pos.y - p_i_pos.y) * (player_pos.y - p_i_pos.y);

          if (distance <= 17500)
          {

            deactive_projectile(i, projectiles, bf_ptr, current_projectiles, active_count);
          }
        }

        // Check if outside screen
        if (p_i_pos.y > max_down_pos)
        {
          deactive_projectile(i, projectiles, bf_ptr, current_projectiles, active_count);
        }
      }
    }

    multi->set_buffer(bf);
  }

  Globals->set("current_projectiles", current_projectiles);
}

void BulletManager::deactive_projectile(int i, std::vector<projectile> &pjs, float *buffer, unsigned int &current_projectiles, int &active_count)
{

  projectile &projectile_i = pjs[i];

  projectile_i.active = false;
  buffer[(i * 8) + OFFSET_Y] = 9000;
  current_projectiles -= 1;
  active_count -= 1;
}