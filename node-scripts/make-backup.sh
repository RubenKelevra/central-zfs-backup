#!/bin/bash

source ../options.sh

echo "checking preconditions..."
`rsync --version >/dev/null`
if test $? -ne 0; then
	echo "no rsync found."
	exit 1
fi

echo "we need the cold-storage-node. Informing control-vm...."
ssh $CONTROL_NODE_SSHUSER@$CONTROL_NODE_HOSTNAME:$CONTROL_NODE_SSHPORT $SSH_OPTIONS "touch $CONTROL_NODE_NOTIFYFOLDER/start-cold-storage-node"
if test $? -ne 0; then
	echo "failed."
	logger "can't inform control-node, that want to start the cold-storage..."
	exit 1
fi

echo "waiting for cold-storage-node..."
sleep $STORAGE_NODE_BOOTTIME

STORAGE_NODE_TRIES=0
while [ $STORAGE_NODE_TRIES -le 4 ]; do
	STORAGE_NODE_TRIES=$( expr $STORAGE_NODE_TRIES + 1 )
	echo "try to reach storage-node...."
	ssh $STORAGE_NODE_SSHUSER@$STORAGE_NODE_HOSTNAME:$STORAGE_NODE_SSHPORT $SSH_OPTIONS "quit"
	if test $? -ne 0; then
		echo "failed, retrying in $( expr $STORAGE_NODE_BOOTTIME / 10 )"
		sleep $( expr $STORAGE_NODE_BOOTTIME / 10 )
	else
		echo "successful."
		break
	fi
done

if [ $STORAGE_NODE_TRIES -eq 5 ]; then
	echo "storage node was not reachable..."
	exit 1
fi

echo "want to run a full systembackup on the cold-storage-node. Informing control-vm...."
ssh $CONTROL_NODE_SSHUSER@$CONTROL_NODE_HOSTNAME:$CONTROL_NODE_SSHPORT $SSH_OPTIONS "touch $CONTROL_NODE_NOTIFYFOLDER/$HOSTNAME-started-backup"
if test $? -ne 0; then
	echo "failed."
	logger "can't inform control-node, that want to start the backup..."
	exit 1
fi

echo "start rsyncing..."
rsync -qaAXve "ssh -p$STORAGE_NODE_SSHPORT" --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.cache/*","/home/*/tmp/*","/var/cache/pacman/pkg/*","/var/cache/nginx/*","/var/log/journal/*"} /* $STORAGE_NODE_SSHUSER@$STORAGE_NODE_HOSTNAME:$STORAGE_NODE_PATH/$HOSTNAME-root-backup

if test $? -ne 0; then
	echo "backup-job failed, informing control-vm..."
	ssh $CONTROL_NODE_SSHUSER@$CONTROL_NODE_HOSTNAME:$CONTROL_NODE_SSHPORT $SSH_OPTIONS "echo \"failed\" > $CONTROL_NODE_NOTIFYFOLDER/$HOSTNAME-finished-backup" #FIXME
	logger "root-backup failed, rsync returned an error..."
	exit 1
else
	echo "backup-job done. Informing control-vm..."
	ssh $CONTROL_NODE_SSHUSER@$CONTROL_NODE_HOSTNAME:$CONTROL_NODE_SSHPORT $SSH_OPTIONS "echo \"$BACKUP_TIME\" > $CONTROL_NODE_NOTIFYFOLDER/$HOSTNAME-finished-backup" #FIXME
	if test $? -ne 0; then
		echo "failed."
		logger "can't inform storage-node, that the backup was completed..."
		exit 1
	fi
fi


echo "backup successful completed, writing status-info to local systemlog..."

echo "done."
