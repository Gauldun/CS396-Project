#pragma once

#ifdef __cplusplus
extern "C" {
#endif
#include <stdbool.h>
#include <stdint.h>

// Opaque type: The PlayerEntity pointer, hidden from C/Zig
typedef void PlayerEntityHandle;
typedef void EnemyEntityHandle;
typedef void ItemHandle;

// Constructors
PlayerEntityHandle *PlayerEntityCreate(int32_t hVal, int32_t dVal,
                                       int32_t defVal);
EnemyEntityHandle *EnemyEntityCreate(int32_t hVal, int32_t dVal,
                                     int32_t defVal);
ItemHandle *ItemHandleCreate(int32_t dVal, int32_t hVal, int32_t defVal,
                             int32_t sDVal);

// Destructors
void PlayerEntityDestroy(PlayerEntityHandle *handle);
void EnemyEntityDestroy(EnemyEntityHandle *handle);
void ItemDestroy(ItemHandle *handle);

// PlayerEntity Methods
int32_t PlayerEntityEquipItem(PlayerEntityHandle *handle, int32_t modifiedVal,
                              int32_t newItemMod, int32_t oldItemMod);

// EnemyEntity Methods

// PlayerEntity Getters
int32_t PlayerEntityGetHealth(PlayerEntityHandle *handle);
int32_t PlayerEntityGetMaxHealth(PlayerEntityHandle *handle);
int32_t PlayerEntityGetDamage(PlayerEntityHandle *handle);
int32_t PlayerEntityGetDefense(PlayerEntityHandle *handle);

// EnemyEntity Getters
int32_t EnemyEntityGetHealth(EnemyEntityHandle *handle);
int32_t EnemyEntityGetMaxHealth(EnemyEntityHandle *handle);
int32_t EnemyEntityGetDamage(EnemyEntityHandle *handle);
int32_t EnemyEntityGetDefense(EnemyEntityHandle *handle);

// Item Getters
int32_t ItemGetDamage(ItemHandle *handle);
int32_t ItemGetHealth(ItemHandle *handle);
int32_t ItemGetDefense(ItemHandle *handle);
int32_t ItemGetSelfDamage(ItemHandle *handle);

// PlayerEntity Setters
void PlayerEntitySetHealth(PlayerEntityHandle *handle, int32_t newHealth);
void PlayerEntitySetMaxHealth(PlayerEntityHandle *handle, int32_t newMaxHealth);
void PlayerEntitySetDamage(PlayerEntityHandle *handle, int32_t newDamage);
void PlayerEntitySetDefense(PlayerEntityHandle *handle, int32_t newDefense);

// EnemyEntity Setters
void EnemyEntitySetHealth(EnemyEntityHandle *handle, int32_t newHealth);
void EnemyEntitySetMaxHealth(EnemyEntityHandle *handle, int32_t newMaxHealth);
void EnemyEntitySetDamage(EnemyEntityHandle *handle, int32_t newDamage);
void EnemyEntitySetDefense(EnemyEntityHandle *handle, int32_t newDefense);

// Item Setters
void ItemSetDamage(ItemHandle *handle, int32_t newDamage);
void ItemSetHealth(ItemHandle *handle, int32_t newHealth);
void ItemSetDefense(ItemHandle *handle, int32_t newDefense);
void ItemSetSelfDamage(ItemHandle *handle, int32_t newSelfDamage);

#ifdef __cplusplus
} // extern "C"
#endif
