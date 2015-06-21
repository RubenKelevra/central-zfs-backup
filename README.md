# central-zfs-backup
on a coldstore-server


This scripts are made for a cold-store server, which boots each time you want to transfer a backup. You need a other server, or VM in the same subnet, to make the wol-call for the storage-node.

Each node, which should be backuped make a boot-request to the control-vm, which boots the storage-node, when all backups are notified to be done, a summary-mail is printed.

There is a timeout for open backup-jobs, so the control-vm will send you a warning-mail, if this timeout is reached, but let the storage-node running.

