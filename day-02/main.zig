const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }
    const input = @embedFile("input.txt");
    std.debug.print("{d}", .{try part_1(allocator, input)});
}

fn part_1(allocator: std.mem.Allocator, input: []const u8) !u8 {
    var tokenized = std.mem.splitAny(u8, input, "\n");

    var safeTotal: u8 = 0;

    loop: while (tokenized.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var numbers = std.mem.tokenizeScalar(u8, line, ' ');
        var list = std.ArrayList(u128).init(allocator);
        defer list.deinit();

        var list2 = std.ArrayList(u128).init(allocator);
        defer list2.deinit();

        while (numbers.next()) |num| {
            try list.append(try std.fmt.parseInt(u128, num, 10));
            try list2.append(try std.fmt.parseInt(u128, num, 10));
        }

        for (list.items, 0..) |num, index| {
            if (index < list.items.len - 1) {
                const diff = @abs(@as(i256, num) - @as(i256, list.items[index + 1]));
                if ((diff < 1) or (diff > 3)) {
                    continue :loop;
                }
            }
        }

        std.mem.sort(u128, list2.items, {}, comptime std.sort.asc(u128));

        if (!std.mem.eql(u128, list.items, list2.items)) {
            std.mem.sort(u128, list2.items, {}, comptime std.sort.desc(u128));

            if (!std.mem.eql(u128, list.items, list2.items)) {
                continue;
            }
        }

        safeTotal += 1;
    }

    return safeTotal;
}

fn part_2(allocator: std.mem.Allocator, input: []const u8) !u8 {
    var tokenized = std.mem.splitAny(u8, input, "\n");

    var safeTotal: u8 = 0;

    loop: while (tokenized.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var numbers = std.mem.tokenizeScalar(u8, line, ' ');
        var list = std.ArrayList(u128).init(allocator);
        defer list.deinit();

        var list2 = std.ArrayList(u128).init(allocator);
        defer list2.deinit();

        while (numbers.next()) |num| {
            try list.append(try std.fmt.parseInt(u128, num, 10));
            try list2.append(try std.fmt.parseInt(u128, num, 10));
        }

        var tries: usize = 0;

        forloop: for (list.items, 0..) |num, index| {
            if (index < list.items.len - 1) {
                const diff = @abs(@as(i256, num) - @as(i256, list.items[index + 1]));
                if ((diff < 1) or (diff > 3)) {
                    if (tries > 0) {
                        continue :loop;
                    } else {
                        _ = list.orderedRemove(index);
                        _ = list2.orderedRemove(index);
                        std.debug.print("{any}\n", .{list});
                        tries += 1;
                        continue :forloop;
                    }
                }
            }
        }

        std.mem.sort(u128, list2.items, {}, comptime std.sort.asc(u128));

        if (!std.mem.eql(u128, list.items, list2.items)) {
            std.mem.sort(u128, list2.items, {}, comptime std.sort.desc(u128));

            if (!std.mem.eql(u128, list.items, list2.items)) {
                continue;
            }
        }

        safeTotal += 1;
    }

    return safeTotal;
}

test "part_1" {
    const input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
        \\1 3 4 5 8 10 7
    ;
    try std.testing.expect(try part_1(std.testing.allocator, input) == 2);
}

test "part_2" {
    const input =
        \\1 3 2 4 5
    ;
    std.debug.print("{any}\n", .{try part_2(std.testing.allocator, input)});
    try std.testing.expect(try part_2(std.testing.allocator, input) == 4);
}
