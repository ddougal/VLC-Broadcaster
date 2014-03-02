#Include <File.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <FileConstants.au3>

 Opt("GUIOnEventMode", 1)

StartGUI()

 ; ----- GUIs
Func StartGUI()
    Opt("GUICoordMode", 1)

	Global $listview, $listview2, $listview3, $listview4, $listview5
	$listGUI = GUICreate("Broadcast Media Stations", 400, 500, 100, 440, -1)  ;width, height
	GUISetBkColor(0x00E0FFFF) ; will change background color
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Main")

	Global $tab = GUICtrlCreateTab(40, 20, 290, 320)
	;$tab = GUICtrlCreateTab(110, 20, 200, 150)
	; Close Tab definiton

	;============================================================================
	; TV Tab
	;============================================================================
	$Tab_Tools = GUICtrlCreateTabItem("TV")
	GUICtrlSetState(-1, $GUI_SHOW) ; Use this!

	$listview = GUICtrlCreateListView("Shows | Channel | Port", 40, 40, 290, 380, $LVS_SORTASCENDING, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)  ;width, height, width, height
	_GUICtrlListView_SetColumnWidth($listview, 0, 140)  ;width
	GUICtrlSetBkColor($listview, $GUI_BKCOLOR_LV_ALTERNATE)

	$selItem = "SelectItem"
	$filename = "tv.txt"
	Records($listview, $filename, $selItem)

	;============================================================================
	; Audio Tab
	;============================================================================
	$Tab_Audio = GUICtrlCreateTabItem("Audio")
	$listview2 = GUICtrlCreateListView("Broadcasts | Channel | Port", 40, 40, 290, 380, $LVS_SORTASCENDING, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)  ;width, height, width, height
	_GUICtrlListView_SetColumnWidth($listview2, 0, 140)  ;width
	GUICtrlSetBkColor($listview2, $GUI_BKCOLOR_LV_ALTERNATE)

	$selItem = "SelectItem2"
	$filename = "audio.txt"
	Records($listview2, $filename, $selItem)

	;============================================================================
	; Movies Tab
	;============================================================================
	$Tab_Movies = GUICtrlCreateTabItem("Movies")
	$listview4 = GUICtrlCreateListView("Shows | Channel | Port", 40, 40, 290, 380, $LVS_SORTASCENDING, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)  ;width, height, width, height
	_GUICtrlListView_SetColumnWidth($listview4, 0, 140)  ;width
	GUICtrlSetBkColor($listview4, $GUI_BKCOLOR_LV_ALTERNATE)

	$selItem = "SelectItem4"
	$filename = "movies.txt"
	Records($listview4, $filename, $selItem)

	;============================================================================
	; Other Tabs
	;============================================================================
	$Tab_MVidz = GUICtrlCreateTabItem("MVideos")
	;$Tab_Concerts = GUICtrlCreateTabItem("Concerts")
	;$Tab_Pics = GUICtrlCreateTabItem("Pics")






	;============================================================================
	; Misc Tab
	;============================================================================
	$Tab_Misc = GUICtrlCreateTabItem("Misc")
	$listview5 = GUICtrlCreateListView("Shows | Channel | Port", 40, 40, 290, 380, $LVS_SORTASCENDING, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT)  ;width, height, width, height
	_GUICtrlListView_SetColumnWidth($listview5, 0, 140)  ;width
	GUICtrlSetBkColor($listview5, $GUI_BKCOLOR_LV_ALTERNATE)

	$selItem = "SelectItem5"
	$filename = "misc.txt"
	Records($listview5, $filename, $selItem)

	;============================================================================
	; Movies Mosaic
	;============================================================================
	$Tab_Mosaic = GUICtrlCreateTabItem("Mosaic")
	$bkcolor = "0xcceeff"
	$listview3 = GUICtrlCreateListView("Shows | Channel | Port", 40, 40, 290, 380, $LVS_SORTASCENDING, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT + $LVS_EX_CHECKBOXES)  ;width, height, width, height
	_GUICtrlListView_SetColumnWidth($listview3, 0, 140)  ;width
	GUICtrlSetBkColor($listview3, $GUI_BKCOLOR_LV_ALTERNATE)

	Local $mosaicRecords
	If Not _FileReadToArray(@ScriptDir & "\mosaic.txt", $mosaicRecords) Then
		;MsgBox(4096, "Error", " Error reading log to Array     error:" & @error)
		;Exit
	EndIf

	;Dim $item[47]  ;1 more than total u have
	Dim $item[UBound($mosaicRecords)]  ;1 more than total u have

	For $i = 1 To UBound($mosaicRecords) - 1
		$item[$i] = GUICtrlCreateListViewItem($mosaicRecords[$i], $listview3)
		GUICtrlSetBkColor(-1, $bkcolor)
	Next

	;$BtnAdd = GUICtrlCreateButton("Add Item", 10, 450, 80, 30)
	;GUICtrlSetOnEvent(-1, "Addi")
	$BtnSelect = GUICtrlCreateButton("Play", 150, 450, 80, 30)
	GUICtrlSetOnEvent(-1, "SelectItem3")


	GUICtrlCreateTabItem(""); end tabitem definition
	GUISetState()

	While 1
		Sleep(10)
	WEnd
EndFunc








 ; ///// Functions
Func Records($listviews, $filename, $selItem)
	Local $audioRecords
	$bkcolor = "0xcceeff"
	If Not _FileReadToArray(@ScriptDir & "\" & $filename, $audioRecords) Then
		;MsgBox(4096, "Error", " Error reading log to Array     error:" & @error)
		;Exit
	EndIf
	;GUICtrlSetBkColor(-1, 0xcceeff)
	;MsgBox(4160, "Information", "Column 1 Width: " & _GUICtrlListView_GetColumnWidth($listview, 0))
	For $i = 1 To UBound($audioRecords) - 1
		GUICtrlCreateListViewItem($audioRecords[$i], $listviews)
		GUICtrlSetBkColor(-1, $bkcolor)
	Next

	;$BtnAdd = GUICtrlCreateButton("Add Item", 10, 450, 80, 30)
	;GUICtrlSetOnEvent(-1, "Addi")
	$BtnSelect = GUICtrlCreateButton("Play", 150, 450, 80, 30)
	GUICtrlSetOnEvent(-1, $selItem)

EndFunc

Func Addi()
   $sToAdd = InputBox("Add", "Enter Item Name", "")
   GUICtrlCreateListViewItem($sToAdd, $listview)
EndFunc

;why do I have to use multiple SelectItem functions here. has to do with onevent not able to pass variables. should be another way
Func SelectItem()
  $sItem = GUICtrlRead(GUICtrlRead($listview))
	ProcessFile($sItem)
EndFunc

Func SelectItem2()
	$sItem = GUICtrlRead(GUICtrlRead($listview2))
	ProcessFile($sItem)
EndFunc

Func SelectItem4()
	$sItem = GUICtrlRead(GUICtrlRead($listview4))
	ProcessFile($sItem)
EndFunc

Func SelectItem3()
	FileCopy(@ScriptDir & "\Template-Conf.vlm", @ScriptDir & "\Conf.vlm", 1)
	;$sItem = GUICtrlRead(GUICtrlRead($listview3))
	Local $find[12] = ["1401", "1402", "1403", "1404", "1405", "1406", "1407", "1408", "1409", "1410", "1411", "1412"]  ;12 videos in the montage
	$cntr = 0
	;Local $replace = "AFTER"

	$filename = @ScriptDir & "\Conf.vlm"
	For $x = 1 To 47 ;change this to variable  this has to be changed if u add more videos
		If _GUICtrlListView_GetItemChecked($listview3, $x - 1) Then
			$sItem = _GUICtrlListView_GetItemTextString($listview3, $x - 1)
			;$len = StringLen($sItem)
			;MsgBox(0, "", "sitem: " & $sItem & " len: " & $len)
			;$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
			$string2 = StringRight($sItem, 4)
			$string1 = "udp://@:"
			$replace = $string1 & $string2
			$retval = _ReplaceStringInFile($filename, $find[$cntr], $string2)
			If $retval = -1 Then
				MsgBox(0, "ERROR", "The pattern could not be replaced in file: " & $filename & " Error: " & @error & " find: " & $find[$cntr])
				Exit
			Else
				;MsgBox(0, "INFO", "Found " & $retval & " occurances of the pattern: " & $find[$cntr] & " in the file: " & $filename)
			EndIf
			;MsgBox(0, "listview item", _GUICtrlListView_GetItemTextString($listview3, $x - 1) & "    " & @CRLF & "Line Checked = " & $x & " string2: " & $string2, 2)
			$cntr = $cntr + 1
		EndIf
	Next
	Run("C:\Program Files (x86)\VideoLAN\VLC\vlc.exe --vlm-conf=C:\Users\dave\Desktop\test\Conf.vlm --mosaic-height=864 --mosaic-width=1152 --mosaic-rows=2 --mosaic-cols=6 --mosaic-order=1,2,3,4,5,6,7,8,9,10,11,12 -I dummy")
	;vlc.exe --vlm-conf=C:\CONFIG-12b.vlm --mosaic-height=864 --mosaic-width=1152 --mosaic-rows=2 --mosaic-cols=6 --mosaic-order=1,2,3,4,5,6,7,8,9,10,11,12 -I dummy
	;ProcessFile($sItem)
EndFunc

Func SelectItem5()
	$sItem = GUICtrlRead(GUICtrlRead($listview5))
	ProcessFile($sItem)
EndFunc

Func ProcessFile($sItem)
	$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
	$string2 = StringRight($sItem, 4)
	$string1 = "udp://@:"
	$string3 = $string1 & $string2
	;MsgBox(0, "Selected Item", $sItem & " string3: " & $string3 & " string1: " & $string1 & " string2: " & $string2)
	CreateFile($string3)
	Shellexecute(@ScriptDir & "\tmp.m3u")
EndFunc


Func CreateFile($string3)
	$fileName = @ScriptDir & "\tmp.m3u"
	If Not _FileCreate($fileName) Then
		MsgBox(0, "Error", " Error Creating/Resetting log.      error:" & @error)
	EndIf

	 ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($fileName, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox(0, "", "An error occurred when reading the file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, $string3)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

EndFunc


Func On_Close_Main()
   Exit
EndFunc