# Create the volumes

# Creating the /hana volume
sudo pvcreate /dev/disk/azure/scsi1/lun0
sudo pvcreate /dev/disk/azure/scsi1/lun1
sudo pvcreate /dev/disk/azure/scsi1/lun2
sudo pvcreate /dev/disk/azure/scsi1/lun3
sudo pvcreate /dev/disk/azure/scsi1/lun4
sudo pvcreate /dev/disk/azure/scsi1/lun5
sudo pvcreate /dev/disk/azure/scsi1/lun6
sudo pvcreate /dev/disk/azure/scsi1/lun7

sudo vgcreate data-vg01 /dev/disk/azure/scsi1/lun0 /dev/disk/azure/scsi1/lun1 /dev/disk/azure/scsi1/lun2 /dev/disk/azure/scsi1/lun3 /dev/disk/azure/scsi1/lun4 /dev/disk/azure/scsi1/lun5 /dev/disk/azure/scsi1/lun6 /dev/disk/azure/scsi1/lun7
sudo lvcreate --extents 100%FREE --stripes 8 --stripesize 256 --name data-lv01 data-vg01
sudo mkfs.xfs /dev/data-vg01/data-lv01
sudo mkdir /hana /hana/data /hana/log
# Update fstab
echo "/dev/data-vg01/data-lv01  /hana  xfs  defaults,nobarrier,nofail  0  2" | sudo tee -a /etc/fstab

# Creating the /hana/shared volume
sudo pvcreate /dev/disk/azure/scsi1/lun8
sudo vgcreate shared-vg01 /dev/disk/azure/scsi1/lun8
sudo lvcreate --extents 100%FREE --name shared-lv01 shared-vg01
sudo mkfs.xfs /dev/shared-vg01/shared-lv01

sudo mkdir /hana/shared
# Update fstab
echo "/dev/shared-vg01/shared-lv01 /hana/shared  xfs  defaults,nobarrier,nofail  0  2" | sudo tee -a /etc/fstab

# Creating the /usr/sap volume
sudo pvcreate /dev/disk/azure/scsi1/lun9
sudo vgcreate usrsap-vg01 /dev/disk/azure/scsi1/lun9
sudo lvcreate --extents 100%FREE --name usrsap-lv01 usrsap-vg01
sudo mkfs.xfs /dev/usrsap-vg01/usrsap-lv01

sudo mkdir /usr/sap
# Update fstab
echo "/dev/usrsap-vg01/usrsap-lv01 /usr/sap  xfs  defaults,nobarrier,nofail  0  2" | sudo tee -a /etc/fstab

# Creating the /hana/backup volume

sudo pvcreate /dev/disk/azure/scsi1/lun10
sudo pvcreate /dev/disk/azure/scsi1/lun11
sudo pvcreate /dev/disk/azure/scsi1/lun12
sudo pvcreate /dev/disk/azure/scsi1/lun13

sudo vgcreate backup-vg01 /dev/disk/azure/scsi1/lun10 /dev/disk/azure/scsi1/lun11 /dev/disk/azure/scsi1/lun12 /dev/disk/azure/scsi1/lun13
sudo lvcreate --extents 100%FREE --stripes 4 --name backup-lv01 backup-vg01
sudo mkfs.xfs /dev/backup-vg01/backup-lv01
sudo mkdir /hana/backup

echo "/dev/backup-vg01/backup-lv01  /hana/backup  xfs  defaults,nobarrier,nofail  0  2" | sudo tee -a /etc/fstab

sudo chmod -R 0755 /hana
sudo chmod -R 0755 /usr/sap
