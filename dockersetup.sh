echo " {\n"\
         "  \"gateway_conf\": {\n" \
         "      \"gateway_ID\": \"${gateway_ID}\",\n" \
         "      \"server_address\": \"${server_address}\",\n" \
         "      \"serv_port_up\": ${serv_port_up},\n" \
         "      \"serv_port_down\": ${serv_port_down}\n" \
         "    }\n"\
         "  }\n" > /home/middleman/configs/config.json

echo "middleman_ENVs=\"${middleman_ENVs}\"" > /home/middleman/middleman.conf
cat /home/middleman/configs/config.json && cat /home/middleman/middleman.conf
