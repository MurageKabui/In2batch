#NoTrayIcon
#include-once

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_CompanyName=Kabue Murage[Thebateam.org]
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo /sf /rm /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ===================================================================================
 AutoIt Version  : 3.3.14.5
 Author          : Mr.km
 Facebook        : Kabue Murage
 Script Function : Commandline version of In2batch
				   Embed files into your batch scripts.
 Date            : Nov 1st 2019
 Website         : Thebateam.org
# ---------------------------------------------------
FEATURES :
# ---------------------------------------------------

Notifications (GUI).
Custom Batch script Function name.
End/Start Regions markings.


#ce ===================================================================================

#include <GUIConstants.au3>
#include <Process.au3>
#include <Misc.au3>
#include <WinAPIFiles.au3>

Local $ifilesize
Global $vFirArg
Global $sMod_pth_, $s1stEcho, $sHelp_syn
Global $sSize_, $sLne_rd, $sALL_, $sfile2wrte, $sFuD2, $s_Args_, $sFdw_, $sFileName = ""
Global $hNdlrd, $hNdlWte, $hSearch
Global $bISclicked = False, $bSndNotice, $bNotice, $bExpError = False
Global $iNotyLimit = 7

Global $_notificationStartup = False
Global $_notificationOnEvent = False
Global $_desktopHeight = 0
Global Const $_notificationWidth = 300
Global Const $_notificationHeight = 115
Global Const $_notificationLeft = @DesktopWidth - $_notificationWidth - 10


Global $_notificationList[0][9]
;      $_notificationList[i][0] = notification window handle
;      $_notificationList[i][1] = notification window state (True: notification visible, False: invisible)
;      $_notificationList[i][2] = notification window x coord
;      $_notificationList[i][3] = notification window y coord
;      $_notificationList[i][4] = notification button handle
;      $_notificationList[i][5] = notification closing button handle
;      $_notificationList[i][6] = notification call function
;      $_notificationList[i][7] = notification close on click
;      $_notificationList[i][8] = notification transparency


Global Const $_notificationAnimationTimeDefault = 150
Global Const $_notificationBkColorDefault = Default
Global Const $_notificationBorderDefault = False
Global Const $_notificationColorDefault = 0xFFFFFF
Global Const $_notificationDateFormatDefault = "DD.MM."
Global Const $_notificationClosingButtonTextDefault = "Close"
Global Const $_notificationSoundDefault = @WindowsDir & "\Media\Windows Background.wav"
Global Const $_notificationTextAlignDefault = $SS_CENTER
Global Const $_notificationTimeFormatDefault = "HH:MM"
Global Const $_notificationTransparencyDefault = Default

Global $_notificationAnimationTime = $_notificationAnimationTimeDefault
Global $_notificationBkColor = $_notificationBkColorDefault
Global $_notificationBorder = $_notificationBorderDefault
Global $_notificationClosingButtonText = $_notificationClosingButtonTextDefault
Global $_notificationDateFormat = $_notificationDateFormatDefault
Global $_notificationSound = $_notificationSoundDefault
Global $_notificationTextAlign = $_notificationTextAlignDefault
Global $_notificationColor = $_notificationColorDefault
Global $_notificationTimeFormat = $_notificationTimeFormatDefault
Global $_notificationTransparency = $_notificationTransparencyDefault

Global Const $_dllTimeStruct = DllStructCreate("int64 time;")
Global Const $_dllTimeStructPointer = DllStructGetPtr($_dllTimeStruct)


Global $_ntDLL

;~ If _Singleton(@ScriptName) = 0 Then
;~ 	$bISclicked = True
;~ 	ConsoleWrite("Running instance" & @LF)
;~ 	Exit
;~ EndIf

$vFirArg = _CmdLine_GetValByIndex(1, False)
$sChkWld = StringInStr($vFirArg, "*.", $STR_CASESENSE)
; Check wildcrads
If $sChkWld = 1 Then
	ConsoleWrite("This version of In2Batch does not support wildcrads." & @LF)
	Exit (1)
EndIf

$aMtpleEnc = StringSplit($vFirArg, ";", $STR_ENTIRESPLIT)

$bNotice = _CmdLine_KeyExists('notify')
If $bNotice And $aMtpleEnc[0] <> 0 Then
	Opt("GUIOnEventMode", 1)
	$bSndNotice = True
	_Notifications_Startup()
	_Notifications_SetColor(0xfb7803)
	_Notifications_SetBkColor(0x191919)
	_Notifications_SetTransparency(225)
	_Notifications_SetButtonText("close")
Else
	$bSndNotice = False
EndIf

$bHlp1 = _CmdLine_KeyExists('?')
$bHlp2 = _CmdLine_KeyExists('-help')
$bStNot = StringInStr($vFirArg, "/notify")

If Not $vFirArg Or $bHlp1 Or $bHlp2 Or $bStNot Then
	help_me()
	Print_help()
	Exit (0)
ElseIf _CmdLine_KeyExists('ver') Or _CmdLine_KeyExists('version') Then
	ConsoleWrite("In2Batch build 2.Mar.2020" & @LF)
	Exit (0)
ElseIf _CmdLine_KeyExists('size') Then
	$aMtple_sze = StringSplit($vFirArg, ";")
	If $aMtple_sze[0] <> 0 Then
		For $i = 1 To $aMtple_sze[0]
			If FileExists($aMtple_sze[$i]) Then
				$sDlngWth = $aMtple_sze[$i]
				$nnPath_valid = _WinAPI_FileExists($sDlngWth)
				If $nnPath_valid = 1 Then
					ConsoleWrite(StringRegExpReplace($sDlngWth, "^.*\\", "") & "/" & ByteSuffix(FileGetSize($sDlngWth)) & @LF)
				EndIf
				$bExpError = False
			Else
				ConsoleWrite(":: File does not exist [" & $aMtple_sze[$i] & "]")
				$bExpError = True
			EndIf
		Next
	ElseIf ($aMtple_sze[0]) = 0 And (_WinAPI_FileExists($vFirArg) = 1) Then
		ConsoleWrite(StringRegExpReplace($vFirArg, "^.*\\", "") & ":" & ByteSuffix(FileGetSize($vFirArg)) & @LF)
	EndIf
	Exit (0)
	If Not $bExpError Then
		Exit (0)
	Else
		Exit (1)
	EndIf
ElseIf $aMtpleEnc[0] <> 0 Then
	For $i = 1 To $aMtpleEnc[0]
		$sFdw_ = $aMtpleEnc[$i]
		If FileExists($sFdw_) Then
			$nPath_valid = _WinAPI_FileExists($sFdw_)
			$nIs_dir = @extended
			If $nPath_valid = 1 Then     ; IS FILE
				;$vFirArg = sFdw_
				encode_now($sFdw_)
				$s1stEcho = True
				If $bSndNotice And $sSize_ <> "0 bytes" And $aMtpleEnc[0] <> 0 Then
					_Notifications_Create("CL-In2Batch processd [" & $sSize_ & "] ", " Completed : " & $sFdw_, "click", True)
				EndIf
			ElseIf $nIs_dir = 1 Then     ; If Is a folder.
				If StringRight($sFdw_, 1) <> "\" Then $sFdw_ &= "\"
				$hSearch = FileFindFirstFile($sFdw_ & "*.*")
				$sFullPth = $sFdw_

				If $hSearch = -1 Then
					ConsoleWrite(":: Error :No files found in folder " & $sFdw_ & @LF)
					Exit (4)
				Else
					; While 1
					For $i = 1 To $iNotyLimit ; Step +1
						$sFileName = FileFindNextFile($hSearch)
						If @error Then ExitLoop
						;$vFirArg = $sFullPth & $sFileName
						encode_now($sFullPth & $sFileName)
						If Not $s1stEcho Then $s1stEcho = True
						If $bSndNotice And $sSize_ <> "0 bytes" And $aMtpleEnc[0] <> 0 Then
							_Notifications_Create("CLIn2Batch completed", $sFdw_ & @LF & "\" & $sFileName, "click", True)
						EndIf
						If $i > 5 Then $i = 1
					Next
					; WEnd
					FileClose($hSearch)
				EndIf
			EndIf
		Else
			$bNotice = False
			$bExpError = True
			ConsoleWrite(":: Error : Check Filename/Path [" & $aMtpleEnc[$i] & "]" & @LF)
		EndIf
	Next
EndIf
#EndRegion ;=============check Arguments / Parameters parsed! ==========

Func encode_now($vFirArg)
	$ifilesize = FileGetSize($vFirArg)
	$sMod_pth_ = StringRegExpReplace($vFirArg, "^.*\\", "")
	$sSize_ = ByteSuffix($ifilesize)
	_delfile(@TempDir & "\_unProcessed_cert.txt")
	; Local $func_ID1
	If _CmdLine_KeyExists('funcname') Then
		$func_ID1 = _CmdLine_Get("funcname", "")
		If Not $func_ID1 Or $func_ID1 = "" Then
			GenRandom_for_batch()
		Else
			$sFuD2 = StringRegExpReplace($func_ID1, "[~ ^.*-+@!#$%&()|;]", "_")
		EndIf
	Else
		GenRandom_for_batch()
	EndIf
	$s_pthCer = @WindowsDir & "\System32\certutil.exe"
	If FileExists($s_pthCer) Then
		$s_Args_ = $s_pthCer & " -encode " & '"' & $vFirArg & '" ' & '"' & @TempDir & "\_unProcessed_cert.txt" & '" >nul'
		CsALL_cmd($s_Args_)
	Else
		ConsoleWrite("In2Batch Error [3] : CertUtil.exe missing." & @LF)
		Exit (3)
	EndIf
	$sfile2wrte = "\_unProcessed_cert.txt"
	$hNdlrd = FileOpen(@TempDir & "\_unProcessed_cert.txt", 0)
	$hNdlWte = FileOpen($sfile2wrte, 2)
	If $sSize_ <> "0 bytes" Then
		If Not $s1stEcho Then
			$sWtecho_ = "@Echo off" & _
					@CRLF & @CRLF & _
					"Set ""destination_dir=%cd%\bin""" & @CRLF & @CRLF & _
					"If not exist ""%destination_dir%"" (md ""%destination_dir%"")" & @CRLF & @CRLF
			If _CmdLine_KeyExists('srg') Then $sWtecho_ &= "rem ================ Start Region In2Batch CL-Generator ================="
		Else
			$sWtecho_ = ""
		EndIf
		ConsoleWrite( _
				$sWtecho_ & @CRLF & _
				" If Exist " & '"%destination_dir%\' & $sMod_pth_ & '" (goto :' & $sFuD2 & ")" & @CRLF & @CRLF)
		$sALL_ = ""
		Local $hDLL = DllOpen("user32.dll")
		Global $sRedone
		Do
			; Sleep(10)
			$sLne_rd = FileReadLine($hNdlrd)
			If @error = 1 Then ExitLoop
			If _IsPressed("1B", $hDLL) Then Exit (4)
			$sALL_ &= $sLne_rd & @CRLF & "    Echo "
		Until ($sLne_rd = "-----END CERTIFICATE-----") Or _IsPressed("23", $hDLL) Or @error = -1
		; 23 = EndKey / Exit running file to the next in line.
		; 1b = EscKey / Exits whole script.
		DllClose($hDLL)
		$sRedone = StringReplace($sALL_, "-----BEGIN CERTIFICATE-----", "    Echo -----BEGIN CERTIFICATE----- >""%temp%\_tempDoc_.In2b""" & @LF & " (")
		$sIfEndRegion = ""
		If _CmdLine_KeyExists('erg') Then $sIfEndRegion = "rem ================= End Region In2Batch CL-Generator ==================" & @CRLF
		ConsoleWrite($sRedone & _
				"File properties. &&REM The Lines below won't affect decoding." & @CRLF & _
				"    Echo File Name : " & $sMod_pth_ & @CRLF & _
				"    Echo File Size : " & $sSize_ & @CRLF & _
				" ) >>""%temp%\_tempDoc_.In2b""" & @CRLF & _
				" CertUtil -decode -f ""%temp%\_tempDoc_.In2b"" " & '"%destination_dir%\' & $sMod_pth_ & '" >nul' & @CRLF & _
				" del /F /Q ""%temp%\_tempDoc_.In2b""" & @CRLF & @CRLF & _
				$sIfEndRegion & _
				":" & $sFuD2 & @CRLF)
		FileClose($hNdlrd)
		FileClose($hNdlWte)
	Else
		ConsoleWrite(":: File " & $sMod_pth_ & " contains no readable data. Size:" & $sSize_ & @LF)
		; Exit (1)
	EndIf
EndFunc   ;==>encode_now

Func _delfile($spath)
	If FileExists($spath) Then FileDelete($spath)
	; If FileExists($spath) Then FileDelete($spath)
EndFunc   ;==>_delfile

Func GenRandom_for_batch()
	$sFuD2 = ""
	$sFuD2 = Random(10000000, 1000000000, 1) & Random(10000, 10000000, 1)
EndFunc   ;==>GenRandom_for_batch

Func ByteSuffix($iBytes)
	Local $iIndex = 0, $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>ByteSuffix

Func CsALL_cmd($s_Args_)
	If StringLeft($s_Args_, 1) = " " Then $s_Args_ = " " & $s_Args_
	Local $nPid = Run(@ComSpec & " /c" & $s_Args_, "", @SW_HIDE, 8), $sRet = ""
	If @error Then Exit (3)
	ProcessWait($nPid)
	While 1
		$sRet &= StdoutRead($nPid)
		If @error Or (Not ProcessExists($nPid)) Then
			ExitLoop
		EndIf
		Sleep(10)
	WEnd
	Return $sRet
EndFunc   ;==>CsALL_cmd


Func Print_help()
	ConsoleWrite($sHelp_syn)
EndFunc   ;==>Print_help


Func help_me()
	$sHelp_syn = @CRLF & " In2Batch Commandline version by Kabue Murage" & _
			@CRLF & _
			" Generate a batch code that allows you to recreate or store files in your" & @CRLF & _
			" batch scripts." & @CRLF & _
			@CRLF & _
			"  Syntax:" & @CRLF & _
			"  " & @ScriptName & " ""[File.abc;FolderABC;File.abc; ...]"" (opt [/funcname] [/notify] [/size])" & @CRLF & _
			@CRLF & _
			"  The first argument should consist of valid folders/file paths, which are" & @CRLF & _
			"  delimited using a semi colon for a multiple file operation. If a folder " & @CRLF & _
			"  is included among the delimited argument listing, then all the present files" & @CRLF & _
			"  in that folder will be included in the operation. Unreadable/0 byte files" & @CRLF & _
			"  and subdirectories present are automatically skipped." & @CRLF & @CRLF & _
			" /funcname - The custom name for your Batch script Function. If this parameter" & @CRLF & _
			"             is left unused, the program will generate a random number as your" & @CRLF & _
			"              function ID for your batch code. This Parameter is best used when" & @CRLF & _
			"              working with a single file." & @CRLF & _
			"           Example: " & @CRLF & _
			"             " & @ScriptName & " File1.abc /funcname ""CreateImage1""" & @CRLF & _
			"             (Generates for file: ""File.abc"" with function label :CreateImage1)" & @CRLF & @CRLF & _
			"       (NB)  To avoid errors, This parameter filters out all unsupported characters" & @CRLF & _
			"              from the given argument and attempts to validate it with acceptable" & @CRLF & _
			"              characters that suit a callable batch function ID." & @CRLF & _
			" /notify   - Including this switch causes a notification to be triggered after every" & @CRLF & _
			"             instance of a successful operation." & @CRLF & @CRLF & _
			" Use the shell redirection capability to parse the standard output code to a physical" & @CRLF & _
			" file handle using the redirection operators "">>"" Or "">"" , or pipe directly to the" & @CRLF & _
			" clipboard using ""| Clip"" . Ongoing operations can be terminated by pressing ""esc""" & @CRLF & _
			" or the ""end"" key. For more examples, read documentation." & @CRLF & @CRLF & _
			" Examples: " & @CRLF & _
			"> " & @ScriptName & " ""File1.abc"" /funcname ""CreateImage1"" >>MyBatchFile.bat" & @CRLF & _
			"> " & @ScriptName & " ""File1.abc;File2.xyz;Myicon.ico"" /notify | clip" & @CRLF & _
			"> " & @ScriptName & " ""G:\Temp\Image.bmp;C:\Temp\File.vbs;%cd%\Icon1.ico"" /size" & @CRLF & @CRLF & _
			" Exit codes: (Set to DOS variable %ERRORLEVEL%)" & @CRLF & _
			"     0 - Success / No Error." & @CRLF & _
			"     1 - One or more files failed (Mostly due to Invalid File/Path)" & @CRLF & _
			"     3 - CertUtil error." & @CRLF & _
			"> Fb) Kabue Murage //web: Thebateam.org" & @CRLF
EndFunc   ;==>help_me

; =======================================================================

Func _CmdLine_Get($sKey, $mDefault = Null)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = "/" & $sKey Or $CmdLine[$i] = "-" & $sKey Or $CmdLine[$i] = "--" & $sKey Then
			If $CmdLine[0] >= $i + 1 Then
				Return $CmdLine[$i + 1]
			EndIf
		EndIf
	Next
	Return $mDefault
EndFunc   ;==>_CmdLine_Get

Func _CmdLine_KeyExists($sKey)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = "/" & $sKey Or $CmdLine[$i] = "-" & $sKey Or $CmdLine[$i] = "--" & $sKey Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_KeyExists

Func _CmdLine_ValueExists($sValue)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = $sValue Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_ValueExists

Func _CmdLine_FlagEnabled($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "\+([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagEnabled

Func _CmdLine_FlagDisabled($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "\-([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagDisabled

Func _CmdLine_FlagExists($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "(\+|\-)([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagExists

Func _CmdLine_GetValByIndex($iIndex, $mDefault = Null)
	If $CmdLine[0] >= $iIndex Then
		Return $CmdLine[$iIndex]
	Else
		Return $mDefault
	EndIf
EndFunc   ;==>_CmdLine_GetValByIndex
; =======================================================================
Func _Notifications_CheckGUIMsg($_GUIMsg)

	If _Notifications_StartupIsComplete() = False Then Return

	Local $_notificationCount = UBound($_notificationList)
	Local $_deleteNotification = False
	Local $_callFunction = ""

	;check all notifications buttons for the gui message...
	For $_i = 0 To $_notificationCount - 1

		;until invisible notifications are reached. Stop here so save execution time
		If $_notificationList[$_i][1] = False Then ExitLoop


		;notification was clicked
		If $_GUIMsg = $_notificationList[$_i][4] Then

			If $_notificationList[$_i][6] <> "" Then $_callFunction = $_notificationList[$_i][6]

			If $_notificationList[$_i][7] = True Then $_deleteNotification = True

			ExitLoop


			;close button on notification was clicked
		ElseIf $_GUIMsg = $_notificationList[$_i][5] Then

			$_deleteNotification = True
			Global $isclicked = True
			ExitLoop

		EndIf

	Next

	If $_deleteNotification = True Then _Notifications_Close($_i)

	If $_callFunction <> "" Then Call($_callFunction)

EndFunc   ;==>_Notifications_CheckGUIMsg

Func _Notifications_CloseAll()

	If _Notifications_StartupIsComplete() = False Then Return

	For $_i = 0 To UBound($_notificationList) - 1

		GUIDelete($_notificationList[$_i][0])

	Next

	ReDim $_notificationList[0][UBound($_notificationList, 2)]

EndFunc   ;==>_Notifications_CloseAll

Func _Notifications_Create($_title, $_message, $_callFunction = "", $_closeOnClick = True)

	If _Notifications_StartupIsComplete() = False Then Return



	;Local $_bkColor = $_notificationBkColor
	;If $_bkColor = Default Then $_bkColor = _Notifications_GetTaskbarColor()
	Local $_bkColor = $_notificationBkColor = Default ? _Notifications_GetTaskbarColor() : $_notificationBkColor

	;Local $_transparency = $_notificationTransparency
	;If $_transparency = Default Then $_transparency = _Notifications_GetTaskbarTransparency()
	Local $_transparency = $_notificationTransparency = Default ? _Notifications_GetTaskbarTransparency() : $_notificationTransparency



	;date & time
	Local $_date, $_time
	$_date = StringReplace($_notificationDateFormat, "DD", @MDAY)
	$_date = StringReplace($_date, "MM", @MON)
	$_date = StringReplace($_date, "YYYY", @YEAR)
	$_time = StringReplace($_notificationTimeFormat, "HH", @HOUR)
	$_time = StringReplace($_time, "MM", @MIN)
	$_time = StringReplace($_time, "SS", @SEC)


	;add an entry to the notification array
	Local $_notificationCount = UBound($_notificationList)
	ReDim $_notificationList[$_notificationCount + 1][UBound($_notificationList, 2)]

	;new notifications top position
	Local $_notificationWindowTopPos = _Notifications_GetTopPos()

	$_notificationList[$_notificationCount][1] = False
	$_notificationList[$_notificationCount][2] = $_notificationLeft
	$_notificationList[$_notificationCount][3] = $_notificationWindowTopPos
	$_notificationList[$_notificationCount][6] = $_callFunction

	If $_callFunction = "" Then $_closeOnClick = False
	$_notificationList[$_notificationCount][7] = $_closeOnClick

	$_notificationList[$_notificationCount][8] = $_transparency


	Local $_closingButtonTop = 85

	;create the GUI and set transparency
	$_notificationList[$_notificationCount][0] = GUICreate($_title, $_notificationWidth, $_notificationHeight, _
			$_notificationLeft, $_notificationWindowTopPos, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))

	GUISetBkColor($_bkColor, $_notificationList[$_notificationCount][0])
	WinSetTrans($_notificationList[$_notificationCount][0], "", $_transparency)


	If $_notificationBorder = True Then ; border created by colored labels with 1 pixel height or width
		GUICtrlCreateLabel("", 0, 0, 1, $_notificationHeight) ;left border
		GUICtrlSetBkColor(-1, $_notificationColor)
		GUICtrlCreateLabel("", 0, 0, $_notificationWidth, 1) ;top border
		GUICtrlSetBkColor(-1, $_notificationColor)
		GUICtrlCreateLabel("", $_notificationWidth - 1, 0, 1, $_notificationHeight) ;right border
		GUICtrlSetBkColor(-1, $_notificationColor)
		GUICtrlCreateLabel("", 0, $_notificationHeight - 1, $_notificationWidth, 1) ;bottom border
		GUICtrlSetBkColor(-1, $_notificationColor)
	EndIf


	;clickable label for the function to call when notification is clicked
	$_notificationList[$_notificationCount][4] = GUICtrlCreateLabel("", 0, 0, $_notificationWidth, $_closingButtonTop - 1)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	;title label
	GUICtrlCreateLabel($_title, 10, 10, $_notificationWidth - 20, 30, $_notificationTextAlign)
	GUICtrlSetColor(-1, $_notificationColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 13, 500)

	;message label
	GUICtrlCreateLabel($_message, 10, 40, $_notificationWidth - 20, 35, $_notificationTextAlign)
	GUICtrlSetColor(-1, $_notificationColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 11, 400)


	;creating a line to seperate the message of the notification from the closing button
	If $_notificationBorder = True Then
		GUICtrlCreateLabel("", 10, $_closingButtonTop, $_notificationWidth - 20, 1)
	Else
		GUICtrlCreateLabel("", 0, $_closingButtonTop, $_notificationWidth, 1)
	EndIf
	GUICtrlSetBkColor(-1, $_notificationColor)


	;bottom of the notification (closing button, date and time label)
	$_notificationList[$_notificationCount][5] = GUICtrlCreateLabel($_notificationClosingButtonText, 0, $_closingButtonTop, _
			$_notificationWidth, $_notificationHeight - $_closingButtonTop, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, $_notificationColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 11, 600)


	;date label
	GUICtrlCreateLabel($_date, 10, $_closingButtonTop, $_notificationWidth - 20, _
			$_notificationHeight - $_closingButtonTop, $SS_CENTERIMAGE)

	GUICtrlSetColor(-1, $_notificationColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 11, 400)


	;time label
	GUICtrlCreateLabel($_time, 10, $_closingButtonTop, $_notificationWidth - 20, _
			$_notificationHeight - $_closingButtonTop, BitOR($SS_RIGHT, $SS_CENTERIMAGE))

	GUICtrlSetColor(-1, $_notificationColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 11, 400)


	;if notification is in desktop area, show it
	If $_notificationWindowTopPos >= 0 Then

		GUISetState(@SW_SHOWNA, $_notificationList[$_notificationCount][0])
		$_notificationList[$_notificationCount][1] = True

	EndIf


	If $_notificationSound <> "" Then SoundPlay($_notificationSound)


	;if GUIOnEventMode is activated, set the function to be called when button is clicked
	If $_notificationOnEvent Then

		;Yes, it is right that the closing function for OnEvent is called for the usual notification click, because all the
		;function does it to get the clicked control ID and pass it to another function which checks which control was clicked
		If $_callFunction <> "" Then _
				GUICtrlSetOnEvent($_notificationList[$_notificationCount][4], "_Notifications_CloseOnEvent")

		;closing button
		GUICtrlSetOnEvent($_notificationList[$_notificationCount][5], "_Notifications_CloseOnEvent")

	EndIf


EndFunc   ;==>_Notifications_Create

Func _Notifications_SetAnimationTime($_animationTime)

	If $_animationTime = Default Then

		$_notificationAnimationTime = $_notificationAnimationTimeDefault
		Return True

	EndIf

	If StringRegExp($_animationTime, "^\d{1,4}$") = 0 Then Return False
	If $_animationTime > 2000 Then Return False

	$_notificationAnimationTime = $_animationTime
	Return True

EndFunc   ;==>_Notifications_SetAnimationTime

Func _Notifications_SetBorder($_showBorder)

	If $_showBorder = Default Then

		$_notificationBorder = $_notificationBorderDefault
		Return True

	EndIf

	If IsBool($_showBorder) = 0 Then Return False

	$_notificationBorder = $_showBorder
	Return True

EndFunc   ;==>_Notifications_SetBorder

Func _Notifications_SetButtonText($_buttonText)

	If $_buttonText = Default Then

		$_notificationClosingButtonText = $_notificationClosingButtonTextDefault
		Return True

	EndIf

	$_notificationClosingButtonText = $_buttonText
	Return True

EndFunc   ;==>_Notifications_SetButtonText

Func _Notifications_SetBkColor($_bkColor)

	If $_bkColor = Default Then

		$_notificationBkColor = $_notificationBkColorDefault
		Return True

	EndIf

	$_notificationBkColor = $_bkColor
	Return True

EndFunc   ;==>_Notifications_SetBkColor

Func _Notifications_SetColor($_textColor)

	If $_textColor = Default Then

		$_notificationColor = $_notificationColorDefault
		Return True

	EndIf

	$_notificationColor = $_textColor
	Return True

EndFunc   ;==>_Notifications_SetColor

Func _Notifications_SetDateFormat($_dateFormat)

	If $_dateFormat = Default Then

		$_notificationDateFormat = $_notificationDateFormatDefault
		Return True

	EndIf

	$_notificationDateFormat = $_dateFormat
	Return True

EndFunc   ;==>_Notifications_SetDateFormat


;set notification sound; "" = no sound; only mp3 or wav
Func _Notifications_SetSound($_sound)

	If $_sound = Default Then

		$_notificationSound = $_notificationSoundDefault
		Return True

	EndIf

	If $_sound = "" Then

		$_notificationSound = ""
		Return True

	EndIf

	If Not FileExists($_sound) Then Return False

	If StringRegExp($_sound, "\.(wav|mp3)$") = 0 Then Return False

	$_notificationSound = $_sound
	Return True

EndFunc   ;==>_Notifications_SetSound

Func _Notifications_SetTextAlign($_textAlign)

	If IsBool($_textAlign) Then Return False

	If $_textAlign = Default Then
		$_notificationTextAlign = $_notificationTextAlignDefault
		Return True

	EndIf


	Switch $_textAlign
		Case "left"
			$_notificationTextAlign = $SS_LEFT
		Case "center"
			$_notificationTextAlign = $SS_CENTER
		Case "right"
			$_notificationTextAlign = $SS_RIGHT
		Case Else
			Return False
	EndSwitch

	Return True

EndFunc   ;==>_Notifications_SetTextAlign

Func _Notifications_SetTimeFormat($_timeFormat)
	If $_timeFormat = Default Then

		$_notificationTimeFormat = $_notificationTimeFormatDefault
		Return True

	EndIf
	$_notificationTimeFormat = $_timeFormat
	Return True
EndFunc   ;==>_Notifications_SetTimeFormat

Func _Notifications_SetTransparency($_transparency)

	If $_transparency = Default Then

		$_notificationTransparency = $_notificationTransparencyDefault
		Return True

	EndIf

	If StringRegExp($_transparency, "^\d{1,3}$") = 0 Then Return False
	If $_transparency > 255 Then Return False

	$_notificationTransparency = $_transparency

	Return True
EndFunc   ;==>_Notifications_SetTransparency

Func _Notifications_Shutdown()

	If _Notifications_StartupIsComplete() = False Then Return

	For $_i = 0 To UBound($_notificationList) - 1

		GUIDelete($_notificationList[$_i][0])

	Next

	ReDim $_notificationList[0][UBound($_notificationList, 2)]

	DllClose($_ntDLL)
	$_notificationStartup = False

EndFunc   ;==>_Notifications_Shutdown

Func _Notifications_Startup()

	;check if startup was already called
	If _Notifications_StartupIsComplete() = True Then Return SetError(1, 0, False)


	;get taskbar height
	Local $_taskbarPos = ControlGetPos("[CLASS:Shell_TrayWnd]", "", "[CLASS:MSTaskListWClass; INSTANCE:1]")
	If Not IsArray($_taskbarPos) Then Return SetError(2, 0, False)

	$_desktopHeight = @DesktopHeight - $_taskbarPos[3]
	If $_desktopHeight <= 0 Then Return SetError(3, 0, False)


	;Open the dll that is used for _Notifications_Sleep
	$_ntDLL = DllOpen("ntdll.dll")
	If $_ntDLL = -1 Then Return SetError(4, 0, False)

	;register the shutdown function to be called when autoit exits so that resources are released (dll...)
	OnAutoItExitRegister("_Notifications_Shutdown")


	;check if GUIOnEventMode is activated
	Local $_isEventModeActivated = Opt("GUIOnEventMode", 1)
	If $_isEventModeActivated <> 1 Then Opt("GUIOnEventMode", $_isEventModeActivated)
	If $_isEventModeActivated Then $_notificationOnEvent = True


	;startup complete
	$_notificationStartup = True

	Return True

EndFunc   ;==>_Notifications_Startup


Func _Notifications_Close($_index)

	Local $_notificationCount = UBound($_notificationList)

	Local $_processPriority = _ProcessGetPriority(@AutoItPID)
	If $_processPriority = -1 Then $_processPriority = 2 ;normal priority

	;Set high process priority for smooth window movement
	If $_processPriority < 4 Then ProcessSetPriority(@AutoItPID, 4)


	;fade out time for the closing notitifaction
	Local $_fadeOutTime = $_notificationAnimationTime < $_notificationAnimationTimeDefault ? _
			$_notificationAnimationTime : $_notificationAnimationTimeDefault

	;Fade out time per step (fade out in 10 transparency steps)
	Local $_fadeOutTimePerStep = $_fadeOutTime / ($_notificationList[$_index][8] / 10)

	Local $_timer, $_timeFadeStep

	;ony use fade out when there is an animation time set, if 0 then it is instant
	If $_notificationAnimationTime > 0 Then

		;slowly increase transparency
		For $_transparency = $_notificationList[$_index][8] - 10 To 0 Step -10

			;as mentioned, there is a time for moving all notifications for 1 pixel, e.g. 2.5 ms. Moving one window may take
			;significantly shorter, while several notifications still need less time, but more more than just one. To compensate,
			;the time for moving the window will be recorded...
			$_timer = TimerInit()

			WinSetTrans($_notificationList[$_index][0], "", $_transparency)

			$_timeFadeStep = TimerDiff($_timer)

			;.. pause the script in case setting new transparency took less time than set
			If $_timeFadeStep < $_fadeOutTimePerStep Then

				DllStructSetData($_dllTimeStruct, "time", -10000 * ($_fadeOutTimePerStep - $_timeFadeStep))
				DllCall($_ntDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", $_dllTimeStructPointer)

			EndIf

		Next

	EndIf


	GUIDelete($_notificationList[$_index][0])

	;restructure notification array: move all entries one index below and ReDim the array to its new size
	For $_rows = $_index To $_notificationCount - 2
		For $_columns = 0 To UBound($_notificationList, 2) - 1

			$_notificationList[$_rows][$_columns] = $_notificationList[$_rows + 1][$_columns]

		Next
	Next

	ReDim $_notificationList[$_notificationCount - 1][UBound($_notificationList, 2)]


	;lets do some cool windows moving now
	_Notifications_Move($_index)

	;restore original process priority
	ProcessSetPriority(@AutoItPID, $_processPriority)

EndFunc   ;==>_Notifications_Close

Func _Notifications_CloseOnEvent()
	$bISclicked = True
	If _Notifications_StartupIsComplete() = False Then Return

	Local $_isEventModeActivated = Opt("GUIOnEventMode", 1)
	If $_isEventModeActivated <> 1 Then Opt("GUIOnEventMode", $_isEventModeActivated)

	If $_isEventModeActivated = 1 And $_notificationOnEvent = True Then _
			_Notifications_CheckGUIMsg(@GUI_CtrlId)

EndFunc   ;==>_Notifications_CloseOnEvent

Func _Notifications_GetTaskbarColor()

	If @OSVersion = "Win_8" Or @OSVersion = "Win_81" Then

		If RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM", "EnableWindowColorization") Then _
				Return "0x" & Hex(RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM", "ColorizationColor"), 6)

	ElseIf @OSVersion = "WIN_10" Then

		Local $_userOwnColorSettings = _
				RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "ColorPrevalence")

		Local $_taskbarIsTransparent = _
				RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "EnableTransparency")

		Local $_colorAccentPalette = _
				RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent", "AccentPalette")

		If $_userOwnColorSettings Then

			If $_taskbarIsTransparent Then Return "0x" & StringLeft(StringRight($_colorAccentPalette, 16), 6)

			Return "0x" & StringLeft(StringRight($_colorAccentPalette, 24), 6)

		Else

			If $_taskbarIsTransparent Then Return 0x000000

			Return "0x101010"

		EndIf

	EndIf

	Return 0x000000

EndFunc   ;==>_Notifications_GetTaskbarColor

; Name ..........: _Notifications_GetTaskbarTransparency
; Description ...: Returns the transparency of the taskbar.
; Syntax ........: _Notifications_GetTaskbarTransparency ()
; Return values .: Windows 7 and earlier - 217 (slight transparency)
;                  Windows 8, 8.1        - 255 (solid) if Window colorization is enabled, 217 else
;                  Windows 10            - 217 if taskbar is transparent, 255 it not
; Remarks .......: This function is used internally by other functions in this UDF and is not supposed to be called by user
; Link ..........: https://www.autoitscript.com/forum/topic/182192-get-windows-810-taskbar-color/
; ===============================================================================================================================
Func _Notifications_GetTaskbarTransparency()

	If @OSVersion = "Win_10" Then

		Local $_taskbarIsTransparent = _
				RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "EnableTransparency")

		If Not $_taskbarIsTransparent Then Return 255

	ElseIf @OSVersion = "Win_8" Or @OSVersion = "Win_81" Then

		If RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM", "EnableWindowColorization") Then Return 255

	EndIf

	Return 217

EndFunc   ;==>_Notifications_GetTaskbarTransparency


Func _Notifications_GetTopPos($_notificationID = -1)

	If _Notifications_StartupIsComplete() = False Then Return

	If $_notificationID = -1 Then $_notificationID = UBound($_notificationList)

	Local $_topPos = 0

	For $_i = 1 To $_notificationID

		$_topPos += 10 + $_notificationHeight

	Next

	Return $_desktopHeight - $_topPos

EndFunc   ;==>_Notifications_GetTopPos

Func _Notifications_Move($_index)

	If _Notifications_StartupIsComplete() = False Then Return

	;Number of notifications to move
	Local $_notificationsToMove = UBound($_notificationList) - $_index

	If $_notificationsToMove < 1 Then Return


	Local $_movingDistance = _Notifications_GetTopPos($_index + 1) - $_notificationList[$_index][3] ;in pixels
	Local $_lastNotificationToMove = 0 ;set the last notification to move

	;find the last notification to move: it is the first hidden in the list or if there are only visible notifications,
	;it is the last one in the list
	For $_i = $_index To UBound($_notificationList) - 1

		;first invisible notification
		If $_notificationList[$_i][1] = False Then

			$_lastNotificationToMove = $_i
			GUISetState(@SW_SHOWNA, $_notificationList[$_lastNotificationToMove][0]) ;show notification
			$_notificationList[$_lastNotificationToMove][1] = True
			ExitLoop

		EndIf

	Next

	If $_lastNotificationToMove = 0 Then $_lastNotificationToMove = UBound($_notificationList) - 1
	;Move notifications simultiniously, therefore a timer is used to set a time to move the notifications 1 pixel further.
	;This guarantees the same moving speed no matter how many notifications are moved (in case animation time > computing time)
	Local $_timePerPixelMove = $_notificationAnimationTime / $_movingDistance
	Local $_timer, $_timeWinMoveStep
	;ony use animation when there is a time set, if 0 then it is instant
	If $_notificationAnimationTime > 0 Then
		;cover the moving distance
		For $_y = 1 To $_movingDistance
			;as mentioned, there is a time for moving all notifications for 1 pixel, e.g. 2.5 ms. Moving one window may take
			;significantly shorter, while several notifications still need less time, but more more than just one. To compensate,
			;the time for moving the window will be recorded...
			$_timer = TimerInit()
			;for each pixel move every notification by 1 pixel down
			For $_i = $_index To $_lastNotificationToMove
				$_notificationList[$_i][3] = $_notificationList[$_i][3] + 1
				WinMove($_notificationList[$_i][0], "", $_notificationList[$_i][2], $_notificationList[$_i][3])
			Next
			$_timeWinMoveStep = TimerDiff($_timer)
			;.. and for the time difference between the timePerPixel and the time of moving the windows the script will pause
			If $_timeWinMoveStep < $_timePerPixelMove Then
				DllStructSetData($_dllTimeStruct, "time", -10000 * ($_timePerPixelMove - $_timeWinMoveStep))
				DllCall($_ntDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", $_dllTimeStructPointer)
			EndIf

		Next

	EndIf


	Local $_firstNotificationToMoveImmidiately = $_lastNotificationToMove + 1
	If $_notificationAnimationTime = 0 Then $_firstNotificationToMoveImmidiately = $_index

	;Move invisible notifications immidiately (and if time = 0, also visible notifications)
	For $_i = $_firstNotificationToMoveImmidiately To UBound($_notificationList) - 1

		$_notificationList[$_i][3] = $_notificationList[$_i][3] + $_movingDistance
		WinMove($_notificationList[$_i][0], "", $_notificationList[$_i][2], $_notificationList[$_i][3])

	Next


EndFunc   ;==>_Notifications_Move

Func _Notifications_StartupIsComplete()

	Return $_notificationStartup
EndFunc   ;==>_Notifications_StartupIsComplete



Func click()
	; ConsoleWrite("A notification has been clicked" & @LF)
	$bISclicked = True
EndFunc   ;==>click

If $bNotice And $sSize_ <> "0 bytes" Then
	Local $hDLL = DllOpen("user32.dll")
	Do
		Sleep(100)     ; slow to reduce CPU Usage.
	Until $bISclicked Or _IsPressed("1B", $hDLL)
	DllClose($hDLL)
	; Exit
EndIf

If Not $bExpError Then
	Exit (0)
Else
	Exit (1)
EndIf
