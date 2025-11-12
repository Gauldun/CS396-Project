#include "entities.hpp"

// PlayerEntity Methods
PlayerEntity::PlayerEntity(int hVal, int dVal, int rVal, bool tVal)
    : health{hVal}, damage{dVal}, range{rVal}, hasTurn{tVal} {}

int PlayerEntity::equipItem(int modifiedVal, int newItemMod, int oldItemMod) {
  modifiedVal = -(oldItemMod) + newItemMod;
  return modifiedVal;
}

// Getters
int PlayerEntity::getHealth() { return health; }
int PlayerEntity::getDamage() { return damage; }
int PlayerEntity::getRange() { return range; }
bool PlayerEntity::getTurn() { return hasTurn; }

// Setters
void PlayerEntity::setHealth(int newHealth) { health = newHealth; }
void PlayerEntity::setDamage(int newDamage) { damage = newDamage; }
void PlayerEntity::setRange(int newRange) { range = newRange; }
void PlayerEntity::setTurn(bool newTurn) { hasTurn = newTurn; }

// EnemyEntity Methods
EnemyEntity::EnemyEntity(int hVal, int dVal, int rVal, bool tVal)
    : health{hVal}, damage{dVal}, range{rVal}, hasTurn{tVal} {}

// Getters
int EnemyEntity::getHealth() { return health; }
int EnemyEntity::getDamage() { return damage; }
int EnemyEntity::getRange() { return range; }
bool EnemyEntity::getTurn() { return hasTurn; }

// Setters
void EnemyEntity::setHealth(int newHealth) { health = newHealth; }
void EnemyEntity::setDamage(int newDamage) { damage = newDamage; }
void EnemyEntity::setRange(int newRange) { range = newRange; }
void EnemyEntity::setTurn(bool newTurn) { hasTurn = newTurn; }

// Item Methods
Item::Item(bool dmgBool, bool suppBool, bool effectBool, int durVal)
    : doesDamage{dmgBool}, hasSupport{suppBool}, hasEffect{effectBool},
      duration{durVal} {}

// Getters
int Item::getDuration() { return duration; }

// Setters
void Item::setDuration(int newDur) { duration = newDur; }
