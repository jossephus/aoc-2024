const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    //const input = @embedFile("input.txt");
    //std.debug.print("{d}", .{try part_1(allocator, input)});

    const input = @embedFile("input.txt");
    std.debug.print("{d}", .{try part_2(allocator, input)});
}

fn part_1(allocator: std.mem.Allocator, input: []const u8) !i512 {
    var list = std.ArrayList(u128).init(allocator);
    defer list.deinit();
    var list2 = std.ArrayList(u128).init(allocator);
    defer list2.deinit();

    var tokenized = std.mem.tokenizeAny(u8, input, " \n");

    var index: u32 = 0;

    while (tokenized.next()) |line| {
        const num = try std.fmt.parseInt(u128, line, 10);

        if (index % 2 == 0) {
            try list.append(num);
        } else {
            try list2.append(num);
        }

        index += 1;
    }

    std.mem.sort(u128, list.items, {}, comptime std.sort.asc(u128));
    std.mem.sort(u128, list2.items, {}, comptime std.sort.asc(u128));

    var sum: i512 = 0;

    for (list.items, list2.items) |a, b| {
        sum += @abs(@as(i256, a) - @as(i256, b));
    }
    return sum;
}

fn part_2(allocator: std.mem.Allocator, input: []const u8) !i512 {
    var list = std.ArrayList(u128).init(allocator);
    defer list.deinit();
    var list2 = std.ArrayList(u128).init(allocator);
    defer list2.deinit();

    var tokenized = std.mem.tokenizeAny(u8, input, " \n");

    var index: u32 = 0;

    while (tokenized.next()) |line| {
        const num = try std.fmt.parseInt(u128, line, 10);

        if (index % 2 == 0) {
            try list.append(num);
        } else {
            try list2.append(num);
        }

        index += 1;
    }

    var sum: i512 = 0;

    for (list.items) |a| {
        sum += (a) * std.mem.count(u128, list2.items, &[_]u128{a});
    }

    return sum;
}

test "part_1" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3 
        \\3   9
        \\3   3 
    ;
    try std.testing.expect((try part_1(std.testing.allocator, input)) == 11);
}

test "part_2" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3 
        \\3   9
        \\3   3 
    ;
    try std.testing.expect((try part_2(std.testing.allocator, input)) == 31);
}
