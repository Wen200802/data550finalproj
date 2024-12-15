FROM rocker/r-ver:4.4.0

RUN apt-get update && apt-get install -y \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	libgit2-dev \
	pandoc \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /project
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

CMD make && mv report.html final_report