//Library const imports
const std = @import("std");
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

// Standard lib function const calls
const printErr = std.debug.print;
const stdout = std.fs.File.stdout();

// CPP Const function calls
const setPlayerHealth = CPP.PlayerEntitySetHealth;
const setEnemyHealth = CPP.EnemyEntitySetHealth;

pub fn welcomeMessage() !void {
    try stdout.writeAll("Welcome to [GAME_NAME]!\n ");
    // Basic game play explanation:
    // Keybindings explanation:
    // General goal explanation:
}

pub fn readInput() ![]const u8 {
    // 1. Get the stdout writer and stdin reader
    var stdin_buffer: [63]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;

    const line = try stdin.takeDelimiterExclusive('\n');

    return line;
}
// Functional: Returns new health value after character takes damage
pub fn calcDamage(damage: i32, health: i32) i32 {
    const result = if ((health - damage) <= 0) 0 else health - damage;
    return result;
} 

// Functional: Returns new modified value after character acquires some modifier (Could be an item or game effect)
pub fn calcModifiedVal(modifier: i32, currVal: i32) i32 {
    if (currVal == 0) {
        return currVal;
    }
    else {
    const result = if ((currVal * modifier) <= 1) 1 else currVal * modifier;
    return result;
    }
}

// Imperative: Applies resulting damage onto player character
pub fn applyPlayerDamage(player: *const CPP.PlayerEntityHandle, damage: i32, health: i32) void {
    const result = calcDamage(damage, health);
    setPlayerHealth(@constCast(player), result);
}

// Imperative: Applies resulting damage onto player character
pub fn applyEnemyDamage(enemy: *const CPP.EnemyEntityHandle, damage: i32, health: i32) void {
    const result = calcDamage(damage, health);
    setEnemyHealth(@constCast(enemy), result);
}
