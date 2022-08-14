#https://github.com/curiousfokker/helium-DIY-middleman.git
FROM ubuntu:latest

LABEL org.opencontainers.image.source="https://github.com/sblanchard/helium-DIY-middleman"
LABEL org.opencontainers.image.description="Middleman between LoRa gateways running Semtech packet forwarders and servers ingesting packet forwarder data"
LABEL org.opencontainers.image.authors="sblanchard"

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV PATH="/usr/bin:${PATH}"

# Specify Middleman Environment Variables
ENV middleman_port=1681
ENV middleman_tx_adjust='--tx-adjust -25'
ENV middleman_rx_adjust='--rx-adjust -35'
ENV middleman_ENVs="${middleman_tx_adjust} ${middleman_rx_adjust}"

# Service Virtual Environment Variables
ENV gateway_ID=AA555A0000000000
ENV server_address="helium-miner"
ENV serv_port_up=1680
ENV serv_port_down=1680

# Open Middleman Listening Ports
 #Use "-p 1681:1681/udp" for example at run time instead
EXPOSE ${middleman_port}:${middleman_port}/udp
EXPOSE 1681
EXPOSE 1680
# Echo Path
RUN echo ${PATH}

# Update Packages
RUN apt-get update && apt-get install -y apt-utils && apt-get -y -f -m --show-progress full-upgrade

# Install Supporting Software
RUN apt-get install -y git cmake make htop wget python3 python3-pip python3-dev systemctl gcc curl gpg
# Fix Python3 and Python3-pip
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools

# Install Middle-Man
RUN git clone https://github.com/sblanchard/helium-DIY-middleman.git
RUN cd /helium-DIY-middleman && make install
RUN rm /home/middleman/configs/*.example > /dev/null

RUN cd /helium-DIY-middleman/ && chmod +x ./dockersetup.sh
RUN cd /helium-DIY-middleman/ && cat ./dockersetup.sh
CMD ["/bin/bash", "/helium-DIY-middleman/dockersetup.sh"]
