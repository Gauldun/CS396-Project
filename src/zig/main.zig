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

    // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 1 Range, hasTurn
    const tankChar = createPlayerChar(100, 15, 1, true);
    // Priest Player Party Character w/ Base Stats; 50 Health, 0 Damage, 3 Range, hasTurn
    const priestChar = createPlayerChar(50, 0, 3, true);
    // Archer Player Party Character w/ Base Stats; 75 Health, 30 Damge, 3 Range, hasTurn
    const archerChar = createPlayerChar(75, 30, 3, true);

    while (true) {
        const charChoice = try sys.getCharInput("\nEnter which character you'd like to have act [1. Tank] [2. Archer] [3. Priest]: ");

        try switch (charChoice) {
            '1' => sys.handleTankInput(),
            '2' => sys.handleArcherInput(),
            '3' => sys.handlePriestInput(),
            else => {
                try stdout.print("Invalid Input. Please try again!", .{});
                try stdout.flush();
            },
        };
    }
    // Call Destructors
    destroyPlayerChar(tankChar);
    destroyPlayerChar(priestChar);
    destroyPlayerChar(archerChar);
}
