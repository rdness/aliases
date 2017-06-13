# --- Verify curl is installed
if [[ -z `command -v curl` ]]; then
    echo "curl not installed. Installing curl"
    sudo apt-get install curl
fi

# --- Establish Hue group IDs
export HUEKITGROUP="1"
export HUEBEDGROUP="2"

#-- -Hue commands
function bedon
{
	if [[ $1 -gt 0 ]]; then
		curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/1/action -d '{ "on": true, "bri": '$1',"effect": "none"}' &> /dev/null
	else
		curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/1/action -d '{ "on": true, "bri": 254, "effect": "none"}' &> /dev/null
	fi
}		

function bedoff
{
	curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/1/action -d '{ "on": false, "effect": "none"}' &> /dev/null
}		

function kiton
{
	if [[ $1 -gt 0 ]]; then
		curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/2/action -d '{ "on": true, "bri": '$1',"effect": "none"}' &> /dev/null
	else
		curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/2/action -d '{ "on": true, "bri": 254, "effect": "none"}' &> /dev/null
	fi
}	

function kitoff
{
	curl -X PUT -H "Content-type: application/json" http://$HUESERVER/api/$HUEKEY/groups/2/action -d '{ "on": false, "effect": "none"}' &> /dev/null
}
