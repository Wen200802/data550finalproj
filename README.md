# Alzheimer's Disease and Healthy Aging Data Analysis

This project focuses on analyzing data related to Alzheimer's disease and healthy aging, particularly examining cognitive decline across various demographics. The project utilizes R scripts to process and analyze data, and the final output includes summary statistics, visual plots, and a detailed HTML report.

## Project Structure

Original Dataset: [Alzheimer's Disease and Healthy Aging Data](https://data.cdc.gov/Healthy-Aging/Alzheimer-s-Disease-and-Healthy-Aging-Data/hfr9-rurv/data_preview)

The project directory contains the following structure:

```
project_directory/
  ├── code/
  │     ├── Alzheimer_s_Disease_Part_1.csv
  │     ├── Alzheimer_s_Disease_Part_2.csv
  │     ├── Alzheimer_s_Disease_Part_3.csv
  │     ├── Alzheimer_s_Disease_Part_4.csv
  │     ├── makeoutput.R      # Script to generate the RDS files
  │     └── renderreport.R    # Script to render the HTML report
  ├── output/
  │     ├── summary_table.rds
  │     ├── topic_frequency_plot.rds
  │     └── question_frequency_plot.rds
  ├── report.html
  └── Makefile
```

### Prerequisites

- R version >= 4.0.0
- Required R packages: `here`, `data.table`, `dplyr`, `ggplot2`, `labelled`, `gtsummary`, `stringr`
- The project uses the `renv` package to ensure reproducibility by managing the package environment


### How to Run the Project

This project involves two main steps: data processing and report generation. You can run these steps using the provided R scripts or use the Makefile for automation.

#### Step 0: Restore Package Environment

To ensure you have the correct package versions used in this project, run the following command:
```r
renv::restore()
```
This will synchronize your local package environment with the versions specified in the lock file.

#### Step 1: Set Up the Project Environment
Make sure all required CSV files (`Alzheimer_s_Disease_Part_1.csv` to `Alzheimer_s_Disease_Part_4.csv`) are located in the `code/` directory.

#### Step 2: Run the Analysis Using R Scripts
- **Generate Outputs**:
  - The script `makeoutput.R` reads the CSV files, merges them, and generates three `.rds` files.
  - To run the script:
    ```r
    source("code/makeoutput.R")
    ```
  - This script will generate the following files:
    - **`summary_table.rds`**: A summary table with relevant statistics.
    - **`topic_frequency_plot.rds`**: A topic frequency plot.
    - **`question_frequency_plot.rds`**: A question frequency plot.

- **Render the Report**:
  - The script `renderreport.R` generates an HTML report using the `.rds` files created in the previous step.
  - To run the script:
    ```r
    source("code/renderreport.R")
    ```
  - This script will generate the following file:
    - **`report.html`**: The final HTML report summarizing the analysis.

## Docker Build and Run Instructions

This project includes a Dockerfile to create a reproducible environment for generating the report.

### Build the Docker Image

To build the Docker image, run the following command in the project root directory:

```bash
docker build -t project_image .
```

### Run the Docker Container

To generate the report and save it in the local `final_report/` folder, follow these instructions based on your system:

**For Mac/Linux:**

```bash
docker run --rm -v $(pwd)/final_report:/project/final_report wen2008/project_image
```

**For Windows:**

```bash
docker run --rm -v "$(pwd)/final_report:/project/final_report" wen2008/project_image
```

### Output

- The generated report (e.g., `report.html`) will be saved in the `final_report` folder on your local machine.


### Using the Makefile

For an automated approach, use the provided `Makefile` to run the entire analysis.

- **To generate all output and report**:
  ```sh
  make all
  ```
  This command will:
  1. Run `makeoutput.R` to generate the `.rds` files.
  2. Run `renderreport.R` to generate the final HTML report.

### Output Files

1. **`output/summary_table.rds`**: Combined and processed dataset with summary information.
2. **`output/topic_frequency_plot.rds`**: A plot summarizing topic frequencies.
3. **`output/question_frequency_plot.rds`**: A plot summarizing question frequencies.
4. **`output/report.html`**: An HTML report summarizing the key findings of the analysis.

### Project Workflow Summary

1. **Data Preparation**:
   - The four CSV files are read, merged, and processed using `makeoutput.R`.
   - Output is saved as `.rds` files for efficiency.

2. **Report Generation**:
   - Summary tables and visualizations are created using `makeoutput.R`.
   - The `renderreport.R` script uses these processed data files to create the final HTML report.

3. **Automation**:
   - The `Makefile` is provided to streamline the entire workflow, making it easy to execute the entire analysis with a single command.

