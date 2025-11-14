// Library const imports
const std = @import("std");
const sys = @import("systems.zig");
const cpp = @cImport({
    @cInclude("c_wrapper.hpp");
});

// Player Character cpp function const calls
const createPlayerChar = cpp.PlayerEntityCreate;
const destroyPlayerChar = cpp.PlayerEntityDestroy;

// Enemy Character cpp function const calls
const createEnemyChar = cpp.EnemyEntityCreate;
const destroyEnemyChar = cpp.EnemyEntityDestroy;

pub fn main() !void {
    // Comptime constants for print function calls
    const stdout = sys.stdout;

    // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, hasTurn
    const tankChar = createPlayerChar(100, 15, true);
    // Priest Player Party Character w/ Base Stats; 50 Health, 0 Damage, hasTurn
    const priestChar = createPlayerChar(50, 0, true);
    // Archer Player Party Character w/ Base Stats; 75 Health, 30 Damge, hasTurn
    const archerChar = createPlayerChar(75, 30, true);

    // Enemy Grunt For First Enemy Party; 50 Health, 20 Damage, hasTurn
    const grunt1 = createEnemyChar(50, 20, true);
    const grunt2 = createEnemyChar(50, 20, true);
    const grunt3 = createEnemyChar(50, 20, true);

    while (true) {
        const charChoice = try sys.getCharInput("\nEnter which character you'd like to have act [1. Tank] [2. Archer] [3. Priest]: ");

        while (true) {
            switch (charChoice) {
                '1' => {
                    try sys.handleTankInput();
                    break;
                },
                '2' => {
                    try sys.handleArcherInput();
                    break;
                },
                '3' => {
                    try sys.handlePriestInput();
                    break;
                },
                else => {
                    try stdout.print("Invalid Input. Please try again!", .{});
                    try stdout.flush();
                },
            }
        }
    }
    // Call Destructors
    destroyPlayerChar(tankChar);
    destroyPlayerChar(priestChar);
    destroyPlayerChar(archerChar);

    destroyEnemyChar(grunt1);
    destroyEnemyChar(grunt2);
    destroyEnemyChar(grunt3);
}
