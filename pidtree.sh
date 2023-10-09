RPID=$(systemctl show --property MainPID --value jupyterhub-dev.service)
regex='s!^([^a-zA-Z0-9\s]*)([a-zA-Z0-9_-]*),?([[:digit:]]*) ?([/[_0-9a-zA-Z-]*]*)(.*)'
while read -r line; do 
	if [ "$1" = "--inspect" ]; then
		echo $line | sed -r "$regex!\1..\2..\3..\4..\5!"
	else
		#echo $line | sed 's/^[^a-z]*[a-z]+,\(\d+\)/\1/'
		tree=$(echo $line | sed -r "$regex!\1!")
		name=$(echo $line | sed -r "$regex!\2!")
		pid=$(echo $line | sed -r "$regex!\3!")
		user=$(ps -o uname= -p $pid)
		mem=$(ps -o %mem -p $pid | xargs)
		cpu=$(ps -o %cpu -p $pid | xargs)
		arg1=$(echo $line | sed -r "$regex!\4!")
		rest=$(echo $line | sed -r "$regex!\5!")
		red='\033[0;31m'
		green='\033[0;32m'
		blue='\033[0;34m'
		nc='\033[0m'
		echo -e "$red$tree $user $name $green$arg1 $blue$mem $cpu $nc$rest" 
	fi
done < <(pstree -cUTpa $RPID)
read p

# get pid
# if node, take the first argument


