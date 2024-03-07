# undo-teams-filename-changes
Batch script that you can drag files onto to remove the filename additions that Microsoft Teams adds.

## Usage
Download this script anywhere and drag the files you want to clean onto it.

## Examples
#### Example 1
```
File1 1.txt     -> File1.txt
File 1 2.txt    -> File 1.txt
```

## Flags
1. `RENAME_EXISTING` - default=1. If set, and the script tries to rename file A to an already existing file B, then it renames file B, appending the last modified datetime before the extension. Otherwise, it does not rename either file. For example:
```bash
# If flag is not set
File1 2.txt     -> File1 2.txt
File1.txt       -> File1.txt
# If flag is set
File1 2.txt     -> File1.txt
File1.txt       -> File1_20240307_1749.txt

```
1. `PAUSE_AT_END` - default=0. If set, the script pauses at the end so the user can see the output, which will look something like:
    ```
    File renamed from File1 2.txt to File1.txt
    File renamed from File1 1.txt to File1.txt
    Done processing files.
    ```