# Scripts
## countdown.sh
countdown.sh is a script which can help people know how long they have been sitting in front of a computer and when to take a break.
By default, this script will countdown from 50:00 to 0:00 for work period. Then countdown from -0:00 to -10:00 for break period.

Here's a sample Usage:
```
$./countdown.sh
Started to work at
17:43:26
49:18
```
The last line above will keep updating every seconds until 0:00 or user inputs one the following commands.

**N** (shift-n): Move to the next period in advance.

**Q** (shift-q): Quit the script.

Here's a sample output after applying an '**N**' command at 17:51:01.
```
$ ./countdown.sh
Started to work at
17:43:26
Took a break at
17:51:01
-00:05
```