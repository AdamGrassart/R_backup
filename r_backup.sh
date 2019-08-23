#!/bin/sh

# ===========================================
#	-> 1.Backup_full 
#		-> mysqldump tunel
#	-> 2.Backups_incrementals
#		-> mysqldump tunel
# ===========================================

if [ !$1 ];then
	echo "You muse add a path to config file \n example : r_backup.sh 'custom.cnf'"
fi
exit 0;

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
#	FIRST FULL BACKUP
# -------------------------------------------
backup_full(){

	# CREATE MONTH FOLDER 
	mkdir_if_noExist ${dirToSave}${month_year_now}	

	# FULL BACKUP RSYNC
	rsync ${options} \
	--timeout=90 \
	"${sshOptions}" \
	${saveFromSource} \
	${dirToSave}${month_year_now}/${date_now} \
	--log-file=${dirToSave}${month_year_now}/${date_now}/backup.log

	# DATABASE 
	ssh ${sshLoginHost} \
	-p ${sshPort} \
	"mysqldump ${groupMysql} \
	--compress ${dbName}"| xz > ${dirToSave}${month_year_now}/${date_now}/backup.sql.7z
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
	--timeout=90 \
	"${sshOptions}" \
	--link-dest=${dirToSave}${month_year_now}/${date_prev} \
	${saveFromSource} \
	${dirToSave}${month_year_now}/${date_now} \
	--log-file=${dirToSave}${month_year_now}/${date_now}/backup.log

	# DATABASE 
	ssh ${sshLoginHost} \
	-p ${sshPort} \
	"mysqldump ${groupMysql} \
	--compress ${dbName}"| xz > ${dirToSave}${month_year_now}/${date_now}/backup.sql.7z
}

if [ $(( $day_now )) = $(( $firstDayMonth )) ];then
	backup_full
else
	backup_incremental
fi