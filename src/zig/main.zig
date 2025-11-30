// Library const imports
const std = @import("std");
const sys = @import("systems.zig");
const cpp = @cImport({
    @cInclude("c_wrapper.hpp");
});

// For printing to file/console
const stdout = sys.stdout;

// For dynamic array declaration
const arrayList = std.array_list.Managed;

// Player Character cpp function const calls
const createPlayerChar = cpp.PlayerEntityCreate;
const destroyPlayerChar = cpp.PlayerEntityDestroy;

// Enemy Character cpp function const calls
const createEnemyChar = cpp.EnemyEntityCreate;
const destroyEnemyChar = cpp.EnemyEntityDestroy;

pub fn main() !void {
    // For memory allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Stores all active buffs
    var activeBuffs = arrayList(sys.ActiveBuff).init(allocator);
    defer activeBuffs.deinit();

    // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 25% Defense
    const tankChar = createPlayerChar(100, 15, 25);
    // Priest Player Party Character w/ Base Stats; 50 Health, 0 Damage, 10% Defense
    const priestChar = createPlayerChar(50, 0, 10);
    // Archer Player Party Character w/ Base Stats; 75 Health, 30 Damge, 15% Defense
    const archerChar = createPlayerChar(75, 30, 15);

    // Enemy Grunt For First Enemy Party; 50 Health, 20 Damage, 5% Defense
    const grunt1 = createEnemyChar(50, 15, 5);
    const grunt2 = createEnemyChar(50, 15, 5);
    const grunt3 = createEnemyChar(50, 15, 5);

    // Defer Destructors
    defer destroyPlayerChar(tankChar);
    defer destroyPlayerChar(priestChar);
    defer destroyPlayerChar(archerChar);
    defer destroyEnemyChar(grunt1);
    defer destroyEnemyChar(grunt2);
    defer destroyEnemyChar(grunt3);

    var playerTeam = [_]?*const cpp.PlayerEntityHandle{
        tankChar,
        archerChar,
        priestChar,
    };

    const enemyTeam = [_]?*const cpp.EnemyEntityHandle{
        grunt1,
        grunt2,
        grunt3,
    };

    while (true) {
        while (true) {
            const charChoice = try sys.getCharInput(sys.COLOR_HERO ++ "\nEnter which character you'd like to have act [1. Tank] [2. Archer] [3. Priest]: " ++ sys.ANSI_RESET);
            switch (charChoice) {
                '1' => {
                    try sys.handleTankInput(tankChar, &enemyTeam, &activeBuffs);
                    break;
                },
                '2' => {
                    try sys.handleArcherInput(archerChar, &enemyTeam, &activeBuffs);
                    break;
                },
                '3' => {
                    try sys.handlePriestInput(priestChar, &playerTeam, &activeBuffs);
                    break;
                },
                else => {
                    try stdout.print(sys.COLOR_ERROR ++ "Invalid Input. Please try again!" ++ sys.ANSI_RESET, .{});
                    try stdout.flush();
                },
            }
        } // End Player Character Handling Loop
        try sys.tickBuffs(&activeBuffs);
        try sys.displayStats(&playerTeam, &enemyTeam);
    } // End of Game Loop
}
