// Library const imports
const std = @import("std");
const sys = @import("systems.zig");
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

// Player Character CPP function const calls
const createPlayerChar = CPP.PlayerEntityCreate;
const destroyPlayerChar = CPP.PlayerEntityDestroy;

// Standard Library const function calls
const printErr = std.debug.print;
const stdout = std.fs.File.stdout();
const printBuffer = std.fmt.bufPrint;

// Global buffer for printing game logic 
var BUFF: [4096]u8 = undefined; // Size is 4 Kilobytes 

pub fn main() !void {
    try sys.welcomeMessage();
    // Tank Player Party Character w/ Base Stats; 100 Health, 15 Damage, 1 Range, 3 Speed
    const tankChar = createPlayerChar(100, 15, 1, 3);
    // Priest Player Party Character w/ Base Stats; 75 Health, 0 Damage, 3 Range, 5 Speed
    const priestChar = createPlayerChar(75, 0, 3, 5);
    // Archer Player Party Character w/ Base Stats; 50 Health, 30 Damge, 3 Range, 7 Speed
    const archerChar = createPlayerChar(50, 30, 3, 7);

    // GENERAL GAME LOOP HERE

    // Call Destructors
    destroyPlayerChar(tankChar);
    destroyPlayerChar(priestChar);
    destroyPlayerChar(archerChar);
}

