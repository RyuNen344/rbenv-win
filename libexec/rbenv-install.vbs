Option Explicit

Dim objws
Dim objfs
Set objws = WScript.CreateObject("WScript.Shell")
Set objfs = CreateObject("Scripting.FileSystemObject")

Dim strCurrent
Dim strRbenvHome
Dim strDirCache
Dim strDirVers
Dim strDirLibs
Dim strVerFile
strCurrent   = objfs.GetAbsolutePathName(".")
strRbenvHome = objfs.getParentFolderName(objfs.getParentFolderName(WScript.ScriptFullName))
strDirCache  = strRbenvHome & "\install_cache"
strDirVers   = strRbenvHome & "\versions"
strDirLibs   = strRbenvHome & "\libexec"
strVerFile   = "\.ruby_version"


Dim tool7z
Dim strDirDevKit
tool7z = """" & strRbenvHome & "\tools\7z\7zdec.exe"" x "
strDirDevKit  = strRbenvHome & "\tools\DevKit"


Sub ShowHelp()
     Wscript.echo "Usage: rbenv install [-f|-s] <version>"
     Wscript.echo "       rbenv install [-f|-s] <definition-file>"
     Wscript.echo "       rbenv install -l|--list"
     Wscript.echo ""
     Wscript.echo "  -l/--list          List all available versions"
     Wscript.echo "  -f/--force         Install even if the version appears to be installed already"
     Wscript.echo "  -s/--skip-existing Skip if the version appears to be installed already"
     Wscript.echo ""
     Wscript.Quit
End Sub

Dim listDevKit
listDevKit = Array( _
    Array("i386","https://github.com/oneclick/rubyinstaller/releases/download/devkit-4.7.2/","DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe" ),_
    Array("x64" ,"https://github.com/oneclick/rubyinstaller/releases/download/devkit-4.7.2/","DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe" ),_
    Array("tdm" ,"https://github.com/oneclick/rubyinstaller/releases/download/DevKit-tdm-32-4.5.2/","DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe" ) _
)

Dim listEnv

listEnv = Array( _
    Array("3.1.1"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.1-1/","rubyinstaller-3.1.1-1-x64.7z" ,"bundled"),_
    Array("3.1.1-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.1-1/","rubyinstaller-3.1.1-1-x86.7z" ,"bundled"),_
    Array("3.1.0"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.0-1/","rubyinstaller-3.1.0-1-x64.7z" ,"bundled"),_
    Array("3.1.0-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.0-1/","rubyinstaller-3.1.0-1-x86.7z" ,"bundled"),_
    Array("3.0.3"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.3-1/","rubyinstaller-3.0.3-1-x64.7z" ,"bundled"),_
    Array("3.0.3-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.3-1/","rubyinstaller-3.0.3-1-x86.7z" ,"bundled"),_
    Array("3.0.2"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.2-1/","rubyinstaller-3.0.2-1-x64.7z" ,"bundled"),_
    Array("3.0.2-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.2-1/","rubyinstaller-3.0.2-1-x86.7z" ,"bundled"),_
    Array("3.0.1"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.1-1/","rubyinstaller-3.0.1-1-x64.7z" ,"bundled"),_
    Array("3.0.1-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.1-1/","rubyinstaller-3.0.1-1-x86.7z" ,"bundled"),_
    Array("3.0.0"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.0-1/","rubyinstaller-3.0.0-1-x64.7z" ,"bundled"),_
    Array("3.0.0-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.0-1/","rubyinstaller-3.0.0-1-x86.7z" ,"bundled"),_
    Array("2.7.5"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.5-1/","rubyinstaller-2.7.5-1-x64.7z" ,"bundled"),_
    Array("2.7.5-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.5-1/","rubyinstaller-2.7.5-1-x86.7z" ,"bundled"),_
    Array("2.7.4"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.4-1/","rubyinstaller-2.7.4-1-x64.7z" ,"bundled"),_
    Array("2.7.4-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.4-1/","rubyinstaller-2.7.4-1-x86.7z" ,"bundled"),_
    Array("2.7.3"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.3-1/","rubyinstaller-2.7.3-1-x64.7z" ,"bundled"),_
    Array("2.7.3-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.3-1/","rubyinstaller-2.7.3-1-x86.7z" ,"bundled"),_
    Array("2.7.2"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.2-1/","rubyinstaller-2.7.2-1-x64.7z" ,"bundled"),_
    Array("2.7.2-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.2-1/","rubyinstaller-2.7.2-1-x86.7z" ,"bundled"),_
    Array("2.7.1"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.1-1/","rubyinstaller-2.7.1-1-x64.7z" ,"bundled"),_
    Array("2.7.1-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.1-1/","rubyinstaller-2.7.1-1-x86.7z" ,"bundled"),_
    Array("2.7.0"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.0-1/","rubyinstaller-2.7.0-1-x64.7z" ,"bundled"),_
    Array("2.7.0-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.0-1/","rubyinstaller-2.7.0-1-x86.7z" ,"bundled"),_
    Array("2.6.9"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.9-1/","rubyinstaller-2.6.9-1-x64.7z" ,"bundled"),_
    Array("2.6.9-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.9-1/","rubyinstaller-2.6.9-1-x86.7z" ,"bundled"),_
    Array("2.6.8"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.8-1/","rubyinstaller-2.6.8-1-x64.7z" ,"bundled"),_
    Array("2.6.8-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.8-1/","rubyinstaller-2.6.8-1-x86.7z" ,"bundled"),_
    Array("2.6.7"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.7-1/","rubyinstaller-2.6.7-1-x64.7z" ,"bundled"),_
    Array("2.6.7-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.7-1/","rubyinstaller-2.6.9-1-x86.7z" ,"bundled"),_
    Array("2.6.6"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.6-1/","rubyinstaller-2.6.6-1-x64.7z" ,"bundled"),_
    Array("2.6.6-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.6-1/","rubyinstaller-2.6.6-1-x86.7z" ,"bundled"),_
    Array("2.6.5"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/","rubyinstaller-2.6.5-1-x64.7z" ,"bundled"),_
    Array("2.6.5-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/","rubyinstaller-2.6.5-1-x86.7z" ,"bundled"),_
    Array("2.6.4"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.4-1/","rubyinstaller-2.6.4-1-x64.7z" ,"bundled"),_
    Array("2.6.4-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.4-1/","rubyinstaller-2.6.4-1-x86.7z" ,"bundled"),_
    Array("2.6.0"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.0-1/","rubyinstaller-2.6.0-1-x64.7z" ,"bundled"),_
    Array("2.6.0-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.0-1/","rubyinstaller-2.6.0-1-x86.7z" ,"bundled"),_
    Array("2.5.3"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.5.3-1/","rubyinstaller-2.5.3-1-x64.7z" ,"bundled"),_
    Array("2.5.3-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.5.3-1/","rubyinstaller-2.5.3-1-x86.7z" ,"bundled"),_
    Array("2.4.5"            ,"https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.5-1/","rubyinstaller-2.4.5-1-x64.7z" ,"bundled"),_
    Array("2.4.5-x86"        ,"https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.5-1/","rubyinstaller-2.4.5-1-x86.7z" ,"bundled") _
)

Function DownloadFile(strUrl,strFile)
    Dim objHttp
    Dim httpProxy
    Set objHttp = Wscript.CreateObject("Msxml2.ServerXMLHTTP")
    on error resume next
    Call objHttp.Open("GET", strUrl, False )
    if Err.Number <> 0 then
        Wscript.Echo Err.Description
        Wscript.Quit
    end if
    httpProxy = objws.ExpandEnvironmentStrings("%http_proxy%")
    if httpProxy <> "" AND httpProxy <> "%http_proxy%" Then
    	objHttp.setProxy 2, httpProxy
    end if
    objHttp.Send

    if Err.Number <> 0 then
        Wscript.Echo Err.Description
        Wscript.Quit
    end if
    on error goto 0
    if objHttp.status = 404 then
        Wscript.Echo "404:file not found"
        Wscript.Quit
    end if

    Dim Stream
    Set Stream = Wscript.CreateObject("ADODB.Stream")
    Stream.Open
    Stream.Type = 1
    Stream.Write objHttp.responseBody
    Stream.SaveToFile strFile, 2
    Stream.Close
End Function

Sub extractDevKit(cur)
    If Not objfs.FolderExists( strDirDevKit ) Then objfs.CreateFolder(strDirDevKit)
    If Not objfs.FolderExists(    cur(1)    ) Then objfs.CreateFolder(cur(1))

    If Not objfs.FileExists(cur(2)) Then 
        objws.Run "%comspec% /c rmdir /s /q " & cur(1), 0 , true
        objfs.CreateFolder(cur(1))
        If objfs.FileExists(cur(4)) Then
            objfs.CopyFile cur(4), cur(1)&"\", True
        Else
            download(cur)
        End If
    End If
    
    If Not objfs.FileExists(cur(1) & "\dk.rb") Then
        Wscript.echo "extract" & cur(0) & " ..."
        objws.Run """" & cur(2) & """", 1 , true
    End If
End Sub

Sub writeConfigYML(dev,cur)
    Dim ofile
    Set ofile = objfs.CreateTextFile(dev(1) & "\config.yml" , True )
    ofile.WriteLine("- " & cur(1))
    ofile.Close()
End Sub

Sub patchDevKit(dev,cur)
     Wscript.echo "patch " & dev(0) & " to " & cur(0)
     writeConfigYML dev,cur
     objws.CurrentDirectory = dev(1)
     objws.Run """" & cur(1) & "\bin\ruby.exe"" dk.rb install", 1 , true
     objws.CurrentDirectory =strCurrent
End Sub

Sub installDevKit(cur)
    Dim list
    Dim dev
    Dim idx
    If cur(4) = "bundled" Then
        objws.Run """" & cur(1) & "\bin\ridk.cmd"" install", 1 , true
    Else
        For Each list In listDevKit
            If list(0) = cur(4) Then
                dev=Array("DevKit_" & list(0), strDirDevKit&"\"&list(0), strDirDevKit&"\"&list(0)&"\"&list(2), list(1)&list(2),  strDirCache&"\"&list(2))
                extractDevKit dev
                patchDevKit dev,cur
                Exit Sub
            End If
        Next
    End If
End Sub

Sub clear(cur)
    If objfs.FolderExists(cur(1)) Then objfs.DeleteFolder cur(1),True 
    If objfs.FileExists(  cur(2)) Then objfs.DeleteFile   cur(2),True 
End Sub

Sub download(cur)
    Wscript.echo "download " & cur(0) & " ..."
    DownloadFile cur(3) , cur(2)
End Sub

Sub extract(cur)
    If Not objfs.FolderExists( strDirCache ) Then objfs.CreateFolder(strDirCache)
    If Not objfs.FolderExists( strDirVers  ) Then objfs.CreateFolder(strDirVers )

    If objfs.FolderExists(cur(1)) Then Exit Sub

    If Not objfs.FileExists(cur(2)) Then download(cur)
    
     Wscript.echo "install " & cur(0) & " ..."

    objws.CurrentDirectory = strDirCache
    objws.Run tool7z & " """ & cur(2) & """" , 0 , true
    objfs.MoveFolder strDirCache&"\"&objfs.GetBaseName(cur(2)) , cur(1)

    installDevKit(cur)
    objws.Run "rbenv rehash " & cur(0), 0, true
    Wscript.echo "comlete! " & cur(0)

End Sub

Function GetCurrentVersionGlobal()
    GetCurrentVersionGlobal = Null

    Dim fname
    Dim objFile
    fname = strRbenvHome & "\version"
    If objfs.FileExists( fname ) Then
        Set objFile = objfs.OpenTextFile(fname)
        If objFile.AtEndOfStream <> True Then
           GetCurrentVersionGlobal = Array(objFile.ReadLine,fname)
        End If
        objFile.Close
    End If
End Function

Function GetCurrentVersionLocal(path)
    GetCurrentVersionLocal = Null

    Dim fname
    Dim objFile
    Do While path <> ""
        fname = path & strVerFile
        If objfs.FileExists( fname ) Then
            Set objFile = objfs.OpenTextFile(fname)
            If objFile.AtEndOfStream <> True Then
               GetCurrentVersionLocal = Array(objFile.ReadLine,fname)
            End If
            objFile.Close
            Exit Function
        End If
        path = objfs.getParentFolderName(path)
    Loop
End Function

Function GetCurrentVersionShell()
    GetCurrentVersionShell = Null

    Dim str
    str=objws.ExpandEnvironmentStrings("%RBENV_VERSION%")
    If str <> "%RBENV_VERSION%" Then
        GetCurrentVersionShell = Array(str,"%RBENV_VERSION%")
    End If
End Function

Function GetCurrentVersionNoError()
    Dim str
    str=GetCurrentVersionShell
    If IsNull(str) Then str = GetCurrentVersionLocal(strCurrent)
    If IsNull(str) Then str = GetCurrentVersionGlobal
    GetCurrentVersionNoError = str
End Function

Sub main(arg)
    If arg.Count = 0 Then ShowHelp

    Dim idx
    Dim optForce
    Dim optSkip
    Dim optList
    Dim version

    optForce=False
    optSkip=False
    optList=False
    version=""

    For idx = 0 To arg.Count - 1 
        Select Case arg(idx)
           Case "--help"          ShowHelp
           Case "-l"              optList=True
           Case "--list"          optList=True
           Case "-f"              optForce=True
           Case "--force"         optForce=True
           Case "-s"              optSkip=True
           Case "--skip-existing" optSkip=True
           Case Else
               version = arg(idx)
               Exit For
        End Select
    Next

    If version = "" Then
        Dim ary
        ary=GetCurrentVersionNoError()
        If Not IsNull(ary) Then version=ary(0)
    End If
    
    Dim list
    Dim cur
    If optList Then
        For Each list In listEnv
            Wscript.echo list(0)
        Next
        Exit Sub
    ElseIf version <> "" Then
        For Each list In listEnv
            If list(0) = version Then 
                cur=Array(list(0),strDirVers&"\"&list(0),strDirCache&"\"&list(2),list(1)&list(2),list(3))
                If optForce Then  clear(cur)
                extract(cur)
                Exit Sub
            End If
        Next
        Wscript.echo "rbenv-install: definition not found: " & version
        Wscript.echo ""
        Wscript.echo "See all available versions with `rbenv install --list'."
    Else
        ShowHelp
    End If
End Sub

main(WScript.Arguments)
