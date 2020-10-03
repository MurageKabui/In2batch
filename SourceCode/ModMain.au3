#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\new1\XSkin_Fully_Loaded\Examples\Skins\Default-ToolBar\BAT.ico
#AutoIt3Wrapper_Outfile=F:\my_project\autoit\MetroUDF-v5.1\2020_BatchLab.Exe
#AutoIt3Wrapper_Res_Comment=Embed resources in batch scripts.
#AutoIt3Wrapper_Res_CompanyName=kabueMurage
#AutoIt3Wrapper_Res_LegalCopyright=kabueMurage
#AutoIt3Wrapper_Res_LegalTradeMarks=kabueMurage
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_HiDpi=y
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel /sort_funcs /reel
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /sf /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iMinBtn,_iMaxBtn,_iCloseBtn,_iRestoreBtn,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete

Opt("GUIOnEventMode", 1)

 ; <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/logo.jpg?raw=true" align="center" alt="">
 ;  <br>
  
; Opt("WinWaitDelay", 0) ;Required for faster WinActivate when using the fullscreen mode
; "nircmd.exe" "batbox.exe" "Box.bat" "Fn.dll" "Getlen.bat" "logs.txt" 
#include <MetroGUI-UDF\MetroGUI_UDF.au3>
#include <GuiEdit.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <Clipboard.au3>
#include <Misc.au3>
#include <GUIConstants.au3>

; #include "_SciLexer.au3"
; #include <BlockInputEx.au3>
#include "TheBateamLogo.au3"


If _Singleton("BatchLab", 1) = 0 Then
	If Not WinActive("BatchLab") Then
		WinActivate("BatchLab", "")
	EndIf
	Exit
EndIf

Global $idBtnClearProcessed, $idHProcessedCode, $idLogPane, $Label_mode, $Label_2mode
Global $idBtnOptions, $idCopyProc2Clip, $idBtnOptions, $IdBtnSelectFile, $IdBtnClearLogs, $idBtnClearProcessed, $idAdvert
Global $h_gFileSelect
Global $g_sTool = "In2Batch"
Local $sControl
Global $bBtnVisible

Global $sFSelDiag
Global $bMultiple, $bFdiagParams, $bProceed = True
Global $h_gIdMidIcon

Global $bProceed = False

_Metro_EnableHighDPIScaling()

$OnEventMode = True
Global $sParams = ""
Global $_Args_


_SetTheme("DarkOrange")

Global $hInterface = _Metro_CreateGUI("BatchLab", 841, 452, -1, -1, False)
_Metro_SetGUIOption($hInterface, True, False, 841, 452)

$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, True)
;CloseBtn = True,MaximizeBtn = True,MinimizeBtn = True,FullscreenBtn = True,MenuBtn = True
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
$GUI_MENU_BUTTON = $Control_Buttons[6]

$idHProcessedCode = GUICtrlCreateEdit("", 389, 48, 445, 368)
	GUICtrlSetLimit($idHProcessedCode, 100000000000000)             ;limit for inputip
	GUICtrlSetFont($idHProcessedCode, 9.5, 400, 0, "Consolas")
	GUICtrlSetColor($idHProcessedCode, 0xff7800)
	GUICtrlSetBkColor($idHProcessedCode, 0x191919)
	GUICtrlSetCursor($idHProcessedCode, 5)

$idLogPane = GUICtrlCreateEdit("", 10, 48, 245, 368, $ES_READONLY + $ES_AUTOVSCROLL) ;, $WS_EX_LAYOUTRTL)
GUICtrlSetLimit($idLogPane, 10000000)              ;limit for input
GUICtrlSetFont($idLogPane, 9, 400, 2, "Consolas")
GUICtrlSetColor($idLogPane, 0xfb7803)
GUICtrlSetBkColor($idLogPane, 0x191919)
GUICtrlSetCursor($idLogPane, 5)

$Label_mode = GUICtrlCreateLabel("MODE:", 392, 31, 39, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Consolas")
GUICtrlSetColor(-1, 0xD8D8D8)

$Label_2mode = GUICtrlCreateLabel("[In2Batch]", 430, 30, 230, 17)
GUICtrlSetFont($Label_2mode, 10, 400, 0, "Consolas")
GUICtrlSetColor($Label_2mode, 0xC76810)
GUICtrlSetTip($Label_2mode, "Toggle modes at the menu.")

$idBtnOptions = _Metro_CreateButtonEx2("Options", 280, 77, 91, 25)
GUICtrlSetTip($idBtnOptions, "More Options")

$idCopyProc2Clip = _Metro_CreateButtonEx2("Export As ▼", 685, 421, 139, 25)
GUICtrlSetTip($idCopyProc2Clip, "Exports the processed Code to clipboard")

$IdBtnSelectFile = _Metro_CreateButtonEx2("Select File ▼", 280, 47, 91, 25, $ButtonBKColor, $ButtonTextColor, "Segoe UI")
GUICtrlSetFont($IdBtnSelectFile, 10, 400, 0, "Segoe UI")

$IdBtnClearLogs = _Metro_CreateButtonEx2("clear logs", 12, 421, 91, 25)
GUICtrlSetTip($IdBtnClearLogs, "Clears all the logs")

$idBtnClearProcessed = _Metro_CreateButtonEx2("clear", 609, 421, 75, 25)

$idAdvert = GUICtrlCreateLabel("Mr.KM * https://batch-man.com", 251, 429, 267, 20)
GUICtrlSetFont(-1, 10, 400, 0, "@Malgun Gothic")
GUICtrlSetColor(-1, 0xc1c1cb)
GUICtrlSetTip(-1, "Download thousands of commandline" & @CRLF & _
		"plugins from our community website.")

If Not FileExists(@TempDir & "\Thebateam.ico") Then _Writemy_stuffToDir(@TempDir & "\Thebateam.ico")
$h_gIdMidIcon = GUICtrlCreateIcon(@TempDir & "\Thebateam.ico", 5, 287, 216, 76, 41)
GUICtrlSetBkColor($h_gIdMidIcon, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetOnEvent($h_gIdMidIcon, "ad_")
GUICtrlSetTip($h_gIdMidIcon, "Download thousands of commandline" & @CRLF & _
		"plugins from our community website.")

WinSetTrans($hInterface, '', 0)

GUISetOnEvent($GUI_EVENT_CLOSE, "_GUIEvent_ControlButtons", $hInterface)
GUICtrlSetOnEvent($GUI_CLOSE_BUTTON, "_GUIEvent_ControlButtons")
GUICtrlSetOnEvent($GUI_MAXIMIZE_BUTTON, "_GUIEvent_ControlButtons")
GUICtrlSetOnEvent($GUI_MINIMIZE_BUTTON, "_GUIEvent_ControlButtons")
GUICtrlSetOnEvent($GUI_RESTORE_BUTTON, "_GUIEvent_ControlButtons")
GUICtrlSetOnEvent($GUI_MENU_BUTTON, "_GUIEvent_ControlButtons")
GUICtrlSetOnEvent($idBtnOptions, "_func_Options")
GUICtrlSetOnEvent($IdBtnSelectFile, "_fileSelectNdo")
GUICtrlSetOnEvent($IdBtnClearLogs, "_clearLOGS")
GUICtrlSetOnEvent($idBtnClearProcessed, "_clearSB")
GUICtrlSetOnEvent($idCopyProc2Clip, "to_clip")
GUICtrlSetOnEvent($idAdvert, "ad_")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "_GUIEvent_SecondaryDown")

GUISetState(@SW_SHOW)
For $i = 0 To 255 Step +5
	WinSetTrans($hInterface, '', $i)
	Sleep(5)
Next

While 1
	Sleep(1000)
WEnd

Func _clearLOGS()
	GUICtrlSetData($idLogPane, "")
EndFunc   ;==>_clearLOGS

Func _clearSB()
	GUICtrlSetData($idHProcessedCode, "")
EndFunc   ;==>_clearSB

Func _fileSelectNdo()
	$sALL = ""
	Local $idArrayFiles
	Local $aCInfo = GUIGetCursorInfo($hInterface)
	If $aCInfo[4] = $IdBtnSelectFile Then
		Local $MenuButtonsArray[3] = ["Select resource(s)", $g_sTool & " Settings", "Cancel"]
		Local $MenuOpt_ = _Metro_RightClickMenu($hInterface, 200, $MenuButtonsArray, "Segoe UI", 9, 0, $g_sTool)
		Switch $g_sTool
			Case "In2Batch"
				Switch $MenuOpt_
					Case "0"
						$bFdiagParams = BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT, $FD_PATHMUSTEXIST)
						$h_gFileSelect = FileOpenDialog("● Select Files.", -1, "All (*.*) |Media (*.jpg;*.bmp;*.ico;*.jpeg;*.gif;*.png)|PlugIns (*.bat;*.vbs;*.exe;*.cmd)", $bFdiagParams)
						If Not @error Then
							; means path is alrady defined and array is GEQ than 2
							FileChangeDir(@ScriptDir)
							Local $idArrayFiles = StringSplit($h_gFileSelect, "|")
							If StringRight($idArrayFiles[1], 1) <> "\" Then $idArrayFiles[1] &= "\"
							$sALL = ""
							If $idArrayFiles[0] <> 1 Then
								For $i = 2 To $idArrayFiles[0]
									$sALL &= $idArrayFiles[1] & $idArrayFiles[$i] & ";"
									_GUICtrlEdit_InsertText($idLogPane, $idArrayFiles[1] & $idArrayFiles[$i] & @CRLF)
								Next
							Else
								$sALL &= $idArrayFiles[1]
								_GUICtrlEdit_InsertText($idLogPane, $idArrayFiles[1] & @CRLF)
							EndIf
							$sALL = StringTrimRight($sALL, 1)
							If $sALL <> "" Then encode_now($sALL)     ; $sNamePlusPath)

						EndIf
					Case "1"
						ConsoleWrite(" > Settings button." & @CRLF)
				EndSwitch
			Case "Obfuscator"
				ConsoleWrite("Obfuscating batch" & @LF)
		EndSwitch
	EndIf
EndFunc   ;==>_fileSelectNdo

; clear all Log pane and generated code.
Func _func_Options()
	; GUICtrlSetData($idLogPane, "")
	; GUICtrlSetData($idHProcessedCode, "")
	ConsoleWrite("Options" & @CRLF)
EndFunc   ;==>_func_Options

Func _GUIEvent_ControlButtons()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			For $i = 255 To 0 Step -10
				WinSetTrans($hInterface, '', $i)
				Sleep(20)
			Next
			_Metro_GUIDelete($hInterface)
			Exit
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $hInterface)
		Case $GUI_MENU_BUTTON
			Local $MenuButtonsArray[5] = ["Embed Resource", "Obfuscator", "BatCenter", "More Plugins", "Exit"]
			Local $MenuSelect = _Metro_MenuStart($hInterface, 120, $MenuButtonsArray, "Segoe UI", 9, 0)
			Switch $MenuSelect
				Case "0"
					_GUICtrlEdit_InsertText($idLogPane, @CRLF & "[In2Batch]" & @CRLF)
					GUICtrlSetData($idHProcessedCode, "")
					$g_sTool = "In2batch"
					GUICtrlSetData($Label_2mode, "[In2Batch]")
					GUICtrlSetData($idHProcessedCode, "")
				Case "1"
					$g_sTool = "Obfuscator"
					GUICtrlSetData($Label_2mode, "[Set to use " & $g_sTool & " ]")
					_GUICtrlEdit_InsertText($idLogPane, @CRLF & "[Obfuscator]" & @CRLF)
					GUICtrlSetData($idHProcessedCode, "")
				Case "2"
					; About_GUI()
				Case "3"
					ad_()
				Case "4"
					For $i = 255 To 0 Step -10
						WinSetTrans($hInterface, '', $i)
						Sleep(20)
					Next
					_Metro_GUIDelete($hInterface)     ;Delete GUI/release resources, make sure you use this when working with multiple GUIs!
					Exit
			EndSwitch
	EndSwitch
EndFunc   ;==>_GUIEvent_ControlButtons

Func _GUIEvent_SecondaryDown() ;Rightclick demo
	Local $aCInfo = GUIGetCursorInfo($hInterface)
	Switch $aCInfo[4]
		Case $idLogPane
			If GUICtrlRead($idLogPane) <> "" Then
				Local $MenuButtonsArray[3] = ["Export As", "Clear logs", "Cancel"]
				GUICtrlSetState($idLogPane, $GUI_DISABLE)
				Local $MenuSelect = _Metro_RightClickMenu($hInterface, 150, $MenuButtonsArray, "Segoe UI", 9, 0, "logs")
				GUICtrlSetState($idLogPane, $GUI_ENABLE)
				Switch $MenuSelect
					Case "0"
						_Metro_MsgBox(0, "", "Exporting to file", 300, 11, $hInterface)
						$sFilePath = FileSaveDialog("Save the file as ...", "", "All files (*.*)")
						If Not @error Then
							ConsoleWrite("saved to file" & $sFilePath & @CRLF)
						EndIf
					Case "1"
						GUICtrlSetData($idLogPane, "")
					Case Else
				EndSwitch
			EndIf
		Case $idHProcessedCode
			If GUICtrlRead($idHProcessedCode) <> "" Then
				If $g_sTool = "In2Batch" Then
					Local $MenuButtonsArray[3] = ["• Export As", "• Export As ..", "Cancel"]
					;_GUIDisable($hInterface, 5, 0xbbbbbb)
					GUICtrlSetState($idHProcessedCode, $GUI_DISABLE)
					Local $MenuSelect = _Metro_RightClickMenu($hInterface, 155, $MenuButtonsArray, "Segoe UI", 9, 0, "Options")
					;_GUIDisable($hInterface)
					Switch $MenuSelect
						Case "0"
							to_clip()
						Case "1"
							$sFilePath = FileSaveDialog("Save As ...", "", "Batch file (*.bat)") ; Select a file to save the encrypted data to.
							If Not @error Then
								ConsoleWrite("saved to file" & $sFilePath & @CRLF)
							EndIf
					EndSwitch
					GUICtrlSetState($idHProcessedCode, $GUI_ENABLE)
				ElseIf $g_sTool = "Obfuscator" Then
					Local $MenuButtonsArray[3] = ["• Copy code to clipboard", "• More options", "Cancel"]
					_GUIDisable($hInterface, 5, 0xbbbbbb)
					Local $MenuSelect = _Metro_RightClickMenu($hInterface, 155, $MenuButtonsArray, "Segoe UI", 9, 0, "Options")
					_GUIDisable($hInterface)
					Switch $MenuSelect
						Case "0"
							to_clip()
						Case "1"
					EndSwitch
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>_GUIEvent_SecondaryDown

Func ad_()
	ShellExecute("https://thebateam.org/")
EndFunc   ;==>ad_

Func ByteSuffix($iBytes)
	Local $iIndex = 0, $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>ByteSuffix

; function call to parse command output locally without using a external file
Func Call_cmd($_Args_)
	; If StringLeft($_Args_, 1) = " " Then $_Args_ = " " & $_Args_
	Local $nPid = Run(@ComSpec & ' /c "' & $_Args_ & '"', "", @SW_HIDE, 8), $sRet = ""
	; ConsoleWrite("> [" & @ComSpec & ' /c " ' & $_Args_ & ' "' & @CRLF)
	If @error Then
		_GUICtrlEdit_InsertText($idLogPane, "ERROR: " & @error & @CRLF)
	EndIf
	ProcessWait($nPid)
	local $bError = false
	While 1
		; $errors = StringInStr($sRet, "0 bytes")
		; if $errors <> 0 and not $bError then 
		; 	_GUICtrlEdit_InsertText($idLogPane, "Caught an Error." & @CRLF)
		; 	$bError = true
		; endif
		$sRet &= StdoutRead($nPid)
		If @error Or (Not ProcessExists($nPid)) Then ExitLoop
		Sleep(5)
	WEnd
	Return $sRet
EndFunc   ;==>Call_cmd

Func encode_now($sFileFQPN, $sParams = " -srg -erg")
	; if $g_genHeaders then $s_headers = " -srg -erg"
	; $sParams = "" ; & $s_headers
	$_Args_ = '"' & @ScriptDir & '\bin\CL-In2batch.dll" "' & $sFileFQPN & '" ' & $sParams
	; $size_got = Call_cmd($_Args_ & " -size")
	; _GUICtrlEdit_InsertText($idLogPane, @CRLF & $size_got & @CRLF & "-Press the END button to ABORT-" & @CRLF)

	_GUIDisable($hInterface, 20, $GUIThemeColor, True)
	_GUICtrlEdit_BeginUpdate($idHProcessedCode)

	GUICtrlSetData($idHProcessedCode, Call_cmd($_Args_) & @CRLF)

	_GUICtrlEdit_EndUpdate($idHProcessedCode)
	; sleep(3000)

	_GUIDisable($hInterface)

	$sParams = ""
	$sFileFQPN = ""
EndFunc   ;==>encode_now

Func to_clip()     ; function to copy user input to clipboard memory
	If GUICtrlRead($idHProcessedCode) <> "" Then
		_GUIDisable($hInterface, 20, 0xbbbbbb)
		$ir = ClipPut(GUICtrlRead($idHProcessedCode))
		If $ir = 1 Then _Metro_MsgBox(0, "", "Copied to clipboard!", 300, 11, $hInterface)
		_GUIDisable($hInterface)
	Else
		ConsoleWrite("Oops! nothing to copy to clipnoard" & @CRLF)
	EndIf
EndFunc   ;==>to_clip
