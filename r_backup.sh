#!/bin/sh

# -------------------------------------------
#	CHECK PATH TO CONFIG FILE AND LOAD
# -------------------------------------------
if [ -z "$1" ];then
	echo "You muse add a path to config file \n \
		  example : r_backup.sh 'custom.cnf'"
	exit 1;
else
	. $1
fi


# -------------------------------------------
#	FUNC TOOLS
# -------------------------------------------
mkdir_if_noExist(){
	if [ ! -d "$1" ];then
		mkdir $1
	fi
}

# -------------------------------------------
#	BUILD INTERNAL VARIABLES FROM file.ini
# -------------------------------------------
date_now=`date +%d-%m-%Y`
day_now=`date +%d`
month_year_now=`date +%m-%Y`

# -------------------------------------------
#	DUMP DATA 
# -------------------------------------------
mysqldump(){
	# DATABASE 
	ssh ${sshLoginHost} \
	-p ${sshPort} \
	"mysqldump ${groupMysql} \
	--compress ${dbName}"| xz > ${dirToSave}${month_year_now}/${date_now}/backup.sql.7z
}

# -------------------------------------------
#	FIRST FULL BACKUP
# -------------------------------------------
backup_full(){

	# CREATE MONTH FOLDER 
	mkdir_if_noExist ${dirToSave}${month_year_now}/${date_now}

	# FULL BACKUP RSYNC
	rsync ${options} \
	"${sshOptions}" \
	${saveFromSource} \
	${dirToSave}${month_year_now}/${date_now} \
	--log-file=${dirToSave}${month_year_now}/${date_now}/backup.log
}

# -------------------------------------------
#	INCREMENTALES BACKUPS
# -------------------------------------------
backup_incremental(){
	date_prev=`date -d "-1 day" +%d-%m-%Y`

	# avoid bug with --log-file
	mkdir_if_noExist ${dirToSave}${month_year_now}/${date_now}

	# RSYNC 
	rsync ${options} \
	"${sshOptions}" \
	--link-dest=${dirToSave}${month_year_now}/${date_prev} \
	${saveFromSource} \
	${dirToSave}${month_year_now}/${date_now} \
	--log-file=${dirToSave}${month_year_now}/${date_now}/backup.log
}

# -------------------------------------------
#  STRUCTURE PROGRAM
# -------------------------------------------
if [ $(( $day_now )) = $(( $firstDayMonth )) ];then
	backup_full
	mysqldump
else
	backup_incremental
	mysqldump
fi