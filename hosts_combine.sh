#!/bin/bash

OUTPUT_FOLDER=output
RESOURCE_FOLDER=resources
WGET_TIMEOUT=5
WGET_TRIES=3

printf "\n" && echo 'Cleaning old hosts and resources folders if present'
rm -r $OUTPUT_FOLDER $RESOURCE_FOLDER &> /dev/null
mkdir $OUTPUT_FOLDER $RESOURCE_FOLDER

for item in `cat sources.txt`; do
    printf "\n" && echo "Fetching $item"
    wget -P $RESOURCE_FOLDER -T $WGET_TIMEOUT -t $WGET_TRIES -q --show-progress $item
done

printf "\n" && echo "Combining files" && echo "(This may take a while)"
cat $RESOURCE_FOLDER/* | egrep -v '^(;|#|//)' | sort -u > $OUTPUT_FOLDER/hosts

printf "\n" && read -p 'Copy hosts to /etc? (Y/n): ' yn
case $yn in
    [Yy]* )
        sudo mv $OUTPUT_FOLDER/hosts /etc/hosts
    ;;
esac

printf "\n" && echo 'Done'

