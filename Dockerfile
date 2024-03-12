FROM intersystems/irishealth-community:2023.1
WORKDIR /mnt

# Copy all necessary files/folders
COPY Samples /mnt/Samples
COPY src /mnt/src
COPY query.sql /mnt/query.sql
COPY setup.sh /mnt/setup.sh
COPY merge.cpf /mnt/merge.cpf

# Change temporarily to root
USER root
# Create necessary log file
RUN touch iris-main.log
# Create ENHRINTEROP folder to use as database
RUN mkdir /usr/irissys/mgr/EHRINTEROP
# Change ownership for all new files/folders
RUN chown irisowner:irisowner iris-main.log /usr/irissys/mgr/EHRINTEROP
# Install dependencies
RUN apt-get update && apt-get install dos2unix
RUN dos2unix setup.sh
# Change back to irisowner
USER irisowner

ENTRYPOINT [ "/tini", "--", "/iris-main", "-b", "/mnt/setup.sh" ]