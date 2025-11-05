#include "c_wrapper.h"
#include "entities.hpp"
#include <stdint.h>
#include <stdbool.h>

extern "C"{
#define TO_PLAYER_ENTITY(handle) reinterpret_cast<PlayerEntity*>(handle)
#define TO_ENEMY_ENTITY(handle) reinterpret_cast<EnemyEntity*>(handle)
#define TO_ITEM(handle) reinterpret_cast<Item*>(handle)

  // Constructors
  PlayerEntityHandle* PlayerEntityCreate(int32_t hVal, int32_t dVal, int32_t rVal, int32_t sVal) 
  {
      // Allocate the C++ object on the heap and cast its pointer to the opaque handle
      return reinterpret_cast<PlayerEntityHandle*>(new PlayerEntity(hVal, dVal, rVal, sVal));
  }

  EnemyEntityHandle* EnemyEntityCreate(int32_t hVal, int32_t dVal, int32_t rVal, int32_t sVal)
  {
      return reinterpret_cast<EnemyEntityHandle*>(new EnemyEntity(hVal, dVal, rVal, sVal));
  }

  ItemHandle* ItemHandleCreate(bool dmgBool, bool suppBool, bool effectBool, int32_t durVal)
  {
      return reinterpret_cast<ItemHandle*>(new Item(dmgBool, suppBool, effectBool, durVal));
  }

  // Destructors
  void PlayerEntityDestroy(PlayerEntityHandle* handle){delete TO_PLAYER_ENTITY(handle);}
  void EnemyEntityDestroy(EnemyEntityHandle* handle){delete TO_ENEMY_ENTITY(handle);}
  void ItemDestroy(ItemHandle* handle){delete TO_ITEM(handle);}

  // Methods 
  int32_t PlayerEntityEquipItem(PlayerEntityHandle* handle, int32_t modifiedVal, int32_t newItemMod, int32_t oldItemMod) 
  {
      // Check For NULL Handle
      if (!handle) return 0; 
      return TO_PLAYER_ENTITY(handle)->equipItem(modifiedVal, newItemMod, oldItemMod);
  }

  // PlayerEntity Getters
  int32_t PlayerEntityGetHealth(PlayerEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_PLAYER_ENTITY(handle)->getHealth();
  }

  int32_t PlayerEntityGetDamage(PlayerEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_PLAYER_ENTITY(handle)->getDamage();
  }

  int32_t PlayerEntityGetRange(PlayerEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_PLAYER_ENTITY(handle)->getRange();
  }

  int32_t PlayerEntityGetSpeed(PlayerEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_PLAYER_ENTITY(handle)->getSpeed();
  }

  // EnemyEntity Getters
  int32_t EnemyEntityGetHealth(EnemyEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_ENEMY_ENTITY(handle)->getHealth();
  }

  int32_t EnemyEntityGetDamage(EnemyEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_ENEMY_ENTITY(handle)->getDamage();
  }

  int32_t EnemyEntityGetRange(EnemyEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_ENEMY_ENTITY(handle)->getRange();
  }

  int32_t EnemyEntityGetSpeed(EnemyEntityHandle* handle) 
  {
      if (!handle) return 0;
      return TO_ENEMY_ENTITY(handle)->getSpeed();
  }

  // Item Getters
  int32_t ItemGetDuration(ItemHandle* handle)
  {
      if(!handle) return 0;
      return TO_ITEM(handle)->getDuration();
  }

  // PlayerEntity Setters
  void PlayerEntitySetHealth(PlayerEntityHandle* handle, int32_t newHealth)
  {
      if (!handle) return;
      TO_PLAYER_ENTITY(handle)->setHealth(newHealth);
  }

  void PlayerEntitySetDamage(PlayerEntityHandle* handle, int32_t newDamage)
  {
      if (!handle) return;
      TO_PLAYER_ENTITY(handle)->setDamage(newDamage);
  }

  void PlayerEntitySetRange(PlayerEntityHandle* handle, int32_t newRange)
  {
      if (!handle) return;
      TO_PLAYER_ENTITY(handle)->setRange(newRange);
  }

  void PlayerEntitySetSpeed(PlayerEntityHandle* handle, int32_t newSpeed)
  {
      if (!handle) return;
      TO_PLAYER_ENTITY(handle)->setSpeed(newSpeed);
  }

  // EnemyEntity Setters
  void EnemyEntitySetHealth(EnemyEntityHandle* handle, int32_t newHealth)
  {
      if (!handle) return;
      TO_ENEMY_ENTITY(handle)->setHealth(newHealth);
  }

  void EnemyEntitySetDamage(EnemyEntityHandle* handle, int32_t newDamage)
  {
      if (!handle) return;
      TO_ENEMY_ENTITY(handle)->setDamage(newDamage);
  }

  void EnemyEntitySetRange(EnemyEntityHandle* handle, int32_t newRange)
  {
      if (!handle) return;
      TO_ENEMY_ENTITY(handle)->setRange(newRange);
  }

  void EnemyEntitySetSpeed(EnemyEntityHandle* handle, int32_t newSpeed)
  {
      if (!handle) return;
      TO_ENEMY_ENTITY(handle)->setSpeed(newSpeed);
  }

  // Item Setters
  void ItemSetDuration(ItemHandle* handle, int32_t newDur)
  {
      if(!handle) return;
      TO_ITEM(handle)->setDuration(newDur);
  }
}
