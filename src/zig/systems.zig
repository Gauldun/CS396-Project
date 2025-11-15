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

// Info variable

// Player Entity Getters
const getPlayerHealth = cpp.PlayerEntityGetHealth;
const getPlayerMaxHealth = cpp.PlayerEntityGetMaxHealth;
const getPlayerDamage = cpp.PlayerEntityGetDamage;
const getPlayerTurn = cpp.PlayerEntityGetTurn;

// Player Entity Setters
const setPlayerHealth = cpp.PlayerEntitySetHealth;
const setPlayerMaxHealth = cpp.PlayerEntitySetMaxHealth;
const setPlayerDamage = cpp.PlayerEntitySetDamage;
const setPlayerTurn = cpp.PlayerEntitySetTurn;

// Enemy Entity Getters
const getEnemyHealth = cpp.EnemyEntityGetHealth;
const getEnemyMaxHealth = cpp.EnemyEntityGetMaxHealth;
const getEnemyDamage = cpp.EnemyEntityGetDamage;
const getEnemyTurn = cpp.EnemyEntityGetTurn;

// Enemy Entity Setters
const setEnemyHealth = cpp.EnemyEntitySetHealth;
const setEnemyMaxHealth = cpp.EnemyEntitySetMaxHealth;
const setEnemyDamage = cpp.EnemyEntitySetDamage;
const setEnemyTurn = cpp.EnemyEntitySetTurn;

// Entity Constants
const PlayerHandle = cpp.PlayerEntityHandle;
const EnemyHandle = cpp.EnemyEntityHandle;

// EntityHandle Enum For Functions Calls
const EntityHandle = union(enum) {
    enemy: ?*const EnemyHandle,
    player: ?*const PlayerHandle,
};

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

pub fn handleTankInput(tank: ?*const PlayerHandle, enemyTeam: *const [3]?*const EnemyHandle) !void {
    const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Enemy Hit" ++
        COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Taunt Enemy Team" ++
        COLOR_HERO ++ "\nAbility 3: " ++ COLOR_ABILITY ++ "Increase Resistance" ++
        COLOR_HERO ++ "\nEnter which ability you'd like to have the tank use: " ++ ANSI_RESET);
    while (true) {
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
                try updateHealth(enemyHandle, getPlayerDamage(@constCast(tank)), getEnemyHealth(@constCast(enemyChar)), null, calcDamage, setEnemyHealth);

                try stdout.print(COLOR_DAMAGE ++ "\nEnemy {c} has been hit!" ++ ANSI_RESET, .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // The enemies are forced to attack the tank for a set number of turns
                // The tank should be unable to act for a set number of turns
                // Consider combining this and the third ability
                try stdout.print(COLOR_DEBUFF ++ "\nThe enemy party has taken notice of the tanks presence!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // The tank has increased resistance to physical attacks
                // The resistance can be either the inability to take damage OR
                // The ability to take less damage
                // Considering comibing this with the second ability
                // Possibly replacing this ability with a taunt and a doubling of damage
                try stdout.print(COLOR_BUFF ++ "\nThe tanks defenses have been bolstered!" ++ ANSI_RESET, .{});
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

pub fn handleArcherInput(archer: ?*const PlayerHandle, enemyTeam: *const [3]?*const EnemyHandle) !void {
    const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Enemy Hit" ++
        COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Team Enemy Hits" ++
        COLOR_HERO ++ "\nAbility 3: " ++ COLOR_ABILITY ++ "Aim Sights" ++
        COLOR_HERO ++ "\nEnter which ability you'd like to have the archer use: " ++ ANSI_RESET);

    while (true) {
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

                // Applies archer entities' damage to the health of the chosen grunt
                try updateHealth(enemyHandle, getPlayerDamage(@constCast(archer)), getEnemyHealth(@constCast(enemyChar)), null, calcDamage, setEnemyHealth);

                // Enemy takes average damage on hit
                try stdout.print(COLOR_DAMAGE ++ "\nEnemy {c} has been hit!" ++ ANSI_RESET, .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Less than average damage is applied to the every enemy
                for (enemyTeam) |enemy| {
                    const enemyHandle = EntityHandle{ .enemy = enemy };
                    try updateHealth(enemyHandle, getPlayerDamage(@constCast(archer)) / 2, getEnemyHealth(@constCast(enemy)), null, calcDamage, setEnemyHealth);
                }

                try stdout.print(COLOR_DAMAGE ++ "\nThe enemy party has been hit!" ++ ANSI_RESET, .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // The archer should be unable to attack for a single turn
                // On next available aciton, the archer will apply double damage
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

pub fn handlePriestInput(priest: ?*const PlayerHandle, playerTeam: *const [3]?*const PlayerHandle) !void {
    const abilityChoice = try getCharInput(COLOR_HERO ++ "\nAbility 1: " ++ COLOR_ABILITY ++ "Single Team Member Heal" ++
        COLOR_HERO ++ "\nAbility 2: " ++ COLOR_ABILITY ++ "Buff Team" ++
        COLOR_HERO ++ "\nEnter which ability you'd like to have the priest use: " ++ ANSI_RESET);

    while (true) {
        switch (abilityChoice) {
            '1' => {
                const teamChoice = try getCharInput(COLOR_HERO ++ "\nEnter which team member you'd like to healed [1. Tank] [2. Archer] [3. Priest]: " ++ ANSI_RESET);

                const teamChar = switch (teamChoice) {
                    '1' => playerTeam[0],
                    '2' => playerTeam[1],
                    '3' => playerTeam[2],
                };

                const playerHandle = EntityHandle{ .player = teamChar };

                try updateHealth(playerHandle, getPlayerDamage(@constCast(priest)), getPlayerHealth(@constCast(teamChar)), getPlayerMaxHealth(@constCast(teamChar)), calcHeal, setPlayerHealth);

                // Heal team member by average amount
                try stdout.print(COLOR_HEAL ++ "\nTeam member {c} has been healed!" ++ ANSI_RESET, .{teamChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Every living team member gains some resitance and/or health regen for a set amount of turns
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

// Functional: Returns new health value after character takes damage
fn calcDamage(damage: i32, health: i32) i32 {
    const result = if ((health - damage) <= 0) 0 else health - damage;
    return result;
}

fn calcHeal(heal: i32, health: i32, maxHealth: i32) i32 {
    const result = if ((health + heal) >= maxHealth) maxHealth else health + heal;
    return result;
}

// Applies damage to specific entities based on given handle, and given setter function
fn updateHealth(handle: EntityHandle, damage: i32, health: i32, maxHealth: ?i32, calcVal: fn (i32, i32, ?i32) i32, setHealth: fn (?*anyopaque, i32) callconv(.c) void) !void {
    var result: i32 = 0;
    const paramCount = @typeInfo(@TypeOf(calcVal)).Fn.params.len;

    if (paramCount == 2) {
        result = calcVal(damage, health);
    } else if (paramCount == 3) {
        result = calcVal(damage, health, maxHealth);
    } else {
        @compileError("Error: Incorrect Function Usage!");
    }

    switch (handle) {
        .enemy => |e_ptr| {
            setHealth(@constCast(e_ptr), result);
        },
        .player => |p_ptr| {
            setHealth(@constCast(p_ptr), result);
        },
    }
}

// // Functional: Returns new modified value after character acquires some modifier (Could be an item or game effect)
// pub fn calcModifiedVal(modifier: i32, currVal: i32) i32 {
//     if (currVal == 0) {
//         return currVal;
//     } else {
//         const result = if ((currVal * modifier) <= 1) 1 else currVal * modifier;
//         return result;
//     }
// }
