const std = @import("std");
const printErr = std.debug.print;
const stdout = std.fs.File.stdout();
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

pub fn welcomeMessage() !void {
    try stdout.writeAll("Welcome to [GAME_NAME]!\n ");
    // Basic game play explanation:
    // Keybindings explanation:
    // General goal explanation:
}


