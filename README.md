## **Building & Running**

The project utilizes the zig build system to compile both the Zig and C++ code

### **Requires:**

Zig Compiler Version 0.15+  
C++ Compiler (Supporting C++20)

### **Commands:**

**Build Only:** ‘zig build’  
**Build & Run:** ‘zig build run’

## **Entities (C++)**

**PlayerEntity:** Can equip items, hold standard game stats (defense, health, max health, damage, aggro) and has public methods for getting/setting stats  
**EnemyEntity:** Standard antagonist entities with basic stats (defense, health, damage)  
**Item:** Objects that modify stats, only one may be carried by each player party member

### **Game Loop**

1. **Initialization:** Allocates memory for entities and active buffs  
2. **Turn Execution:** Randomly determines which entity may go first, either player or enemy as well as checking for death conditions  
3. **Phase Transitions:**  
   1. First Game Loop with grunt-filled enemy party  
   2. Items drop and may be equipped  
   3. Second Game Loop with cultist-filled enemy party  
   4. More Items drop

## **Combat System**

**Stat Update:** Uses function pointers to apply changes to entities generically  
**Buff Management:** Tracks buff/debuff that applied and quashed based on given duration  
**I/O**: Wraps stdin/stdout for colored console interaction

### **Character Classes:**

**Tank:** High Defense, Aggro Management, high resist buffers  
**Archer:** High Damage, Multi-Target Attacks, self damage buffs  
**Priest:** Generalized Healer, whole team stat buffer

### **Enemies:**

**Grunt:** Basic enemy type with basic attack, can debuff player character with fear  
**Cultist:** Advanced enemy type with lifesteal attack, buffs self

### **Items:**

Randomly generated based on 10 possible items with 4 different possible rarities (Vague, Distant, Indelible, Unforgettable)