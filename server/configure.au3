#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3> ; Only required to display the arrays
#include <String.au3>

;mediaArray holds the artist name or tv show, channel, and port in the following format: Airwolf | 2 | 1221.  Used to list the channels in the list guide
;aList holds the vlc configuration file information. The actual filename and path of the media file. ex: setup channel2 input "C:\atest\Airwolf\Season 1\Airwolf_S01e03.avi"

;todo
;1. How to handle multiple configuration scripts for TV, Movies, Music, etc.
;2. How to handle start.bat that will start the VLC server. The batch file must have the correct configuration file name in it and correct path to VLC
;3 add error checking if vlc is not installed
;4 issue with gui no retaining values when u click go the 2nd time
;5 options to start server when configuration is done

Start()

Func Start()
    Local $radio1, $btn, $radio2, $msg, $type, $IP, $channel, $mosaicCopy = 0, $startit = 0

    GUICreate("Config", 180, 300, 100, 440, -1)  ;width, height ; will create a dialog box that when displayed is centered
	;$listGUI = GUICreate("Broadcast Media Stations", 400, 500, 100, 440, -1)  ;width, height

    $radio1 = GUICtrlCreateRadio("Audio", 10, 10, 60, 20)
    $radio2 = GUICtrlCreateRadio("TV", 10, 40, 60, 20)
	GUICtrlSetState($radio2, $GUI_CHECKED)
	;GUICtrlCreateLabel("All", 20, 70, 40, 20) ;
	$radio3 = GUICtrlCreateRadio("All", 80, 10, 60, 20)
	$radio4 = GUICtrlCreateRadio("Movies", 80, 40, 60, 20)
	Local $iMosaicCheckbox = GUICtrlCreateCheckbox("Copy to mosaic tab", 10, 70, 120, 20)

    GUICtrlCreateLabel("Start Channel", 10, 120, 80, 20) ;
	$channel = GUICtrlCreateInput(1, 80, 120, 30, 20)

    GUICtrlCreateLabel("Client IP:", 10, 140, 50, 20) ;
	$IP = GUICtrlCreateInput("127.0.0.1", 70, 140, 80, 20)
	GUICtrlCreateLabel("Port:", 10, 160, 40, 20) ;
	$port = GUICtrlCreateInput("1220", 40, 160, 80, 20)
    Local $iCheckbox2 = GUICtrlCreateCheckbox("Start Broadcasting on exit", 10, 180, 160, 20)
	$btn = GUICtrlCreateButton("Go", 40, 220, 60, 20)

    GUISetState(@SW_SHOW) ; will display an  dialog box with 1 checkbox

    ; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
			Case $msg = $btn
				;$menutext = GUICtrlRead($radio1, 1) ; return the text of the menu item

				If GUICtrlRead($radio1) = 1 Then
					$type = "audio"
				;ElseIf GUICtrlRead($radio2) = 2 Then
				ElseIf $radio2 And BitAND(GUICtrlRead($radio2), $GUI_CHECKED) = $GUI_CHECKED Then
					$type = "TV"
				ElseIf $radio4 And BitAND(GUICtrlRead($radio4), $GUI_CHECKED) = $GUI_CHECKED Then
					$type = "Movies"
				Else
					 $type = "misc"
				 EndIf

				 If _IsChecked($iMosaicCheckbox) Then
                    If $type = "audio" Then
						$mosaicCopy = 0
						MsgBox($MB_SYSTEMMODAL, "msg", "Audio files will not work with Mosaic.")
					Else
						$mosaicCopy = 1
					EndIf
				EndIf

				If _IsChecked($iCheckbox2) Then
                    ;MsgBox($MB_SYSTEMMODAL, "", "The checkbox is checked.")
					$startit = 1
					If $IP = "127.0.0.1" Then
						Run("..\client\Broadcaster.exe")
					EndIf
				EndIf

				$channel = GUICtrlRead($channel)
				$IP = GUICtrlRead($IP)
 				$port = GUICtrlRead($port)
				;MsgBox(0, "", "radio selected " & $type & " port: " & $port & " IP: " & $IP & " channel: " & $channel)
				GetFiles($type, $channel, $IP, $port)

				;end of script show the files we wrote to
				If $mosaicCopy = 1 Then
					;MsgBox($MB_SYSTEMMODAL, "", "Mosaic copy = yes")
					FileCopy("..\client\" & $type & ".txt", "..\client\mosaic.txt", 1)
				EndIf

;~ 				If FileExists(@ScriptDir & "\" & $type & ".cfg") Then
;~ 					Run('notepad.exe ' & @ScriptDir & '\' & $type & '.cfg')
;~ 				EndIf
;~ 				If FileExists("..\client\" & $type & ".txt") Then
;~ 					Run('notepad.exe ' & '..\client\' & $type & '.txt')
;~ 				EndIf
;~ 				If FileExists(@ScriptDir & "\" & $type & ".bat") Then
;~ 					Run('notepad.exe ' & @ScriptDir & '\' & $type & '.bat')
;~ 				EndIf

				If ($startit = 1) Then
					Run( @ScriptDir & '\' & $type & '.bat')
					;MsgBox(0, "", "Starting app", 3)
				EndIf
				Exit
;~             Case $msg = $radio1 And BitAND(GUICtrlRead($radio1), $GUI_CHECKED) = $GUI_CHECKED
;~                 ;MsgBox($MB_SYSTEMMODAL, 'Info:', 'Audio it is.')
;~ 				$type = "audio"
;~ 				$channel = GUICtrlRead($channel)
;~ 				$IP = GUICtrlRead($IP)
;~ 				$port = GUICtrlRead($port)
;~ 				;MsgBox(0, "", "channel: " &  GUICtrlRead($channel))
;~ 				MsgBox(0, "", "radio selected " & $type & " port: " & $port & " IP: " & $IP & " channel: " & $channel)
;~ 				GetFiles($type, $channel, $IP, $port)
;~             Case $msg = $radio2 And BitAND(GUICtrlRead($radio2), $GUI_CHECKED) = $GUI_CHECKED
;~                 $channel = GUICtrlRead($channel)
;~ 				;MsgBox($MB_SYSTEMMODAL, 'Info:', 'Video it is.')
;~ 				$type = "video"
;~ 				$IP = GUICtrlRead($IP)
;~ 				$port = GUICtrlRead($port)
;~ 				MsgBox(0, "", "radio selected " & $type & " port: " & $port & " IP: " & $IP & " channel: " & $channel)
;~ 				GetFiles($type, $channel, $IP, $port)

;~ 			Case $msg = $radio3 And BitAND(GUICtrlRead($radio3), $GUI_CHECKED) = $GUI_CHECKED
;~ 				$channel = GUICtrlRead($channel)
;~ 				$type = "all"
;~ 				$IP = GUICtrlRead($IP)
;~ 				$port = GUICtrlRead($port)
;~ 				MsgBox(0, "", "radio selected " & $type & " port: " & $port & " IP: " & $IP & " channel: " & $channel)
;~ 				GetFiles($type, $channel, $IP, $port)
		EndSelect

		;$channel = GUICtrlRead($channel)
		;$IP = GUICtrlRead($IP)
		;GetFiles($type, $channel, $IP)
    WEnd
EndFunc   ;==>Example



Func GetFiles($type, $channel, $IP, $port)
	;MsgBox(0, "", "port: " & $port & " channel: " & $channel & " type: " & $type)
	$dir = SetDir()
	;$channel = InputBox("Question", "Enter starting channel number", 1, "")

	;$sInsertString = 'setup channel' & $channel & ' input "v:\Media\Music-MP3\Music-Master\'
	$sInsertString = 'setup channel' & $channel & ' input "' & $dir & '\'
	$sInsertString2 = '"'

	;$sInsertString = "setup Channel95 input"
    ; A sorted list of all files and folders in the AutoIt installation
    If $type = "audio" Then
		$aList = _FileListToArrayRec($dir, "*.mp3||*.*", 13, 1, 1, 1)
		;MsgBox(0, "", "audio was picked")
	Else
		$aList = _FileListToArrayRec($dir, "*.avi;*.wmv;*.mov;*.mpeg;*.mpg;*.wma;*.flv;*.m4v;*.mkv;*.mp4;*.divx||*.*", 13, 1, 1, 1)
		;MsgBox(0, "", "tv was picked")
	;Else
		;$aList = _FileListToArrayRec($dir, "*.avi;*.wmv;*.mov;*.mpeg;*.mpg;*.flv;*.m4v;*.mkv;*.mp4;*.mp3;*.divx||*.*", 13, 1, 1, 1)
		;MsgBox(0, "", "misc was picked")
	EndIf
    ConsoleWrite("Error: " & @error & " - " & " Extended: " & @extended & @CRLF)
    ;_ArrayDisplay($aList, "aList")

	;Declare variables
	$iLine = -1   ;array indexer
	$sCurrent_Band = ""
	$iChannel = $channel
	$cnt = 0

	$sString_1 = 'setup channel'
	$sString_2 = ' input "'
	;$sInsertString = 'setup channel' & $iChannel & ' input "' & $dir & '\' & '"'
	Local $mediaArray[UBound($aList)]
	;MsgBox(0, "", "arraysize " & UBound($mediaArray))

	; Start the loop
	SplashTextOn("Working", "Gathering data.... ", -1, 100, -1, -1, 18, "", 24)

	While 1
		; Next line and check still within array
		$iLine += 1

		;If $iLine = UBound($aList, $UBOUND_ROWS) Then ExitLoop
		If $iLine = UBound($aList) Then
			;$port += 1
			_ArrayInsert($aList, $iLine, $sString_1 & $iChannel & " output #duplicate{dst=standard{access=udp,mux=ts,dst=" & $IP & ":" & $port & ",sap,name=" & '"' & "channel" & $iChannel & '"}}')
			;$mediaArray[$iChannel] = $sCurrent_Band & " | " & $iChannel & " | " & $port   ;insert records for audio/tv.txt
			ExitLoop   ;check for end of array
		EndIf

		; Skip leading lines with numbers
		If Int($aList[$iLine]) <> 0 Then ContinueLoop

		; Split line to get band and check for new band
		$aSplit = StringSplit($aList[$iLine], "\")   ;index[1] is band
		;MsgBox(0, "", "aSplit: " & @CR & $aSplit[1] & @CR & $sCurrent_Band)

		If $aSplit[1] <> $sCurrent_Band Then
			; Increase channel
			$iChannel += 1
			$cnt += 1
			If $iChannel > 1 Then
				SplashTextOn("Working", "Processing.. " & $sCurrent_Band, -1, 100, -1, -1, 18, "", 24)
				; Insert line for channel if greater then 1
				_ArrayInsert($aList, $iLine, $sString_1 & $iChannel -1 & " output #duplicate{dst=standard{access=udp,mux=ts,dst=" & $IP & ":" & $port & ",sap,name=" & '"' & "channel" & $iChannel -1 & '"}}')
				_ArrayInsert($aList, $iLine +1, "new channel" & $iChannel & " broadcast enabled loop")

				;setup channel28 output #duplicate{dst=standard{access=udp,mux=ts,dst=10.1.10.103:1228,sap,name="channel28-IT-Crowd"}}
				; Skip that line
				$mediaArray[$cnt] = $sCurrent_Band & " | " & $iChannel & " | " & $port   ;insert records for audio/tv.txt
				$iLine += 2
				$port += 1
			EndIf
			; Reset current band
			$sCurrent_Band = $aSplit[1]
			$mediaArray[$cnt] = $sCurrent_Band & " | " & $iChannel & " | " & $port   ;insert records for audio/tv.txt
		EndIf

    $aList[$iLine] = $sString_1 & $iChannel & $sString_2 & $dir & '\' & $aList[$iLine] & '"'
	WEnd
	SplashOff()

	;audio.txt, tv.txt, etc
	$sFilePath = @ScriptDir & "\" & $type & ".cfg" ;server folder
	$sFilePath2 = "..\client\" & $type & ".txt"
	If FileExists($sFilePath) Then
		;MsgBox(0, "", "deleting file")
		FileDelete($sFilePath)
		FileDelete($sFilePath2)
	EndIf

	SplashTextOn("Working", "Writing Data to Files.. ",  -1, 100, -1, -1, 18, "", 24)
	For $i = $channel To $iChannel -1
		;_ArrayInsert($aList, $iLine +1, "new channel" & $iChannel & " broadcast enabled loop")
		_ArrayAdd($aList, "control channel" & $i + 1 & " play")
	Next
	;control channel16 play	#New WKRP
	;MsgBox(0, "", "iChannel:" & $iChannel & " channel: " & $channel)
	_ArrayInsert($aList, 2, "new channel" & $channel + 1 & " broadcast enabled loop")
	$mediaArray = _RemoveEmptyArrayElements($mediaArray)
	_ArrayDelete($aList, 2)
	_ArrayDelete($aList, 2)
	;_ArrayDisplay($aList, "aList")
	;_ArrayDisplay($mediaArray, "mediaArray")


	_FileWriteFromArray($sFilePath, $aList, 2)  ;write array to file named: $type.cfg  ex: audio.cfg
	_FileWriteFromArray($sFilePath2, $mediaArray, 0)  ;start at index 0 of array  $type.txt ex: audio.txt

	;-------------------------------------------------------------------
	;Start batch file creation and replace string config.cfg with server path to $type.cfg
	;-------------------------------------------------------------------
	;Replace string in file code. Replacing config file with $type.cfg
	$batch_Filename = @ScriptDir & "\start-template.bat"
	$start_Filename = @ScriptDir & "\" & $type & ".bat"
	FileCopy($batch_Filename, $start_Filename, 1)

	$find = "config.cfg"
	$replace = @ScriptDir & "\" & $type & ".cfg"
	Local $retval = _ReplaceStringInFile($start_Filename, $find, $replace)
	If $retval = -1 Then
		MsgBox($MB_SYSTEMMODAL, "ERROR", "The pattern could not be replaced in file: " & $start_Filename & " Errors: " & @error)
		Exit
	Else
		;MsgBox($MB_SYSTEMMODAL, "INFO", "Found " & $retval & " occurances of the pattern: " & $find & " in the file: " & $start_Filename)
	EndIf

	;-------------------------------------------------------------------
	;Replace string in file start-template.bat with vlc path location
	;-------------------------------------------------------------------
	; get install path of vlc
	$replace = GetInstalledPath()
	$find = "C:\Program Files (x86)\VideoLAN\VLC"
	;Local $retval = _ReplaceStringInFile($start_Filename, $find, $replace)

	ReplaceStringInFile($start_Filename, $find, $replace)
	SplashOff()
EndFunc

Func ReplaceStringInFile($start_Filename, $find, $replace)
	Local $results = _ReplaceStringInFile($start_Filename, $find, $replace)
	If $results = -1 Then
		MsgBox($MB_SYSTEMMODAL, "ERROR", "The pattern could not be replaced in file: " & $start_Filename & " Error: " & @error & " find: " & $find & " replace: " & $replace)
		Exit
	Else
		;MsgBox($MB_SYSTEMMODAL, "INFO", "Found " & $results & " occurances of the pattern: " & $find & " in the file: " & $start_Filename)
	EndIf
EndFunc




Func SetDir()
    ; Create a constant variable in Local scope of the message to display in FileSelectFolder.
    Local Const $sMessage = "Select folder location of MP3 directory"

    ; Display an open dialog to select a file.
    Local $sFileSelectFolder = FileSelectFolder($sMessage, "")
    If @error Then
        ; Display the error message.
        MsgBox($MB_SYSTEMMODAL, "", "No folder was selected.")
    Else
        ; Display the selected folder.
        ;MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $sFileSelectFolder)
    EndIf
	Return $sFileSelectFolder
EndFunc   ;==>Example

Func _RemoveEmptyArrayElements ( $_Array )
    Local $_Item
    For $_Element In $_Array
        If $_Element= '' Then
            _ArrayDelete ( $_Array, $_Item )
        Else
            $_Item+=1
        EndIf
    Next
    Return ( $_Array )
EndFunc ;==> _RemoveEmptyArrayElements ( )


Func _IsChecked($iControlID)
    Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked


Func GetInstalledPath()
	$osv = @OSVersion
	$ost = @OSArch
	; @error = 1 - Not installed
	;Get Installed path
	Static $sInstalledPath = ""
	If $ost = "X64" Then
		$key = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player"
	Else
		$key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\VLC media player"
	EndIf

	If $sInstalledPath = "" Then
		$sInstalledPath = RegRead($key, "InstallLocation")
		If @error Then
			$sInstalledPath = ""
			Return SetError(1, 0, "")
		EndIf
	EndIf
	Return $sInstalledPath
EndFunc   ;==>GetInstalledPath

