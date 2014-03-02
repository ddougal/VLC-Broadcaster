#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

$CurrentVersion = "0.01"
Menu()

Func Menu()
    Local $Start_Button, $Stop_Button, $msg, $icons32 = "C:\Windows\System32\shell32.dll", $rAudio, $rTV, $rMisc, $rMovies
	Local $radio1, $btn, $radio2, $radio5, $msg, $type, $IP, $channel, $mosaicCopy = 0, $startit = 0
   ; GUICreate("Tech Support Tools", 500, 500) ; will create a dialog box that when displayed is centered
	global $hGUI = GUICreate("Starter " & $CurrentVersion, 220, 280)

    Opt("GUICoordMode", 1)

    $tab = GUICtrlCreateTab(7, 5, 200, 250)
    $Tab_Tools = GUICtrlCreateTabItem("Tools")
	$bkcolor = "0xcceeff"
	GUISetBkColor($bkcolor) ; will change background color
    $menu1 = GUICtrlCreateMenu("File")
	;$help = GUICtrlCreateMenuItem("Help",$menu1)
	$about = GUICtrlCreateMenuItem("About",$menu1)
	$exit = GUICtrlCreateMenuItem("Exit",$menu1)

	$rAudio = GUICtrlCreateRadio("Audio",20, 40, 60, 20)
    $rTV = GUICtrlCreateRadio("TV", 20, 70, 60, 20)
	GUICtrlSetState($radio2, $GUI_CHECKED)
	;GUICtrlCreateLabel("All", 20, 70, 40, 20) ;
	$rMisc = GUICtrlCreateRadio("Misc", 90, 40, 60, 20)
	$rMovies = GUICtrlCreateRadio("Movies", 90, 70, 60, 20)
	;$rAll = GUICtrlCreateRadio("All", 150, 70, 60, 20)

	$Start_Button = GUICtrlCreateButton("Start", 20, 110, 80)
	GUICtrlSetImage(-1, "Shell32.dll", 246, 0)
	$Stop_Button = GUICtrlCreateButton("Stop All", 20, 150, 80)
	GUICtrlSetImage(-1, "C:\Windows\System32\imageres.dll", -101,0)
	$Reset_Button = GUICtrlCreateButton("Reset", 104, 110, 80)
	GUICtrlSetImage(-1, $icons32, 23,0)
	$Broadcaster_Button = GUICtrlCreateButton("Guide", 104, 150, 80)
	GUICtrlSetImage(-1, $icons32, 22,0)

	;------------------------------------------
	;Tab Configure
	;------------------------------------------
	$Tab_Configure = GUICtrlCreateTabItem("Configure")
    $radio1 = GUICtrlCreateRadio("Audio", 20, 40, 60, 20)
    $radio2 = GUICtrlCreateRadio("TV", 20, 70, 60, 20)
	GUICtrlSetState($radio2, $GUI_CHECKED)
	$radio3 = GUICtrlCreateRadio("All", 90, 40, 60, 20)
	$radio4 = GUICtrlCreateRadio("Movies", 90, 70, 60, 20)
	Local $iMosaicCheckbox = GUICtrlCreateCheckbox("Copy to mosaic tab", 20, 100, 120, 20)

    GUICtrlCreateLabel("Start Channel", 20, 130, 80, 20) ;
	$channel = GUICtrlCreateInput(1, 90, 130, 30, 20)
    GUICtrlCreateLabel("Client IP:", 20, 150, 50, 20) ;
	$IP = GUICtrlCreateInput("127.0.0.1", 80, 150, 80, 20)
	GUICtrlCreateLabel("Port:", 20, 170, 40, 20) ;
	$port = GUICtrlCreateInput("1220", 50, 170, 80, 20)
    Local $iCheckbox2 = GUICtrlCreateCheckbox("Start Broadcasting on exit", 20, 200, 160, 20)
	$btn = GUICtrlCreateButton("Go", 70, 230, 60, 20)

    GUISetState(@SW_SHOW)
	GUICtrlCreateTabItem("")   ;end of tabs
	GUISetState()

; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
           ;------------------------------------------
		   ;Start
		   ;------------------------------------------
		   Case $msg = $Start_Button   ;Start
				If GUICtrlRead($rAudio) = 1 Then
					If FileExists(@ScriptDir & "\audio.bat") Then
						Run(@ScriptDir & "\audio.bat")
					Else
						MsgBox(0, "msg", "Batch File missing. Run configure first", 3)
					EndIf
				ElseIf $rTV And BitAND(GUICtrlRead($rTV), $GUI_CHECKED) = $GUI_CHECKED Then
					If FileExists(@ScriptDir & "\TV.bat") Then
						Run(@ScriptDir & "\TV.bat")
					Else
						MsgBox(0, "msg", "Batch File missing. Run configure first", 3)
					EndIf
				ElseIf $rMovies And BitAND(GUICtrlRead($rMovies), $GUI_CHECKED) = $GUI_CHECKED Then
					$type = "Movies"
					If FileExists(@ScriptDir & "\movies.bat") Then
						Run(@ScriptDir & "\movies.bat")
					Else
						MsgBox(0, "msg", "Batch File missing. Run configure first", 3)
					EndIf
				ElseIf $rMisc And BitAND(GUICtrlRead($rMisc), $GUI_CHECKED) = $GUI_CHECKED Then
					 If FileExists(@ScriptDir & "\misc.bat") Then
						Run(@ScriptDir & "\misc.bat")
					Else
						MsgBox(0, "msg", "Batch File missing. Run configure first", 3)
					EndIf
				Else
					 If FileExists(@ScriptDir & "\misc.bat") Then
						Run(@ScriptDir & "\misc.bat")
					EndIf
				 EndIf
			;------------------------------------------
		   ;Stop
		   ;------------------------------------------
			Case $msg = $Stop_Button
				 If ProcessExists("vlc.exe") Then
						;MsgBox(0, "msg", "Stopping process...")
						;Local $PID = ProcessExists("vlc.exe") ; Will return the PID or 0 if the process isn't found.
						;With Do/Until Loop
						SplashTextOn("Msg", "Stopping Processes... ", -1, 100, -1, -1, 18, "", 24)
						Do
							ProcessClose('vlc.exe')
						Until Not ProcessExists('vlc.exe')
						SplashOff()
					EndIf
			Case $msg = $Broadcaster_Button
				If FileExists("..\client\Broadcasts.exe") Then
					Run("..\client\Broadcasts.exe")
				EndIf
			Case $msg = $Reset_Button
				Dim $dFiles[12]=["misc.bat", "misc.cfg", "misc.txt", "TV.bat", "TV.cfg", "TV.txt", "Movies.bat", "Movies.cfg", "movies.txt", "audio.bat", "audio.cfg", "audio.txt"]
				For $x = 0 to UBound($dFiles) -1
					If FileExists(@ScriptDir & "\" & $dFiles[$x]) Then
						FileDelete(@ScriptDir & "\" & $dFiles[$x])
					ElseIf FileExists("..\client" & "\" & $dFiles[$x]) Then
						FileDelete("..\client" & "\" & $dFiles[$x])
					EndIf
				Next
				MsgBox(0, "msg", "Reset completed...", 3)
			;-------------------------------------------
			;Configure tab starts here
			;-------------------------------------------
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

				$channel1 = GUICtrlRead($channel)
				$IP1 = GUICtrlRead($IP)
 				$port1 = GUICtrlRead($port)
				;MsgBox(0, "", "radio selected " & $type & " port: " & $port & " IP: " & $IP & " channel: " & $channel)
				GetFiles($type, $channel1, $IP1, $port1)

				If ($mosaicCopy = 1) Then
					FileCopy("..\client\" & $type & ".txt", "..\client\mosaic.txt", 1)
				EndIf

				If _IsChecked($iCheckbox2) Then
                    ;MsgBox($MB_SYSTEMMODAL, "", "The checkbox is checked.")
					$startit = 1
					If $IP = "127.0.0.1" Then
						Run("..\client\Broadcasts.exe")
					EndIf
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
				MsgBox(0, "msg", "Configuration completed...", 3)
			Case $msg = $exit
			   Exit
			Case $msg = $about
			   MsgBox(0, "About", "Created by Dave Dougal.... Version: " & $CurrentVersion, 10)
		EndSelect
    WEnd
EndFunc

;Functions
Func GetFiles($type, $channel, $IP, $port)
	;MsgBox(0, "", "port: " & $port & " channel: " & $channel & " type: " & $type & " IP: " & $IP)
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
	ElseIf $type = "misc" Then
		$aList = _FileListToArrayRec($dir, "*.avi;*.wmv;*.mp3;*.mov;*.mpeg;*.mpg;*.wma;*.flv;*.m4v;*.mkv;*.mp4;*.divx||*.*", 13, 1, 1, 1)
		;MsgBox(0, "", "misc was picked")
	Else
		$aList = _FileListToArrayRec($dir, "*.avi;*.wmv;*.mov;*.mpeg;*.mpg;*.flv;*.m4v;*.mkv;*.mp4;*.divx||*.*", 13, 1, 1, 1)
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