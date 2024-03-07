FROM intersystems/irishealth-community:2023.1
WORKDIR /mnt

COPY Samples /mnt/Samples
COPY src /mnt/src
COPY query.sql /mnt/query.sql
COPY setup.sh /mnt/setup.sh

ENTRYPOINT [ "/mnt/setup.sh" ]