//Library const imports
const std = @import("std");
const CPP = @cImport({
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

// CPP Const function calls
const setPlayerHealth = CPP.PlayerEntitySetHealth;
const setEnemyHealth = CPP.EnemyEntitySetHealth;

// Inital Message to be called in main function
pub fn welcomeMessage() !void {
    // Basic game play explanation:
    // Keybindings explanation:
    // General goal explanation:
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
    } else {
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
