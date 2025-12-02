#ifndef ENTITIES_H
#define ENTITIES_H

#include <string>

class Item; // Forward Declaration for PlayerEntity

class PlayerEntity {
private:
  // Basic Variables
  int health{}, maxHealth{}, damage{}, defense{}, aggro{};
  Item *heldItem{nullptr};

public:
  // Constructor
  PlayerEntity(int hVal = 100, int dVal = 20, int defVal = 15);

  // Getters
  int getHealth();
  int getMaxHealth();
  int getDamage();
  int getDefense();
  int getAggro();

  // Setters
  void setHealth(int newHealth);
  void setMaxHealth(int newMaxHealth);
  void setDamage(int newDamage);
  void setDefense(int newDefense);
  void setAggro(int newAggro);

  void equipItem(Item *item);
  Item *getHeldItem();
  bool hasItem();
  void dropItem();
};

class EnemyEntity {
private:
  int health{}, maxHealth{}, damage{}, defense{};

public:
  EnemyEntity(int hVal = 200, int dVal = 15, int defVal = 5);

  // Getters
  int getHealth();
  int getMaxHealth();
  int getDamage();
  int getDefense();

  // Setters
  void setHealth(int newHealth);
  void setMaxHealth(int newMaxHealth);
  void setDamage(int newDamage);
  void setDefense(int newDefense);
};

class Item {
private:
  int damage{}, health{}, defense{}, selfDamage{};
  std::string itemName;

public:
  Item(int dVal = 0, int hVal = 0, int defVal = 0, int sDVal = 0,
       const char *name = "");

  // Getters
  int getDamage();
  int getHealth();
  int getDefense();
  int getSelfDamage();
  const char *getItemName();

  // Setters
  // Probably useless but just in case
  void setDamage(int newDamage);
  void setHealth(int newHealth);
  void setDefense(int newDefense);
  void setSelfDamage(int newSelfDamage);
};
#endif // ENTITIES_H
