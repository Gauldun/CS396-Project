// Library const imports
const std = @import("std");
const sys = @import("systems.zig");
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

// Player Character CPP function const calls
const createPlayerChar = CPP.PlayerEntityCreate;
const destroyPlayerChar = CPP.PlayerEntityDestroy;

// Enemy Character CPP function const calls
const createEnemyChar = CPP.EnemyEntityCreate;
const destroyEnemyChar = CPP.EnemyEntityDestroy;

pub fn main() !void {
    // Comptime constants for print function calls
    const stdin = sys.stdin;
    const stdout = sys.stdout;

    try stdout.print("Enter which character you'd like to have act first: ", .{});
    try stdout.flush();
    const x = try stdin.takeByte();

    try stdout.print("\nAction: {c}", .{x});
    try stdout.flush();

    _ = try stdin.takeByte(); // Consume '\n'

    try stdout.print("\nEnter what ability to use: ", .{});
    try stdout.flush();
    const y = try stdin.takeByte();

    try stdout.print("\nAbility: {c}", .{y});
    try stdout.flush();

    _ = try stdin.takeByte(); // Consume '\n'

    // // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 1 Range, 3 Speed
    // const tankChar = createPlayerChar(100, 15, 1, 3);
    // // Priest Player Party Character w/ Base Stats; 75 Health, 0 Damage, 3 Range, 5 Speed
    // const priestChar = createPlayerChar(75, 0, 3, 5);
    // // Archer Player Party Character w/ Base Stats; 50 Health, 30 Damge, 3 Range, 7 Speed
    // const archerChar = createPlayerChar(50, 30, 3, 7);
    //
    // // Call Destructors
    // destroyPlayerChar(tankChar);
    // destroyPlayerChar(priestChar);
    // destroyPlayerChar(archerChar);
    // destroyEnemyChar(enemyGrunt);
    //
    // Prompt User for choice of attack
    // Prompt requires choice of player character to attack with, which enemy to attack (currently there are no abilities [Simple Point & Click])
}
