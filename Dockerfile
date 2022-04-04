FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

# Service Specific Environment Variables
ARG gateway_ID=AA555A0000000000
ARG server_address=localhost
ARG serv_port_up=1680
ARG serv_port_down=1680
ARG middleman_port=1681

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Update Packages
RUN apt-get update && apt-get -y full-upgrade

# Install Required Supporting Software
RUN apt-get install -y git cmake make htop wget python3 python3-pip

# Install Middle-Man
RUN git clone https://github.com/curiousfokker/helium-DIY-middleman.git
RUN cd /helium-DIY-middleman
RUN sudo make install
RUN rm /home/middleman/configs/*.json
RUN echo '{
        "gateway_conf": {
                "gateway_ID": "${gateway_ID}",
                "server_address": "${server_address}",
                "serv_port_up": ${serv_port_up},
                "serv_port_down": ${serv_port_down}
         }
}'> /home/middleman/configs/config.json
RUN systemctl enable middleman
RUN systemctl start middleman

# Open Middleman Listening Ports
EXPOSE ${middleman_port}:1681
#EXPOSE 1681
