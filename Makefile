.PHONY: all clean install

# Default target - generate output and render the report
all: install output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds output/report.html

# Install rule - restore the package environment using renv
install:
	Rscript -e "renv::restore(prompt = FALSE)"

# Generate the output RDS files from CSV files using makeoutput.R
output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds: code/makeoutput.R code/Alzheimer_s_Disease_Part_1.csv code/Alzheimer_s_Disease_Part_2.csv code/Alzheimer_s_Disease_Part_3.csv code/Alzheimer_s_Disease_Part_4.csv
	Rscript code/makeoutput.R

# Render the HTML report using renderreport.R
output/report.html: output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds code/renderreport.R
	Rscript code/renderreport.R

# Clean target to remove all generated outputs
clean:
	rm -f output/*.rds output/report.html


