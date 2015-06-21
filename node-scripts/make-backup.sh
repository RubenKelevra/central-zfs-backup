#!/bin/bash

echo "checking preconditions..."
`rsync --version >/dev/null`
if test $? -ne 0; then
	echo "no rsync found."
	exit 1
fi

echo "want to run a full systembackup on the cold-storage-node. Informing control-vm...."


echo "backup-job done. Informing control-vm..."

echo "backup successful completed, writing status-info to local systemlog..."

echo "done."
