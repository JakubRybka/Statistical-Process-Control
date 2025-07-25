
# Statistical Control Process

This repository contains an R script to analyze process data using Statistical Process Control (SPC) techniques.

## Features

- Reads measurement data from a CSV file.
- Constructs:
  - **X̄ (mean) Chart**
  - **R (range) Chart**
- Automatically identifies and removes out-of-control samples.
- Recalculates cleaned control limits.
- Computes:
  - Estimated process mean and standard deviation.
  - Process capability indices **Cp** and **Cpk**.
  - Defective parts per million (PPM).

## Input

CSV file: `Data.csv`

- Expected to be semicolon-separated (`;`) with comma decimal (`dec=','`).
- Must contain at least the following columns:
  - `Sample`: Sample identifier (grouping variable)
  - `Measurement`: Individual measurements

## Setup & Usage

1. Place `IS23_PCB.csv` in the working directory.
2. Run the R script:
   ```r
   source("control_chart_analysis.R")
   ```

## Output

- X̄ and R control charts (before and after outlier removal)
- Console output:
  - Control limits
  - Process capability indices (**Cp**, **Cpk**)
  - Estimated standard deviation
  - Defective parts per million (PPM)


