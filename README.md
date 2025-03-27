# geo2obj

## Introduction
geo2obj is a small project that automates the process of converting LAS/DEM data into 3d file for 3D modelining and analysis of built environment with minimun coding requirement.
This project may be wrapped up in a package in the future.

What it provides:
- get lidar data only with a bbox (bounding box)
- convert lidar data to 3D DTM/DSM with a generated texture map
- adjust the resolution of the 3D output
- generate 3D output as spatial points and 3D mesh

What it will provide (in the future):
- generate building volume only with a bbox
- integrate building volumes and DTM in the 3D output

## Installation
#### Step 1: install R
R is a programming language and free software environment for statistical computing.

Download R from the [Comprehensive R Archive Network (CRAN)](https://cran.rstudio.com/). 
Choose your operating system (Windows, macOS, or Linux) and follow the installation instructions.

#### Step 2: install Rstudio
RStudio is an integrated development environment (IDE) for R.
Download RStudio from the [RStudio website](https://posit.co/download/rstudio-desktop/)

#### Step 3 (optional but required for Windows): install Rtools
Rtools is a collection of GNU build tools for Windows necessary to build R packages from source.

Download Rtools from the [CRAN Rtools page](https://cran.r-project.org/bin/windows/Rtools/)

Note: Make sure the version of Rtools is compatible with the version of R you installed. After installation, you may need to make sure Rtools is added to your system PATH (this is usually done automatically).

## Usage
