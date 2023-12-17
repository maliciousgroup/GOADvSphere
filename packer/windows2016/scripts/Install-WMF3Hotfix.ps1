#Requires -Version 3.0
[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"
if ($verbose) {
    $VerbosePreference = "Continue"
}

Function Run-Process($executable, $arguments) {
    $process = New-Object -TypeName System.Diagnostics.Process
    $psi = $process.StartInfo
    $psi.FileName = $executable
    $psi.Arguments = $arguments
    Write-Verbose -Message "starting new process '$executable $arguments'"
    $process.Start() | Out-Null

    $process.WaitForExit() | Out-Null
    $exit_code = $process.ExitCode
    Write-Verbose -Message "process completed with exit code '$exit_code'"

    return $exit_code
}

Function Download-File($url, $path) {
    Write-Verbose -Message "downloading url '$url' to '$path'"
    $client = New-Object -TypeName System.Net.WebClient
    $client.DownloadFile($url, $path)
}

Function Extract-Zip($zip, $dest) {
    Write-Verbose -Message "extracting '$zip' to '$dest'"
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem > $null
        $legacy = $false
    } catch {
        $legacy = $true
    }

    if ($legacy) {
        $shell = New-Object -ComObject Shell.Application
        $zip_src = $shell.NameSpace($zip)
        $zip_dest = $shell.NameSpace($dest)
        $zip_dest.CopyHere($zip_src.Items(), 1044)
    } else {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
    }
}

$tmp_dir = $env:temp
$kb = "KB2842230"
if ($PSVersionTable.PSVersion.Major -ne 3) {
    Write-Verbose -Message "$kb is only applicable with Powershell v3, no action required"
    exit 0
}

$hotfix_installed = Get-Hotfix -Id $kb -ErrorAction SilentlyContinue
if ($hotfix_installed -ne $null) {
    Write-Verbose -Message "$kb is already installed"
    exit 0
}

if (-not (Test-Path -Path $tmp_dir)) {
    New-Item -Path $tmp_dir -ItemType Directory > $null
}
$os_version = [Version](Get-Item -Path "$env:SystemRoot\System32\kernel32.dll").VersionInfo.ProductVersion
$host_string = "$($os_version.Major).$($os_version.Minor)-$($env:PROCESSOR_ARCHITECTURE)"
switch($host_string) {
    # These URLS point to the Ansible Core CI S3 bucket, MS no longer provide a link to Server 2008 so we need to
    # rely on this URL. There are no guarantees this will stay up in the future.
    "6.0-x86" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/464091_intl_i386_zip.exe"
    }
    "6.0-AMD64" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/464090_intl_x64_zip.exe"
    }
    "6.1-x86" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/463983_intl_i386_zip.exe"
    }
    "6.1-AMD64" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/463984_intl_x64_zip.exe"
    }
    "6.2-x86" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/463940_intl_i386_zip.exe"
    }
    "6.2-AMD64" {
        $url = "https://s3.amazonaws.com/ansible-ci-files/hotfixes/KB2842230/463941_intl_x64_zip.exe"
    }
}

$filename = $url.Split("/")[-1]
$compressed_file = "$tmp_dir\$($filename).zip"
Download-File -url $url -path $compressed_file
Extract-Zip -zip $compressed_file -dest $tmp_dir
$file = Get-Item -Path "$tmp_dir\*$kb*.msu"
if ($file -eq $null) {
    Write-Error -Message "unable to find extracted msu file for hotfix KB"
    exit 1
}

$exit_code = Run-Process -executable $file.FullName -arguments "/quiet /norestart"
if ($exit_code -eq 3010) {
    Write-Verbose "need to restart computer after hotfix $kb install"
    Restart-Computer -Confirm
} elseif ($exit_code -ne 0) {
    Write-Error -Message "failed to install hotfix $($kb): exit code $exit_code"
} else {
    Write-Verbose -Message "hotfix $kb install complete"
}
exit $exit_code