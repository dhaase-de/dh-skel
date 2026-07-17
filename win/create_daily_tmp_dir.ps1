# creates ~/tmp/YYYY-MM-DD for the current date
#
# To run this script automatically on the first unlock each day use
# Windows Task Scheduler (German: "Aufgabenplanung"):
#   1) Open Task Scheduler:
#      - Win+R -> taskschd.msc
#   2) Click "Create Task..." (not "Create Basic Task...")
#   3) "General" tab:
#      - Name: "Create daily tmp dir"
#      - Select: "Run only when user is logged on"
#      - (Optional) Check "Hidden"
#   4) "Triggers" tab -> "New...":
#      - Begin the task: "On workstation unlock"
#      - (Optional) Choose "Specific user": your user
#      - Ensure "Enabled" is checked
#   5) "Actions" tab -> "New...":
#      - Action: "Start a program"
#      - Program/script: powershell.exe
#      - Add arguments:
#          -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\create_daily_tmp_dir.ps1"
#   6) "Conditions" tab (recommended):
#      - Uncheck "Start the task only if the computer is on AC power" (laptops)
#   7) "Settings" tab:
#      - "If the task is already running": "Do not start a new instance"
#   8) Click OK / Save. Test: right-click the task -> "Run".

$user_base_path = $env:USERPROFILE
$tmp_base_path = Join-Path $user_base_path "tmp"
$today_str = Get-Date -Format "yyyy-MM-dd"
$target_path = Join-Path $tmp_base_path $today_str

New-Item -ItemType Directory -Path $target_path -Force | Out-Null
Write-Output $target_path