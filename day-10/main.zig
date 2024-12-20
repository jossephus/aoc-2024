const std = @import("std");

const Parts = enum {
    PART_1,
    PART_2,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }
    const input = @embedFile("input.txt");
    const sum_1 = try part_1(allocator, input, Parts.PART_1);
    std.debug.print("Part 1: {any}\n", .{sum_1});

    const sum_2 = try part_1(allocator, input, Parts.PART_2);
    std.debug.print("Part 2: {any}\n", .{sum_2});
}
const Save = struct {
    x: usize,
    y: usize,
};

pub fn part_1(allocator: std.mem.Allocator, input: []const u8, part: Parts) !usize {
    const row_length = 57;
    const column_length = 57;

    var abc: [row_length][column_length]usize = undefined;

    var rows: usize = 0;
    var cols: usize = 0;

    for (input) |x| {
        if (x == '\n') {
            rows += 1;
            cols = 0;
        } else {
            abc[rows][cols] = std.fmt.charToDigit(x, 10) catch 10;
            cols += 1;
        }
    }

    var saves = std.ArrayList(Save).init(allocator);
    defer saves.deinit();

    var zeroPlaces = std.ArrayList(Save).init(allocator);
    defer zeroPlaces.deinit();

    var map = std.StringHashMap(bool).init(
        allocator,
    );
    defer {
        var iter = map.keyIterator();

        while (iter.next()) |key| {
            allocator.free(key.*);
        }

        map.deinit();
    }

    var sum: usize = 0;
    for (0..abc.len) |i| {
        for (0..abc[i].len) |j| {
            if (abc[i][j] == 0) {
                const zeroI: usize = i;
                const zeroJ: usize = j;

                //               var expected: usize = abc[i][j]; // which is going to be zero
                try saves.append(.{ .x = i, .y = j });

                while (saves.items.len != 0) {
                    const save = saves.pop();
                    const x = save.x;
                    const y = save.y;

                    //std.debug.print("{any}\n", .{abc[x][y]});

                    if (abc[x][y] == 9) {
                        const s = try std.fmt.allocPrint(allocator, "{d}-{d}-{d}-{d}", .{ zeroI, zeroJ, x, y });
                        switch (part) {
                            Parts.PART_1 => {
                                if (map.get(s) == null) {
                                    sum += 1;
                                    const key = try allocator.dupe(u8, s);
                                    try map.putNoClobber(key, true);
                                } else {}
                            },
                            Parts.PART_2 => {
                                sum += 1;
                            },
                        }
                        allocator.free(s);
                        continue;
                    }

                    // bottom
                    if (x < abc.len - 1 and abc[x][y] + 1 == abc[x + 1][y]) {
                        try saves.append(.{ .x = x + 1, .y = y });
                    }

                    //// top
                    if (x > 0 and abc[x][y] + 1 == abc[x - 1][y]) {
                        try saves.append(.{ .x = x - 1, .y = y });
                    }

                    //// left
                    if (y > 0 and abc[x][y] + 1 == abc[x][y - 1]) {
                        try saves.append(.{ .x = x, .y = y - 1 });
                    }

                    //// right
                    if (y < abc[x].len - 1 and abc[x][y] + 1 == abc[x][y + 1]) {
                        try saves.append(.{ .x = x, .y = y + 1 });
                    }
                }
            }
        }
    }

    return sum;
}

test "part_1" {
    const input =
        \\89010123
        \\78121874
        \\87430965
        \\96549874
        \\45678903
        \\32019012
        \\01329801
        \\10456732
    ;
    try std.testing.expect(try part_1(std.testing.allocator, input, Parts.PART_1) == 36);
}

test "part_2" {
    const input =
        \\89010123
        \\78121874
        \\87430965
        \\96549874
        \\45678903
        \\32019012
        \\01329801
        \\10456732
    ;
    try std.testing.expect(try part_1(std.testing.allocator, input, Parts.PART_2) == 81);
}
