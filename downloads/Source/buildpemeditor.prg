Lparameters tlDebugInfo

Local lcAppFile, lcDropBox, lcJimsFile, lcProject, lcThorFolder, lcVersion, llDebugging

If 'O' = Type ('_oPEMEditor')
	_oPEMEditor.Release()
Endif
Release _oPEMEditor

Use editproperty.Vcx Exclusive
Pack
Use

lcVersion	= UpdateVersionNumber()
llDebugging	= Occurs ('.', m.lcVersion) >= 3

lcProject = 'PEMEditor.PJX'
Select 0
Use (m.lcProject) Again
Locate For Type = 'H'
Replace Debug With m.tlDebugInfo Or m.llDebugging
Use

Erase editproperty.Prg
Erase editproperty.fxp

InsertPRGTextFromTemplateFiles ('EditProperty_Template.PRG', 'EditProperty.PRG')

lcAppFile = '..\PEMEditor.APP'
Erase (m.lcAppFile)
Build App (m.lcAppFile) From PEMEditor Recompile

If Not m.llDebugging
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GenerateSCCFilesOnProject', Fullpath ('PEMEditor.PJX'))
Endif

* -------------------------------------------------------------------------------- 

lcThorFolder = GetThorFolder()
lcJimsFile	 = m.lcThorFolder + '\Thor\Tools\Apps\PEM Editor\PEMEDITOR.APP'

If Directory (Justpath (m.lcJimsFile))
	If Messagebox ('Replace my copy? ', 4) = 6
		If File (m.lcJimsFile)
			Erase (m.lcJimsFile)
		Endif
		Copy File (m.lcAppFile) To (m.lcJimsFile)
	Endif

	lcDropBox = 'C:\Users\Jim Nelson\Dropbox\Public'
	If Not Directory(m.lcDropBox)
		lcDropBox = 'C:\Dropbox\Public'
	Endif
	Erase (m.lcDropBox + '\PEMEditor.APP')
	Copy File (m.lcAppFile) To (m.lcDropBox + '\PEMEditor.APP')
Endif


Procedure GetThorFolder()

	Local laFolders[1], lcFolder, lcFolders, lnCount, lnI

	Text To m.lcFolders Noshow Textmerge
C:\Users\Jim Nelson\DropBox\VFP Utilities\MyThor
C:\DropBox\VFP Utilities\MyThor
C:\Visual Foxpro\Programs\MyThor
	Endtext

	lnCount = Alines(laFolders, m.lcFolders)
	For lnI = 1 To m.lnCount
		lcFolder = Addbs(m.laFolders[m.lni])
		If File(m.lcFolder + 'Thor.APP')
			Return m.lcFolder
		Endif
	Endfor
Endproc
