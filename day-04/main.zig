const std = @import("std");

pub fn main() !void {
    const input = @embedFile("input.txt");
    std.debug.print("Count is: {any}\n", .{try part_1(input)});
}

pub fn part_1(input: []const u8) !usize {
    var abc: [140][140]u8 = undefined;

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

    var count: usize = 0;

    for (abc, 0..140) |row, z| {
        for (row, 0..140) |_, a| {
            if (row[a] != 'X') {
                continue;
            }

            // horizontal
            if (a <= 136 and row[a] == 'X' and row[a + 1] == 'M' and row[a + 2] == 'A' and row[a + 3] == 'S') {
                count += 1;
            }
            // horizontal backward
            if (a >= 3 and row[a] == 'X' and row[a - 1] == 'M' and row[a - 2] == 'A' and row[a - 3] == 'S') {
                count += 1;
            }
            // vertical downward
            if (z <= 136 and abc[z][a] == 'X' and abc[z + 1][a] == 'M' and abc[z + 2][a] == 'A' and abc[z + 3][a] == 'S') {
                count += 1;
            }
            // vertical upward
            if (z >= 3 and abc[z][a] == 'X' and abc[z - 1][a] == 'M' and abc[z - 2][a] == 'A' and abc[z - 3][a] == 'S') {
                count += 1;
            }

            // diagonal right-downward
            if (z <= 136 and a <= 136 and abc[z][a] == 'X' and abc[z + 1][a + 1] == 'M' and abc[z + 2][a + 2] == 'A' and abc[z + 3][a + 3] == 'S') {
                count += 1;
            }

            // diagonal left downward
            if (z <= 136 and a >= 3 and abc[z][a] == 'X' and abc[z + 1][a - 1] == 'M' and abc[z + 2][a - 2] == 'A' and abc[z + 3][a - 3] == 'S') {
                count += 1;
            }

            // diagonal right-upward
            if (z >= 3 and a <= 136 and abc[z][a] == 'X' and abc[z - 1][a + 1] == 'M' and abc[z - 2][a + 2] == 'A' and abc[z - 3][a + 3] == 'S') {
                count += 1;
            }
            // diagonal left upward
            if (z >= 3 and a >= 3 and abc[z][a] == 'X' and abc[z - 1][a - 1] == 'M' and abc[z - 2][a - 2] == 'A' and abc[z - 3][a - 3] == 'S') {
                count += 1;
            }
        }
    }

    return count;
}

test "part_1" {
    const input = @embedFile("input.txt");
    try std.testing.expect(try part_1(std.testing.allocator, input) == 18);
}
