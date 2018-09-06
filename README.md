# checkpoint-vsx-save-configuration
This script will perform a 'show configuration' on all virtual systems on a VSX member and will save the configurations.

Note that most configuration settings in VSX are stored in the management server, so the clish configuration files cannot be used for a full restore of a virtual system. However, some settings like bootp for example are only stored local in the clish configuration of a virtual system. This is where this script provides added value.

### Usage
<pre>
[Expert@fw1:0]# ./backup_configuration_vsx.sh
Saved configs: /tmp/backup_configuration_vsx-fw1-2018-09-05.tar
[Expert@fw1:0]#
</pre>
