const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }
    const input = @embedFile("input.txt");
    std.debug.print("{d}\n", .{try part_1(allocator, input)});
}

pub fn part_1(allocator: std.mem.Allocator, input: []const u8) !u128 {
    var map = std.StringHashMap(bool).init(allocator);
    defer map.deinit();

    var tokenized = std.mem.splitAny(u8, input, "\n");

    var sum: u128 = 0;

    while (tokenized.next()) |line| {
        if (line.len != 5) {
            break;
        }
        try map.put(line, true);
    }

    next: while (tokenized.next()) |line| {
        var it = std.mem.window(u8, line, 5, 3);
        while (it.next()) |i| {
            var str = try allocator.dupe(u8, i);
            defer allocator.free(str);
            std.mem.replaceScalar(u8, str[0..], ',', '|');

            if (map.get(str) == null) {
                continue :next;
            }
        }

        var b: [2]u8 = undefined;
        _ = try std.fmt.bufPrint(&b, "{c}{c}", .{ line[(line.len / 2) - 1], line[line.len / 2] });

        sum += try std.fmt.parseInt(u128, &b, 10);
    }

    return sum;
}

test "part_1" {
    const input =
        \\47|53
        \\97|13
        \\97|61
        \\97|47
        \\75|29
        \\61|13
        \\75|53
        \\29|13
        \\97|29
        \\53|29
        \\61|53
        \\97|53
        \\61|29
        \\47|13
        \\75|47
        \\97|75
        \\47|61
        \\75|61
        \\47|29
        \\75|13
        \\53|13
        \\
        \\75,47,61,53,29
        \\97,61,53,29,13
        \\75,29,13
        \\75,97,47,61,53
        \\61,13,29
        \\97,13,75,29,47 
    ;
    try std.testing.expect(try part_1(std.testing.allocator, input) == 143);
}
