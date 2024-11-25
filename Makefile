.PHONY: all clean


all: output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds output/report.html

install:
	Rscript -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv'); renv::restore()"

output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds: code/makeoutput.R code/Alzheimer_s_Disease_Part_1.csv code/Alzheimer_s_Disease_Part_2.csv code/Alzheimer_s_Disease_Part_3.csv code/Alzheimer_s_Disease_Part_4.csv
	Rscript code/makeoutput.R

output/report.html: code/renderreport.R output/summary_table.rds output/topic_frequency_plot.rds output/question_frequency_plot.rds
	Rscript code/renderreport.R

clean:
	rm -f output/*.rds output/report.html


