#!/bin/bash

# backup_configuration_vsx.sh - niels@van-sluis.nl
#
# v0.1 - 2018-09-05
# v0.2 - 2018-09-09
# v0.3 - 2018-09-09

TEMPDIR=/tmp/backup_configuration_vsx-$$
DATE=`date +%Y-%m-%d`
IDENTIFIER=backup_configuration_vsx-$HOSTNAME-$DATE
FILENAME=$IDENTIFIER.tar.gz
OUTPUTDIR=/tmp

# get CP and VSX environment
. /etc/profile.d/CP.sh
. /etc/profile.d/vsenv.sh

# get configured virtual systems
#LISTVS=(`clish -c 'show virtual-system all' | tail -n +3 | awk {'print $1'} | tr '\r\n' ' '`)
LISTVS=(`vrf list vrfs | tr '\r\n' ' '`)


function save_files() {
    # change to context of virtual system
    vsenv $vs > /dev/null

    # define files to backup
    FILES=($FWDIR/boot/modules/fwkern.conf
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

    for file in "${FILES[@]}"
    do
        DIR=$(dirname "${file}")
        DSTDIR="${TEMPDIR}/${IDENTIFIER}/${vsname}${DIR}"
        [ -f $file ] && mkdir -p ${DSTDIR}
        [ -f $file ] && cp ${file} ${DSTDIR}
    done
}

# create temporary directory
mkdir -p $TEMPDIR/$IDENTIFIER

# remove lock
clish -c 'lock database override' > /dev/null

# get configuration per virtual system
for vs in "${LISTVS[@]}"
do
  # create clish input file
  echo "set virtual-system $vs" > $TEMPDIR/clish-input.txt
  echo 'show configuration' >> $TEMPDIR/clish-input.txt

  # save config
  clish -f $TEMPDIR/clish-input.txt > $TEMPDIR/$IDENTIFIER/vs_$vs-config.txt
  
  retVal=$?
  if [ $retVal -ne 0 ]; then
      echo "Error: show configuration command returned an error."
  fi

  # save important files
  save_files $vs
done

# change workdir
cd $TEMPDIR

# make tar
tar czf $OUTPUTDIR/$FILENAME $IDENTIFIER/
echo "Saved configs: $OUTPUTDIR/$FILENAME"

# remove temporary directory
rm -rf $TEMPDIR

