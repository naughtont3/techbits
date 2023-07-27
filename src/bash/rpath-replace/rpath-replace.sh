#!/bin/bash
# TJN 27-jul-2023

# Update embedded rpath data in a list of libraries.
# If they have the matching rpath info, replace with
# a different value.

# XXX: Path to patchelf executable
PATCHELF=$HOME/projects.summit/bin/patchelf

# XXX: List of ELF libs to update
libs=$(ls -1 lib*.so)

has_rpath () {
    local file=$1
    local str=$2
    echo " >> Checking: $file  for $str"
    readelf -d $file | egrep -i 'runpath|rpath' | grep $str > /dev/null
    return $?
}

update_rpath () {
    local file=$1
    local oldstr=$2
    local newstr=$3
    local default_response="YES"
    local response=""

    # For now, just replace anything that matches our old w/ new

    # Pull out the rpath data (example: /path/to/foo/lib:/path/to/bar/lib)
    tmpstr=$(readelf -d $file |  egrep -i 'runpath|rpath' | awk -F'rpath: ' '{print $2}' | sed 's/\[//' | sed 's/\]//')

    # Replace user specified old string with a new string
    # (example: /path/to/bar/lib => /path/to/BAZ/lib)
    tmp2str=$(echo $tmpstr | sed "s|$oldstr|$newstr|")

    #echo "########"
    #echo "#    tmpstr=$tmpstr"
    #echo "#   tmp2str=$tmp2str"
    #echo "########"

    read -p "Update $file ($default_response/n)?: " response
    if [ "${response}" == '' \
        -o "${response}" == "YES" \
        -o "${response}" == "Y" \
        -o "${response}" == "y" \
        -o "${response}" == "Yes" ] ; then

        echo " >> Step-1: Remove RPATH for $file"
        #echo "    CMD: $PATCHELF --remove-rpath $file"
        $PATCHELF --remove-rpath $file
        rc=$?
        if [ 0 != $rc ] ; then
            echo "Error: Failed to remove rpath on $file -- aborting"
            exit 1
        fi

        echo " >> Step-2: Adding RPATH for $file"
        #echo "    CMD: $PATCHELF --set-rpath    $file $tmp2str"
        $PATCHELF $file --force-rpath --set-rpath  "$tmp2str"
        rc=$?
        if [ 0 != $rc ] ; then
            echo "***\n  PREVIOUS RPATH INFO WAS:\n   $oldstr\n***\n"
            echo "Error: Failed to set rpath on $file -- aborting"
            exit 1
        fi

    else
        echo " >> Skipping rpath changes for $file"
    fi
}

if [ ! -x $PATCHELF ] ; then
    echo "Error: Missing patchelf executable - '$PATCHELF'"
    exit 1
fi

for lib in $libs ; do
    echo "Library: $lib"
    has_rpath "$lib" "13.1.1/install/ucx-1.14.1-20230608"
    rc=$?
    if [ 0 == $rc ] ; then
        echo "--------------------------------------------------"
        echo " >> UPDATE rpath info"
        update_rpath "$lib" "13.1.1/install/ucx-1.14.1-20230608" "9.1.0/install/ucx-1.14.1-20230609"
        echo "--------------------------------------------------"
    #else
    #    echo "  NO  is clean"
    fi
done
