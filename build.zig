const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "game", // Name of your final executable
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/zig/main.zig"), // Your main Zig entry point
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.addCSourceFiles(.{
        .files = &.{
            "src/cpp/entities.cpp",
            "src/cpp_interop/c_wrapper.cpp",
        },
        .flags = &.{
            "-std=c++20",
        },
    });

    exe.addIncludePath(b.path("src/cpp/"));
    exe.addIncludePath(b.path("src/cpp_interop/"));

    exe.linkLibCpp();

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
