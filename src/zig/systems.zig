const std = @import("std");
const printErr = std.debug.print;
const stdout = std.fs.File.stdout();
const CPP = @cImport({
    @cInclude("c_wrapper.hpp");
});
