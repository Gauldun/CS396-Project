#ifndef ENTITIES_H
#define ENTITIES_H

class PlayerEntity {
private:
  // Basic Variables
  int health{}, damage{};
  bool hasTurn{};

public:
  // Constructor
  PlayerEntity(int hVal = 5, int dVal = 5, bool hasTurn = true);
  int equipItem(int modifiedVal, int newItemMod, int oldItemMod);

  // Getters
  int getHealth();
  int getDamage();
  bool getTurn();

  // Setters
  void setHealth(int newHealth);
  void setDamage(int newDamage);
  void setTurn(bool newTurn);
};

class EnemyEntity {
private:
  int health{}, damage{};
  bool hasTurn{};

public:
  EnemyEntity(int hVal = 3, int dVal = 3, bool hasTurn = true);

  // Getters
  int getHealth();
  int getDamage();
  bool getTurn();

  // Setters
  void setHealth(int newHealth);
  void setDamage(int newDamage);
  void setTurn(bool newTurn);
};

class Item {
private:
  bool doesDamage{}, hasSupport{}, hasEffect{};
  int duration{};

public:
  Item(bool dmgBool = false, bool suppBool = false, bool effectBool = false,
       int durVal = 1);

  // Getters
  int getDuration();

  // Setters
  void setDuration(int newDur);
};
#endif // ENTITIES_H
