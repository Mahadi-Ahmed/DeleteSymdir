#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"

while getopts 'hld:' OPTION; do
  case "$OPTION" in
    h) echo "This script will delete all files & directories that are NOT symlinked "
    echo " available flags to use with this script:"
    echo " -h help"
    echo ""
    echo " -l load script from $DIR"
    echo ""
    echo " -d chose which directory the script should run on"
    echo " E.g: ./deleteNotSymlink -d /path/to/directory/to/run/script/on/"
    echo ""
    echo " pwd of script $DIR/`basename $0`"
      ;;
    l)
    echo "directory to clean is: $DIR"
    arrayOfDir=()
    i=0
    # saves the pwd of all the "normal" folders
    for dir in $DIR/*; do
      if ! [ -L $dir ]; then
        :${arrayOfDir[$i] = "$dir"}
        let i=i+1
      fi
    done

    #echo 'These are all the possible deleted folder'
    #for i in ${arrayOfDir[@]}; do echo $i; done

    # saves the source pwd of all symlinks
    arrayOfSyms=()
    j=0
    temp=""
    for dir in $DIR/*; do
      if [ -L $dir ]; then
        temp="$(cd -P "$dir" && pwd)"
        :${arrayOfSyms[$j] = "$temp"}
        let j=j+1
      fi
    done
    :${arrayOfSyms[$j] = "$DIR/`basename $0`"}


    # Remove folders to keep in arrayOfDir
    for dir in ${arrayOfDir[@]}; do
      for sym in ${arrayOfSyms[@]}; do
        if [[ "$dir" == "$sym" ]] || [[ "$dir" == "$DIR/`basename $0`" ]]; then
          arrayOfDir=( "${arrayOfDir[@]/$dir/}" )
        fi
      done
    done

    #echo "basename `basename $0`"
    #echo "should be the full pwd $DIR/`basename $0`"

    echo 'These folders & files will be deleted'
    for dir in ${arrayOfDir[@]}; do echo $dir; done
    echo 'Do you want to delete these files? Y/N: '
    read choice
    if [[ "$choice" == 'Y' ]] || [ "$choice" == 'y' ] || [ "$choice" == 'YES' ] || [ "$choice" == 'yes' ]; then
      for dir in ${arrayOfDir[@]}; do
        if ! [ -L $dir ]; then
          echo "deleted: $dir"
          rm -rf $dir
        fi
      done
    fi
    #echo 'The sources of the symlinked directories'
    #for k in ${arrayOfSyms[@]}; do echo $k; done
      ;;
    d) # select which directory
      chosenDir="$OPTARG"
      arrayOfDir=()
      i=0
      echo "directory to clean is: $chosenDir"
      # saves the pwd of all the "normal" folders
      # Change the directory to the folder you want to clean
      for dir in $chosenDir*; do
        if ! [ -L $dir ]; then
          :${arrayOfDir[$i] = "$dir"}
          let i=i+1
        fi
      done

      #echo 'These are all the possible deleted folder'
      #for i in ${arrayOfDir[@]}; do echo $i; done

      # saves the source pwd of all symlinks
      # Change the directory to the folder you want to clean
      arrayOfSyms=()
      j=0
      temp=""
      for dir in $chosenDir*; do
        if [ -L $dir ]; then
          temp="$(cd -P "$dir" && pwd)"
          :${arrayOfSyms[$j] = "$temp"}
          let j=j+1
        fi
      done

      # Remove folders to keep in arrayOfDir
      for dir in ${arrayOfDir[@]}; do
        for sym in ${arrayOfSyms[@]}; do
          if [[ "$dir" == "$sym" ]]; then
            arrayOfDir=( "${arrayOfDir[@]/$dir/}" )
          fi
        done
      done

      echo 'These folders & files will be deleted'
      for dir in ${arrayOfDir[@]}; do echo $dir; done
      echo 'Do you want to delete these files? Y/N: '
      read choice
      if [[ "$choice" == 'Y' ]] || [ "$choice" == 'y' ] || [ "$choice" == 'YES' ] || [ "$choice" == 'yes' ]; then
        for dir in ${arrayOfDir[@]}; do
          if ! [ -L $dir ]; then
            echo "deleted: $dir"
            rm -rf $dir
          fi
        done
      fi
      ;;
    ?) echo "script useage: $(basename $0) [-h] [-l] [-d directory pwd]" >&2
    exit 1
    ;;
  esac
done