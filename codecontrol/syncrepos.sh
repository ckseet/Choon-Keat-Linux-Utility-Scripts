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
	echo -e "REPO_FLAG,LOCAL_DIRECTORY,REMOTE_OWNER,CURRENT_USER,REPO_NAME"
	echo -e "\tREPO_FLAG : b|g , b for bitbucket.org, g for github.com"
	echo -e "\tLOCAL_DIRECTORY : Path to current repo"
	echo -e "\tREMOTE_OWNER : Owner of repository"
	echo -e "\tCURRENT_USER : User account to sync repositories"
	echo -e "\tREPO_NAME : This is the LOCAL Directoryname - Needs to Be contiguous and no special characters"
}

# Error Checking
if [ $# -ne 1 ]
then
	printUsage
	exit 1
fi
INPUT_FILE=$1

EXPECTED_ENTRY_COLUMNS= 5
ERROR_FLAG_REPO_ENTRY="ERROR_REPO_FORMAT"
ERROR_FLAG_REPO="E";

run_flag="Y" 

while read line
do
	processing "$line"
	# check number of cols
	num_col =`echo $line  | awk '{split($),lineArray, ",");print length(lineArray);}'`
	if [ $num_col -ne $EXPECTED_ENTRY_COLUMNS ]
	then
		run_flag = $ERROR_FLAG_REPO		
	
		echo "Error : Wrong number of arguments for line $line"
		echo ""
		printUsage
		exit 1
	fi
	
done < $INPUT_FILE
