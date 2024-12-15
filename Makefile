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

# Docker build
PROJECTFILES = report.Rmd code/makeoutput.R code/renderreport.R Makefile
RENVFILES = renv.lock renv/active.R renv/settings.json

# rule to build image
# $@ evaluates to the target name in make 
# $(<variable>) references a variable in make

project image: $(PROJECTFILES) $(RENVFILES)
    docker build -t project_image .
    touch $@ 

# rule to build the report automatically in our container
# $$(<command>) does command substitution in make

final_report/report.html: project_image
    # Mac 
    docker run -v "$$(pwd)/final_report":/project/final_report project_image
    # Windows 
    docker run -v /"$$(pwd)/final_report":/project/final_report project_image
