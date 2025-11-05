#pragma once 

#ifdef __cpp
extern "C" 
{
    #endif
    #include <stdint.h>
    #include <stdbool.h>

    // Opaque type: The PlayerEntity pointer, hidden from C/Zig
    typedef void PlayerEntityHandle;
    typedef void EnemyEntityHandle;
    typedef void ItemHandle;

    // Constructors
    PlayerEntityHandle* PlayerEntityCreate(int32_t hVal, int32_t dVal, int32_t rVal, int32_t sVal);
    EnemyEntityHandle* EnemyEntityCreate(int32_t hVal, int32_t dVal, int32_t rVal, int32_t sVal);
    ItemHandle* ItemHandleCreate(bool dmgBool, bool suppBool, bool effectBool, int32_t durVal);

    // Destructors
    void PlayerEntityDestroy(PlayerEntityHandle* handle);
    void EnemyEntityDestroy(EnemyEntityHandle* handle);
    void ItemDestroy(ItemHandle* handle);

    // PlayerEntity Methods
    int32_t PlayerEntityEquipItem(PlayerEntityHandle* handle, int32_t modifiedVal, int32_t newItemMod, int32_t oldItemMod);
    
    // EnemyEntity Methods

    // PlayerEntity Getters
    int32_t PlayerEntityGetHealth(PlayerEntityHandle* handle);
    int32_t PlayerEntityGetDamage(PlayerEntityHandle* handle);
    int32_t PlayerEntityGetRange(PlayerEntityHandle* handle);
    int32_t PlayerEntityGetSpeed(PlayerEntityHandle* handle);

    // EnemyEntity Getters
    int32_t EnemyEntityGetHealth(EnemyEntityHandle* handle);
    int32_t EnemyEntityGetDamage(EnemyEntityHandle* handle);
    int32_t EnemyEntityGetRange(EnemyEntityHandle* handle);
    int32_t EnemyEntityGetSpeed(EnemyEntityHandle* handle);

    // Item Getters
    int32_t ItemGetDuration(ItemHandle* handle);

    // PlayerEntity Setters
    void PlayerEntitySetHealth(PlayerEntityHandle* handle, int32_t newHealth);
    void PlayerEntitySetDamage(PlayerEntityHandle* handle, int32_t newDamage);
    void PlayerEntitySetRange(PlayerEntityHandle* handle, int32_t newRange);
    void PlayerEntitySetSpeed(PlayerEntityHandle* handle, int32_t newSpeed);

    // EnemyEntity Setters
    void EnemyEntitySetHealth(EnemyEntityHandle* handle, int32_t newHealth);
    void EnemyEntitySetDamage(EnemyEntityHandle* handle, int32_t newDamage);
    void EnemyEntitySetRange(EnemyEntityHandle* handle, int32_t newRange);
    void EnemyEntitySetSpeed(EnemyEntityHandle* handle, int32_t newSpeed);

    // Item Setters
    void ItemSetDuration(ItemHandle* handle, int32_t newDur);
    #ifdef __cpp
} // extern "C"
#endif
