[countdown.sh] (https://github.com/happylance/countdown/blob/master/countdown.sh) can help people know how long they have been sitting in front of a computer and when to take a break.
By default, this script will countdown from 50:00 to 0:01 for work period. Then countdown from 10:00 to 0.01 in another color for break period.

## Getting Started
### Prerequisites
This script requires `bash`. I have only tested it in OSX.
### Basic Installation
`git clone https://github.com/happylance/countdown.git ; cd countdown`

## Usage
./countdown.sh [-u \<1-60\>] [-w \<1-59\>] [-b \<1-10\>]

-u Update period in seconds. Default is 1.

-w Work period in minutes. Default is 50.

-b Break period in minutes. Default is 10.

Here's a sample Usage:
```
$./countdown.sh
Started to work at
17:43:26
49:18
```
The first parameter specifies that the working period is 50 minutes. The second parameter specifies that the break period is 10 minutes. The last line above will keep updating every seconds until user inputs one the following commands.

**N** (shift-n): Move to the next period in advance.

**ctrl-c**: Quit the script.

Here's a sample output after applying an '**N**' command at 17:51:01.
```
$ ./countdown.sh
Started to work at
17:43:26
Took a break at
17:51:01
09:55
```
On OSX, I found it convenient by putting a terminal window running countdown.sh at the bottom left corner. 
User can use `command +` and `command -` to adjust the font size in terminal until the font size looks good enough.

![screencast](/images/screencast.gif)

[countdown.sh](https://github.com/happylance/countdown/blob/master/countdown.sh) supports customized work period and break period. For example, if user wants to work for 40 minutes and then take a break for 5 minutes, the following command should work.

` ./countdown.sh -w 40 -b 5`

## Uninstallation
```
cd <Path which contains countdown folder>
rm -rf countdown
```
