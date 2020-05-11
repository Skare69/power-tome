<#
 .SYNOPSIS
  Backup script

.DESCRIPTION
  Backup files which are not backed up automatically. 

.INPUTS
  None

.OUTPUTS
  None
 #>

[cmdletbinding()]
Param()

$backupTarget = "Q:\backup\"
$BackupSources = @(
	"U:\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
	"~/.aws"
	"~/.m2/*.xml"
	"$Env:APPDATA/Microsoft/Signatures"
	"$Env:APPDATA/gnupg"
	"$Env:APPDATA/keepass"
	"$Env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup"
	"~/.ssh"
	"~/.npmrc"
	"$Env:APPDATA/Microsoft/Internet Explorer/Quick Launch/User Pinned/TaskBar"
	"$Env:LOCALAPPDATA/Google\Chrome\User Data\Default"
)
if ( -Not (Get-Item $backupTarget)) {
	mkdir -Path $backupTarget -Force 1> $null
}
$BackupSources | ForEach-Object {
	Write-Verbose "Processing $_"
	$directoryPath = ""
	Get-Item $_ | ForEach-Object {
		if ($_ -is [System.IO.DirectoryInfo]) {
			$directoryPath = Split-Path -Path $_ -NoQualifier
		}
		else {
			$directoryPath = Split-Path -Path $_ -NoQualifier -Resolve | Split-Path -Parent
		}
		$qualifierPath = (Split-Path -Path $_ -Qualifier).Substring(0,1)
		$targetPath = $($backupTarget + $qualifierPath + $directoryPath)
		mkdir -Path $targetPath -Force 1> $null
		if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
			Xcopy $_ $targetPath /v /d /s /i /h /y /exclude:U:\Scripts\backup\exclude.txt
		}
		else {
			Xcopy $_ $targetPath /v /d /s /i /h /y /q /c /exclude:U:\Scripts\backup\exclude.txt 1> $null
		}
	}
}
