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

// cpp Const function calls
const setPlayerHealth = cpp.PlayerEntitySetHealth;
const setEnemyHealth = cpp.EnemyEntitySetHealth;

const EntityHandle = union(enum) {
    enemy: ?*const cpp.EnemyEntityHandle,
    player: ?*const cpp.PlayerEntityHandle,
};

// Colors codes
const ANSI_ESC = "\u{1b}";
const RED = ANSI_ESC ++ "[31m";
const GREEN = ANSI_ESC ++ "[32m";
const BLUE = ANSI_ESC ++ "[34m";
const YELLOW = ANSI_ESC ++ "[33m";
const COLOR_RESET = ANSI_ESC ++ "[0m";

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

pub fn handleTankInput(tank: ?*const cpp.PlayerEntityHandle, enemyTeam: *const [3]?*const cpp.EnemyEntityHandle) !void {
    const abilityChoice = try getCharInput("\nAbility 1: Single Enemy Hit" ++
        "\nAbility 2: Taunt Enemy Team" ++
        "\nAbility 3: Increase Resistance" ++
        "\nEnter which ability you'd like to have the tank use: ");
    while (true) {
        switch (abilityChoice) {
            '1' => {
                const enemyChoice = try getCharInput("\nEnter which enemy you'd like to attack [1. Front] [2. Middle] [3. Rear]: ");
                const enemyChar = switch (enemyChoice) {
                    '1' => enemyTeam[0],
                    '2' => enemyTeam[1],
                    '3' => enemyTeam[2],
                    else => continue,
                };

                const enemyHandle = EntityHandle{ .enemy = enemyChar };

                // Applies tank entities' damage to the health of the chosen grunt
                // Consider adding a stun feature
                try applyDamage(enemyHandle, cpp.PlayerEntityGetDamage(@constCast(tank)), cpp.EnemyEntityGetHealth(@constCast(enemyChar)), calcDamage, cpp.EnemyEntitySetHealth);

                try stdout.print("\nEnemy {c} has been hit!", .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // The enemies are forced to attack the tank for a set number of turns
                // The tank should be unable to act for a set number of turns
                // Consider combining this and the third ability
                try stdout.print("\nThe enemy party has taken notice of the tanks presence!", .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // The tank has increased resistance to physical attacks
                // The resistance can be either the inability to take damage OR
                // The ability to take less damage
                // Considering comibing this with the second ability
                // Possibly replacing this ability with a taunt and a doubling of damage
                try stdout.print("\nThe tanks defenses have been bolstered!", .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print("Invalid Input. Please try again!", .{});
                try stdout.flush();
            },
        }
    }
}

pub fn handleArcherInput(archer: ?*const cpp.PlayerEntityHandle, enemyTeam: *const [3]?*const cpp.EnemyEntityHandle) !void {
    const abilityChoice = try getCharInput("\nAbility 1: Single Enemy Hit" ++
        "\nAbility 2: Team Enemy Hits" ++
        "\nAbility 3: Aim Sights" ++
        "\nEnter which ability you'd like to have the archer use: ");

    while (true) {
        switch (abilityChoice) {
            '1' => {
                const enemyChoice = try getCharInput("\nEnter which enemy you'd like to attack [1. Front] [2. Middle] [3. Rear]: ");

                const enemyChar = switch (enemyChoice) {
                    '1' => enemyTeam[0],
                    '2' => enemyTeam[1],
                    '3' => enemyTeam[2],
                    else => continue,
                };

                const enemyHandle = EntityHandle{ .enemy = enemyChar };

                // Applies archer entities' damage to the health of the chosen grunt
                try applyDamage(enemyHandle, cpp.PlayerEntityGetDamage(archer), cpp.EnemyEntityGetHealth(enemyChar), calcDamage(), cpp.EnemyEntitySetHealth());

                // Enemy takes average damage on hit
                try stdout.print("\nEnemy {c} has been hit!", .{enemyChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Less than average damage is applied to the every enemy
                for (enemyTeam) |enemy| {
                    try applyDamage(enemy, (cpp.PlayerEntityGetDamage(archer) / 2), cpp.EnemyEntityGetHealth(enemy), calcDamage(), cpp.EnemyEntitySetHealth());
                }

                try stdout.print("\nThe enemy party has been hit!", .{});
                try stdout.flush();
                break;
            },
            '3' => {
                // The archer should be unable to attack for a single turn
                // On next available aciton, the archer will apply double damage
                try stdout.print("\nThe archer takes aim!", .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print("Invalid Input. Please try again!", .{});
                try stdout.flush();
            },
        }
    }
}

pub fn handlePriestInput() !void {
    const abilityChoice = try getCharInput("\nAbility 1: Single Team Member Heal" ++
        "\nAbility 2: Buff Team" ++
        "\nEnter which ability you'd like to have the priest use: ");

    while (true) {
        switch (abilityChoice) {
            '1' => {
                const teamChoice = try getCharInput("\nEnter which team member you'd like to have attack [1. Tank] [2. Archer] [3. Priest]: ");
                // Heal team member by average amount
                try stdout.print("\nTeam member {c} has been healed!", .{teamChoice});
                try stdout.flush();
                break;
            },
            '2' => {
                // Every living team member gains some resitance and/or health regen for a set amount of turns
                try stdout.print("The team thrives!", .{});
                try stdout.flush();
                break;
            },
            else => {
                try stdout.print("Invalid Input. Please try again!", .{});
                try stdout.flush();
            },
        }
    }
}

// Functional: Returns new health value after character takes damage
pub fn calcDamage(damage: i32, health: i32) i32 {
    const result = if ((health - damage) <= 0) 0 else health - damage;
    return result;
}

pub fn applyDamage(handle: EntityHandle, damage: i32, health: i32, calcVal: fn (i32, i32) i32, setHealth: fn (EntityHandle, i32) void) !void {
    const result = calcVal(damage, health);

    switch (handle) {
        .enemy => |e_ptr| {
            setHealth(@constCast(e_ptr), result);
        },
        .player => |p_ptr| {
            setHealth(@constCast(p_ptr), result);
        },
    }
}

// Functional: Returns new modified value after character acquires some modifier (Could be an item or game effect)
pub fn calcModifiedVal(modifier: i32, currVal: i32) i32 {
    if (currVal == 0) {
        return currVal;
    } else {
        const result = if ((currVal * modifier) <= 1) 1 else currVal * modifier;
        return result;
    }
}

// // Imperative: Applies resulting damage onto player character
// pub fn applyPlayerDamage(player: *const cpp.PlayerEntityHandle, damage: i32, health: i32) !void {
//     const result = calcDamage(damage, health);
//     setPlayerHealth(@constCast(player), result);
// }
//
// // Imperative: Applies resulting damage onto player character
// pub fn applyEnemyDamage(enemy: *const cpp.EnemyEntityHandle, damage: i32, health: i32) !void {
//     const result = calcDamage(damage, health);
//     setEnemyHealth(@constCast(enemy), result);
// }
