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
	echo -e "REPO_FLAG,REMOTE_CONFIG,CURRENT_USER,PATH_TO_LOCAL_REPO"
	echo -e "\tREPO_FLAG : b|g , b for bitbucket.org, g for github.com"
	echo -e "\tREMOTE_CONFIG : Path to git bitbucket config"
	echo -e "\tCURRENT_USER : User account to sync repositories"
	echo -e "\tPATH_TO_LOCAL_REPO: Path to current repo"
	# echo -e "\tREMOTE_OWNER : Owner of repository"
	#echo -e "\tREPO_NAME : This is the LOCAL Directoryname - Needs to Be contiguous and no special characters"
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

EXPECTED_ENTRY_COLUMNS=4
ERROR_FLAG_REPO_ENTRY="ERROR_REPO_FORMAT"
ERROR_FLAG_REPO="E";

run_flag="Y" 

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

	repoFlag=`echo $line | awk '{split($0,lineArray, ","); print lineArray[1]; }'`
	remoteConfig=`echo $line | awk '{split($0,lineArray, ","); print lineArray[2]; }'`
	currentUser=`echo $line | awk '{split($0,lineArray, ","); print lineArray[3]; }'`
	pathToLocalRepo=`echo $line | awk '{split($0,lineArray, ","); print lineArray[4]; }'`
	gitFldr=`echo $remoteConfig | awk '{split($0,urlArray, "\/"); print urlArray[length(urlArray)];}' | awk '{split($0,nameArray,".git"); print nameArray[1];}'`
	# Only git functionality for now
	if [ $DEBUG_FLAG == $YES ]
	then
		echo "repoFlag : $repoFlag"
		echo "remoteConfig : $remoteConfig"
		echo "currentUser : $currentUser"
		echo "pathToLocalRepo : $pathToLocalRepo"
		echo "gitFldr : $gitFldr"
	fi

	if [ -d $pathToLocalRepo ]
	then
		cd $pathToLocalRepo/$gitFldr 
		git pull 

	else
		mkdir -p $pathToLocalRepo
		cd $pathToLocalRepo
		git clone $remoteConfig
	fi
	
done < $INPUT_FILE
