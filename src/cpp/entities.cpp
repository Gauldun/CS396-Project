#include "entities.hpp"

// PlayerEntity Methods
PlayerEntity::PlayerEntity(int hVal, int dVal, int rVal, int sVal) : health {hVal}, damage {dVal}, range {rVal}, speed {sVal} 
{

}

int PlayerEntity::equipItem(int modifiedVal, int newItemMod, int oldItemMod)
{
    modifiedVal = -(oldItemMod) + newItemMod;
    return modifiedVal;
}

// Getters
int PlayerEntity::getHealth(){return health;}
int PlayerEntity::getDamage(){return damage;}
int PlayerEntity::getRange(){return range;}
int PlayerEntity::getSpeed(){return speed;}

// Setters
void PlayerEntity::setHealth(int newHealth){health = newHealth;}
void PlayerEntity::setDamage(int newDamage){damage = newDamage;}
void PlayerEntity::setRange(int newRange){range = newRange;}
void PlayerEntity::setSpeed(int newSpeed){speed = newSpeed;}

// EnemyEntity Methods
EnemyEntity::EnemyEntity(int hVal, int dVal, int rVal, int sVal) : health {hVal}, damage {dVal}, range {rVal}, speed {sVal} 
{

}

// Getters
int EnemyEntity::getHealth(){return health;}
int EnemyEntity::getDamage(){return damage;}
int EnemyEntity::getRange(){return range;}
int EnemyEntity::getSpeed(){return speed;}

// Setters
void EnemyEntity::setHealth(int newHealth){health = newHealth;}
void EnemyEntity::setDamage(int newDamage){damage = newDamage;}
void EnemyEntity::setRange(int newRange){range = newRange;}
void EnemyEntity::setSpeed(int newSpeed){speed = newSpeed;}

// Item Methods
Item::Item(bool dmgBool, bool suppBool, bool effectBool, int durVal) : doesDamage {dmgBool}, hasSupport {suppBool}, hasEffect {effectBool}, duration {durVal}
{

}

// Getters
int Item::getDuration(){return duration;}

// Setters
void Item::setDuration(int newDur){duration = newDur;}