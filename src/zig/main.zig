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
    const rustyShiv = createItem(5, 0, 0, 0, "Rusty Shiv");
    defer destroyItem(rustyShiv);
    // Tattered Cloth: Additional 10 Health
    const tatteredCloth = createItem(0, 10, 0, 0, "Tattered Cloth");
    defer destroyItem(tatteredCloth);
    // Broken Shield: Additional 5 Health, 3% Defense
    const brokenShield = createItem(0, 5, 3, 0, "Broken Shield");
    defer destroyItem(brokenShield);
    // Suspicious Potion: Additional 5% Damage, 15 Health, 5 Damage to Self Every Round
    const susPotion = createItem(5, 15, 0, 5, "Suspicious Potion");
    defer destroyItem(susPotion);

    // Distant Rarity Items
    // Iron Longsword: Additional 10 Damage, 3% Defense
    const ironSword = createItem(10, 0, 3, 0, "Iron Longsword");
    defer destroyItem(ironSword);
    // Leather Armor Set: Additional 20 Health, 10% Defense
    const leatherArmor = createItem(0, 20, 10, 0, "Leather Armor Set");
    defer destroyItem(leatherArmor);
    // Sturdy Buckler: Addtional 5 Damage, 15 Health, 5% Defense
    const sturdyBuckler = createItem(5, 15, 5, 0, "Sturdy Buckler");
    defer destroyItem(sturdyBuckler);
    // Sharp Duelist's Rapier: Additional 15 Damage, 5% Defense
    const sharpRapier = createItem(15, 0, 5, 0, "Sharp Rapier");
    defer destroyItem(sharpRapier);

    // Indelible Rarity Items
    // Runed BattleAxe: Additional 25 Damage, 25 Health, 5% Defense
    const runedAxe = createItem(25, 25, 5, 0, "Rune-Covered BattleAxe");
    defer destroyItem(runedAxe);
    // Guardian Platemail: Additional 50 Health, 15% Defense
    const guardianPlate = createItem(0, 50, 15, 0, "Guardian Platemail");
    defer destroyItem(guardianPlate);

    // Unforgettable Rarity Items
    // Hollowed Blade: Additional 50 Damage, 20 Health, 5% Defense, 15 Damage to Self Every Round
    const hollowedBlade = createItem(50, 20, 5, 15, "Hollowed Blade");
    defer destroyItem(hollowedBlade);
    // Ancient Aegis of Celestials: Additional 10 Damage, 100 Health, 30% Defense
    const ancientAegis = createItem(10, 100, 30, 0, "Ancient Aegis of Celestials");
    defer destroyItem(ancientAegis);

    var items = [_]?*cpp.ItemHandle{
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
    defer destroyPlayerChar(tankChar);
    // Priest Player Party Character w/ Base Stats; 50 Health, 0 Damage, 10% Defense
    const priestChar = createPlayerChar(50, 20, 10);
    defer destroyPlayerChar(priestChar);
    // Archer Player Party Character w/ Base Stats; 75 Health, 30 Damge, 15% Defense
    const archerChar = createPlayerChar(75, 30, 15);
    defer destroyPlayerChar(archerChar);

    const playerTeam = [_]?*const cpp.PlayerEntityHandle{
        tankChar,
        archerChar,
        priestChar,
    };

    // Random Number Gen
    const rand = std.crypto.random;

    { // Begin First Game Loop
        // Enemy Grunt: 50 Health, 20 Damage, 5% Defense
        const grunt1 = createEnemyChar(50, 15, 5);
        defer destroyEnemyChar(grunt1);
        const grunt2 = createEnemyChar(50, 15, 5);
        defer destroyEnemyChar(grunt2);
        const grunt3 = createEnemyChar(50, 15, 5);
        defer destroyEnemyChar(grunt3);

        const enemyTeam = [_]?*const cpp.EnemyEntityHandle{
            grunt1,
            grunt2,
            grunt3,
        };

        try sys.displayStats(&playerTeam, &enemyTeam);
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
                    },
                    5 => {
                        if (sys.getPlayerHealth(@constCast(grunt2)) <= 0) {
                            continue;
                        }
                        const randAbility = rand.uintLessThan(usize, 2) + 1;
                        const randChar = rand.uintLessThan(usize, 3);
                        try sys.handleGruntTurn(grunt2, &playerTeam, &activeBuffs, randAbility, randChar);
                    },
                    6 => {
                        if (sys.getPlayerHealth(@constCast(grunt3)) <= 0) {
                            continue;
                        }
                        const randAbility = rand.uintLessThan(usize, 2) + 1;
                        const randChar = rand.uintLessThan(usize, 3);
                        try sys.handleGruntTurn(grunt3, &playerTeam, &activeBuffs, randAbility, randChar);
                    },
                    else => unreachable,
                }
            }
            // If Player's team is dead (end game), if enemy's team is dead (end current loop), if neither (continue loop)
            const breakLoop = try processGameState(&activeBuffs, &playerTeam, &enemyTeam);
            if (breakLoop) {
                break;
            }
        } // End First Game Loop
    }
    try sys.generateApplyItem(&playerTeam, &items);
    try sys.generateApplyItem(&playerTeam, &items);
    try sys.generateApplyItem(&playerTeam, &items);

    try sys.clearActiveBuffs(&activeBuffs);
    try sys.resetCharHealth(&playerTeam);

    { // Begin Second Game Loop
        // Enemy Cultist: 200 Health, 35 Damage, 20% Defense
        const cultist1 = createEnemyChar(200, 35, 20);
        defer destroyEnemyChar(cultist1);
        const cultist2 = createEnemyChar(200, 35, 20);
        defer destroyEnemyChar(cultist2);
        const cultist3 = createEnemyChar(200, 35, 20);
        defer destroyEnemyChar(cultist3);

        const enemyTeam = [_]?*const cpp.EnemyEntityHandle{ cultist1, cultist2, cultist3 };

        try sys.displayStats(&playerTeam, &enemyTeam);
        while (true) {
            // Randomizes turn order for all players and enemies
            var turnOrder = [_]usize{ 1, 2, 3, 4, 5 };
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
                        if (sys.getPlayerHealth(@constCast(cultist1)) <= 0) {
                            continue;
                        }
                        const randAbility = rand.uintLessThan(usize, 2) + 1;
                        const randChar = rand.uintLessThan(usize, 3);
                        try sys.handleCultistTurn(cultist1, &playerTeam, &activeBuffs, randAbility, randChar);
                    },
                    5 => {
                        if (sys.getPlayerHealth(@constCast(cultist2)) <= 0) {
                            continue;
                        }
                        const randAbility = rand.uintLessThan(usize, 2) + 1;
                        const randChar = rand.uintLessThan(usize, 3);
                        try sys.handleCultistTurn(cultist2, &playerTeam, &activeBuffs, randAbility, randChar);
                    },
                    6 => {
                        if (sys.getPlayerHealth(@constCast(cultist3)) <= 0) {
                            continue;
                        }
                        const randAbility = rand.uintLessThan(usize, 2) + 1;
                        const randChar = rand.uintLessThan(usize, 3);
                        try sys.handleCultistTurn(cultist3, &playerTeam, &activeBuffs, randAbility, randChar);
                    },
                    else => unreachable,
                }
            }
            // If Player's team is dead (end game), if enemy's team is dead (end current loop), if neither (continue loop)
            const breakLoop = try processGameState(&activeBuffs, &playerTeam, &enemyTeam);
            if (breakLoop) {
                break;
            }
        }
    } // End Second Game Loop
    try sys.generateApplyItem(&playerTeam, &items);
    try sys.generateApplyItem(&playerTeam, &items);
    try sys.generateApplyItem(&playerTeam, &items);

    try sys.clearActiveBuffs(&activeBuffs);
    try sys.resetCharHealth(&playerTeam);
} // End Main Function

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
