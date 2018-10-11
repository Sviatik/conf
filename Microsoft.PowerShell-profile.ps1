$ENV:PATH="$ENV:PATH;C:\Program Files\Git\bin"
Set-Alias subl "C:\Program Files\Sublime Text 3\sublime_text.exe"


Import-Module 'C:\Users\sviatoslav.stetsiak\Documents\WindowsPowerShell\Modules\posh-git\src\posh-git.psd1'

Set-Alias ssh-agent "C:\Program Files\Git\usr\bin\ssh-agent.exe"
Set-Alias ssh-add "C:\Program Files\Git\usr\bin\ssh-add.exe"

. C:\Users\sviatoslav.stetsiak\Documents\WindowsPowerShell\run_ssh.ps1
ssh-add C:\Users\sviatoslav.stetsiak\.ssh\eleks_id_rsa.pem

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
$ENV:PATH="$ENV:PATH;C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin"
$ENV:PATH="$ENV:PATH;C:\bin"


# Next block copy from here https://github.com/felixrieseberg/windows-development-environment

# Increase history
$MaximumHistoryCount = 32767

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Helper Functions
#######################################################

function uptime {
    Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
    EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
    & $profile
}

function find-file($name) {
    ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
        $place_path = $_.directory
        echo "${place_path}\${_}"
    }
}

function print-path {
    ($Env:Path).Split(";")
}

function unzip ($file) {
    $dirname = (Get-Item $file).Basename
    echo("Extracting", $file, "to", $dirname)
    New-Item -Force -ItemType directory -Path $dirname
    expand-archive $file -OutputPath $dirname -ShowProgress
}


# Unixlike commands
#######################################################

function df {
    get-volume
}

function sed($file, $find, $replace){
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function sed-recursive($filePattern, $find, $replace) {
    $files = ls . "$filePattern" -rec
    foreach ($file in $files) {
        (Get-Content $file.PSPath) |
        Foreach-Object { $_ -replace "$find", "$replace" } |
        Set-Content $file.PSPath
    }
}

function grep($regex, $dir) {
    if ( $dir ) {
        ls $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function grepv($regex) {
    $input | ? { !$_.Contains($regex) }
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
    ps $name
}

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

function sudo {
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";
    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi) >> $null
}

# https://gist.github.com/aroben/5542538
function pstree {
    $ProcessesById = @{}
    foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
        $ProcessesById[$Process.ProcessId] = $Process
    }

    $ProcessesWithoutParents = @()
    $ProcessesByParent = @{}
    foreach ($Pair in $ProcessesById.GetEnumerator()) {
        $Process = $Pair.Value

        if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
            $ProcessesWithoutParents += $Process
            continue
        }

        if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
            $ProcessesByParent[$Process.ParentProcessId] = @()
        }
        $Siblings = $ProcessesByParent[$Process.ParentProcessId]
        $Siblings += $Process
        $ProcessesByParent[$Process.ParentProcessId] = $Siblings
    }

    function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
        $Process = $ProcessesById[$ProcessId]
        $Indent = " " * $IndentLevel
        if ($Process.CommandLine) {
            $Description = $Process.CommandLine
        } else {
            $Description = $Process.Caption
        }

        Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
        foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
            Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
        }
    }

    Write-Output ("{0,6} {1}" -f "PID", "Command Line")
    Write-Output ("{0,6} {1}" -f "---", "------------")

    foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
        Show-ProcessTree $Process.ProcessId 0
    }
}


set-PSReadlineOption -TokenKind String -ForegroundColor Cyan




































####################

# $Shell = $Host.UI.RawUI
# # # $size = $Shell.WindowSize
# # # $size.width=70
# # # $size.height=25
# # # $Shell.WindowSize = $size
# # # $size = $Shell.BufferSize
# # # $size.width=70
# # # $size.height=5000
# # # $Shell.BufferSize = $size
# $shell.BackgroundColor = "Gray"
# $shell.ForegroundColor = "Black"

# clear



# $Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'Darkgreen')
# $Host.UI.RawUI.ForegroundColor = 'White'
# $Host.PrivateData.ErrorForegroundColor = 'Red'
# $Host.PrivateData.ErrorBackgroundColor = $bckgrnd
# $Host.PrivateData.WarningForegroundColor = 'Magenta'
# $Host.PrivateData.WarningBackgroundColor = $bckgrnd
# $Host.PrivateData.DebugForegroundColor = 'Yellow'
# $Host.PrivateData.DebugBackgroundColor = $bckgrnd
# $Host.PrivateData.VerboseForegroundColor = 'Green'
# $Host.PrivateData.VerboseBackgroundColor = $bckgrnd
# $Host.PrivateData.ProgressForegroundColor = 'Cyan'
# $Host.PrivateData.ProgressBackgroundColor = $bckgrnd
# Clear-Host
