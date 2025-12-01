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

const createItem = cpp.ItemHandleCreate;
const destroyItem = cpp.ItemDestroy;

pub fn main() !void {
    // For memory allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Stores all active buffs
    var activeBuffs = arrayList(sys.ActiveBuff).init(allocator);
    defer activeBuffs.deinit();

    // Vague Rarity Items
    // Rusty Shiv: Additional 5 Damage
    const rustyShiv = createItem(5, 0, 0, 0);
    // Tattered Cloth: Additional 10 Health
    const tatteredCloth = createItem(0, 10, 0, 0);
    // Broken Shield: Additional 5 Health, 3% Defense
    const brokenShield = createItem(0, 5, 3, 0);
    // Suspicious Potion: Additional 5% Damage, 15 Health, 5 Damage to Self Every Round
    const susPotion = createItem(5, 15, 0, 5);

    // Distant Rarity Items
    // Iron Longsword: Additional 10 Damage, 3% Defense
    const ironSword = createItem(10, 0, 3, 0);
    // Leather Armor Set: Additional 20 Health, 10% Defense
    const leatherArmor = createItem(0, 20, 10, 0);
    // Sturdy Buckler: Addtional 5 Damage, 15 Health, 5% Defense
    const sturdyBuckler = createItem(5, 15, 5, 0);
    // Sharp Duelist's Rapier: Additional 15 Damage, 5% Defense
    const sharpRapier = createItem(15, 0, 5, 0);

    // Indelible Rarity Items
    // Runed BattleAxe: Additional 25 Damage, 25 Health, 5% Defense
    const runedAxe = createItem(25, 25, 5, 0);
    // Guardian Platemail: Additional 50 Health, 15% Defense
    const guardianPlate = createItem(0, 50, 15, 0);

    // Unforgettable Rarity Items
    // Holy Blade Iem: Additional 50 Damage, 20 Health, 5% Defense, 15 Damage to Self Every Round
    const hollowedBlade = createItem(50, 20, 5, 15);
    // Ancient Armor: Additional 10 Damage, 100 Health, 30% Defense
    const ancientAegis = createItem(10, 100, 30, 0);

    const items = [_]?*cpp.ItemHandle{
        rustyShiv,
        tatteredCloth,
        brokenShield,
        susPotion,
        ironSword,
        leatherArmor,
        sturdyBuckler,
        sharpRapier,
        runedAxe,
        guardianPlate,
        hollowedBlade,
        ancientAegis,
    };

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

    // Defer Entity Destructors
    for (playerTeam) |player| {
        defer (destroyPlayerChar(@constCast(player)));
    }

    for (enemyTeam) |enemy| {
        defer (destroyEnemyChar(@constCast(enemy)));
    }

    // Defer Item Destructors
    for (items) |item| {
        defer (destroyItem(@constCast(item)));
    }

    // Random Number Gen
    const rand = std.crypto.random;

    while (true) {
        // Randomizes turn order for all players and enemies
        var turnOrder = [_]usize{ 1, 2, 3, 4, 5, 6 };
        rand.shuffle(usize, &turnOrder);

        for (turnOrder) |charIndex| {
            switch (charIndex) {
                1 => {
                    if (sys.getPlayerHealth(@constCast(tankChar)) <= 0) {
                        continue;
                    }
                    try sys.handleTankInput(tankChar, &enemyTeam, &activeBuffs);
                },
                2 => {
                    if (sys.getPlayerHealth(@constCast(archerChar)) <= 0) {
                        continue;
                    }
                    try sys.handleArcherInput(archerChar, &enemyTeam, &activeBuffs);
                },
                3 => {
                    if (sys.getPlayerHealth(@constCast(priestChar)) <= 0) {
                        continue;
                    }
                    try sys.handlePriestInput(priestChar, &playerTeam, &activeBuffs);
                },
                4 => {
                    if (sys.getPlayerHealth(@constCast(grunt1)) <= 0) {
                        continue;
                    }
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt1, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                5 => {
                    if (sys.getPlayerHealth(@constCast(grunt2)) <= 0) {
                        continue;
                    }
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt2, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                6 => {
                    if (sys.getPlayerHealth(@constCast(grunt3)) <= 0) {
                        continue;
                    }
                    const randAbility = rand.uintLessThan(usize, 2) + 1;
                    const randChar = rand.uintLessThan(usize, 3);
                    try sys.handleGruntTurn(grunt3, &playerTeam, &activeBuffs, randAbility, randChar);
                    continue;
                },
                else => unreachable,
            }
        }
        // If Player's team is dead (end game), if enemy's team is dead (end current loop), if neither (continue loop)
        const breakLoop = try processGameState(&activeBuffs, &playerTeam, &enemyTeam);
        if (breakLoop) {
            break;
        }
    } // End of Game Loop
    const randItem = rand.uintLessThan(usize, 10);
    const givenItem = items[randItem];
    sys.equipItem(@constCast(tankChar), @constCast(givenItem));
    try stdout.print("\nGiven Item: {s}", .{sys.getItemName(@constCast(givenItem))});
    try stdout.flush();
}

fn processGameState(activeBuffs: *arrayList(sys.ActiveBuff), playerTeam: *const [3]?*const sys.PlayerHandle, enemyTeam: *const [3]?*const sys.EnemyHandle) !bool {
    const gameEnd = sys.checkGameEnd(enemyTeam, playerTeam);
    switch (gameEnd) {
        1 => {
            try stdout.print(sys.COLOR_HERO ++ "\nThe enemy's team has died!" ++ sys.ANSI_RESET, .{});
            try stdout.flush();
            return true;
        },
        2 => {
            try stdout.print(sys.COLOR_ENEMY ++ "\nThe player's team has died!" ++ sys.ANSI_RESET, .{});
            try stdout.flush();
            std.process.exit(0);
        },
        0 => {
            try sys.tickBuffs(activeBuffs);
            try sys.displayStats(playerTeam, enemyTeam);
            return false;
        },
        else => unreachable,
    }
}
