@echo off
setlocal enabledelayedexpansion

:: Set this flag to 1 to enable renaming existing files with their last modified timestamp
set "RENAME_EXISTING=1"
set "PAUSE_AT_END=0"

:: Iterate over each file passed as argument
for %%F in (%*) do (
    :: Capture the full path of the file
    set "fullpath=%%~fF"

    :: Change to the file's directory
    cd "%%~dpF"

    :: Extract the file extension
    set "ext=%%~xF"

    :: Extract the filename without the extension
    set "filename=%%~nF"

    :: Initialize variables to build the new filename
    set "newname="
    set "partcount=0"

    :: Count the number of segments in the filename
    for %%a in (!filename!) do set /a partcount+=1

    :: Determine new name based on presence of spaces
    if "!partcount!"=="1" (
        set "newname=!filename!"
    ) else (
        :: Reset part counter for actual processing
        set "counter=0"

        :: Rebuild the filename without the last segment
        for %%a in (!filename!) do (
            set /a counter+=1
            if !counter! lss !partcount! (
                if defined newname (
                    set "newname=!newname! %%a"
                ) else (
                    set "newname=%%a"
                )
            )
        )
    )

    :: Construct the target filename
    set "target=!newname!!ext!"

    :: Only proceed if newname and filename are different (indicating a space was removed)
    if not "!target!"=="!filename!!ext!" (
        :: Check if the target file exists and RENAME_EXISTING is enabled
        if exist "!target!" if "!RENAME_EXISTING!"=="1" (
            :: Get the last modified timestamp of the existing file
            for %%I in ("!target!") do (
                set "lastmod=%%~tI"
            )
            :: Correctly extract and convert date and time parts
            set "year=!lastmod:~6,4!"
            set "month=!lastmod:~0,2!"
            set "day=!lastmod:~3,2!"
            set "hour=!lastmod:~11,2!"
            set "minute=!lastmod:~14,2!"
            set "ampm=!lastmod:~17,2!"
            
            if "!ampm!"=="PM" if !hour! lss 12 set /a hour+=12
            if "!ampm!"=="AM" if !hour!==12 set "hour=00"
            
            :: Combine to form timestamp
            set "lastmod=!year!!month!!day!_!hour!!minute!"

            :: Rename the existing file with its last modified timestamp
            rename "!target!" "!newname!_!lastmod!!ext!"
        )

        :: Rename the file
        rename "%%~nxF" "!target!"
        echo File renamed to: "!target!"
    ) else (
        echo Filename unchanged: "%%~nxF"
    )
)

echo Done processing files.
if "!PAUSE_AT_END!"=="1"(
	pause
)