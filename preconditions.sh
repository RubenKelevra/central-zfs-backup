#create a useraccount on storage-node:
source ./options.sh
useradd --system -m --home-dir $STORAGE_NODE_PATH -g users -s /bin/bash $STORAGE_NODE_SSHUSER
