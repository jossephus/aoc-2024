const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "day-03",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mvzr = b.dependency("mvzr", .{ .target = target, .optimize = optimize });

    exe.root_module.addImport("mvzr", mvzr.module("mvzr"));

    b.installArtifact(exe);
}
