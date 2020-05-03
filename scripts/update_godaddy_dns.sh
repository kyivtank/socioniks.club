#/bin/bash
echo "Current State Before"
curl --silent -X GET -H"Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@"|jq . --color-output|tee before.txt

IP=`cat terraform/terraform.out |grep PUBLIC_IP |sed 's/PUBLIC_IP = //'|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
echo "Changing IP to $IP for domain $GD_DOMAIN"
curl --silent -X PUT "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@" -H "accept: application/json" -H "Content-Type: application/json" -H "Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" -d "[ { \"data\": \"$IP\", \"port\": 1, \"priority\": 1, \"protocol\": \"string\", \"service\": \"string\", \"ttl\": 3600, \"weight\": 1 }]"
# CAA not available yet in API calls
#curl --silent -X PUT "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/CAA/@" -H "accept: application/json" -H "Content-Type: application/json" -H "Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" -d "[ { \"data\": \"128 issue letsencrypt.org\", \"port\": 1, \"priority\": 1, \"protocol\": \"string\", \"service\": \"string\", \"ttl\": 3600, \"weight\": 1 }]"

echo "Current State After"
curl --silent -X GET -H"Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@"|jq . --color-output|tee after.txt

if ! diff after.txt before.txt; 
 then 
  echo DNS Updated.. Waiting for 3 minutes
  sleep 180
 fi

