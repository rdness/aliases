#--- Hue commands
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
