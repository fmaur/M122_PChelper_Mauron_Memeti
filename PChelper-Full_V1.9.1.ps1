########################################################################
# 
# PChelper V1.9
# 
# by: Fabian Mauron, 04.11.2021
# 
########################################################################

# Abfrage des Benutzers oder Bestätigung, dass Script als Admin ausführen
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
if (!$myWindowsPrincipal.IsInRole($adminRole)){
    start-process "powershell" -Verb "runas" -ArgumentList "-File",$MyInvocation.MyCommand.Definition
    exit
}

########################################################################
# 
# SLIDE 1 (Hauptfunktion mit Softwareinstallation)
# 
########################################################################

#Generated Form Function
function Slide1{
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#Variablen für GUI-Objekte
$PChelper_Form_S1 = New-Object System.Windows.Forms.Form
$CancelBtn_S1 = New-Object System.Windows.Forms.Button
$InstBtn_S1 = New-Object System.Windows.Forms.Button
$GrpBox_Driver = New-Object System.Windows.Forms.GroupBox
$CheckBox_autoPC = New-Object System.Windows.Forms.CheckBox
$GrpBox_ManuelDriver = New-Object System.Windows.Forms.GroupBox
$RadBtn_Driver4 = New-Object System.Windows.Forms.RadioButton
$RadBtn_Driver3 = New-Object System.Windows.Forms.RadioButton
$RadBtn_Driver1 = New-Object System.Windows.Forms.RadioButton
$RadBtn_Driver2 = New-Object System.Windows.Forms.RadioButton
$GrpBox_SW = New-Object System.Windows.Forms.GroupBox
$CheckBox_SW4 = New-Object System.Windows.Forms.CheckBox
$CheckBox_SW3 = New-Object System.Windows.Forms.CheckBox
$CheckBox_SW2 = New-Object System.Windows.Forms.CheckBox
$CheckBox_SW1 = New-Object System.Windows.Forms.CheckBox
$Description_S1 = New-Object System.Windows.Forms.Label
$Header_S1 = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#----------------------------------------------
cls
#----------------------------------------------

#Button, der Installation startet
$InstBtn_S1_Click= 
{
    #Test, ob 7zip bereits installiert ist, anderenfalls wird die Installation gestartet
    if ($CheckBox_SW1.Checked -eq $True) {
        if (Test-Path -Path "C:\Program Files\7-Zip") {
            [System.Windows.Forms.MessageBox]::Show("7zip ist bereits installiert.","7zip bereits installiert",0, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        else {
        Start-Process "$PSScriptRoot\Software\7z1900-x64.exe" -ArgumentList "/S /D= C:\Program Files\7-Zip"
        }
    }

    #Test, ob Adobe Acrobat Reader bereits installiert ist, anderenfalls wird die Installation gestartet
    if ($CheckBox_SW2.Checked -eq $True) {
        if (Test-Path -Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC") {
            [System.Windows.Forms.MessageBox]::Show("Acrobat Reader DC ist bereits installiert.","Reader bereits installiert",0, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        else {
        Start-Process "$PSScriptRoot\Software\AcrobatReaderDC\setup.exe" 
        }
    }

    #Test, ob Mozilla Firefox bereits installiert ist, anderenfalls wird die Installation gestartet
    if ($CheckBox_SW3.Checked -eq $True) {
        if (Test-Path -Path "C:\Program Files\Mozilla Firefox") {
            [System.Windows.Forms.MessageBox]::Show("Mozilla Firefox ist bereits installiert.","Firefox bereits installiert",0, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        else {
        Start-Process "$PSScriptRoot\Software\FirefoxSetup93.0.exe" -ArgumentList "-ms -ma"
        }
    }

    #Test, ob VLC Media Player bereits installiert ist, anderenfalls wird die Installation gestartet
    if ($CheckBox_SW4.Checked -eq $True) {
        if (Test-Path -Path "C:\Program Files (x86)\VideoLAN\VLC") {
            [System.Windows.Forms.MessageBox]::Show("VLC Media Player ist bereits installiert.","VLC bereits installiert",0, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        else {
        Start-Process "$PSScriptRoot\Software\vlc-3.0.16-win32.exe" -Argument "/L=1031 /S /NCRC" 
        }
    }

    #Prüfen, ob Auto-Erkennung gewählt wurde
    if ($CheckBox_autoPC.Checked -eq $True) {
        $PCmodel = (Get-WmiObject -Class:Win32_ComputerSystem).Model
        #Switch, der PC-Model mit Liste abgleicht und Installation startet
        switch ($PCmodel) {
            "20RD001GMZ" {Start-Process "$PSScriptRoot\Drivers\LenovoE15G1SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "20RD001FMZ" {Start-Process "$PSScriptRoot\Drivers\LenovoE15G1SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "20TD0003MZ" {Start-Process "$PSScriptRoot\Drivers\LenovoE15G2SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "20TD0004MZ" {Start-Process "$PSScriptRoot\Drivers\LenovoE15G2SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "82DE0035MZ" {Start-Process "$PSScriptRoot\Drivers\LenovoYoga15SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "HP ProBook 430 G7" {Start-Process "$PSScriptRoot\Drivers\HPProBook430450G7SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            "HP ProBook 450 G7" {Start-Process "$PSScriptRoot\Drivers\HPProBook430450G7SCCM.exe" -ArgumentList "/SP- /Verysilent"}
            Default {[System.Windows.Forms.MessageBox]::Show("Das PC-Modell $PCmodel ist nicht bekannt. Bitte wenden Sie sich an Ihren Systemadministrator.","PC-Model unbekannt",0, [System.Windows.Forms.MessageBoxIcon]::Error)}
        }
    }

    else {
        #Manuelle Installation des gewünschten Treibers
        if ($RadBtn_Driver1.Checked -eq $True) {
            #Lenovo Thinkpad E15 Gen 1
            Start-Process "$PSScriptRoot\Drivers\LenovoE15G1SCCM.exe" -ArgumentList "/SP- /Verysilent"
        }

        #Manuelle Installation des gewünschten Treibers
        if ($RadBtn_Driver2.Checked -eq $True) {
            #Lenovo Thinkpad E15 Gen 2
            Start-Process "$PSScriptRoot\Drivers\LenovoE15G2SCCM.exe" -ArgumentList "/SP- /Verysilent"
        }

        #Manuelle Installation des gewünschten Treibers
        if ($RadBtn_Driver3.Checked -eq $True) {
            #Yoga 15 Laptop (ThinkPad)
            Start-Process "$PSScriptRoot\Drivers\LenovoYoga15SCCM.exe" -ArgumentList "/SP- /Verysilent"
        }

        #Manuelle Installation des gewünschten Treibers
        if ($RadBtn_Driver4.Checked -eq $True) {
            #HP ProBook 430 & 450 Gen7
            Start-Process "$PSScriptRoot\Drivers\HPProBook430450G7SCCM.exe" -ArgumentList "/SP- /Verysilent"
        }
    }
    #Abschluss des ersten GUI
    $script:answer="Installieren"
    $PChelper_Form_S1.close()  
}

$CancelBtn_S1_OnClick= 
{
    #Abbrechen des Scripts
    $script:answer="Abbrechen"
    $PChelper_Form_S1.close()  
    Write-Warning "Sie haben die Anwendung beendet."
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$PChelper_Form_S1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 407
$System_Drawing_Size.Width = 316
$PChelper_Form_S1.ClientSize = $System_Drawing_Size
$PChelper_Form_S1.DataBindings.DefaultDataSourceUpdateMode = 0
$PChelper_Form_S1.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSScriptRoot\Extras\PChelper-icon.ico")
$PChelper_Form_S1.Name = "PChelper_Form_S1"
$PChelper_Form_S1.Text = "PChelper"


$CancelBtn_S1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 148
$System_Drawing_Point.Y = 372
$CancelBtn_S1.Location = $System_Drawing_Point
$CancelBtn_S1.Name = "CancelBtn_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$CancelBtn_S1.Size = $System_Drawing_Size
$CancelBtn_S1.TabIndex = 5
$CancelBtn_S1.Text = "Abbrechen"
$CancelBtn_S1.UseVisualStyleBackColor = $True
$CancelBtn_S1.add_Click($CancelBtn_S1_OnClick)

$PChelper_Form_S1.Controls.Add($CancelBtn_S1)


$InstBtn_S1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 229
$System_Drawing_Point.Y = 372
$InstBtn_S1.Location = $System_Drawing_Point
$InstBtn_S1.Name = "InstBtn_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$InstBtn_S1.Size = $System_Drawing_Size
$InstBtn_S1.TabIndex = 4
$InstBtn_S1.Text = "Installieren"
$InstBtn_S1.UseVisualStyleBackColor = $True
$InstBtn_S1.add_Click($InstBtn_S1_Click)

$PChelper_Form_S1.Controls.Add($InstBtn_S1)


$GrpBox_Driver.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 229
$GrpBox_Driver.Location = $System_Drawing_Point
$GrpBox_Driver.Name = "GrpBox_Driver"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 137
$System_Drawing_Size.Width = 291
$GrpBox_Driver.Size = $System_Drawing_Size
$GrpBox_Driver.TabIndex = 3
$GrpBox_Driver.TabStop = $False
$GrpBox_Driver.Text = "Treiber"

$PChelper_Form_S1.Controls.Add($GrpBox_Driver)

$CheckBox_autoPC.Checked = $True
$CheckBox_autoPC.CheckState = 1
$CheckBox_autoPC.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$CheckBox_autoPC.Location = $System_Drawing_Point
$CheckBox_autoPC.Name = "CheckBox_autoPC"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 270
$CheckBox_autoPC.Size = $System_Drawing_Size
$CheckBox_autoPC.TabIndex = 3
$CheckBox_autoPC.Text = "automatische Erkennung"
$CheckBox_autoPC.UseVisualStyleBackColor = $True
#Deaktivieren von Groupbox für Manuelle Treiber, wenn Auto-Erkennung gewählt
$CheckBox_autoPC.Add_CheckStateChanged({
    If ($CheckBox_autoPC.Checked) {
        $GrpBox_ManuelDriver.Enabled = $False
    } 
    else {
        $GrpBox_ManuelDriver.Enabled = $True
    }
})
$GrpBox_Driver.Controls.Add($CheckBox_autoPC)


$GrpBox_ManuelDriver.DataBindings.DefaultDataSourceUpdateMode = 0
$GrpBox_ManuelDriver.Enabled = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 49
$GrpBox_ManuelDriver.Location = $System_Drawing_Point
$GrpBox_ManuelDriver.Name = "GrpBox_ManuelDriver"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 81
$System_Drawing_Size.Width = 279
$GrpBox_ManuelDriver.Size = $System_Drawing_Size
$GrpBox_ManuelDriver.TabIndex = 2
$GrpBox_ManuelDriver.TabStop = $False
$GrpBox_ManuelDriver.Text = "Manuelle Auswahl"

$GrpBox_Driver.Controls.Add($GrpBox_ManuelDriver)

$RadBtn_Driver4.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 145
$System_Drawing_Point.Y = 51
$RadBtn_Driver4.Location = $System_Drawing_Point
$RadBtn_Driver4.Name = "RadBtn_Driver4"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 129
$RadBtn_Driver4.Size = $System_Drawing_Size
$RadBtn_Driver4.TabIndex = 3
$RadBtn_Driver4.TabStop = $True
$RadBtn_Driver4.Text = "HP 430 + 450 Gen7"
$RadBtn_Driver4.UseVisualStyleBackColor = $True

$GrpBox_ManuelDriver.Controls.Add($RadBtn_Driver4)


$RadBtn_Driver3.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 145
$System_Drawing_Point.Y = 19
$RadBtn_Driver3.Location = $System_Drawing_Point
$RadBtn_Driver3.Name = "RadBtn_Driver3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 129
$RadBtn_Driver3.Size = $System_Drawing_Size
$RadBtn_Driver3.TabIndex = 2
$RadBtn_Driver3.TabStop = $True
$RadBtn_Driver3.Text = "Lenovo Yoga C740"
$RadBtn_Driver3.UseVisualStyleBackColor = $True

$GrpBox_ManuelDriver.Controls.Add($RadBtn_Driver3)


$RadBtn_Driver1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$RadBtn_Driver1.Location = $System_Drawing_Point
$RadBtn_Driver1.Name = "RadBtn_Driver1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 150
$RadBtn_Driver1.Size = $System_Drawing_Size
$RadBtn_Driver1.TabIndex = 0
$RadBtn_Driver1.TabStop = $True
$RadBtn_Driver1.Text = "Lenovo E15 Gen 1"
$RadBtn_Driver1.UseVisualStyleBackColor = $True

$GrpBox_ManuelDriver.Controls.Add($RadBtn_Driver1)


$RadBtn_Driver2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 51
$RadBtn_Driver2.Location = $System_Drawing_Point
$RadBtn_Driver2.Name = "RadBtn_Driver2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 150
$RadBtn_Driver2.Size = $System_Drawing_Size
$RadBtn_Driver2.TabIndex = 1
$RadBtn_Driver2.TabStop = $True
$RadBtn_Driver2.Text = "Lenovo E15 Gen 2"
$RadBtn_Driver2.UseVisualStyleBackColor = $True
$RadBtn_Driver2.add_CheckedChanged($handler_RadBtn_Driver2_CheckedChanged)

$GrpBox_ManuelDriver.Controls.Add($RadBtn_Driver2)


$GrpBox_SW.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 83
$GrpBox_SW.Location = $System_Drawing_Point
$GrpBox_SW.Name = "GrpBox_SW"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 140
$System_Drawing_Size.Width = 291
$GrpBox_SW.Size = $System_Drawing_Size
$GrpBox_SW.TabIndex = 2
$GrpBox_SW.TabStop = $False
$GrpBox_SW.Text = "Software"
$GrpBox_SW.add_Enter($handler_GrpBox_SW_Enter)

$PChelper_Form_S1.Controls.Add($GrpBox_SW)

$CheckBox_SW4.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 111
$CheckBox_SW4.Location = $System_Drawing_Point
$CheckBox_SW4.Name = "CheckBox_SW4"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 200
$CheckBox_SW4.Size = $System_Drawing_Size
$CheckBox_SW4.TabIndex = 3
$CheckBox_SW4.Text = "VLC Media Player"
$CheckBox_SW4.UseVisualStyleBackColor = $True

$GrpBox_SW.Controls.Add($CheckBox_SW4)


$CheckBox_SW3.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 81
$CheckBox_SW3.Location = $System_Drawing_Point
$CheckBox_SW3.Name = "CheckBox_SW3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 200
$CheckBox_SW3.Size = $System_Drawing_Size
$CheckBox_SW3.TabIndex = 2
$CheckBox_SW3.Text = "Mozilla Firefox"
$CheckBox_SW3.UseVisualStyleBackColor = $True

$GrpBox_SW.Controls.Add($CheckBox_SW3)


$CheckBox_SW2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 51
$CheckBox_SW2.Location = $System_Drawing_Point
$CheckBox_SW2.Name = "CheckBox_SW2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 200
$CheckBox_SW2.Size = $System_Drawing_Size
$CheckBox_SW2.TabIndex = 1
$CheckBox_SW2.Text = "Adobe Acrobat Reader DC"
$CheckBox_SW2.UseVisualStyleBackColor = $True

$GrpBox_SW.Controls.Add($CheckBox_SW2)


$CheckBox_SW1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 7
$System_Drawing_Point.Y = 21
$CheckBox_SW1.Location = $System_Drawing_Point
$CheckBox_SW1.Name = "CheckBox_SW1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 24
$System_Drawing_Size.Width = 200
$CheckBox_SW1.Size = $System_Drawing_Size
$CheckBox_SW1.TabIndex = 0
$CheckBox_SW1.Text = "7zip"
$CheckBox_SW1.UseVisualStyleBackColor = $True

$GrpBox_SW.Controls.Add($CheckBox_SW1)


$Description_S1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 32
$Description_S1.Location = $System_Drawing_Point
$Description_S1.Name = "Description_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 48
$System_Drawing_Size.Width = 291
$Description_S1.Size = $System_Drawing_Size
$Description_S1.TabIndex = 1
$Description_S1.Text = "Wählen Sie die gewünschte Software und das PC-Modell. Klicken Sie danach auf Installieren und Sie gelangen nach der Installation ins nächste Fenster."

$PChelper_Form_S1.Controls.Add($Description_S1)

$Header_S1.DataBindings.DefaultDataSourceUpdateMode = 0
$Header_S1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",11.25,1,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 9
$Header_S1.Location = $System_Drawing_Point
$Header_S1.Name = "Header_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 224
$Header_S1.Size = $System_Drawing_Size
$Header_S1.TabIndex = 0
$Header_S1.Text = "Willkommen beim PChelper"

$PChelper_Form_S1.Controls.Add($Header_S1)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $PChelper_Form_S1.WindowState
#Init the OnLoad event to correct the initial state of the form
$PChelper_Form_S1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$PChelper_Form_S1.ShowDialog()| Out-Null

} #End Function

########################################################################
# 
# SLIDE 2 (Zusatzfeatures zur Hauptfunktion)
# 
########################################################################

#Generated Form Function
function Slide2 {
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#Variablen für GUI-Objekte
$PChelper_Form_S2 = New-Object System.Windows.Forms.Form
$ExecuteBtn_S2 = New-Object System.Windows.Forms.Button
$CancelBtn_S2 = New-Object System.Windows.Forms.Button
$GrpBox_Acc_S2 = New-Object System.Windows.Forms.GroupBox
$UserBtn_S2 = New-Object System.Windows.Forms.Button
$TxtBox_PW_S2 = New-Object System.Windows.Forms.TextBox
$Label_PW_S1 = New-Object System.Windows.Forms.Label
$Label_Usrname_S1 = New-Object System.Windows.Forms.Label
$TxtBox_UsrName_S2 = New-Object System.Windows.Forms.TextBox
$GrpBox_TempDir_S2 = New-Object System.Windows.Forms.GroupBox
$TempBtn_S2 = New-Object System.Windows.Forms.Button
$Label_TempDir_Description_S2 = New-Object System.Windows.Forms.Label
$GrpBox_Rename_S2 = New-Object System.Windows.Forms.GroupBox
$UmbBtn_S2 = New-Object System.Windows.Forms.Button
$Label_Umben_Description_S2 = New-Object System.Windows.Forms.Label
$TxtBox_PCname_S2 = New-Object System.Windows.Forms.TextBox
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

#----------------------------------------------
cls
#----------------------------------------------

#Button LOKALEN ADMIN ERSTELLEN
$UserBtn_S2_Click= 
{
    $Username = $TxtBox_UsrName_S2.Text
    $UserPassword = $TxtBox_PW_S2.Text
    #Prüfen, ob Angaben vollständig sind
    if ((!$UserPassword) -or (!$Username)) {
            [System.Windows.Forms.MessageBox]::Show("Bitte vervollständigen Sie die Angaben betreffend Username und Passwort.","Angaben unvollständig",0, [System.Windows.Forms.MessageBoxIcon]::Exclamation) 
    }
    else {
        #Passwort in SecureString umwandeln, dass es nicht direkt ausgelesen werden könnte
        $UserPasswordSecured  = ConvertTo-SecureString "$UserPassword" -AsPlainText -Force
        #Prüfen, ob Benutzername bereits existiert
        if((Get-LocalUser $USERNAME -ErrorAction SilentlyContinue) -ne $null) {
            [System.Windows.Forms.MessageBox]::Show("Der User $Username existiert bereits! ","User existiert bereits",0, [System.Windows.Forms.MessageBoxIcon]::Exclamation)
        }
        #Erstellen des gewünschten Benutzers
        else {
            New-LocalUser "$Username" -Password $UserPasswordSecured -FullName "Admin $Username" 
            Add-LocalGroupMember -Group "Administratoren" -Member "$Username"
            $GrpBox_Acc_S2.Enabled = $False
        }
    }
}

#Button C:\TEMP-ORDNER
$TempBtn_S2_Click= 
{
    #Prüfen, ob Ordner bereits existiert
    if ((Test-Path C:\Temp -PathType Container) -or (Test-Path C:\temp -PathType Container)) {
        #Write-Warning "Already exists"
        [System.Windows.Forms.MessageBox]::Show("Der Ordner C:\Temp ist bereits existent!","Ordner existiert bereits",0, [System.Windows.Forms.MessageBoxIcon]::Exclamation)
    }
    #Erstellen des Ordners C:\Temp
    elseif (-not (Test-Path C:\Temp -PathType Container)) {
        New-Item -Path "c:\" -Name "Temp" -ItemType "directory"
    }
}

#Button SCRIPT BEENDEN (ERFOLGREICH)
$ExecuteBtn_S2_Click= 
{
    if ($global:restart -eq $True) {
        #Restart des PCs für neuen PC-Namen
        $result = [System.Windows.Forms.MessageBox]::Show("Sie haben Ihr Gerät umbenannt. Ein Neustart ist nötig, dass die Änderungen wirksam werden. Möchten Sie jetzt einen Neustart ausführen?", "Neustart ausstehend", "YesNo", "Information", "Button1")
        if ($result -eq "Yes") {
            $PChelper_Form_S2.close()
            Restart-Computer 
        } 
        else {
            $PChelper_Form_S2.close()  
        }
    } 
    else {
        $PChelper_Form_S2.close() 
    }
}

#Button SCRIPT ABBRECHEN
$CancelBtn_S2_Click= 
{
    #Abbrechen des Scripts
    $script:answer="Abbrechen"; 
    $PChelper_Form_S2.close()  
    Write-Warning "Sie haben die Anwendung beendet."
}

#Button PC UMBENNEN
$UmbBtn_S2_Click= 
{
    #Variable-Abfrage für PC-Namen
    $oldHostname = $env:COMPUTERNAME
    $newHostname = $TxtBox_PCname_S2.Text

    #Check, ob Variable nicht leer ist
    if (!$newHostname) {
        [System.Windows.Forms.MessageBox]::Show("Bitte geben Sie einen PC-Namen ein.","Angaben unvollständig",0, [System.Windows.Forms.MessageBoxIcon]::Exclamation) 
    }
    else {
        #Prüfen, ob der PC-Name nicht identisch wie bisher ist
        if ($newHostname -ne $oldHostname) {
            Rename-Computer -NewName "$newHostname" 
            [System.Windows.Forms.MessageBox]::Show("Der PC wurde umbenannt. Änderungen werden nach einem Neustart wirksam. Bitte starten Sie den PC nach Abschluss dieses Programms neu.","Neustart ausstehend!",0, [System.Windows.Forms.MessageBoxIcon]::Information) 
            $global:restart = $True
        }
        #Fehler, falls der PC-Name bereits so lautet
        else {
           [System.Windows.Forms.MessageBox]::Show("Der Hostname lautet bereits $oldHostname","Umbennenen fehlgeschlagen",0, [System.Windows.Forms.MessageBoxIcon]::Exclamation) 
           $global:restart = $False
        }
    }
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$PChelper_Form_S2.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 299
$System_Drawing_Size.Width = 330
$PChelper_Form_S2.ClientSize = $System_Drawing_Size
$PChelper_Form_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$PChelper_Form_S2.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSScriptRoot\Extras\PChelper-icon.ico")
$PChelper_Form_S2.Name = "PChelper_Form_S2"
$PChelper_Form_S2.Text = "PChelper"


$ExecuteBtn_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 235
$System_Drawing_Point.Y = 270
$ExecuteBtn_S2.Location = $System_Drawing_Point
$ExecuteBtn_S2.Name = "ExecuteBtn_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$ExecuteBtn_S2.Size = $System_Drawing_Size
$ExecuteBtn_S2.TabIndex = 3
$ExecuteBtn_S2.Text = "Abschliessen"
$ExecuteBtn_S2.UseVisualStyleBackColor = $True
$ExecuteBtn_S2.add_Click($ExecuteBtn_S2_Click)

$PChelper_Form_S2.Controls.Add($ExecuteBtn_S2)


$CancelBtn_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 147
$System_Drawing_Point.Y = 270
$CancelBtn_S2.Location = $System_Drawing_Point
$CancelBtn_S2.Name = "CancelBtn_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 82
$CancelBtn_S2.Size = $System_Drawing_Size
$CancelBtn_S2.TabIndex = 4
$CancelBtn_S2.Text = "Abbrechen"
$CancelBtn_S2.UseVisualStyleBackColor = $True
$CancelBtn_S2.add_Click($CancelBtn_S2_Click)

$PChelper_Form_S2.Controls.Add($CancelBtn_S2)


$GrpBox_Acc_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 184
$GrpBox_Acc_S2.Location = $System_Drawing_Point
$GrpBox_Acc_S2.Name = "GrpBox_Acc_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 74
$System_Drawing_Size.Width = 305
$GrpBox_Acc_S2.Size = $System_Drawing_Size
$GrpBox_Acc_S2.TabIndex = 2
$GrpBox_Acc_S2.TabStop = $False
$GrpBox_Acc_S2.Text = "Neuen lokalen Admin erstellen"

$PChelper_Form_S2.Controls.Add($GrpBox_Acc_S2)

$UserBtn_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 212
$System_Drawing_Point.Y = 43
$UserBtn_S2.Location = $System_Drawing_Point
$UserBtn_S2.Name = "UserBtn_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$UserBtn_S2.Size = $System_Drawing_Size
$UserBtn_S2.TabIndex = 5
$UserBtn_S2.Text = "Erstellen"
$UserBtn_S2.UseVisualStyleBackColor = $True
$UserBtn_S2.add_Click($UserBtn_S2_Click)

$GrpBox_Acc_S2.Controls.Add($UserBtn_S2)

$TxtBox_PW_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 85
$System_Drawing_Point.Y = 45
$TxtBox_PW_S2.Location = $System_Drawing_Point
$TxtBox_PW_S2.Name = "TxtBox_PW_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 122
$TxtBox_PW_S2.Size = $System_Drawing_Size
$TxtBox_PW_S2.TabIndex = 4
$TxtBox_PW_S2.Text = ""
$TxtBox_PW_S2.PasswordChar = '*'

$GrpBox_Acc_S2.Controls.Add($TxtBox_PW_S2)

$Label_PW_S1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 48
$Label_PW_S1.Location = $System_Drawing_Point
$Label_PW_S1.Name = "Label_PW_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 100
$Label_PW_S1.Size = $System_Drawing_Size
$Label_PW_S1.TabIndex = 3
$Label_PW_S1.Text = "Passwort:"

$GrpBox_Acc_S2.Controls.Add($Label_PW_S1)

$Label_Usrname_S1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 22
$Label_Usrname_S1.Location = $System_Drawing_Point
$Label_Usrname_S1.Name = "Label_Usrname_S1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 60
$Label_Usrname_S1.Size = $System_Drawing_Size
$Label_Usrname_S1.TabIndex = 2
$Label_Usrname_S1.Text = "Username:"

$GrpBox_Acc_S2.Controls.Add($Label_Usrname_S1)

$TxtBox_UsrName_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 85
$System_Drawing_Point.Y = 19
$TxtBox_UsrName_S2.Location = $System_Drawing_Point
$TxtBox_UsrName_S2.Name = "TxtBox_UsrName_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 122
$TxtBox_UsrName_S2.Size = $System_Drawing_Size
$TxtBox_UsrName_S2.TabIndex = 0
$TxtBox_UsrName_S2.add_TextChanged($handler_textBox2_TextChanged)

$GrpBox_Acc_S2.Controls.Add($TxtBox_UsrName_S2)



$GrpBox_TempDir_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 93
$GrpBox_TempDir_S2.Location = $System_Drawing_Point
$GrpBox_TempDir_S2.Name = "GrpBox_TempDir_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 79
$System_Drawing_Size.Width = 305
$GrpBox_TempDir_S2.Size = $System_Drawing_Size
$GrpBox_TempDir_S2.TabIndex = 1
$GrpBox_TempDir_S2.TabStop = $False
$GrpBox_TempDir_S2.Text = "C:\Temp erstellen"

$PChelper_Form_S2.Controls.Add($GrpBox_TempDir_S2)

$TempBtn_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 212
$System_Drawing_Point.Y = 48
$TempBtn_S2.Location = $System_Drawing_Point
$TempBtn_S2.Name = "TempBtn_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$TempBtn_S2.Size = $System_Drawing_Size
$TempBtn_S2.TabIndex = 1
$TempBtn_S2.Text = "Erstellen"
$TempBtn_S2.UseVisualStyleBackColor = $True
$TempBtn_S2.add_Click($TempBtn_S2_Click)

$GrpBox_TempDir_S2.Controls.Add($TempBtn_S2)

$Label_TempDir_Description_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 16
$Label_TempDir_Description_S2.Location = $System_Drawing_Point
$Label_TempDir_Description_S2.Name = "Label_TempDir_Description_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 43
$System_Drawing_Size.Width = 290
$Label_TempDir_Description_S2.Size = $System_Drawing_Size
$Label_TempDir_Description_S2.TabIndex = 0
$Label_TempDir_Description_S2.Text = "Sie können durch Knopfdruck auf Ihrem C:\ Laufwerk einen Ordner mit dem Namen Temp erstellen lassen."
$Label_TempDir_Description_S2.add_Click($handler_TempDir_Description_S2_Click)

$GrpBox_TempDir_S2.Controls.Add($Label_TempDir_Description_S2)



$GrpBox_Rename_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 9
$GrpBox_Rename_S2.Location = $System_Drawing_Point
$GrpBox_Rename_S2.Name = "GrpBox_Rename_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 69
$System_Drawing_Size.Width = 305
$GrpBox_Rename_S2.Size = $System_Drawing_Size
$GrpBox_Rename_S2.TabIndex = 0
$GrpBox_Rename_S2.TabStop = $False
$GrpBox_Rename_S2.Text = "PC umbenennen"

$PChelper_Form_S2.Controls.Add($GrpBox_Rename_S2)

$UmbBtn_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 212
$System_Drawing_Point.Y = 36
$UmbBtn_S2.Location = $System_Drawing_Point
$UmbBtn_S2.Name = "UmbBtn_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 86
$UmbBtn_S2.Size = $System_Drawing_Size
$UmbBtn_S2.TabIndex = 2
$UmbBtn_S2.Text = "Umbenennen"
$UmbBtn_S2.UseVisualStyleBackColor = $True
$UmbBtn_S2.add_Click($UmbBtn_S2_Click)

$GrpBox_Rename_S2.Controls.Add($UmbBtn_S2)

$Label_Umben_Description_S2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 16
$Label_Umben_Description_S2.Location = $System_Drawing_Point
$Label_Umben_Description_S2.Name = "Label_Umben_Description_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 193
$Label_Umben_Description_S2.Size = $System_Drawing_Size
$Label_Umben_Description_S2.TabIndex = 1
$Label_Umben_Description_S2.Text = "Geben Sie den neuen PC-Namen ein."

$GrpBox_Rename_S2.Controls.Add($Label_Umben_Description_S2)

$TxtBox_PCname_S2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 8
$System_Drawing_Point.Y = 38
$TxtBox_PCname_S2.Location = $System_Drawing_Point
$TxtBox_PCname_S2.Name = "TxtBox_PCname_S2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 200
$TxtBox_PCname_S2.Size = $System_Drawing_Size
$TxtBox_PCname_S2.TabIndex = 0
$TxtBox_PCname_S2.Text = ""

$GrpBox_Rename_S2.Controls.Add($TxtBox_PCname_S2)


#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $PChelper_Form_S2.WindowState
#Init the OnLoad event to correct the initial state of the form
$PChelper_Form_S2.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$PChelper_Form_S2.ShowDialog()| Out-Null

} #End Function

#Aufrufen des ersten GUIs
Slide1

#Aufrufen des zweiten GUIs
if ($script:answer -eq "Installieren") {
    Slide2
}
