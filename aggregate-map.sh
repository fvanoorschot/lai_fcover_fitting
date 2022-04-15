#!/bin/bash
# aggregation.sh /data/lc-map-example/ESACCI-LC-L4-LCCS-Map-300m-P5Y-2010-v2.nc

set -ex

if [ -z "$1" ]; then
    echo "Land Cover CCI Aggregation Tool"
    echo ""
    echo "For further information see the readme.txt"
    exit 1
fi

export TOOL_HOME=`( cd $(dirname $0); cd ..; pwd )`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TOOL_HOME/lib

# Andrea modified to 24GB instead of 4GB
#exec java -Xmx4G -Dceres.context=snap \
exec java -Xmx62G -Dceres.context=snap \
    -Djava.io.tmpdir=$WORK\
    -Dsnap.logLevel=INFO -Dsnap.consoleLog=true \
    -Dsnap.mainClass=org.esa.snap.core.gpf.main.GPT \
    -Dsnap.binning.sliceHeight=64 \
    -jar "$TOOL_HOME/bin/ceres-launcher.jar" \
    LCCCI.Aggregate.Map -e -c 1024M $@
