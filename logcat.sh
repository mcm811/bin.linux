The following table describes the logcat command line options:

-c	Clears (flushes) the entire log and exits.
-d	Dumps the log to the screen and exits.
-f <filename>	Writes log message output to <filename>. The default is stdout.
-g	Prints the size of the specified log buffer and exits.
-n <count>	Sets the maximum number of rotated logs to <count>. The default value is 4. Requires the -r option.
-r <kbytes>	Rotates the log file every <kbytes> of output. The default value is 16. Requires the -f option.
-s	Sets the default filter spec to silent.
-v <format>	Sets the output format for log messages. The default is brief format. For a list of supported formats, see Controlling Log Output Format.

The priority is one of the following character values, ordered from lowest to highest priority:
V — Verbose (lowest priority)
D — Debug
I — Info
W — Warning
E — Error
F — Fatal
S — Silent (highest priority, on which nothing is ever printed)

adb logcat ActivityManager:I MyApp:D *:S
adb logcat *:W
export ANDROID_LOG_TAGS="ActivityManager:I MyApp:D *:S"


Controlling Log Output Format

Log messages contain a number of metadata fields, in addition to the tag and priority. You can modify the output format for messages so that they display a specific metadata field. To do so, you use the -v option and specify one of the supported output formats listed below.

brief — Display priority/tag and PID of the process issuing the message (the default format).
process — Display PID only.
tag — Display the priority/tag only.
raw — Display the raw log message, with no other metadata fields.
time — Display the date, invocation time, priority/tag, and PID of the process issuing the message.
threadtime — Display the date, invocation time, priority, tag, and the PID and TID of the thread issuing the message.
long — Display all metadata fields and separate messages with blank lines.
When starting LogCat, you can specify the output format you want by using the -v option:

[adb] logcat [-v <format>]
adb logcat -v thread

Viewing Alternative Log Buffers

The Android logging system keeps multiple circular buffers for log messages, and not all of the log messages are sent to the default circular buffer. To see additional log messages, you can run the logcat command with the -b option, to request viewing of an alternate circular buffer. You can view any of these alternate buffers:

radio — View the buffer that contains radio/telephony related messages.
events — View the buffer containing events-related messages.
main — View the main log buffer (default)
The usage of the -b option is:

[adb] logcat [-b <buffer>]
Here's an example of how to view a log buffer containing radio and telephony messages:

adb logcat -b radio

Viewing stdout and stderr
By default, the Android system sends stdout and stderr (System.out and System.err) output to /dev/null. In processes that run the Dalvik VM, you can have the system write a copy of the output to the log file. In this case, the system writes the messages to the log using the log tags stdout and stderr, both with priority I.

To route the output in this way, you stop a running emulator/device instance and then use the shell command setprop to enable the redirection of output. Here's how you do it:

$ adb shell stop
$ adb shell setprop log.redirect-stdio true
$ adb shell start
The system retains this setting until you terminate the emulator/device instance. To use the setting as a default on the emulator/device instance, you can add an entry to /data/local.prop on the device.

adb logcat -b radio
D/RILJ    ( 2469): [0174]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
D/RILJ    ( 2469): [0265]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
D/RILJ    ( 2469): [0338]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
