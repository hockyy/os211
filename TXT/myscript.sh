#!/bin/bash
# Copyright (C) 2020-2021 Cicak Bin Kadal
# https://www.youtube.com/watch?v=KAXK07ni9gU

# This free document is distributed in the hope that it will be 
# useful, but WITHOUT ANY WARRANTY; without even the implied 
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# REV04 Mon 15 Mar 19:27:52 WIB 2021
# REV03 Sun 14 Mar 18:21:27 WIB 2021
# REV02 Fri 12 Mar 13:40:58 WIB 2021
# REV01 Tue 13 Oct 10:37:14 WIB 2020
# START Mon 28 Sep 21:05:04 WIB 2020

# ATTN:
# You new to set "REC2" with your own Public-Key Identity!
# Check it out with "gpg --list-key"

REC2="hocky.yudhiono@gmail.com"
REC1="operatingsystems@vlsm.org"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"

# If the folder $HOME/RESULT doesn't exist, make it. -p is to create its parents if doesnt exist
[ -d $HOME/RESULT ] || mkdir -p $HOME/RESULT
# Go to this dir
pushd $HOME/RESULT
for II in W?? ; do
    # Compute all files matching W?? -Question mark is a single char wildcard-
    [ -d $II ] || continue
    # Skip if doesnt exist
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    # Remove any existing same file
    rm -f $TARFILE $TARFASC
    # Create tarball
    echo "tar cfj $TARFILE $II/"
    tar cfj $TARFILE $II/
	# Encryt tarball, multiple recipient, can be decrypted by Mr. Rahmat and Us
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
done
# Back to initial dir
popd

# Remove this fakeDODOL mysterious file
rm -f $HOME/RESULT/fakeDODOL
for II in $HOME/RESULT/myW*.tar.bz2.asc $HOME/RESULT/fakeDODOL ; do
   echo "Check and move $II..."
   # if this file exist, move it to ., this means TXT/
   [ -f $II ] && mv -f $II .
done

echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

echo "sha256sum -c $SHA"
sha256sum -c $SHA

echo "gpg -o $SHA.asc -a -sb $SHA"
gpg -o $SHA.asc -a -sb $SHA

echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

exit 0


