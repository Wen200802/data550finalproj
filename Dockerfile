FROM rocker/r-ubuntu

RUN apt-get update && apt-get install -y pandoc

RUN mkdir/project
WORKDIR /project

RUN mkdir code
RUN mkdir output

#copy all relevant files
COPY code code
COPY Makefile .
COPY report.Rmd .

COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.json renv

RUN Rscript -e "renv::restore(prompt=FALSE)"

RUN mkdir final_report

CMD make && mv report.html final report