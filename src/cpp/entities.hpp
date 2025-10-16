#ifndef ENTITIES_H
#define ENTITIES_H

#include <string>

class PlayerEntity {
    private:
        // Basic Variables
        int health{}, damage{}, range{}, speed{};

    public:
        // Constructor
        PlayerEntity(int hVal = 5, int dVal = 5, int rVal = 5, int sVal = 5);
        int equipItem(int modifiedVal, int newItemMod, int oldItemMod);

        // Getters
        int getHealth();
        int getDamage();
        int getRange();
        int getSpeed();

        // Setters
        void setHealth(int newHealth);
        void setDamage(int newDamage);
        void setRange(int newRange);
        void setSpeed(int newSpeed);
};

class EnemyEntity {
    private:
        int health{}, damage{}, range{}, speed{};
    public:
        EnemyEntity(int hVal = 3, int dVal = 3, int rVal = 3, int sVal = 3);

        // Getters
        int getHealth();
        int getDamage();
        int getRange();
        int getSpeed();

        // Setters
        void setHealth(int newHealth);
        void setDamage(int newDamage);
        void setRange(int newRange);
        void setSpeed(int newSpeed);
};

class Item {
    private:
        bool doesDamage {}, hasSupport{}, hasEffect{};
        int duration{};
    public:
        Item(bool dmgBool = false, bool suppBool = false, bool effectBool = false, int durVal = 1); 

        // Getters
        int getDuration();

        // Setters
        void setDuration(int newDur);
};
#endif // ENTITIES_H