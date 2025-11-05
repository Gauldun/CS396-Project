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

// Standard Library const function calls
const stderr = std.debug.print;
const stdout = std.fs.File.stdout();
const printBuffer = std.fmt.bufPrint;

// Systems.zig Library const function calls
const stdin = sys.readInput;
// Global buffer for printing game logic 
var BUFF: [4096]u8 = undefined; // Size is 4 Kilobytes 

pub fn main() !void {
    // try sys.welcomeMessage();
    // // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 1 Range, 3 Speed
    // const tankChar = createPlayerChar(100, 15, 1, 3);
    // // Priest Player Party Character w/ Base Stats; 75 Health, 0 Damage, 3 Range, 5 Speed
    // const priestChar = createPlayerChar(75, 0, 3, 5);
    // // Archer Player Party Character w/ Base Stats; 50 Health, 30 Damge, 3 Range, 7 Speed
    // const archerChar = createPlayerChar(50, 30, 3, 7);
    //
    // //Enemy Character
    // const enemyGrunt = createEnemyChar(100, 50, 2, 3);
    //
    // const message1 = try printBuffer(&BUFF, "Health: {}\n", .{CPP.PlayerEntityGetHealth(tankChar)});
    // try stdout.writeAll(message1);
    //
    // sys.applyPlayerDamage(tankChar orelse {return;}, 25, 100);
    // const message2 = try printBuffer(&BUFF, "Health: {}\n", .{CPP.PlayerEntityGetHealth(tankChar)});
    // try stdout.writeAll(message2);
    //
    // const message3 = try printBuffer(&BUFF, "Health: {}\n", .{CPP.EnemyEntityGetHealth(enemyGrunt)});
    // try stdout.writeAll(message3);
    // sys.applyPlayerDamage(enemyGrunt orelse {return;}, 25, 100);
    // const message4 = try printBuffer(&BUFF, "Health: {}\n", .{CPP.EnemyEntityGetHealth(enemyGrunt)});
    // try stdout.writeAll(message4);
    //
    //
    // // Call Destructors
    // destroyPlayerChar(tankChar);
    // destroyPlayerChar(priestChar);
    // destroyPlayerChar(archerChar);
    // destroyEnemyChar(enemyGrunt);
    //
    //General Game loop
    // while (true) {
    //     // Prompt User for choice of attack
    //     // Prompt requires choice of player character to attack with, which enemy to attack (currently there are no abilities [Simple Point & Click])
    //     stdout.WriteAll("Choose which player character to attack with (Rear[3], Middle[2], Front[1]\n");
    // }
}

