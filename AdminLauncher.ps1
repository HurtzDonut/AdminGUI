    #region Launcher Functions
        # 00:F1 CMD
        Function Start-Launcher00 {
            Start-Process "$env:SystemRoot\System32\cmd.exe"
        }

        # 01:F2 PowerShell
        Function Start-Launcher01 {
            Start-Process "$env:AppData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
        }

        # 02:F3 PWSH
        Function Start-Launcher02 {
            Start-Process PwSh.exe
        }

        # 03:F4 VS Code
        Function Start-Launcher03 {
            Start-Process "$env:ProgramW6432\Microsoft VS Code\Code.exe"
        }

        # 04:F5 PowerShell Exchange
        Function Start-Launcher04 {
            $Command = "
            [Console]::Title = 'FFB EXCHANGE';
            Start-FFBExchangeAdmin -WarningAction SilentlyContinue"
            Start-Process PowerShell.exe -ArgumentList "-NoExit","-Command `"& {$Command}`""
        }

        # 05:F6 PwSh Exchange (PowerShell v7)
        Function Start-Launcher05 {
            $Command = "
            [Console]::Title = 'FFB EXCHANGE';
            Start-FFBExchangeAdmin -WarningAction SilentlyContinue"
            Start-Process PwSh.exe -ArgumentList "-NoExit","-Command `"& {$Command}`""
        }

        # 06:F7 Scheduled Tasks
        Function Start-Launcher06 {
            Start-Process "$env:SystemRoot\System32\control.exe" -ArgumentList "schedtasks"
            
        }

        # 07:F8 Credential Manager
        Function Start-Launcher07 {
            Start-Process "rundll32.exe" -ArgumentList "keymgr.dll, KRShowKeyMgr"
        }

        # 08:F9 Computer Management/Server Manager
        Function Start-Launcher08 {
            # Start-Process "$env:SystemRoot\system32\compmgmt.msc" -ArgumentList "/s"
            Start-Process "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Server Manager.lnk"
        }

        # 09:F10 Proofpoint Release
        Function Start-Launcher09 {
            Start-Process PowerShell.exe -ArgumentList '-NoProfile','-WindowStyle Hidden','-File "C:\AdminScripts\GUIs\Proofpoint\Release_Proofpoint_Message.ps1"'
        }

        # 10:F11 Notepad++
        Function Start-Launcher10 {
            $NPP = Get-ChildItem -Path 'C:\Program Files\*\note*'
            Start-Process $NPP.FullName
        }

        # 11:F12 Run Once
        Function Start-Launcher11 {
            [CmdLetBinding()]
            Param(
                [Parameter()]
                    [String]$Text
            )
            Begin {
                $StartProcessSplat = @{ErrorAction = "Stop"}
            }
            Process {
                If ($Text -match '\/|-') {
                    $TextArgs   = $Text -Split '\/|-'
                    $ArgsArray  = $TextArgs[1..($TextArgs.Count-1)] | ForEach-Object {'/',$PSItem -Join ''}

                    $StartProcessSplat['FilePath']      = $TextArgs[0]
                    $StartProcessSplat['ArgumentList']  = $ArgsArray
                } Else {
                    $StartProcessSplat['FilePath']      = $Text
                }
            }
            End {
                Try {
                    Start-Process @StartProcessSplat
                } Catch {
                    # Fail
                }
            }
        }

    #endregion Launcher Functions

[Void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Void][System.Windows.Forms.Application]::EnableVisualStyles()

#region Random Button Image
        Function Get-RandomBtnImage {
            [CmdLetBinding()]
            Param (
                [Parameter()]
                    [String]$FolderPath
            )
            $Image = Get-ChildItem -Path $FolderPath | Get-Random -Count 1
            
            $Image.FullName
        }
        # Dark Fonts
        # 4

        # Light Fonts
        # 1,5,11,7,10,6,2,9,8

        # Look at colors
        # 3,12
#endregion Random Button Image


#region GUI
    #region Launcher Text
        $Launch0T   = "CMD"
        $Launch1T   = "PowerShell"
        $Launch2T   = "PwSh"
        $Launch3T   = "VS Code"
        $Launch4T   = "PowerShell Exchange"
        $Launch5T   = "PwSh Exchange"
        $Launch6T   = "Scheduled Tasks"
        $Launch7T   = "Credential Manager"
        $Launch8T   = "Server Manager"
        $Launch9T   = "Proofpoint Release"
        $Launch10T  = "Notepad++"
        $Launch11T  = "Run Once"
    #endregion Launcher Text

    #region Base
        $ALForm_BGimg                    = [System.Drawing.Image]::FromFile("$env:PUBLIC\Documents\PS_GUI\Resources\AdminLauncher_BG9.jpg")
        $ALGlobal_Font                   = 'Consolas'

        $AdminLauncher                   = [System.Windows.Forms.Form]::New()
        $AdminLauncher.ClientSize        = [System.Drawing.Size]::New(800,500)
        $AdminLauncher.BackColor         = "#5E5E5E"
        $AdminLauncher.FormBorderStyle   = 'Fixed3D'
        $AdminLauncher.StartPosition     = 'CenterScreen'
        $AdminLauncher.MinimizeBox       = $True 
        $AdminLauncher.MaximizeBox       = $False
        $AdminLauncher.TopMost           = $false
        $AdminLauncher.Text              = "FFB Admin Launcher"
        $AdminLauncher.Font              = "$ALGlobal_Font,10"
        $AdminLauncher.Icon              = "$env:PUBLIC\Documents\PS_GUI\Resources\Mountain.ico"
        $AdminLauncher.BackgroundImage   = $ALForm_BGimg
        # Removes Border
        $AdminLauncher.FormBorderStyle   = "None"
        # Locks to Center Screen
        $AdminLauncher.StartPosition     = "CenterScreen"

        # $LaunchBGImage                   = [System.Drawing.Image]::FromFile("$env:PUBLIC\Documents\PS_GUI\Resources\AdminLauncher_Btn9.jpg")
        $LaunchBGImage                   = [ScriptBlock]::Create("Get-RandomBtnImage -FolderPath $env:PUBLIC\Documents\PS_GUI\Resources\Pine")
        $LaunchBack                      = "#909090"
        $LaunchFore                      = "#FFFFFF"
        $DarkLaunchFore                  = "#000000"
        $LightLaunchFore                 = "#FFFFFF"
        $LaunchForePattern               = '[^1](4|6|3)\.jpg$'
        $LaunchFontSize                  = '12'

        $HotKeyFontSize                  = '14'
        $HotKeyFore                      = "#000000"
        $HotkeyBack                      = "Transparent"
    #endregion Base

    #region Buttons

        #region Launcher 00:F1 CMD
            $Launch0                         = [System.Windows.Forms.Button]::New()
            $Launch0.text                    = $Launch0T
            $Launch0.BackColor               = $LaunchBack
            $L0Img                           = $LaunchBGImage.Invoke()[0]
            $Launch0.BackgroundImage         = [System.Drawing.Image]::FromFile($L0Img)
            $Launch0.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch0.location                = [System.Drawing.Point]::new(80,62)
            $Launch0.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            # $Launch0.ForeColor               = $LaunchFore
            $Launch0.ForeColor               = If ($L0Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 00:F1 CMD

        #region Launcher 01:F2 PowerShell
            $Launch1                         = [System.Windows.Forms.Button]::New()
            $Launch1.text                    = $Launch1T
            $Launch1.BackColor               = $LaunchBack
            $L1Img                           = $LaunchBGImage.Invoke()[0]
            $Launch1.BackgroundImage         = [System.Drawing.Image]::FromFile($L1Img)
            $Launch1.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch1.location                = [System.Drawing.Point]::new(248,62)
            $Launch1.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $Launch1.ForeColor               = If ($L1Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 01:F2 PowerShell

        #region Launcher 02:F3 PWSH
            $Launch2                         = [System.Windows.Forms.Button]::New()
            $Launch2.text                    = $Launch2T
            $Launch2.BackColor               = $LaunchBack
            $L2Img                           = $LaunchBGImage.Invoke()[0]
            $Launch2.BackgroundImage         = [System.Drawing.Image]::FromFile($L2Img)
            $Launch2.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch2.location                = [System.Drawing.Point]::new(416,62)
            $Launch2.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $Launch2.ForeColor               = If ($L2Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 02:F3 PWSH

        #region Launcher 03:F4 VSCode
            $Launch3                         = [System.Windows.Forms.Button]::New()
            $Launch3.text                    = $Launch3T
            $Launch3.BackColor               = $LaunchBack
            $L3Img                           = $LaunchBGImage.Invoke()[0]
            $Launch3.BackgroundImage         = [System.Drawing.Image]::FromFile($L3Img)
            $Launch3.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch3.location                = [System.Drawing.Point]::new(584,62)
            $Launch3.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $Launch3.ForeColor               = If ($L4Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 03:F4 VSCode

        #region Launcher 04:F5 PowerShell Exchange
            $Launch4                         = [System.Windows.Forms.Button]::New()
            $Launch4.text                    = $Launch4T
            $Launch4.BackColor               = $LaunchBack
            $L4Img                           = $LaunchBGImage.Invoke()[0]
            $Launch4.BackgroundImage         = [System.Drawing.Image]::FromFile($L4Img)
            $Launch4.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch4.location                = [System.Drawing.Point]::new(80,182)
            $Launch4.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $Launch4.ForeColor               = $LaunchFore
            $Launch4.ForeColor               = If ($L4Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 04:F5 PowerShell Exchange

        #region Launcher 05:F6 PwSh Exchange (PowerShell v7)
            $Launch5                         = [System.Windows.Forms.Button]::New()
            $Launch5.text                    = $Launch5T
            $Launch5.BackColor               = $LaunchBack
            $Launch5.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch5.location                = [System.Drawing.Point]::new(248,182)
            $Launch5.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $L5Img                           = $LaunchBGImage.Invoke()[0]
            $Launch5.BackgroundImage         = [System.Drawing.Image]::FromFile($L5Img)
            $Launch5.ForeColor               = If ($L5Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 05:F6 PwSh Exchange (PowerShell v7)

        #region Launcher 06:F7 Scheduled Tasks
            $Launch6                         = [System.Windows.Forms.Button]::New()
            $Launch6.text                    = $Launch6T
            $Launch6.BackColor               = $LaunchBack
            $Launch6.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch6.location                = [System.Drawing.Point]::new(416,182)
            $Launch6.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $L6Img                           = $LaunchBGImage.Invoke()[0]
            $Launch6.BackgroundImage         = [System.Drawing.Image]::FromFile($L6Img)
            $Launch6.ForeColor               = If ($L6Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 06:F7 Scheduled Tasks

        #region Launcher 07:F8 Credential Manager
            $Launch7                         = [System.Windows.Forms.Button]::New()
            $Launch7.text                    = $Launch7T
            $Launch7.BackColor               = $LaunchBack
            $Launch7.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch7.location                = [System.Drawing.Point]::new(584,182)
            $Launch7.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $Launch7.ForeColor               = $LaunchFore
            $L7Img                           = $LaunchBGImage.Invoke()[0]
            $Launch7.BackgroundImage         = [System.Drawing.Image]::FromFile($L7Img)
            $Launch7.ForeColor               = If ($L7Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 07:F8 Credential Manager

        #region Launcher 08:F9 Computer Management
            $Launch8                         = [System.Windows.Forms.Button]::New()
            $Launch8.text                    = $Launch8T
            $Launch8.BackColor               = $LaunchBack
            $Launch8.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch8.location                = [System.Drawing.Point]::new(80,382)
            $Launch8.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $L8Img                           = $LaunchBGImage.Invoke()[0]
            $Launch8.BackgroundImage         = [System.Drawing.Image]::FromFile($L8Img)
            $Launch8.ForeColor               = If ($L8Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 08:F9 Computer Management

        #region Launcher 09:F10 Proofpoint Release
            $Launch9                         = [System.Windows.Forms.Button]::New()
            $Launch9.text                    = $Launch9T
            $Launch9.BackColor               = $LaunchBack
            $Launch9.Size                    = [System.Drawing.Size]::New(138,51)
            $Launch9.location                = [System.Drawing.Point]::new(248,382)
            $Launch9.Font                    = "$ALGlobal_Font,$LaunchFontSize"
            $L9Img                           = $LaunchBGImage.Invoke()[0]
            $Launch9.BackgroundImage         = [System.Drawing.Image]::FromFile($L9Img)
            $Launch9.ForeColor               = If ($L9Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 09:F10 Proofpoint Release

        #region Launcher 10:F11 Notepad++
            $Launch10                        = [System.Windows.Forms.Button]::New()
            $Launch10.text                   = $Launch10T
            $Launch10.BackColor              = $LaunchBack
            $Launch10.Size                   = [System.Drawing.Size]::New(138,51)
            $Launch10.location               = [System.Drawing.Point]::new(416,382)
            $Launch10.Font                   = "$ALGlobal_Font,$LaunchFontSize"
            $L10Img                           = $LaunchBGImage.Invoke()[0]
            $Launch10.BackgroundImage         = [System.Drawing.Image]::FromFile($L10Img)
            $Launch10.ForeColor               = If ($L10Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 10:F11 Notepad++

        #region Launcher 11:F12 Run Once
            $Launch11                        = [System.Windows.Forms.Button]::New()
            $Launch11.text                   = $Launch11T
            $Launch11.BackColor              = $LaunchBack
            $Launch11.Size                   = [System.Drawing.Size]::New(138,51)
            $Launch11.location               = [System.Drawing.Point]::new(584,382)
            $Launch11.Font                   = "$ALGlobal_Font,$LaunchFontSize"
            $L11Img                           = $LaunchBGImage.Invoke()[0]
            $Launch11.BackgroundImage         = [System.Drawing.Image]::FromFile($L11Img)
            $Launch11.ForeColor               = If ($L11Img -match $LaunchForePattern ){$DarkLaunchFore}Else{$LightLaunchFore}
        #endregion Launcher 11:F12 Run Once

        #region TextBox 11:F12 Run Once
            $TextBox1                        = [System.Windows.Forms.TextBox]::new()
            $TextBox1.multiline              = $false
            $TextBox1.Size                   = [System.Drawing.Size]::New(213,20)
            # $TextBox1.location               = [System.Drawing.Point]::new(558,432)
            $TextBox1.location               = [System.Drawing.Point]::new($Launch11.Location.X-26,$Launch11.Location.Y+80)
            $TextBox1.Font                   = "$ALGlobal_Font,$LaunchFontSize"
        #endregion TextBox 11:F12 Run Once
    #endregion Buttons

    #region HotKey Labels

        #region Launcher 00:F1 CMD
            $HotKey1                         = [System.Windows.Forms.Label]::new()
            $HotKey1.text                    = "F1"
            $HotKey1.BackColor               = $HotkeyBack
            $HotKey1.AutoSize                = $true
            $HotKey1.width                   = 25
            $HotKey1.height                  = 10
            # $HotKey1.location                = [System.Drawing.Point]::new(139,80)
            $HotKey1.location                = [System.Drawing.Point]::new($Launch0.Location.X+59,$Launch0.Location.Y-22)
            $HotKey1.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey1.ForeColor               = $HotkeyFore
        #endregion Launcher 00:F1 CMD

        #region Launcher 01:F2 PowerShell
            $HotKey2                         = [System.Windows.Forms.Label]::new()
            $HotKey2.text                    = "F2"
            $HotKey2.BackColor               = $HotkeyBack
            $HotKey2.AutoSize                = $true
            $HotKey2.width                   = 25
            $HotKey2.height                  = 10
            # $HotKey2.location                = [System.Drawing.Point]::new(307,80)
            $HotKey2.location                = [System.Drawing.Point]::new($Launch1.Location.X+59,$Launch1.Location.Y-22)
            $HotKey2.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey2.ForeColor               = $HotkeyFore
        #endregion Launcher 01:F2 PowerShell

        #region Launcher 02:F3 PWSH
            $HotKey3                         = [System.Windows.Forms.Label]::new()
            $HotKey3.text                    = "F3"
            $HotKey3.BackColor               = $HotkeyBack
            $HotKey3.AutoSize                = $true
            $HotKey3.width                   = 25
            $HotKey3.height                  = 10
            # $HotKey3.location                = [System.Drawing.Point]::new(475,80)
            $HotKey3.location                = [System.Drawing.Point]::new($Launch2.Location.X+59,$Launch2.Location.Y-22)
            $HotKey3.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey3.ForeColor               = $HotkeyFore
        #endregion Launcher 02:F3 PWSH

        #region Launcher 03:F4 VSCode
            $HotKey4                         = [System.Windows.Forms.Label]::new()
            $HotKey4.text                    = "F4"
            $HotKey4.BackColor               = $HotkeyBack
            $HotKey4.AutoSize                = $true
            $HotKey4.width                   = 25
            $HotKey4.height                  = 10
            # $HotKey4.location                = [System.Drawing.Point]::new(643,80)
            $HotKey4.location                = [System.Drawing.Point]::new($Launch3.Location.X+59,$Launch3.Location.Y-22)
            $HotKey4.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey4.ForeColor               = $HotkeyFore
        #endregion Launcher 03:F4 VSCode

        #region Launcher 04:F5 PowerShell Exchange
            $HotKey5                         = [System.Windows.Forms.Label]::new()
            $HotKey5.text                    = "F5"
            $HotKey5.BackColor               = $HotkeyBack
            $HotKey5.AutoSize                = $true
            $HotKey5.width                   = 25
            $HotKey5.height                  = 10
            # $HotKey5.location                = [System.Drawing.Point]::new(139,200)
            $HotKey5.location                = [System.Drawing.Point]::new($Launch4.Location.X+59,$Launch4.Location.Y-22)
            $HotKey5.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey5.ForeColor               = $HotkeyFore
        #endregion Launcher 04:F5 PowerShell Exchange

        #region Launcher 05:F6 PwSh Exchange (PowerShell v7)
            $HotKey6                         = [System.Windows.Forms.Label]::new()
            $HotKey6.text                    = "F6"
            $HotKey6.BackColor               = $HotkeyBack
            $HotKey6.AutoSize                = $true
            $HotKey6.width                   = 25
            $HotKey6.height                  = 10
            # $HotKey6.location                = [System.Drawing.Point]::new(307,200)
            $HotKey6.location                = [System.Drawing.Point]::new($Launch5.Location.X+59,$Launch5.Location.Y-22)
            $HotKey6.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey6.ForeColor               = $HotkeyFore
        #endregion Launcher 05:F6 PwSh Exchange (PowerShell v7)

        #region Launcher 06:F7 Scheduled Tasks
            $HotKey7                         = [System.Windows.Forms.Label]::new()
            $HotKey7.text                    = "F7"
            $HotKey7.BackColor               = $HotkeyBack
            $HotKey7.AutoSize                = $true
            $HotKey7.width                   = 25
            $HotKey7.height                  = 10
            # $HotKey7.location                = [System.Drawing.Point]::new(475,200)
            $HotKey7.location                = [System.Drawing.Point]::new($Launch6.Location.X+59,$Launch6.Location.Y-22)
            $HotKey7.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey7.ForeColor               = $HotkeyFore
        #endregion Launcher 06:F7 Scheduled Tasks

        #region Launcher 07:F8 Credential Manager
            $HotKey8                         = [System.Windows.Forms.Label]::new()
            $HotKey8.text                    = "F8"
            $HotKey8.BackColor               = $HotkeyBack
            $HotKey8.AutoSize                = $true
            $HotKey8.width                   = 25
            $HotKey8.height                  = 10
            # $HotKey8.location                = [System.Drawing.Point]::new(643,200)
            $HotKey8.location                = [System.Drawing.Point]::new($Launch7.Location.X+59,$Launch7.Location.Y-22)
            $HotKey8.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey8.ForeColor               = $HotkeyFore
        #endregion Launcher 07:F8 Credential Manager

        #region Launcher 08:F9 Computer Management
            $HotKey9                         = [System.Windows.Forms.Label]::new()
            $HotKey9.text                    = "F9"
            $HotKey9.BackColor               = $HotkeyBack
            $HotKey9.AutoSize                = $true
            $HotKey9.width                   = 25
            $HotKey9.height                  = 10
            # $HotKey9.location                = [System.Drawing.Point]::new(139,402)
            $HotKey9.location                = [System.Drawing.Point]::new($Launch8.Location.X+59,$Launch8.Location.Y+50)
            $HotKey9.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey9.ForeColor               = $HotkeyFore
        #endregion Launcher 08:F9 Computer Management

        #region Launcher 09:F10 Proofpoint Release
            $HotKey10                         = [System.Windows.Forms.Label]::new()
            $HotKey10.text                    = "F10"
            $HotKey10.BackColor               = $HotkeyBack
            $HotKey10.AutoSize                = $true
            $HotKey10.width                   = 25
            $HotKey10.height                  = 10
            # $HotKey10.location                = [System.Drawing.Point]::new(307,402)
            $HotKey10.location                = [System.Drawing.Point]::new($Launch9.Location.X+59,$Launch9.Location.Y+50)
            $HotKey10.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey10.ForeColor               = $HotkeyFore
        #endregion Launcher 09:F10 Proofpoint Release

        #region Launcher 10:F11 Notepad++
            $HotKey11                         = [System.Windows.Forms.Label]::new()
            $HotKey11.text                    = "F11"
            $HotKey11.BackColor               = $HotkeyBack
            $HotKey11.AutoSize                = $true
            $HotKey11.width                   = 25
            $HotKey11.height                  = 10
            # $HotKey11.location                = [System.Drawing.Point]::new(475,402)
            $HotKey11.location                = [System.Drawing.Point]::new($Launch10.Location.X+59,$Launch10.Location.Y+50)
            $HotKey11.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey11.ForeColor               = $HotkeyFore
        #endregion Launcher 10:F11 Notepad++

        #region Launcher 11:F12 Run Once
            $HotKey12                         = [System.Windows.Forms.Label]::new()
            $HotKey12.text                    = "F12"
            $HotKey12.BackColor               = $HotkeyBack
            $HotKey12.AutoSize                = $true
            $HotKey12.width                   = 25
            $HotKey12.height                  = 10
            # $HotKey12.location                = [System.Drawing.Point]::new(643,402)
            $HotKey12.location                = [System.Drawing.Point]::new($Launch11.Location.X+59,$Launch11.Location.Y+50)
            $HotKey12.Font                    = "$ALGlobal_Font,$HotkeyFontSize"
            $HotKey12.ForeColor               = $HotkeyFore
        #endregion Launcher 11:F12 Run Once
    #endregion HotKey Labels

    $AdminLauncher.controls.AddRange(@($Launch0,$Launch1,$Launch2,$Launch3,$Launch4,$Launch5,$Launch6,$Launch7,$Launch8,$Launch9,$Launch10,$Launch11,$TextBox1,`
                                        $HotKey1,$HotKey2,$HotKey3,$HotKey4,$HotKey5,$HotKey6,$HotKey7,$HotKey8,$HotKey9,$HotKey10,$HotKey11,$HotKey12))

    #region Events
        #region Button Clicks
            # 00:F1 CMD
                $Launch0.Add_Click({ Start-Launcher00 })
            # 01:F2 PowerShell
                $Launch1.Add_Click({ Start-Launcher01 })
            # 02:F3 PWSH
                $Launch2.Add_Click({ Start-Launcher02 })
            # 03:F4 VS Code
                $Launch3.Add_Click({ Start-Launcher03 })
            # 04:F5 PowerShell Exchange
                $Launch4.Add_Click({ Start-Launcher04 })
            # 05:F6 Scheduled Tasks
                $Launch5.Add_Click({ Start-Launcher05 })
            # 06:F7 Credential Manager
                $Launch6.Add_Click({ Start-Launcher06 })
            # 07:F8 Task Manager
                $Launch7.Add_Click({ Start-Launcher07 })
            # 08:F9 Computer Management
                $Launch8.Add_Click({ Start-Launcher08 })
            # 09:F10 Proofpoint Release
                $Launch9.Add_Click({ Start-Launcher09 })
            # 10:F11 Notepad++
                $Launch10.Add_Click({ Start-Launcher10 })
            # 11:F12 Run Once
                $Launch11.Add_Click({ Start-Launcher11 -Text $Textbox1.Text ; $Textbox1.Text = $Null })
        #endregion Button Clicks

        #region Key Press
            $AdminLauncher.KeyPreview=$True
            $AdminLauncher.Add_KeyDown({
                Switch($_.KeyCode){
                    'Escape'	{$AdminLauncher.Close();$AdminLauncher.Dispose()}
                    'F1'        { $Launch0.PerformClick() }  # 00:F1 CMD
                    'F2'        { $Launch1.PerformClick() }  # 01:F2 PowerShell
                    'F3'        { $Launch2.PerformClick() }  # 02:F3 PWSH
                    'F4'        { $Launch3.PerformClick() }  # 03:F4 VS Code
                    'F5'        { $Launch4.PerformClick() }  # 04:F5 PowerShell Exchange
                    'F6'        { $Launch5.PerformClick() }  # 05:F6 Scheduled Tasks
                    'F7'        { $Launch6.PerformClick() }  # 06:F7 Credential Manager
                    'F8'        { $Launch7.PerformClick() }  # 07:F8 Task Manager
                    'F9'        { $Launch8.PerformClick() }  # 08:F9 Computer Management
                    'F10'       { $Launch9.PerformClick() }  # 09:F10 Proofpoint Release
                    'F11'       { $Launch10.PerformClick() } # 10:F11 Notepad++
                    'F12'       { $Launch11.PerformClick() } # 11:F12 Run Once
                }
            })
        #endregion KeyPress
    #endregion Events
#endregion GUI

[void]$AdminLauncher.ShowDialog()