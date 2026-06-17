#-------------------------------------------------------------------------------------------------
#--Script Name   : oh_backup.sh
#--Description   : Script to take Oracle Home Backup with timestamp
#--Args          : None
#--Author        : Abhilash Kumar Bhattaram
#--Email         : abhilash8@gmail.com                                           
#-------------------------------------------------------------------------------------------------
# Run as Root user (Doc ID 565017.1)
export NOW=$(date +"%Y_%m_%d_%H%M%S")
export ip=`hostname -i`
export host=`hostname`
df -h /u01
ls -l /u01

### Tar Backup For DB & GI Home in /u01
export bkp_dir=/nfs_backup/oh_backup
cd /u01
tar -pcvf ${bkp_dir}/u01appbkp_${host}_${ip}_${NOW}.tar app 
