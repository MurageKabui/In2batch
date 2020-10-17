#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\..\my_project\briefcase-24.ico
#AutoIt3Wrapper_Outfile=F:\my_project\autoit\MetroUDF-v5.1\bin\CL-In2batch.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_CompanyName=Kabue Murage
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel /sort_funcs /reel
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo /sf /rm /sv
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once

#cs ===================================================================================
 AutoIt Version  : 3.3.14.5
 Author          : Mr.km
 Facebook        : Kabue Murage
 Script Function : Commandline version of In2batch
				   Embed files into your batch scripts.
 Date            :  1st Nov 2018
#ce ===================================================================================

; #include <GUIConstants.au3>
#include <Process.au3>
#include <Misc.au3>
#include <WinAPIFiles.au3>
#include "Notifications.au3"

Local $ifilesize
Global $vFirArg
Global $sMod_pth_, $s1stEcho, $sHelp_syn, $sAllFunctions = "", $sAllHeaders = ""
Global $sSize_, $sLne_rd, $sALL_, $sfile2wrte, $sFuD2, $s_Args_, $sFdw_, $sFileName = ""
Global $hNdlrd, $hNdlWte, $hSearch
Global $bISclicked = False, $bSndNotice, $bNotice, $bExpError = False, $bPrtOut = False
Global $iNotyLimit = 20

$vFirArg = _CmdLine_GetValByIndex(1, False)
$sChkWld = StringInStr($vFirArg, "*.", $STR_CASESENSE)
; Check wildcrads
If $sChkWld = 1 Then
	ConsoleWrite("This version of In2Batch does not support wildcrads." & @CRLF)
	Exit (1)
EndIf
$bNotice = _CmdLine_KeyExists('notify')
$aMtpleEnc = StringSplit($vFirArg, ";", $STR_ENTIRESPLIT)
If $bNotice And $aMtpleEnc[0] <> 0 Then
	Opt("GUIOnEventMode", 1)
	$bSndNotice = True
	_Notifications_Startup()
	_Notifications_SetColor(0xfb7803)
	_Notifications_SetBkColor(0x191919)
	_Notifications_SetTransparency(250)
	_Notifications_SetButtonText("")
Else
	$bSndNotice = False
EndIf
$bHlp1 = _CmdLine_KeyExists('?')
$bHlp2 = _CmdLine_KeyExists('-help')
$bStNot = StringInStr($vFirArg, "/notify")

If Not $vFirArg Or $bHlp1 Or $bHlp2 Or $bStNot <> 0 Then
	help_me()
	Print_help()
	Exit (0)
ElseIf _CmdLine_KeyExists('ver') Or _CmdLine_KeyExists('version') Then
	ConsoleWrite("In2Batch build 2.Mar.2020" & @CRLF)
	Exit (0)
ElseIf _CmdLine_KeyExists('size') Then
	$aMtple_sze = StringSplit($vFirArg, ";")
	If $aMtple_sze[0] <> 0 Then
		For $i = 1 To $aMtple_sze[0]
			If FileExists($aMtple_sze[$i]) Then
				$sDlngWth = $aMtple_sze[$i]
				$nnPath_valid = _WinAPI_FileExists($sDlngWth)
				If $nnPath_valid = 1 Then
					ConsoleWrite(StringRegExpReplace($sDlngWth, "^.*\\", "") & "/" & ByteSuffix(FileGetSize($sDlngWth)) & @CRLF)
				EndIf
				$bExpError = False
			Else
				ConsoleWrite(":: File does not exist [" & $aMtple_sze[$i] & "]" & @CRLF)
				$bExpError = True
			EndIf
		Next
	ElseIf ($aMtple_sze[0]) = 0 And (_WinAPI_FileExists($vFirArg) = 1) Then
		ConsoleWrite(StringRegExpReplace($vFirArg, "^.*\\", "") & ":" & ByteSuffix(FileGetSize($vFirArg)) & @CRLF)
	EndIf
	If $bExpError Then Exit (1)
	Exit (0)
ElseIf $aMtpleEnc[0] <> 0 Then
	For $i = 1 To $aMtpleEnc[0]
		$sFdw_ = $aMtpleEnc[$i]
		If FileExists($sFdw_) Then
			$nPath_valid = _WinAPI_FileExists($sFdw_)
			$nIs_dir = @extended
			If $nPath_valid = 1 Then     ; IS FILE
				;$vFirArg = sFdw_
				encode_now($sFdw_)
				
				If $bSndNotice And $sSize_ <> "0 bytes" And $aMtpleEnc[0] <> 0 Then
					_Notifications_Create("CL-In2Batch processd [" & $sSize_ & "] ", " Completed : " & $sFdw_, "click", True)
				EndIf
			ElseIf $nIs_dir = 1 Then     ; If Is a folder.
				If StringRight($sFdw_, 1) <> "\" Then $sFdw_ &= "\"
				$hSearch = FileFindFirstFile($sFdw_ & "*.*")
				$sFullPth = $sFdw_
				If $hSearch = -1 Then
					ConsoleWrite(":: Error :No files found in folder " & $sFdw_ & @CRLF)
					Exit (4)
				Else
					For $i = 1 To $iNotyLimit
						$sFileName = FileFindNextFile($hSearch)
						If @error Then ExitLoop
						;$vFirArg = $sFullPth & $sFileName
						encode_now($sFullPth & $sFileName)
						
						If $bSndNotice And $sSize_ <> "0 bytes" And $aMtpleEnc[0] <> 0 Then
							_Notifications_Create("CLIn2Batch completed", $sFdw_ & @CRLF & "\" & $sFileName, "click", True)
						EndIf
						If $i > 5 Then $i = 1
					Next
				EndIf
				FileClose($hSearch)
			EndIf
		Else
			$bNotice = False
			$bExpError = True
			ConsoleWrite(":: Error : Check Filename/Path [" & $aMtpleEnc[$i] & "]" & @CRLF)
		EndIf
	Next
EndIf

; =====================================================================
If $bPrtOut Then
	ConsoleWrite($sAllHeaders & _
			"Exit /b" & @CRLF & @CRLF & $sAllFunctions)
EndIf
; =====================================================================

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

Func _CmdLine_FlagDisabled($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "\-([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagDisabled

Func _CmdLine_FlagEnabled($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "\+([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagEnabled

Func _CmdLine_FlagExists($sKey)
	For $i = 1 To $CmdLine[0]
		If StringRegExp($CmdLine[$i], "(\+|\-)([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagExists

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

Func _CmdLine_GetValByIndex($iIndex, $mDefault = Null)
	If $CmdLine[0] >= $iIndex Then
		Return $CmdLine[$iIndex]
	Else
		Return $mDefault
	EndIf
EndFunc   ;==>_CmdLine_GetValByIndex

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

Func _delfile($spath)
	If FileExists($spath) Then FileDelete($spath)
	; If FileExists($spath) Then FileDelete($spath)
EndFunc   ;==>_delfile

Func ByteSuffix($iBytes)
	Local $iIndex = 0, $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>ByteSuffix
; =======================================================================

Func click()
	; ConsoleWrite("A notification has been clicked" & @CRLF)
	$bISclicked = True
EndFunc   ;==>click

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

Func encode_now($vFirArg)
	$ifilesize = FileGetSize($vFirArg)
	$sMod_pth_ = StringRegExpReplace($vFirArg, "^.*\\", "")
	$sSize_ = ByteSuffix($ifilesize)
	_delfile(@TempDir & "\_unProcessed_cert.txt")
	; Local $func_ID1
	If _CmdLine_KeyExists('funcname') Then
		$func_ID1 = _CmdLine_Get("funcname", "")
		If $func_ID1 = "" Then
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
		ConsoleWrite("In2Batch Error [3] : CertUtil.exe missing." & @CRLF)
		Exit (3)
	EndIf
	$sfile2wrte = "\_unProcessed_cert.txt"
	$hNdlrd = FileOpen(@TempDir & "\_unProcessed_cert.txt", 0)
	$hNdlWte = FileOpen($sfile2wrte, 2)
	If $sSize_ <> "0 bytes" Then
		If Not $s1stEcho Then
			$sWtecho_ = "@Echo off" & @CRLF & @CRLF & _
					"Call :ExtractFiles ""%cd%"" " & @CRLF & _
					":: ===================== Add your Code Here =========================" & _
					@CRLF & @CRLF & @CRLF & @CRLF & _
					":: ==================================================================" & _
					@CRLF & _
					":ExtractFiles <OutPutDir>" & @CRLF & _
					"    Set ""AssetsDir=%~1"" " & @CRLF & _
					"    if not exist ""%AssetsDir%"" (md ""%AssetsDir%"")" & @CRLF
			$s1stEcho = True
		Else
			$sWtecho_ = ""
		EndIf
		$sAllHeaders &= $sWtecho_ & _
				"    If not exist " & '"%AssetsDir%\' & $sMod_pth_ & '" (Call :' & $sFuD2 & ' "%AssetsDir%\' & $sMod_pth_ & '")' & @CRLF
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
		$sRedone = StringReplace($sALL_, "-----BEGIN CERTIFICATE-----", "    Echo -----BEGIN CERTIFICATE----- >""%temp%\_tempDoc_.In2b""" & @CRLF & " (")
		$sIfEndRegion = ""
		;If _CmdLine_KeyExists('erg') Then $sIfEndRegion = "rem ================= End Region In2Batch CL-Generator ==================" & @CRLF
		$sAllFunctions &= ":" & $sFuD2 & @CRLF & _
				$sRedone & _
				"File properties:" & @CRLF & _
				"    Echo File Name : " & $sMod_pth_ & @CRLF & _
				"    Echo File Size : " & $sSize_ & @CRLF & _
				" ) >>""%temp%\_tempDoc_.In2b""" & @CRLF & _
				" CertUtil -decode -f ""%temp%\_tempDoc_.In2b"" " & '"%~1" >nul' & @CRLF & _
				" del /F /Q ""%temp%\_tempDoc_.In2b""" & @CRLF & _
				$sIfEndRegion & _
				"Exit /b 0" & @CRLF & @CRLF
		FileClose($hNdlrd)
		FileClose($hNdlWte)
		; Else
		; 	ConsoleWrite(":: File " & $sMod_pth_ & " contains no readable data. Size:" & $sSize_ & @CRLF)
	EndIf
	$bPrtOut = True
EndFunc   ;==>encode_now

Func GenRandom_for_batch()
	$sFuD2 = ""
	$sFuD2 = Random(10000000, 1000000000, 1) & Random(10000, 10000000, 1)
EndFunc   ;==>GenRandom_for_batch

Func help_me()
	$sHelp_syn = "  Generate a batch code that allows you to embed resources in your batch scripts." & @CRLF & _
			@CRLF & _
			"  Syntax:" & @CRLF & _
			"  " & @ScriptName & " ""[File.abc;FolderABC;File.abc; ...]"" (opt [/funcname] [/notify] [/size])" & @CRLF & _
			@CRLF & _
			"  Arg1 = valid folders/file paths, may be delimited using a semi colon for a multiple" & @CRLF & _
			"  file operation. Folder paths cause the the present files to be included in the operation." & @CRLF & _
			"  Unreadable/0 byte files and directories detected are automatically skipped. With no" & @CRLF & _
			"  effect to DOS variable %errorlevel% ,on a continuous operation." & @CRLF & @CRLF & _
			" /funcname - Specify a name for your Batch script function. If this parameter is left unused," & @CRLF & _
			"             an acceptable random number will be generated instead, that can be used without" & @CRLF & _
			"             errors in the batch code. This Parameter is best used when working with a single" & @CRLF & _
			"             file. Example: " & @CRLF & _
			"             > " & @ScriptName & " ""MyLogo.ico"" /funcname ""MakeResourceIcon""" & @CRLF & _
			"                (Generates code for icon file: ""MyLogo.ico"" with function label :MakeResourceIcon)" & @CRLF & _
			"       (NB)  To avoid errors, This parameter validates the given function name by removing" & @CRLF & _
			"             all unacceptable characters and replacing them with a ""_"" instead, so as to" & @CRLF & _
			"             suit a callable batch function ID." & @CRLF & @CRLF & _
			" /notify   - Including this flag causes a notification to be triggered after every" & @CRLF & _
			"             instance of a successful operation." & @CRLF & @CRLF & _
			" Use the shell redirection capability to parse the standard output code to a file handle" & @CRLF & _
			" using the redirection operators "">>"" Or "">"" , or pipe directly to the" & @CRLF & _
			" clipboard using ""| Clip"" . Ongoing operations can be terminated by pressing ""esc""" & @CRLF & _
			" or the ""end"" key. Examples: " & @CRLF & _
			"" & @CRLF & _
			"> " & @ScriptName & " ""Image.ico"" /funcname ""CreateMyicon"" >>MyBatchFile.bat" & @CRLF & _
			"> " & @ScriptName & " ""EULA.rtf;License.txt;Logo.bmp"" /notify | clip" & @CRLF & _
			"> " & @ScriptName & " ""G:\Temp\FolderABC;C:\Temp\dependencies;%cd%\Icon1.ico"" " & @CRLF & @CRLF & _
			" Exit codes: (Set to DOS variable %ERRORLEVEL%)" & @CRLF & _
			"     0 - Success / No Error." & @CRLF & _
			"     1 - One or more files failed (Mostly due to Invalid File/Path)" & @CRLF & _
			"     3 - CertUtil error." & @CRLF & _
			" [Fb] Kabue Murage" & @CRLF
EndFunc   ;==>help_me

Func Print_help()
	ConsoleWrite($sHelp_syn)
EndFunc   ;==>Print_help
