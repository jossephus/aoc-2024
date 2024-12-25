const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }
    const input = @embedFile("input.txt");

    _ = try part_1(allocator, input);
}

pub fn part_1(allocator: std.mem.Allocator, input: []const u8) !u128 {
    var rows = std.mem.splitAny(u8, input, "\n");

    var calibration: u128 = 0;

    outer: while (rows.next()) |row| {
        var tokenized = std.mem.splitAny(u8, row, ":");
        const a = tokenized.next().?;
        const total = std.fmt.parseInt(usize, a, 10) catch {
            continue :outer;
        };

        var numbers = std.mem.split(u8, tokenized.next().?, " ");

        var list = std.ArrayList(u128).init(allocator);
        defer list.deinit();

        loop: while (numbers.next()) |num| {
            try list.append(std.fmt.parseInt(u128, num, 10) catch {
                continue :loop;
            });
        }

        std.debug.print("We here {any}\n", .{list.items});

        // start with +
        var sum: u128 = 0;

        for (list.items, 0..) |item, index| {
            if (sum > total) {
                continue;
            }

            if (index % 2 == 0) {
                sum += item;
            } else {
                sum *= item;
            }
        }

        if (sum == total) {
            calibration += total;
            continue;
        }

        sum = 1;

        for (list.items, 0..) |item, index| {
            if (sum > total) {
                continue;
            }

            if (index % 2 == 0) {
                sum *= item;
            } else {
                sum += item;
            }
        }
        if (sum == total) {
            calibration += total;
            continue;
        }
    }
    std.debug.print("{any}\n", .{calibration});

    return calibration;
}

test "part_1" {
    const input =
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
    ;
    //const input = @embedFile("input.txt");
    try std.testing.expect(try part_1(std.testing.allocator, input) == 3749);
}
