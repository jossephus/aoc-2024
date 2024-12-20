const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = "814 1183689 0 1 766231 4091 93836 46";
    const sum = try part_1(allocator, input, 75);
    std.debug.print("Sum is: {any}\n", .{sum});
}

pub fn part_1(allocator: std.mem.Allocator, input: []const u8, total_blinks: usize) !usize {
    var it = std.mem.tokenizeScalar(u8, input, ' ');

    var numbers = std.ArrayList(usize).init(allocator);
    defer numbers.deinit();

    while (it.next()) |num| {
        try numbers.append(try std.fmt.parseInt(usize, num, 10));
    }

    var blink_counter: usize = 0;

    while (blink_counter < total_blinks) : (blink_counter += 1) {
        var i: usize = 0;
        while (i < numbers.items.len) : (i += 1) {
            const num: usize = numbers.items[i];
            const s = try std.fmt.allocPrint(allocator, "{d}", .{num});
            defer allocator.free(s);

            if (num == 0) {
                try numbers.replaceRange(i, 1, &[1]usize{1});
            } else if (s.len % 2 == 0) {
                const first_half = try std.fmt.parseInt(usize, s[0 .. s.len / 2], 10);
                const second_half = try std.fmt.parseInt(usize, s[s.len / 2 ..], 10);

                try numbers.replaceRange(i, 1, &[2]usize{ first_half, second_half });
                i += 1;
            } else {
                try numbers.replaceRange(i, 1, &[1]usize{num * 2024});
            }
        }
        std.debug.print("Done: Blink Counter: {d}\n", .{});
    }

    std.debug.print("Length is {any}\n", .{numbers.items.len});

    return numbers.items.len;
}

test "part_1" {
    const input = "814 1183689 0 1 766231 4091 93836 46";

    try std.testing.expect(try part_1(std.testing.allocator, input, 25) == 55312);
}
