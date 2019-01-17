# deleteNotSymlink
This script will delete all files & directories that are **not** symlinked.

To run the script one of three flags __must__ be used:
* ./scriptName -h
  * will print the available flags and how to use them.
* ./scriptName -l 
  * load script from the directory where the script is located
* ./scriptName -d /path/to/directory/to/run/script/on/
  * chose which directory the script should run on
