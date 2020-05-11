<#
 .SYNOPSIS
  Register a new task for the backup script.

.DESCRIPTION
  Registers a new task in the Windows task scheduler to run the backup script every day at 10:15. If the task already exists it is unregistered first. 

.INPUTS
  None

.OUTPUTS
  None
 #>

$Trigger = New-ScheduledTaskTrigger -Daily -At 10:15
#$Trigger = New-JobTrigger -Daily -At 10:15
$Action = New-ScheduledTaskAction -WorkingDirectory $Env:TEMP `
	-Execute "powershell"`
	-Argument "-File U:\Scripts\backup\backup.ps1"
$Configuration = New-ScheduledTaskSettingsSet -WakeToRun
#$Option = New-ScheduledJobOption -WakeToRun

if (Get-ScheduledTask -TaskName Backup -TaskPath '\PS\' -ErrorAction SilentlyContinue) {
	Unregister-ScheduledTask -TaskName Backup -TaskPath '\PS\'
}
Register-ScheduledTask -TaskName Backup -TaskPath "\PS" -Action $Action -Settings $Configuration -Trigger $Trigger
#Register-ScheduledJob -FilePath "U:\Scripts\backup\backup.ps1" -Name "Backup" -Trigger $Trigger -ScheduledJobOption $Option

# Do a test run
Start-ScheduledTask -Taskname Backup -TaskPath PS
