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

pub fn part_1(allocator: std.mem.Allocator, input: []const u8) !u128 {
    var lines = try std.ArrayList(usize).initCapacity(allocator, input.len);
    defer lines.deinit();

    const data = std.mem.trim(u8, input, &std.ascii.whitespace);

    var index: usize = 0;

    var id: usize = 0;

    while (index < data.len) : (index += 1) {
        var counter: usize = charToDigit(data[index]);

        while (counter > 0) : (counter -= 1) {
            try lines.append(if (index % 2 == 0) @as(usize, id) else '.');
        }
        if (index % 2 == 0) id += 1;
    }

    var up: usize = 0;
    var down: usize = lines.items.len - 1;

    while (up <= down) {
        while (lines.items[up] != '.') {
            up += 1;
        }

        while (lines.items[down] == '.') {
            down -= 1;
        }
        std.mem.swap(usize, &lines.items[up], &lines.items[down]);
        up += 1;
    }

    std.mem.swap(usize, &lines.items[up - 1], &lines.items[up - 2]);

    //std.debug.print("Lines: {any}\n", .{lines.items});
    //std.debug.print("Lines: {any}\n", .{lines.items[0 .. up - 1]});

    var sum: u128 = 0;

    for (lines.items[0 .. up - 1], 0..) |val, i| {
        if (val == '.') {
            break;
        }
        sum += val * i;
        std.debug.print("{any}*{any}={any}    {any}\n", .{ i, val, i * val, sum });
    }

    std.debug.print("Sums: {any}\n", .{sum});

    return sum;
}

fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'A'...'Z' => c - 'A' + 10,
        'a'...'z' => c - 'a' + 10,
        else => std.math.maxInt(u8),
    };
}

test "part_1" {
    std.debug.print("Result: {any}\n", .{part_1(std.testing.allocator, "2333133121414131402")});
}
