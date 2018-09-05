#!/bin/bash

# backup_configuration_vsx.sh - niels@van-sluis.nl
#
# v0.1 - 2018-09-05

TEMPDIR=/tmp/backup_configuration_vsx-$$
DATE=`date +%Y-%m-%d`
IDENTIFIER=backup_configuration_vsx-$HOSTNAME-$DATE
FILENAME=$IDENTIFIER.tar
OUTPUTDIR=/tmp

# get configured virtual systems
#LISTVS=(`clish -c 'show virtual-system all' | tail -n +3 | awk {'print $1'} | tr '\r\n' ' '`)
LISTVS=(`vrf list vrfs | tr '\r\n' ' '`)

# create temporary directory
mkdir -p $TEMPDIR/$IDENTIFIER

# get configuration per virtual system
for vs in "${LISTVS[@]}"
do
  # create clish input file
  echo "set virtual-system $vs" > $TEMPDIR/clish-input.txt
  echo 'show configuration' >> $TEMPDIR/clish-input.txt

  # save config
  clish -f $TEMPDIR/clish-input.txt > $TEMPDIR/$IDENTIFIER/vs_$vs-config.txt
done

# change workdir
cd $TEMPDIR

# make tar
tar czf $OUTPUTDIR/$FILENAME $IDENTIFIER/
echo "Saved configs: $OUTPUTDIR/$FILENAME"

# remove configs
rm $TEMPDIR/$IDENTIFIER/vs_*-config.txt

# remove clish input file
rm $TEMPDIR/clish-input.txt

# remove temporary directory
rmdir $TEMPDIR/$IDENTIFIER
rmdir $TEMPDIR
