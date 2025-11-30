//Library const imports
const std = @import("std");
const cpp = @cImport({
    @cInclude("c_wrapper.hpp");
});

// Print for debugging
pub const stderr = std.debug.print;

// Stdout variables
var stdoutBuffer: [1024]u8 = undefined;
var stdoutWriter = std.fs.File.stdout().writer(&stdoutBuffer);
pub const stdout = &stdoutWriter.interface;

//Stdin variables
var stdinBuffer: [1024]u8 = undefined;
var stdinReader = std.fs.File.stdin().reader(&stdinBuffer);
pub const stdin = &stdinReader.interface;

// Array declaration variable
pub const arrayList = std.array_list.Managed;

// Player Entity Getters
const getPlayerHealth = cpp.PlayerEntityGetHealth;
const getPlayerMaxHealth = cpp.PlayerEntityGetMaxHealth;
const getPlayerDamage = cpp.PlayerEntityGetDamage;
const getPlayerDefense = cpp.PlayerEntityGetDefense;

// Player Entity Setters
const setPlayerHealth = cpp.PlayerEntitySetHealth;
const setPlayerMaxHealth = cpp.PlayerEntitySetMaxHealth;
const setPlayerDamage = cpp.PlayerEntitySetDamage;
const setPlayerDefense = cpp.PlayerEntitySetDefense;

// Enemy Entity Getters
const getEnemyHealth = cpp.EnemyEntityGetHealth;
const getEnemyMaxHealth = cpp.EnemyEntityGetMaxHealth;
const getEnemyDamage = cpp.EnemyEntityGetDamage;
const getEnemyDefense = cpp.EnemyEntityGetDefense;

// Enemy Entity Setters
const setEnemyHealth = cpp.EnemyEntitySetHealth;
const setEnemyMaxHealth = cpp.EnemyEntitySetMaxHealth;
const setEnemyDamage = cpp.EnemyEntitySetDamage;
const setEnemyDefense = cpp.EnemyEntitySetDefense;

// Item Getters
const getItemHealth = cpp.ItemGetHealth;
const getItemDamage = cpp.ItemGetDamage;
const getItemDefense = cpp.ItemGetDamage;
const getItemSelfDamage = cpp.ItemGetSelfDamage;

// Item Setters
const setItemHealth = cpp.ItemSetHealth;
const setItemDamage = cpp.ItemSetDamage;
const setItemDefense = cpp.ItemSetDefense;
const setItemSelfDamage = cpp.ItemSetSelfDamage;

// Entity Constants
const PlayerHandle = cpp.PlayerEntityHandle;
const EnemyHandle = cpp.EnemyEntityHandle;

// EntityHandle Enum For Functions Calls
const EntityHandle = union(enum) {
    enemy: ?*const EnemyHandle,
    player: ?*const PlayerHandle,
};

// Used for holding buff type
const StatType = enum { Damage, Defense, MaxHealth };

//Used for reverting active buffs
pub const ActiveBuff = struct { handle: EntityHandle, stat: StatType, revertVal: i32, duration: i32, revertFn: *const fn (i32, i32) i32, setFn: *const fn (?*anyopaque, i32) callconv(.c) void };

// Colors codes
const ANSI_ESC = "\u{1b}";
pub const ANSI_RESET = ANSI_ESC ++ "[0m";

// Basic Colors
pub const RED = ANSI_ESC ++ "[31m"; // Enemy, Damage, Bleed
pub const BRIGHT_RED = ANSI_ESC ++ "[91m";
pub const GREEN = ANSI_ESC ++ "[32m"; // Player HP, Healing, Blight, Distant Items
pub const YELLOW = ANSI_ESC ++ "[33m"; // Heroes, Buffs, Mastered Skills, Gold
pub const BLUE = ANSI_ESC ++ "[34m"; // Indelible Items, Negative Tokens (Debuffs)
pub const MAGENTA = ANSI_ESC ++ "[35m"; // Stress, Unforgettable Items, Stealth
pub const CYAN = ANSI_ESC ++ "[36m"; // Combo Tokens, Daze/Stun
pub const WHITE = ANSI_ESC ++ "[37m"; // TBD
pub const GREY = ANSI_ESC ++ "[90m"; // Vague Items, Base Stats
pub const ORANGE = ANSI_ESC ++ "[38;5;208m"; // Critical Hits, Burn (Requires 256-color terminal)

// Color Scheme
pub const COLOR_HERO = YELLOW;
pub const COLOR_ENEMY = RED;
pub const COLOR_HEAL = GREEN;
pub const COLOR_DAMAGE = RED;
pub const COLOR_CRIT = ORANGE;
pub const COLOR_BUFF = YELLOW;
pub const COLOR_DEBUFF = BLUE;
pub const COLOR_STRESS = MAGENTA;
pub const COLOR_ABILITY = BLUE;
pub const COLOR_ERROR = BRIGHT_RED;

// Item Rarity Aliases
pub const RARITY_VAGUE = GREY;
pub const RARITY_DISTANT = GREEN;
pub const RARITY_INDELIBLE = BLUE;
pub const RARITY_UNFORGETTABLE = MAGENTA;

// Get User Character Input
pub fn getCharInput(prompt: []const u8) !u8 {
    try stdout.print("{s}", .{prompt});
    try stdout.flush();

    const choice = try stdin.takeByte();

    // Consumes any extra input
    while (true) {
        const extraByte = try stdin.takeByte();
        if (extraByte == '\n') {
            break;
        }
    }
    return choice;
}

// Displays stats in regards to Player and Enemy party health, if they are dead, and any buffs they may have
pub fn displayStats(playerTeam: *const [3]?*const PlayerHandle, enemyTeam: *const [3]?*const EnemyHandle) !void {
    const tank = playerTeam[0];
    const archer = playerTeam[1];
    const priest = playerTeam[2];

    const enemyFront = enemyTeam[0];
    const enemyMiddle = enemyTeam[1];
    const enemyRear = enemyTeam[2];

    // Display Health
    try stdout.print(COLOR_HERO ++ "\nPlayer's Team Status: " ++
        COLOR_HERO ++ "\nTank Health: " ++ COLOR_HEAL ++ "{d}" ++
        COLOR_HERO ++ "\nArcher Health: " ++ COLOR_HEAL ++ "{d}" ++
        COLOR_HERO ++ "\nPriest Health: " ++ COLOR_HEAL ++ "{d}" ++
        COLOR_ENEMY ++ "\nEnemy Front Health: " ++ COLOR_HEAL ++ "{d}" ++
        COLOR_ENEMY ++ "\nEnemy Middle Health: " ++ COLOR_HEAL ++ "{d}" ++
        COLOR_ENEMY ++ "\nEnemy Rear Health: " ++ COLOR_HEAL ++ "{d}\n" ++ ANSI_RESET, .{ getPlayerHealth(@constCast(tank)), getPlayerHealth(@constCast(archer)), getPlayerHealth(@constCast(priest)), getEnemyHealth(@constCast(enemyFront)), getEnemyHealth(@constCast(enemyMiddle)), getEnemyHealth(@constCast(enemyRear)) });
}

pub fn handleTankInput(tank: ?*const PlayerHandle, enemyTeam: *const [3]?*const EnemyHandle, buffs: *arrayList(ActiveBuff)) !void {
    const tankHandle = EntityHandle{ .player = tank };
    while (true) {
        const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Enemy Hit" ++
            COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Taunt Enemy Team & Increase Resistance" ++
            COLOR_HERO ++ "\nAbility 3: " ++ COLOR_ABILITY ++ "Taunt Enemy Team & Increase Damage" ++
            COLOR_HERO ++ "\nEnter which ability you'd like to have the tank use: " ++ ANSI_RESET);

        switch (abilityChoice) {
            '1' => {
                const enemyChoice = try getCharInput(COLOR_HERO ++ "\nEnter which enemy you'd like to attack [1. Front] [2. Middle] [3. Rear]: " ++ ANSI_RESET);
                const enemyChar = switch (enemyChoice) {
                    '1' => enemyTeam[0],
                    '2' => enemyTeam[1],
                    '3' => enemyTeam[2],
                    else => continue,
                };

                const enemyHandle = EntityHandle{ .enemy = enemyChar };

                // Applies tank entities' damage to the health of the chosen grunt
                // Consider adding a stun feature
                const currDmg = getPlayerDamage(@constCast(tank)); // Gets tanks current damage stat
                const currHealth = getEnemyHealth(@constCast(enemyChar)); // Gets Current Enemy Health

                try updateHealth(enemyHandle, currDmg, currHealth, null, calcDamage, setEnemyHealth);

                try stdout.print(COLOR_DAMAGE ++ "\nEnemy {c} has been hit!" ++ ANSI_RESET, .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // The tank has increased damage resist for 2 turns and taunts enemy team for 3 turns
                const currDef = getPlayerDefense(@constCast(tank)); // Gets Tanks current defense stat
                // Doubles current defense stat for 2 turns
                try applyBuff(buffs, tankHandle, .Defense, currDef, 2, 2, 2, mult, divide, setPlayerDefense);

                try stdout.print(COLOR_BUFF ++ "\nThe tanks defenses have been bolstered! " ++ COLOR_DEBUFF ++ "But, the enemy party has taken notice of the tanks presence!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // The tank has increased damage and taunts enemy team
                const currDmg = getPlayerDamage(@constCast(tank)); // Gets Tanks current damage stat
                // Triples current damage stat for 2 turns
                try applyBuff(buffs, tankHandle, .Damage, currDmg, 3, 3, 2, mult, divide, setPlayerDamage);
                try stdout.print(COLOR_BUFF ++ "\nThe tanks weapons have been emboldened! " ++ COLOR_DEBUFF ++ "But, the enemy party has taken notice of the tanks presence!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print(COLOR_ERROR ++ "Invalid Input. Please try again!" ++ ANSI_RESET, .{});
                try stdout.flush();
            },
        }
    }
}

pub fn handleArcherInput(archer: ?*const PlayerHandle, enemyTeam: *const [3]?*const EnemyHandle, buffs: *arrayList(ActiveBuff)) !void {
    const archerHandle = EntityHandle{ .player = archer };
    while (true) {
        const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Enemy Hit" ++
            COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Team Enemy Hits" ++
            COLOR_HERO ++ "\nAbility 3: " ++ COLOR_ABILITY ++ "Aim Sights" ++
            COLOR_HERO ++ "\nEnter which ability you'd like to have the archer use: " ++ ANSI_RESET);

        switch (abilityChoice) {
            '1' => {
                const enemyChoice = try getCharInput(COLOR_HERO ++ "\nEnter which enemy you'd like to attack [1. Front] [2. Middle] [3. Rear]: " ++ ANSI_RESET);

                const enemyChar = switch (enemyChoice) {
                    '1' => enemyTeam[0],
                    '2' => enemyTeam[1],
                    '3' => enemyTeam[2],
                    else => continue,
                };

                const enemyHandle = EntityHandle{ .enemy = enemyChar }; // Stores enemy entities handle
                const currDmg = getPlayerDamage(@constCast(archer)); // Gets archers current damage stat
                const currHealth = getEnemyHealth(@constCast(enemyChar)); // Gets enemy's current health stat

                // Applies archer entities' damage to the health of the chosen grunt
                try updateHealth(enemyHandle, currDmg, currHealth, null, calcDamage, setEnemyHealth);

                // Enemy takes average damage on hit
                try stdout.print(COLOR_DAMAGE ++ "\nEnemy {c} has been hit!" ++ ANSI_RESET, .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Less than average damage is applied to the every enemy
                for (enemyTeam) |enemy| {
                    const enemyHandle = EntityHandle{ .enemy = enemy }; // Stores enemy entities handle
                    const currDmg = @divFloor(getPlayerDamage(@constCast(archer)), 2); // Gets archers current damage stat int divided by 2 rounded down
                    const currHealth = getEnemyHealth(@constCast(enemy)); // Gets enemy's current health stat

                    try updateHealth(enemyHandle, currDmg, currHealth, null, calcDamage, setEnemyHealth);
                }

                try stdout.print(COLOR_DAMAGE ++ "\nThe enemy party has been hit!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // For 1 Turn, the archer's damage is tripled
                const currDmg = getPlayerDamage(@constCast(archer)); // Gets archers current damage stat
                try applyBuff(buffs, archerHandle, .Damage, currDmg, 3, 3, 1, mult, divide, setPlayerDamage);
                try stdout.print(COLOR_BUFF ++ "\nThe archer takes aim!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print(COLOR_ERROR ++ "Invalid Input. Please try again!" ++ ANSI_RESET, .{});
                try stdout.flush();
            },
        }
    }
}

pub fn handlePriestInput(priest: ?*const PlayerHandle, playerTeam: *const [3]?*const PlayerHandle, buffs: *arrayList(ActiveBuff)) !void {
    while (true) {
        const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Team Member Heal" ++
            COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Buff Team" ++
            COLOR_HERO ++ "\nEnter which ability you'd like to have the priest use: " ++ ANSI_RESET);

        switch (abilityChoice) {
            '1' => {
                const teamChoice = try getCharInput(COLOR_HERO ++ "\nEnter which team member you'd like to healed [1. Tank] [2. Archer] [3. Priest]: " ++ ANSI_RESET);

                const teamChar = switch (teamChoice) {
                    '1' => playerTeam[0],
                    '2' => playerTeam[1],
                    '3' => playerTeam[2],
                    else => continue,
                };

                const playerHandle = EntityHandle{ .player = teamChar };

                // Uses Priest damage as healing integer
                const currHealing = getPlayerDamage(@constCast(priest));
                const currHealth = getPlayerHealth(@constCast(teamChar));
                const currMaxHealth = getPlayerMaxHealth(@constCast(teamChar));

                try updateHealth(playerHandle, currHealing, currHealth, currMaxHealth, calcHeal, setPlayerHealth);

                // Heal team member by average amount
                try stdout.print(COLOR_HEAL ++ "\nTeam member {c} has been healed!" ++ ANSI_RESET, .{teamChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Every team member has all stats increased
                for (playerTeam) |player| {
                    const playerHandle = EntityHandle{ .player = player };

                    const currDef = getPlayerDefense(@constCast(player));
                    const currMaxHealth = getPlayerMaxHealth(@constCast(player));
                    const currDmg = getPlayerDamage(@constCast(player));

                    // Adds 25 Defense to every team member
                    try applyBuff(buffs, playerHandle, .Defense, currDef, 25, 25, 2, add, subtract, setPlayerDefense);
                    // Adds 25 Max Health to every team member
                    try applyBuff(buffs, playerHandle, .MaxHealth, currMaxHealth, 25, 25, 4, add, subtract, setPlayerMaxHealth);
                    // Adds 15 Damage to every team member
                    try applyBuff(buffs, playerHandle, .Damage, currDmg, 15, 15, 3, add, subtract, setPlayerDamage);
                }

                try stdout.print(COLOR_BUFF ++ "The team thrives!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print(COLOR_ERROR ++ "Invalid Input. Please try again!" ++ ANSI_RESET, .{});
                try stdout.flush();
            },
        }
    }
}

pub fn handleGruntTurn(grunt: ?*const EnemyHandle, playerTeam: *const [3]?*const PlayerHandle, buffs: *arrayList(ActiveBuff), randAbility: usize, randChar: usize) !void {
    const playerMember = playerTeam[randChar];
    const playerHandle = EntityHandle{ .player = playerMember };
    switch (randAbility) {
        // Attack Random Player Character
        1 => {
            const currDmg = getEnemyDamage(@constCast(grunt));
            const currHealth = getPlayerHealth(@constCast(playerMember));
            try updateHealth(playerHandle, currDmg, currHealth, null, calcDamage, setPlayerHealth);
        },
        // Fear Random Player Character
        // Debuffs Player with less defense and less damage output
        2 => {
            const currDef = getPlayerDefense(@constCast(playerMember));
            const currDmg = getPlayerDamage(@constCast(playerMember));

            // Subtracts Player defense by 10 and Player damage by 5 for 1 turn
            try applyBuff(buffs, playerHandle, .Defense, currDef, 10, 10, 1, subtract, add, setPlayerDefense);
            try applyBuff(buffs, playerHandle, .Damage, currDmg, 5, 5, 1, subtract, add, setPlayerDamage);
        },
        else => unreachable,
    }
}

// Functional: Returns new health value after character takes damage
fn calcDamage(damage: i32, health: i32, _: ?i32) i32 {
    const result = if ((health - damage) <= 0) 0 else health - damage;
    return result;
}

fn calcHeal(heal: i32, health: i32, maxHealth: ?i32) i32 {
    const mHealth = maxHealth.?;
    const result = if ((health + heal) >= mHealth) mHealth else health + heal;
    return result;
}

// Applies damage or healing effect based on given functions
fn updateHealth(handle: EntityHandle, damage: i32, health: i32, maxHealth: ?i32, calcFn: *const fn (i32, i32, ?i32) i32, setHealth: *const fn (?*anyopaque, i32) callconv(.c) void) !void {
    const result = calcFn(damage, health, maxHealth);

    switch (handle) {
        .enemy => |e_ptr| {
            setHealth(@constCast(e_ptr), result);
        },
        .player => |p_ptr| {
            setHealth(@constCast(p_ptr), result);
        },
    }
}

// To be used depending on modifier
fn add(currVal: i32, modVal: i32) i32 {
    return currVal + modVal;
}

fn subtract(currVal: i32, modVal: i32) i32 {
    const result = if ((currVal - modVal) <= 0) 0 else currVal - modVal;
    return result;
}

fn mult(currVal: i32, modVal: i32) i32 {
    return currVal * modVal;
}

fn divide(currVal: i32, modVal: i32) i32 {
    return @divFloor(currVal, modVal);
}

// Updates character stats based on given buffs or items
fn updateStat(handle: EntityHandle, currVal: i32, modVal: i32, calcFn: *const fn (i32, i32) i32, setFn: *const fn (?*anyopaque, i32) callconv(.c) void) !void {
    const result = calcFn(currVal, modVal);

    switch (handle) {
        .enemy => |e_ptr| {
            setFn(@constCast(e_ptr), result);
        },
        .player => |p_ptr| {
            setFn(@constCast(p_ptr), result);
        },
    }
}

fn applyBuff(buffs: *arrayList(ActiveBuff), handle: EntityHandle, stat: StatType, currVal: i32, modVal: i32, revertVal: i32, duration: i32, calcFn: *const fn (i32, i32) i32, revertFn: *const fn (i32, i32) i32, setFn: *const fn (?*anyopaque, i32) callconv(.c) void) !void {
    try updateStat(handle, currVal, modVal, calcFn, setFn);

    try buffs.append(ActiveBuff{ .handle = handle, .stat = stat, .revertVal = revertVal, .duration = duration, .revertFn = revertFn, .setFn = setFn });
}

pub fn tickBuffs(buffs: *arrayList(ActiveBuff)) !void {
    var i: usize = 0;
    // Iterate using an index so we can handle removal safely
    while (i < buffs.items.len) {
        // Get a pointer to the current buff so we can modify duration
        const buff = &buffs.items[i];

        if (buff.duration <= 0) {
            switch (buff.stat) {
                .Defense => {
                    switch (buff.handle) {
                        .enemy => {
                            const currVal = getEnemyDefense(@constCast(buff.handle.enemy));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                        .player => {
                            const currVal = getPlayerDefense(@constCast(buff.handle.player));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                    }
                },
                .Damage => {
                    switch (buff.handle) {
                        .enemy => {
                            const currVal = getEnemyDamage(@constCast(buff.handle.enemy));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                        .player => {
                            const currVal = getPlayerDamage(@constCast(buff.handle.player));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                    }
                },
                .MaxHealth => {
                    switch (buff.handle) {
                        .enemy => {
                            const currVal = getEnemyMaxHealth(@constCast(buff.handle.enemy));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                        .player => {
                            const currVal = getPlayerMaxHealth(@constCast(buff.handle.player));
                            try updateStat(buff.handle, currVal, buff.revertVal, buff.revertFn, buff.setFn);
                        },
                    }
                },
            }
            try stdout.print(COLOR_DEBUFF ++ "\nA buff has expired!" ++ ANSI_RESET, .{});
            _ = buffs.swapRemove(i);
        } else {
            buff.duration -= 1;
            i += 1;
        }
    }
}
