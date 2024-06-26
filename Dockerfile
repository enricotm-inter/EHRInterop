FROM intersystems/irishealth-community:2023.1
WORKDIR /mnt

# Copy all necessary files/folders
COPY Samples /mnt/Samples
COPY src /mnt/src
COPY query.sql /mnt/query.sql
COPY setup.sh /mnt/setup.sh

# Change temporarily to root
USER root
# Create necessary log file and change ownership
RUN touch iris-main.log
RUN chown irisowner:irisowner iris-main.log
# Install dependencies
RUN apt-get update && apt-get install dos2unix
# Configure setup.sh to be executable and use LF
RUN chmod +x setup.sh
RUN dos2unix setup.sh
# Change back to irisowner
USER irisowner

ENTRYPOINT [ "/tini", "--", "/iris-main", "-a", "/mnt/setup.sh" ]