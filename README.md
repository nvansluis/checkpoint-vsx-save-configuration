# checkpoint-vsx-save-configuration
This script will perform a 'show configuration' on all virtual systems on a VSX member and will save the configurations. It will also backup important configuration files.

Note that most configuration settings in VSX are stored in the management server, so the clish configuration files cannot be used for a full restore of a virtual system. However, some settings like bootp for example are only stored local in the clish configuration of a virtual system. This is where this script provides added value.

### Important configuration files
The following files will be part of the backup.

<pre>
$FWDIR/boot/modules/fwkern.conf
$FWDIR/boot/modules/vpnkern.conf
$PPKDIR/boot/modules/simkern.conf
$PPKDIR/boot/modules/sim_aff.conf
$FWDIR/conf/fwaffinity.conf
$FWDIR/conf/fwauthd.conf
$FWDIR/conf/local.arp
$FWDIR/conf/discntd.if
$FWDIR/conf/cpha_bond_ls_config.conf
$FWDIR/conf/resctrl
$FWDIR/conf/vsaffinity_exception.conf
$FWDIR/database/qos_policy.C
$FWDIR/conf/sdconf.rec
$FWDIR/conf/sdopts.rec
$FWDIR/conf/sdstatus.12
$FWDIR/conf/securid
/var/ace/sdconf.rec
/var/ace/sdopts.rec
/var/ace/sdstatus.12
/var/ace/securid)
</pre>

### Usage
<pre>
[Expert@fw1:0]# ./backup_configuration_vsx.sh
Saved configs: /tmp/backup_configuration_vsx-fw1-2018-09-05.tar
[Expert@fw1:0]#
</pre>
