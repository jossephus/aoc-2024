use std::fs;

use nom::character::complete::char;
use nom::{
    bytes::complete::tag,
    character::complete::{alpha1, digit1},
    combinator::map,
    sequence::tuple,
    IResult,
};

#[derive(Debug)]
pub struct Button {
    x: i128,
    y: i128,
}

impl Button {
    fn parse(ch: char, input: &str) -> IResult<&str, Self> {
        let (input, _) = tag(format!("Button {ch}: ").as_str())(input)?;

        map(
            tuple((equation, char(','), char(' '), equation)),
            |(x, _, _, y)| Button { x, y },
        )(input)
    }
}

#[derive(Debug)]
pub struct Prize {
    x: i128,
    y: i128,
}

impl Prize {
    fn parse(input: &str) -> IResult<&str, Self> {
        let (input, _) = tag("Prize: ")(input)?;
        map(
            tuple((assign, char(','), char(' '), assign)),
            |(x, _, _, y)| Prize { x, y },
        )(input)
    }
}

#[derive(Debug)]
pub struct Information {
    a: Button,
    b: Button,
    prize: Prize,
}

impl Information {
    fn calculate(self: &Self) -> Result<f32, String> {
        let (a1, b1, c1, a2, b2, c2) = (
            self.a.x,
            self.b.x,
            self.prize.x,
            self.a.y,
            self.b.y,
            self.prize.y,
        );

        let determinant: f32 = (a1 * b2 - a2 * b1) as f32;

        let x = (c1 * b2 - c2 * b1) as f32 / determinant;
        let y = (a1 * c2 - a2 * c1) as f32 / determinant;

        if x.floor() != x.ceil() || y.floor() != y.ceil() {
            return Err("Failed".to_string());
        }

        Ok(3 as f32 * x + 1 as f32 * y)
    }

   fn parse(input: &str) -> IResult<&str, Information> {
        let (input, a) = Button::parse('A', input).unwrap();

        let (input, _) = char('\n')(input)?;

        let (input, b) = Button::parse('B', input).unwrap();

        let (input, _) = char('\n')(input)?;

        let (input, prize) = Prize::parse(input).unwrap();

        Ok((
            input,
            Self {
                a,
                b,
                prize,
            },
        ))
    }
}

fn main() {
    let data = fs::read_to_string("input.txt").unwrap();

    let sum = data
        .split("\n\n")
        .map(|x| x)
        .collect::<Vec<&str>>()
        .into_iter()
        .map(|x| Information::parse(x).unwrap().1.calculate())
        .filter_map(|x| x.ok())
        .map(|x| x)
        .sum::<f32>();

    println!("{}", sum);
}

fn equation(input: &str) -> IResult<&str, i128> {
    map(
        tuple((alpha1::<&str, _>, char('+'), digit1)),
        |(_, _, number)| number.parse::<i128>().unwrap(),
    )(input)
}

fn assign(input: &str) -> IResult<&str, i128> {
    map(
        tuple((alpha1::<&str, _>, char('='), digit1)),
        |(_, _, number)| (number).parse::<i128>().unwrap(),
    )(input)
}
