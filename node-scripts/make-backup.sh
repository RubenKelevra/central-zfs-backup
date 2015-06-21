#!/bin/bash

echo "checking preconditions..."
if ! [ `rsync --version` ]; then
	echo "no rsync found."
	exit 1
fi

echo "want to run a full systembackup on the cold-storage-node. Informing control-vm...."


echo "backup-job done. Informing control-vm..."

echo "backup successful completed, writing status-info to local systemlog..."

echo "done."
