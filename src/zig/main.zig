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
    const priestChar = createPlayerChar(50, 20, 10);
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

    // Random Number Gen
    const rand = std.crypto.random;

    while (true) {
        // Randomizes turn order for all players and enemies
        var turnOrder = [_]usize{ 1, 2, 3, 4, 5, 6 };
        rand.shuffle(usize, &turnOrder);

        for (turnOrder) |charIndex| {
            switch (charIndex) {
                1 => {
                    try sys.handleTankInput(tankChar, &enemyTeam, &activeBuffs);
                },
                2 => {
                    try sys.handleArcherInput(archerChar, &enemyTeam, &activeBuffs);
                },
                3 => {
                    try sys.handlePriestInput(priestChar, &playerTeam, &activeBuffs);
                },
                4 => {
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt1, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                5 => {
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt2, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                6 => {
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt3, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                else => unreachable,
            }
        }
        // End Player Character Handling Loop
        try sys.tickBuffs(&activeBuffs);
        try sys.displayStats(&playerTeam, &enemyTeam);
    } // End of Game Loop
}
