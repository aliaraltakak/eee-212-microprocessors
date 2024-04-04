# EEE212 Microprocessors Laboratory Exercises

This repository contains code for laboratory exercises as part of the EEE212 Microprocessors course. Each lab exercise is designed to enhance students' understanding of microprocessors, 
specifically working with the 8051 microcontroller, its timers, and interfacing with various components using Proteus simulation software.

## Lab 1: Working with Hexadecimal Numbers and Date Calculations

### Part 1: Sum of Digits in a Hexadecimal Number 

- **Objective:** Write a program to sum the digits of a hexadecimal number in its decimal representation.
- **Tools Used:** MCU 8051 IDE simulator.
- **Example:** For an input of `55h`, the program should output `0Dh` in register R1, indicating the sum of digits `13` in decimal.

### Part 2: Determining the Date from a Day Number 

- **Objective:** Given an input number representing the index of the day in the year 2024, display the corresponding month and day, along with the weekday, on an LCD.
- **Tools Used:** Proteus simulation software for displaying results on an LCD and taking inputs from a keypad.
- **Example:** For an input of `302`, the LCD should display `OCT 28 MON`, indicating the 302nd day of 2024 falls on October 28th, a Monday.

## Lab 2: Timers and Countdown System

### Part 1: Generating Square Waveforms 

- **Objective:** Generate two square waveforms with specified frequencies and duty cycles simultaneously on pins P2.6 and P2.7, changing characteristics with a switch.
- **Tools Used:** Proteus software for simulation, including the Digital Oscilloscope for displaying waveforms.
- **Switch Configuration:**
  - When the switch is 0 (open): Generate waveforms with frequencies defined by `f1()` and `f2()` and a 50% duty cycle.
  - When the switch is 1 (closed): Generate waveforms with frequencies defined by `f1()` and `f2()` and a 25% duty cycle.

### Part 2: Countdown System 

- **Objective:** Construct a countdown system taking a time input (1-15 seconds) from a keyboard and display the countdown on an LCD, ending with "LAUNCH!".
- **Tools Used:** Proteus simulation software for input and LCD display.
- **Key Feature:** The countdown must be implemented using timers, with updates every 0.5 seconds.

