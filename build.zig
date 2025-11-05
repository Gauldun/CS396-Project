const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "game",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/zig/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const systemsLib = b.createModule (.{
        .root_source_file = b.path("src/zig/systems.zig"),
    });

    exe.addCSourceFiles(.{
        .files = &.{
            "src/cpp/entities.cpp",
            "src/cpp_interop/c_wrapper.cpp",
        },
        .flags = &.{
            "-std=c++20",
            "-Wall",
            "-Wextra",
        },
    });

    exe.linkLibCpp();
    exe.linkSystemLibrary("c++");
    exe.addIncludePath(b.path("src/cpp/"));
    exe.addIncludePath(b.path("src/cpp_interop/"));


    exe.root_module.addImport("systems", systemsLib);

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
