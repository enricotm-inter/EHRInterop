FROM intersystems/irishealth-community:2023.1
WORKDIR /mnt

COPY Samples /mnt/Samples
COPY src /mnt/src
COPY query.sql /mnt/query.sql
COPY setup.sh /mnt/setup.sh

USER root
RUN touch /mnt/iris-main.log
RUN chown irisowner:irisowner iris-main.log
RUN apt-get update && apt-get install dos2unix
RUN dos2unix setup.sh
USER irisowner

ENTRYPOINT [ "/mnt/setup.sh" ]