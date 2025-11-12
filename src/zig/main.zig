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
    const stdin = sys.stdin;
    const stdout = sys.stdout;

    // // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 1 Range, hasTurn
    // const tankChar = createPlayerChar(100, 15, 1, true);
    // // Priest Player Party Character w/ Base Stats; 50 Health, 0 Damage, 3 Range, hasTurn
    // const priestChar = createPlayerChar(50, 0, 3, true);
    // // Archer Player Party Character w/ Base Stats; 75 Health, 30 Damge, 3 Range, hasTurn
    // const archerChar = createPlayerChar(75, 30, 3, true);
    //
    // // Call Destructors
    // destroyPlayerChar(tankChar);
    // destroyPlayerChar(priestChar);
    // destroyPlayerChar(archerChar);
    //
    // Prompt User for choice of attack
    // Prompt requires choice of player character to attack with, which enemy to attack (currently there are no abilities [Simple Point & Click])

    while (true) {
        try stdout.print("Enter which character you'd like to have act: ", .{});
        try stdout.flush();

        const charChoiceInput = try stdin.takeByte();
        _ = try stdin.takeByte(); // Consumes '\n' character

        if (charChoiceInput == '3') {
            // Ability 1: Single Target hit, average Damage
            // Ability 2: Entire enemy team it hit, less than average Damage
            // Ability 3: Cosumes a turn, next turn with archer, damage is doubled
            try stdout.print("Display Archer Character Abilites: Make it 3 Abilites [Damage/Target Debuff]", .{});
            const abilityChoice = try stdin.takeByte();
            _ = try stdin.takeByte(); // Consumes '\n' charcter
            if (abilityChoice == '1') {
                try stdout.print("Enter Which Enemy you'd like to attack", .{});
            } else if (abilityChoice == '2') {
                try stdout.print("Enemy Team takes damage!", .{});
            } else if (abilityChoice == '3') {
                try stdout.print("Next time Archer is used, damage is double", .{});
            }
        } else if (charChoiceInput == '2') {
            // Ability 1: Single Target Heal Greatly
            // Ability 3:  Team Buff (Could be Regen or Resistance or both), priest takes 2 turns before he can go again
            try stdout.print("Display Priest Character Abilties: Make it 2 Abilites [Healing/Buff]", .{});
            const abilityChoice = try stdin.takeByte();
            _ = try stdin.takeByte(); // Consumes '\n' character
            if (abilityChoice == '1') {
                try stdout.print("Enter which team member you'd like to heal: ", .{});
            } else if (abilityChoice == '2') {
                try stdout.print("The teams members have gained slight resistance and health regen!");
            }
        } else if (charChoiceInput == '1') {
            // Ability 1: Stuns and Damages a single target, average amount
            // Ability 2: Taunts to force enemies to attack for the next three turns, tank takes 2 turns before he can go again
            // Ability 3: Bolsters Physical Resistance for the next two turns
            try stdout.print("Display Tank Character Abilites: Make it 3 Abilities [Damage/Taunt/Tank", .{});
            const abilityChoice = try stdin.takeByte();
            _ = try stdin.takeByte(); // Consumes '\n' character

            if (abilityChoice == '1') {
                try stdout.print("Enter which enemy you'd like to attack: ");
            } else if (abilityChoice == '2') {
                try stdout.print("The enemies are forced to attack you!");
            } else if (abilityChoice == '3') {
                try stdout.print("Your defense has increased!");
            }
        }
    }
}
