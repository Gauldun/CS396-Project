const std = @import("std");
const sys = @import("systems.zig");
const printErr = std.debug.print;
const stdout = std.fs.File.stdout();
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

pub fn main() !void {
    try stdout.writeAll("Hello, world!\n");
}
