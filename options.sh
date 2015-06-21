CONTROL_NODE_HOSTNAME="chons.vfn-nrw.de"
CONTROL_NODE_SSHPORT="2337"
CONTROL_NODE_SSHUSER="backupjob"
CONTROL_NODE_NOTIFYFOLDER="/tmp/backupcontroller" 
STORAGE_NODE_HOSTNAME="anubis.vfn-nrw.de"
STORAGE_NODE_SSHPORT="1337"
STORAGE_NODE_SSHUSER="backupjob"
STORAGE_NODE_BOOTTIME="60"

STORAGE_NODE_PATH="/data/backupstorage" 

SSH_OPTIONS="-o Ciphers='chacha20-poly1305@openssh.com,aes256-cbc' -o Compression=yes -o CompressionLevel=8 -o IPQoS=0x02 -o 	KexAlgorithms='curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,diffie-hellman-group-exchange-sha256' -o MACs='hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256' -o TCPKeepAlive=no -o ServerAliveInterval=3 -o ServerAliveCountMax=5 -o ConnectTimeout=4 -o ControlMaster='auto' -o ControlPersist=yes -o	ControlPath='~/.ssh/socket-%r@%h:%p'"
