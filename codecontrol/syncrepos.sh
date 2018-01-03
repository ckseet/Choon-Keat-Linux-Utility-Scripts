#!/bin/bash
# Original Author : ckseet@gmail.com
# Version : 0.0.1
# Line Description : Script
# Number of Arguments : 1 
# Arg 1 : PATH_TO_GITREPO_CSV File path to expected input configuration file
# Argument Validation : Off
# Getopt Check : Off

function  printUsage
{
	echo -e "Usage : $0 PATH_TO_GITREPO_CSV" 
	echo -e "\tPATH_TO_GITREPO_CSV : path to csv file containing git details"
	echo -e "\nExpected Git Config CSV layout"
	echo -e "REMOTE_CONFIG,PATH_TO_LOCAL_REPO"
	echo -e "\tREMOTE_CONFIG : Path to git bitbucket config"
	echo -e "\tPATH_TO_LOCAL_REPO: Path to current repo"
}

# Error Checking
if [ $# -ne 1 ]
then
	printUsage
	exit 1
fi
INPUT_FILE=$1

YES=1
NO=0
DEBUG_FLAG=$YES

EXPECTED_ENTRY_COLUMNS=2
ERROR_FLAG_REPO_ENTRY="ERROR_REPO_FORMAT"
ERROR_FLAG_REPO="E";

run_flag="Y" 
git config --global credential.helper 'cache --timeout 3600'
while read line
do
	echo processing "$line"
	# check number of cols
	num_col=`echo $line  | awk '{split($0,lineArray, ",");print length(lineArray);}'`
	if [ $num_col -ne $EXPECTED_ENTRY_COLUMNS ]
	then
		run_flag=$ERROR_FLAG_REPO		
	
		echo "Error : Wrong number of arguments for line $line"
		echo ""
		printUsage
		exit 1
		#EXIT_MARKER
	fi

	remoteConfig=`echo $line | awk '{split($0,lineArray, ","); print lineArray[1]; }'`
	pathToLocalRepo=`echo $line | awk '{split($0,lineArray, ","); print lineArray[2]; }'`
	gitFldr=`echo $remoteConfig | awk '{split($0,urlArray, "\/"); print urlArray[length(urlArray)];}' | awk '{split($0,nameArray,"\\\.git"); print nameArray[1];}'`
	# Only git functionality for now
	if [ $DEBUG_FLAG == $YES ]
	then
		echo "remoteConfig : $remoteConfig"
		echo "pathToLocalRepo : $pathToLocalRepo"
		echo "gitFldr : $gitFldr"
	fi

	if [ -d $pathToLocalRepo/$gitFldr ]
	then
		cd $pathToLocalRepo/$gitFldr 
		git pull 

	else
		mkdir -p $pathToLocalRepo
		cd $pathToLocalRepo
		git clone $remoteConfig
	fi
	
done < $INPUT_FILE
