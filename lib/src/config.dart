import 'package:flutter/material.dart';

const brickColors = [
  Color(0xffFF206E), // Vivid Neon Pink  
  Color(0xffFBFF12), // Bright Cyber Yellow  
  Color(0xff00F5D4), // Electric Aqua  
  Color(0xff8338EC), // Bold Deep Purple  
  Color(0xffFF5700), // Futuristic Orange  
  Color(0xff06D6A0), // Neon Mint Green  
  Color(0xff3A86FF), // Vibrant Royal Blue  
  Color(0xffEF233C), // Striking Crimson Red  
  Color(0xff8D99AE), // Cool Modern Gray  
  Color(0xffFFD166), // Soft Warm Gold  
];





// Colors specifically for indestructible bricks
const indestructibleBrickColors = [
  Color(0xffEF233C), // Striking Crimson Red 
  Color(0xff00F5D4), // Electric Aqua  
   Color(0xffFF5700), // Futuristic Orange  
];

const gameWidth = 820.0;
const gameHeight = 1600.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.2;
const batHeight = ballRadius * 1;
const batStep = gameWidth * 0.05;
const brickGutter = gameWidth * 0.035;

// Adjusted brick width to ensure correct spacing
final brickWidth =
    (gameWidth - (brickGutter * (brickColors.length + 2))) / brickColors.length;

const brickHeight = gameHeight * 0.03;
const difficultyModifier = 1.05;

// Function to generate bricks with 50% being indestructible