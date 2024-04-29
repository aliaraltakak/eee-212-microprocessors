# EEE212 Microprocessors Laboratory Exercises

This repository contains code for laboratory exercises as part of the EEE212 Microprocessors course. 

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


## Lab 3: Binary LED Counter

- **Objective:** Construct a 4-bit binary LED counter system that can count up or down, with varying speed; depending on the switch conditions.
- **Tools Used:** Keil microVision software for coding environment, NXP FRDM KL25Z microcontroller for the main system, LEDs and a switch on a breadboard for physical implementation.
- **Switch Configuration:**
  - Switch 1 controls the counting order, that is, up or down.
  - Switches 2 and 3 control the counting speed.

## Lab 4: Servo Motor Control

- **Objective:** Design a servo motor control unit which will rotate on two states:
  - **State 1:** The servo will rotate between angles 0-30-60-90-60-30-0 continuously, with a time interval of 0.5 seconds between each angle.
  - **State 2:** The servo will rotate between angles 180-150-120-90-120-150-180 continuously, with a time interval of 0.5 seconds between each angle.
- **Details:** The servo state is determined by an external button, whereas the status of the button triggers an interrupt service. I have used the internal timer TPM1 to generate pulse signals, and used the SysTick timer to generate the required delay between the movements.
- **Tools Used:** Keil microVision software for coding environment, NXP FRDM KL25Z microcontroller for the main system, SG90 servo motor and a simple push button for physical implementation.
