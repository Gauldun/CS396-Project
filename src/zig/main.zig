const std = @import("std");
const printLn = std.debug.print;
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});

pub fn main() void {
    printLn("Compiles Great!\n", .{});
}
