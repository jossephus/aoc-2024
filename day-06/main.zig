const std = @import("std");

const Direction = enum {
    U,
    D,
    L,
    R,
};

pub fn part_1(allocator: std.mem.Allocator, input: []const u8) !usize {
    const row_length = 11;
    const column_length = 11;

    var abc: [row_length][column_length]u8 = undefined;
    // Create a visited array to track where we've been
    var visited: [row_length][column_length]bool = [_][column_length]bool{[_]bool{false} ** column_length} ** row_length;

    _ = allocator;

    var direction = Direction.U;

    var rows: usize = 0;
    var cols: usize = 0;

    for (input) |x| {
        if (x == '\n') {
            rows += 1;
            cols = 0;
        } else {
            abc[rows][cols] = x;
            cols += 1;
        }
    }

    const index = std.mem.indexOf(u8, input, "^").?;

    std.debug.print("{any}\n", .{index});
    var row_number = index / column_length;
    var column_number = index % column_length;
    std.debug.print("{any} {any} {c}\n", .{ row_number, column_number, abc[row_number][column_number] });

    var traps: usize = 0; // Count the starting position
    visited[row_number][column_number] = true;

    loop: while (true) {
        switch (direction) {
            .U => {
                while (row_number > 0) {
                    row_number -= 1;
                    std.debug.print("UP: {any} {any}\n", .{ row_number, column_number });

                    if (abc[row_number][column_number] == '#') {
                        row_number += 1;
                        direction = .R;
                        break;
                    }
                    if (!visited[row_number][column_number]) {
                        traps += 1;
                        visited[row_number][column_number] = true;
                    }
                } else break :loop;
            },
            .D => {
                while (row_number < row_length - 1) {
                    row_number += 1;
                    std.debug.print("DOWN: {any} {any}\n", .{ row_number, column_number });

                    if (abc[row_number][column_number] == '#') {
                        row_number -= 1;
                        direction = .L;
                        break;
                    }
                    if (!visited[row_number][column_number]) {
                        traps += 1;
                        visited[row_number][column_number] = true;
                    }
                } else break :loop;
            },
            .L => {
                while (column_number > 0) {
                    column_number -= 1;
                    std.debug.print("LEFT: {any} {any}\n", .{ row_number, column_number });

                    if (abc[row_number][column_number] == '#') {
                        column_number += 1;
                        direction = .U;
                        break;
                    }
                    if (!visited[row_number][column_number]) {
                        traps += 1;
                        visited[row_number][column_number] = true;
                    }
                } else break :loop;
            },
            .R => {
                while (column_number < column_length - 1) {
                    column_number += 1;
                    std.debug.print("RIGHT: {any} {any}\n", .{ row_number, column_number }); // Fixed debug message

                    if (abc[row_number][column_number] == '#') {
                        column_number -= 1;
                        direction = .D;
                        break;
                    }
                    if (!visited[row_number][column_number]) {
                        traps += 1;
                        visited[row_number][column_number] = true;
                    }
                } else break :loop;
            },
        }
    }

    std.debug.print("Total traps {any}\n", .{traps});

    return traps;
}

test "part_1" {
    const input = @embedFile("input.txt");
    std.testing.expect(try part_1(std.testing.allocator, input) == 41) catch |err| {
        std.debug.print("Error is {any}", .{err});
    };
}
