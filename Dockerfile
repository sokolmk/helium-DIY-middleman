#https://github.com/curiousfokker/helium-DIY-middleman.git

FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
ENV container docker
VOLUME /home/middleman .

# Specify Middleman Environment Variables
ENV middleman_port=1681
ENV middleman_tx_adjust='--tx-adjust 0'
ENV middleman_rx_adjust='--rx-adjust 0'
ENV middleman_ENVs="${middleman_tx_adjust} ${middleman_rx_adjust}"

# Service Virtual Environment Variables
ENV gateway_ID=AA555A0000000000
ENV server_address=localhost
ENV serv_port_up=1680
ENV serv_port_down=1680

# Open Middleman Listening Ports
EXPOSE 1680:${middleman_port}
#EXPOSE 1681

# Update Packages
RUN apt-get update && apt-get -y full-upgrade

# Install Supporting Software
RUN apt-get install -y git cmake make htop wget python3 python3-pip python-dev systemctl gcc curl gpg
# Fix Python3-pip
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

# Install Middle-Man
RUN git clone https://github.com/simeononsecurity/helium-DIY-middleman.git
RUN cd /helium-DIY-middleman && make install
RUN rm /home/middleman/configs/*.example > /dev/null

#RUN echo " {\n"\
#         "  \"gateway_conf\": {\n" \
#         "      \"gateway_ID\": \"${gateway_ID}\",\n" \
#         "      \"server_address\": \"${server_address}\",\n" \
#         "      \"serv_port_up\": ${serv_port_up},\n" \
#         "      \"serv_port_down\": ${serv_port_down}\n" \
#         "    }\n"\
#         "  }\n" > /home/middleman/configs/config.json
#RUN echo "middleman_ENVs=\"${middleman_ENVs}\"" > /home/middleman/middleman.conf
#RUN cat /home/middleman/configs/config.json && cat /home/middleman/middleman.conf
CMD ["/bin/bash", "/helium-diy-middleman/middleman.sh"]

# Start Middle-Man
#Systemd broken in docker. Workarround is insecure
#RUN systemctl enable middleman
#RUN systemctl start middleman
RUN echo "python3 /home/middleman/gateways2miners.py -p 1680 -c /home/middleman/configs/" > ./middleman.sh
RUN chmod +x ./middleman.sh
RUN cat ./middleman.sh

CMD ["/bin/bash", "./middleman.sh"]
