if [ $1 -eq 1 ]
then

	sed -ir "s%	#---End of Aliases---#%\talias $2\=\'$3\'\n\t#---End of Aliases---#%g" ~/repos/aliases/linux/bash_aliases

else

	sed -ir "s%	#---End of Functions---#%\tfunction $2\n\t\{\n\t\t$3\n\t\}\n\n\t#---End of Functions---#%g" ~/repos/aliases/linux/bash_aliases

fi

