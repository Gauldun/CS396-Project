#include "entities.hpp"

// PlayerEntity Methods
PlayerEntity::PlayerEntity(int hVal, int dVal, bool tVal)
    : health{hVal}, maxHealth{hVal}, damage{dVal}, hasTurn{tVal} {}

int PlayerEntity::equipItem(int modifiedVal, int newItemMod, int oldItemMod) {
  modifiedVal = -(oldItemMod) + newItemMod;
  return modifiedVal;
}

// Getters
int PlayerEntity::getHealth() { return health; }
int PlayerEntity::getMaxHealth() { return maxHealth; }
int PlayerEntity::getDamage() { return damage; }
bool PlayerEntity::getTurn() { return hasTurn; }

// Setters
void PlayerEntity::setHealth(int newHealth) { health = newHealth; }
void PlayerEntity::setMaxHealth(int newMaxHealth) { maxHealth = newMaxHealth; }
void PlayerEntity::setDamage(int newDamage) { damage = newDamage; }
void PlayerEntity::setTurn(bool newTurn) { hasTurn = newTurn; }

// EnemyEntity Methods
EnemyEntity::EnemyEntity(int hVal, int dVal, bool tVal)
    : health{hVal}, maxHealth{hVal}, damage{dVal}, hasTurn{tVal} {}

// Getters
int EnemyEntity::getHealth() { return health; }
int EnemyEntity::getMaxHealth() { return maxHealth; }
int EnemyEntity::getDamage() { return damage; }
bool EnemyEntity::getTurn() { return hasTurn; }

// Setters
void EnemyEntity::setHealth(int newHealth) { health = newHealth; }
void EnemyEntity::setMaxHealth(int newMaxHealth) { maxHealth = newMaxHealth; }
void EnemyEntity::setDamage(int newDamage) { damage = newDamage; }
void EnemyEntity::setTurn(bool newTurn) { hasTurn = newTurn; }

// Item Methods
Item::Item(bool dmgBool, bool suppBool, bool effectBool, int durVal)
    : doesDamage{dmgBool}, hasSupport{suppBool}, hasEffect{effectBool},
      duration{durVal} {}

// Getters
int Item::getDuration() { return duration; }

// Setters
void Item::setDuration(int newDur) { duration = newDur; }
