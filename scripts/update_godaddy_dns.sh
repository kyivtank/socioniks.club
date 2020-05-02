#/bin/bash
echo "Current State Before"
curl --silent -X GET -H"Authorization: sso-key $GD_API_KEY:$GD_API_SECRET" "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@"|jq . --color-output

IP=`cat terraform/terraform.out |grep PUBLIC_IP |sed 's/PUBLIC_IP = //'|sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
echo "Changing IP to $IP for domain $GD_DOMAIN"
curl --silent -X PUT "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@" -H "accept: application/json" -H "Content-Type: application/json" -H "Authorization: sso-key $GD_API_KEY:$GD_API_SECRET" -d "[ { \"data\": \"$IP\", \"port\": 1, \"priority\": 1, \"protocol\": \"string\", \"service\": \"string\", \"ttl\": 3600, \"weight\": 1 }]"

echo "Current State After"
curl --silent -X GET -H"Authorization: sso-key $GD_API_KEY:$GD_API_SECRET" "https://api.godaddy.com/v1/domains/$GD_DOMAIN/records/A/@"|jq . --color-output
