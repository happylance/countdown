# Scripts
## countdown.sh
[countdown.sh](https://github.com/happylance/Scripts/blob/master/countdown.sh) is a script which can help people know how long they have been sitting in front of a computer and when to take a break.
By default, this script will countdown from 50:00 to 0:00 for work period. Then countdown from -0:00 to -10:00 for break period.

### Basic Installation
`curl -O https://raw.githubusercontent.com/happylance/Scripts/master/countdown.sh ; chmod +x countdown.sh`

### Usage
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
On OSX, I found it convenient by putting a terminal window running countdown.sh at the bottom left corner. 

Here's a screenshots at bottom left corner when Terminal app is in foreground.

![Foreground](/images/screenshot1_countdown.png)

Here's a screenshot at bottom left corner when Terminal app is in background and Safari app is in foreground.

![Background](/images/screenshot2_countdown.png)

### Advanced Usage
[countdown.sh](https://github.com/happylance/Scripts/blob/master/countdown.sh) supports customized work period and break period. For example, if user wants to work for 40 minutes and then take a break for 5 minutes, the following command should work.

` ./countdown.sh 40 5`
