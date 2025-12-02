#include "c_wrapper.hpp"
#include "../cpp/entities.hpp"
#include <stdbool.h>
#include <stdint.h>

#define TO_PLAYER_ENTITY(handle) reinterpret_cast<PlayerEntity *>(handle)
#define TO_ENEMY_ENTITY(handle) reinterpret_cast<EnemyEntity *>(handle)
#define TO_ITEM(handle) reinterpret_cast<Item *>(handle)

// Constructors
PlayerEntityHandle *PlayerEntityCreate(int32_t hVal, int32_t dVal,
                                       int32_t defVal) {
  // Allocate the C++ object on the heap and cast its pointer to the opaque
  // handle
  return reinterpret_cast<PlayerEntityHandle *>(
      new PlayerEntity(hVal, dVal, defVal));
}

EnemyEntityHandle *EnemyEntityCreate(int32_t hVal, int32_t dVal,
                                     int32_t defVal) {
  return reinterpret_cast<EnemyEntityHandle *>(
      new EnemyEntity(hVal, dVal, defVal));
}

ItemHandle *ItemHandleCreate(int32_t dVal, int32_t hVal, int32_t defVal,
                             int32_t sDVal, const char *name) {
  return reinterpret_cast<ItemHandle *>(
      new Item(dVal, hVal, defVal, sDVal, name));
}

// Destructors
void PlayerEntityDestroy(PlayerEntityHandle *handle) {
  delete TO_PLAYER_ENTITY(handle);
}
void EnemyEntityDestroy(EnemyEntityHandle *handle) {
  delete TO_ENEMY_ENTITY(handle);
}
void ItemDestroy(ItemHandle *handle) { delete TO_ITEM(handle); }

// PlayerEntity for Item
void PlayerEntityEquipItem(PlayerEntityHandle *handle, ItemHandle *itemHandle) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->equipItem(TO_ITEM(itemHandle));
}

ItemHandle *PlayerEntityGetItem(PlayerEntityHandle *handle) {
  if (!handle)
    return nullptr;
  Item *itemPtr = TO_PLAYER_ENTITY(handle)->getHeldItem();
  return reinterpret_cast<ItemHandle *>(itemPtr);
}

bool PlayerEntityHasItem(PlayerEntityHandle *handle) {
  if (!handle)
    return false;
  return TO_PLAYER_ENTITY(handle)->hasItem();
}

void PlayerEntityDropItem(PlayerEntityHandle *handle) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->dropItem();
}

// PlayerEntity Getters
int32_t PlayerEntityGetHealth(PlayerEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_PLAYER_ENTITY(handle)->getHealth();
}

int32_t PlayerEntityGetMaxHealth(PlayerEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_PLAYER_ENTITY(handle)->getMaxHealth();
}

int32_t PlayerEntityGetDamage(PlayerEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_PLAYER_ENTITY(handle)->getDamage();
}

int32_t PlayerEntityGetDefense(PlayerEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_PLAYER_ENTITY(handle)->getDefense();
}

int32_t PlayerEntityGetAggro(PlayerEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_PLAYER_ENTITY(handle)->getAggro();
}

// EnemyEntity Getters
int32_t EnemyEntityGetHealth(EnemyEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_ENEMY_ENTITY(handle)->getHealth();
}

int32_t EnemyEntityGetMaxHealth(EnemyEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_ENEMY_ENTITY(handle)->getMaxHealth();
}

int32_t EnemyEntityGetDamage(EnemyEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_ENEMY_ENTITY(handle)->getDamage();
}

int32_t EnemyEntityGetDefense(EnemyEntityHandle *handle) {
  if (!handle)
    return 0;
  return TO_ENEMY_ENTITY(handle)->getDefense();
}

// Item Getters
int32_t ItemGetDamage(ItemHandle *handle) {
  if (!handle)
    return 0;
  return TO_ITEM(handle)->getDamage();
}

int32_t ItemGetHealth(ItemHandle *handle) {
  if (!handle)
    return 0;
  return TO_ITEM(handle)->getHealth();
}

int32_t ItemGetDefense(ItemHandle *handle) {
  if (!handle)
    return 0;
  return TO_ITEM(handle)->getDefense();
}

int32_t ItemGetSelfDamage(ItemHandle *handle) {
  if (!handle)
    return 0;
  return TO_ITEM(handle)->getSelfDamage();
}

const char *ItemGetItemName(ItemHandle *handle) {
  if (!handle)
    return "";
  return TO_ITEM(handle)->getItemName();
}

// PlayerEntity Setters
void PlayerEntitySetHealth(PlayerEntityHandle *handle, int32_t newHealth) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->setHealth(newHealth);
}

void PlayerEntitySetMaxHealth(PlayerEntityHandle *handle,
                              int32_t newMaxHealth) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->setMaxHealth(newMaxHealth);
}

void PlayerEntitySetDamage(PlayerEntityHandle *handle, int32_t newDamage) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->setDamage(newDamage);
}

void PlayerEntitySetDefense(PlayerEntityHandle *handle, int32_t newDefense) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->setDefense(newDefense);
}

void PlayerEntitySetAggro(PlayerEntityHandle *handle, int32_t newAggro) {
  if (!handle)
    return;
  TO_PLAYER_ENTITY(handle)->setAggro(newAggro);
}

// EnemyEntity Setters
void EnemyEntitySetHealth(EnemyEntityHandle *handle, int32_t newHealth) {
  if (!handle)
    return;
  TO_ENEMY_ENTITY(handle)->setHealth(newHealth);
}

void EnemyEntitySetMaxHealth(EnemyEntityHandle *handle, int32_t newMaxHealth) {
  if (!handle)
    return;
  TO_ENEMY_ENTITY(handle)->setMaxHealth(newMaxHealth);
}

void EnemyEntitySetDamage(EnemyEntityHandle *handle, int32_t newDamage) {
  if (!handle)
    return;
  TO_ENEMY_ENTITY(handle)->setDamage(newDamage);
}

void EnemyEntitySetDefense(EnemyEntityHandle *handle, int32_t newDefense) {
  if (!handle)
    return;
  TO_ENEMY_ENTITY(handle)->setDefense(newDefense);
}

// Item Setters
void ItemSetDamage(ItemHandle *handle, int32_t newDamage) {
  if (!handle)
    return;
  TO_ITEM(handle)->setDamage(newDamage);
}

void ItemSetHealth(ItemHandle *handle, int32_t newHealth) {
  if (!handle)
    return;
  TO_ITEM(handle)->setHealth(newHealth);
}

void ItemSetDefense(ItemHandle *handle, int32_t newDefense) {
  if (!handle)
    return;
  TO_ITEM(handle)->setDefense(newDefense);
}

void ItemSetSelfDamage(ItemHandle *handle, int32_t newSelfDamage) {
  if (!handle)
    return;
  TO_ITEM(handle)->setSelfDamage(newSelfDamage);
}
