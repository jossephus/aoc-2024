const std = @import("std");
const mvzr = @import("mvzr");

pub fn main() !void {
    const regex: mvzr.Regex = mvzr.compile("abced").?;
    _ = regex;

    const input = @embedFile("input.txt");
    const sum = try part_2(input);
    std.debug.print("{any}", .{sum});
}

pub fn part_1(input: []const u8) !i32 {
    var r_iter = mvzr.compile("mul\\(\\d+,\\d+\\)").?.iterator(input);

    var sum: i32 = 0;

    while (r_iter.next()) |m| {
        const index = std.mem.indexOf(u8, m.slice, "mul(").?;

        const comma = std.mem.indexOf(u8, m.slice, ",").?;

        const first = try std.fmt.parseInt(i32, m.slice[index + 4 .. comma], 10);

        const end = std.mem.indexOf(u8, m.slice, ")").?;
        const second = try std.fmt.parseInt(i32, m.slice[comma + 1 .. end], 10);

        sum += (first * second);
    }
    return sum;
}

pub fn part_2(input: []const u8) !i32 {
    var r_iter = mvzr.compile("mul\\(\\d+,\\d+\\)").?.iterator(input);

    var sum: i32 = 0;
    var start: usize = 0;

    loop: while (r_iter.next()) |m| {
        const index = std.mem.indexOf(u8, m.slice, "mul(").?;

        const regex = mvzr.compile("don't").?;

        const dont_match = regex.match(input[start..m.start]);

        if (dont_match != null) {
            const regex_do = mvzr.compile("do").?;
            const do_match = regex_do.match(input[start..m.start]);

            if (do_match != null and do_match.?.start > dont_match.?.start) {
                start = do_match.?.start;
            } else {
                start = dont_match.?.start;
                continue :loop;
            }
        }

        const do = mvzr.compile("do");
        _ = do;

        const comma = std.mem.indexOf(u8, m.slice, ",").?;

        const first = try std.fmt.parseInt(i32, m.slice[index + 4 .. comma], 10);

        const end = std.mem.indexOf(u8, m.slice, ")").?;
        const second = try std.fmt.parseInt(i32, m.slice[comma + 1 .. end], 10);
        std.debug.print("{any} {any}\n", .{ first, second });

        sum += (first * second);
    }
    return sum;
}

test "part_1" {
    const input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";

    try std.testing.expect(try part_1(input) == 161);
}
