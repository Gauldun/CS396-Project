#include "entities.hpp"

// PlayerEntity Methods
PlayerEntity::PlayerEntity(int hVal, int dVal, int defVal)
    : health{hVal}, maxHealth{hVal}, damage{dVal}, defense{defVal} {}

int PlayerEntity::equipItem(int modifiedVal, int newItemMod, int oldItemMod) {
  modifiedVal = -(oldItemMod) + newItemMod;
  return modifiedVal;
}

// Getters
int PlayerEntity::getHealth() { return health; }
int PlayerEntity::getMaxHealth() { return maxHealth; }
int PlayerEntity::getDamage() { return damage; }
int PlayerEntity::getDefense() { return defense; }
int PlayerEntity::getAggro() { return aggro; }

// Setters
void PlayerEntity::setHealth(int newHealth) { health = newHealth; }
void PlayerEntity::setMaxHealth(int newMaxHealth) { maxHealth = newMaxHealth; }
void PlayerEntity::setDamage(int newDamage) { damage = newDamage; }
void PlayerEntity::setDefense(int newDefense) { defense = newDefense; }
void PlayerEntity::setAggro(int newAggro) { aggro = newAggro; }

// EnemyEntity Methods
EnemyEntity::EnemyEntity(int hVal, int dVal, int defVal)
    : health{hVal}, maxHealth{hVal}, damage{dVal}, defense{defVal} {}

// Getters
int EnemyEntity::getHealth() { return health; }
int EnemyEntity::getMaxHealth() { return maxHealth; }
int EnemyEntity::getDamage() { return damage; }
int EnemyEntity::getDefense() { return defense; }

// Setters
void EnemyEntity::setHealth(int newHealth) { health = newHealth; }
void EnemyEntity::setMaxHealth(int newMaxHealth) { maxHealth = newMaxHealth; }
void EnemyEntity::setDamage(int newDamage) { damage = newDamage; }
void EnemyEntity::setDefense(int newDefense) { defense = newDefense; }

// Item Methods
Item::Item(int dVal, int hVal, int defVal, int sDVal)
    : damage{dVal}, health{hVal}, defense{defVal}, selfDamage{sDVal} {}

// Getters
int Item::getDamage() { return damage; }
int Item::getHealth() { return health; }
int Item::getDefense() { return defense; }
int Item::getSelfDamage() { return selfDamage; }

// Setters
// Probably useless but just in case
void Item::setDamage(int newDamage) { damage = newDamage; }
void Item::setHealth(int newHealth) { health = newHealth; }
void Item::setDefense(int newDefense) { defense = newDefense; }
void Item::setSelfDamage(int newSelfDamage) { selfDamage = newSelfDamage; }
