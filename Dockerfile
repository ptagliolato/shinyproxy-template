FROM openanalytics/r-base

#MAINTAINER Tobias Verbeke "tobias.verbeke@openanalytics.eu"
MAINTAINER ptagliolato

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    software-properties-common

RUN apt-get update && add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev 

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

# install dependencies of the euler app
RUN R -e "install.packages('Rmpfr', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('shinyjs')"
RUN R -e "install.packages('leaflet')"
RUN R -e "install.packages('leaflet.extras')"
RUN R -e "install.packages('osmdata')"
RUN R -e "install.packages('sf')"
RUN R -e "install.packages('sp')"
RUN R -e "install.packages('RColorBrewer')"
RUN R -e "install.packages('rgdal')"
RUN R -e "install.packages('shinydashboard')"
RUN R -e "devtools::install_github('RinteRface/shinydashboardPlus', force = TRUE)"
RUN R -e "devtools::install_github('andrewsali/shinycssloaders')"
# copy the app to the image
RUN mkdir /root/euler
#COPY euler /root/euler
COPY TELLme-vlab-OSMDataFromRelatedConcept root/TELLme-vlab-OSMDataFromRelatedConcept

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/TELLme-vlab-OSMDataFromRelatedConcept')"]
