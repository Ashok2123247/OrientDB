<#
    Database health check report (Services, DB, Disk)
    Version : 1.0
    Author : Ashok Sagar Bazar
    Environment : Windows 2008R2
    Browser compatability: Chrome, Fireforx
    Powershell Version : 3.0
    Dfefault output path : C:\Temp

#>

Clear-host
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
$DBNode = @()
Write-Host "Enter Instance names by using comma separator or input text file with multiple Instance details." -ForegroundColor yellow
Write-host "Output file should be under c:\Temp\ folder" -ForegroundColor Yellow
$DBNode = Read-host "Enter Instance list or input txt file path"
If($DBNode -like "*.txt"){
$DBNode = Get-Content $DBNode}
else{$DBNode = $DBNode.Split(',').Split(' ')}
#$DBNode
$ErrorActionPreference = "Stop"
$start = (get-date -DisplayHint DateTime).DateTime
$Counting = 0
$pathDir = "C:\temp\"
$filedate = (Get-Date).tostring(“ddMMyyyy-hhmmss”)
$filename= $pathDir + 'HealthCheck_Report_' + $filedate + '.html'
$OldInstanceName = " "
Remove-Item –path $pathDir* -include HealthCheck_Report*.html -ErrorAction Ignore

###################################################
## HTML Script Block
###################################################
$a = @'
<style>body{background-color:#566573;}
.container{	width:90%; margin:auto; margin-top: 15px;background-color:#F8F9F9;overflow:hidden; box-shadow: 10px 10px }
.headerbox {width:auto%; padding-left:10px;padding-right:10px;padding-top:5px;padding-bottom:0px; }
.p.a{font:0.4em/145% Segoe UI;font-style: oblique;}
.TABLE1{width:auto%;font:0.7em/145% Segoe UI,helvetica,Segoe UI,Segoe UI;}
.headerbox.h1{font-family:Castellar;padding-bottom:0px}
.datacon{color:#17202A;width:auto%;background-color :#B2BABB;padding:20px;}
.databox {color:#17202A;width:auto%;background-color :#B2BABB;}
.databox.h3{color:#17202A;font-family :Castellar;line-height: normal; }
TABLE{width:100%;border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;font:0.6em/145% Segoe UI,helvetica,Segoe UI,Segoe UI;}
TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#778899}
TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
tr:nth-child(odd) { background-color:#F2F2F2;}
tr:nth-child(even) { background-color:#DDDDDD;}
.footer{width:auto%; padding:10px;text-align:right;font:0.6em/145% Segoe UI;line-height: normal;font-style: oblique;line-height: 1;}
</style>
'@
$ColorFilter = @{
                    Running = ' style="color:Green">Running<';
                    Stopped = ' style="color:RED">Stopped<';
                    ONLINE = ' style="color:Green">ONLINE<';
                    OFFLINE = ' style="color:RED">OFFLINE<';
                    NOTHEALTHY = ' style="color:RED">NOTHEALTHY<';
                    HEALTHY = ' style="color:Green">HEALTHY<';
                    RESTORING = ' style="color:magenta">RESTORING<';
                    CRITICAL  = ' style="color:RED">CRITICAL<'; 
                    WARNING   = ' style="color:ORANGE">WARNING<';              
                }
$a =  $a + '<div class="container"> <div class ="headerbox"><h1>Health Check Report</h1><div class = "table1">Date: ' + $start + ' || Version : 2.0  || </div> 
<div class = "table1"><p style="color:red">Critical < 10% [Disk space is less than 10%]</p><p style="color:Magenta;">Warning < 20% [Disk space is less than 20%]</p><p style="color:green;">Heatlthy < 30 % [Disk space is less than 30%]</p></div></div>'| Out-File -append $filename
$a =  $a + '<div class = "datacon">' | Out-File -append $filename
## SQL Query Block  
################################################### 
$SQLQuery = "select @@Servername as ServerName,name as DBName,database_id,compatibility_level,
page_verify_option_desc,log_reuse_wait_desc,state_desc as DB_Status
from sys.databases"

$backupquery="select @@servername as Hostname, bs.Database_name, 
		CAST(bs.compressed_backup_size/1024/1024 as decimal(10,2)) as Compressedsize_MB, 
		bs.Backup_start_date, 
		bs.Backup_finish_date,
		DATEDIFF(MINUTE,bs.backup_start_date,bs.backup_finish_date) as DurationMin,
		bf.Physical_device_name
from msdb.dbo.backupset bs join msdb.dbo.backupmediafamily bf 
on bs.media_set_id = bf.media_set_id 
where type='D' and bs.backup_start_date 
BETWEEN DATEADD(hh, -72, GETDATE()) and getdate()
and bs.database_name not in ('master', 'msdb', 'model', 'sqladmin')
order by bs.database_name"

$InstanceInfo ="SELECT 
	--CAST( SERVERPROPERTY('MachineName') AS NVARCHAR(128)) AS [MachineName],
	CAST( SERVERPROPERTY('ServerName')AS NVARCHAR(128)) AS [ServerName],
	CAST( SERVERPROPERTY('IsClustered') AS NVARCHAR(128)) AS [IsClustered],
	serverproperty('edition') as [Edition],
	serverproperty('productlevel') as [Servicepack],
	SERVERPROPERTY('Productversion') AS [ProductVersion],	
	(SELECT value_in_use FROM sys.configurations WHERE name like '%max server memory%') as AssignedRAM_MB,
	(SELECT physical_memory_in_use_kb/1024 FROM sys.dm_os_process_memory) as SQLMemoryInUse_MB,
	(SELECT available_physical_memory_kb/1024 FROM sys.dm_os_sys_memory)as FreeRAM_MB,
	(select memory_utilization_percentage from sys.dm_os_process_memory) as RAM_UsagePCT,	
	(
		SELECT (SUM(mf.size) * 8 / 1024/1024) 
		FROM sys.master_files mf 
		INNER JOIN sys.databases d ON d.database_id = mf.database_id 
		WHERE d.database_id > 4 
	) as DBs_SUM_GB,				
	(
		select count(name)	
		from sys.databases 
		where name not in ('master','tempdb', 'msdb','model','sqladmin','distribution')
	)as UserDBCount,				
	(select cpu_count from sys.dm_os_sys_info)as CPUCount,			
	(SELECT total_physical_memory_kb/1024 FROM sys.dm_os_sys_memory) as PhysicalRAM_MB,
	(SELECT sqlserver_start_time AS SqlServerStartTime FROM sys.dm_os_sys_info) as SQLLastRestart"

## Looping start
###################################################
foreach($InsNames in $DBNode)
{
asnp SqlServer* -ea 0 ## Snapin SQL
$Counting = $Counting + 1
$InsNames1 = $InsNames
Write-Progress -Activity "$Counting..$InsNames ... in progress.." -percentComplete (($Counting) / ($DBNode.Count) * 100)
    ## Try block Begin
    try
    {
            ## Split ServerName and InstanceNames
            $Instance = $InsNames.Split("\")
            $ServerName = $Instance[0]

            ##instance info
            [string[]]$insinfo = Invoke-Sqlcmd -ServerInstance $InsNames1 -Query $InstanceInfo -TrustServerCertificate |`
            Select-Object ServerName,IsClustered,Edition,Servicepack,ProductVersion,AssignedRAM_MB,SQLMemoryInUse_MB,FreeRAM_MB,RAM_UsagePCT,DBs_SUM_GB,UserDBCount,CPUCount,PhysicalRAM_MB,SQLLastRestart|`
            ConvertTo-HTML -head $a -body "<h5>SQL Server Information</h5>" |out-string
            $ColorFilter.Keys | foreach { $insinfo = $insinfo -replace ">$_<",($ColorFilter.$_) }
            $insinfo | Out-File -append $filename
                 
            if ($OldInstanceName -ne $ServerName)
            { ## IF Begin            
            ## SQL Services information
            [string[]]$html3 = get-service -computerName $ServerName  |` 
            where-object {$_.Name -like "MSSQL$*" -or $_.Name -like "SQLAgent$*" -or $_.name -like "SQLBrowser" -or $_.DisplayName -like "*Full-text*" -or $_.name -like "MSSQLSERVER" -or $_.name -like "SQLSERVERAGENT" } |`
            Select-Object Name,DisplayName,Status | Sort-Object Name| ConvertTo-HTML -head $a -body "<h5>SQL Services $ServerName </h5>" | out-string
            $ColorFilter.Keys | foreach { $html3 = $html3 -replace ">$_<",($ColorFilter.$_) }
            $html3 | Out-File -append $filename
            ## Disk Information
            [string[]]$htmlDisk = Get-WmiObject -computername $ServerName -query "select SystemName, DriveType, FileSystem, FreeSpace, Capacity, Label
		    from Win32_Volume where DriveType = 2 or DriveType = 3" | ForEach { New-Object PSObject -Property @{
            SystemName = $_.systemName
            LABEL = $_.Label
            SIZEInGB = ([Math]::Round($_.Capacity/1GB,2))
            UsedSizeInGB = ([Math]::Round($_.Capacity/1GB - $_.FreeSpace/1GB,2))
            FREESizeInGB = ([Math]::Round($_.FreeSpace/1GB,2))
            UsedPercentage =  ([Math]::Round(($_.Capacity/1GB - $_.FreeSpace/1GB)/($_.Capacity/1GB) * 100,2))
            FreePercentage = ([Math]::Round(($_.freespace/1GB)/ ($_.Capacity/1GB) * 100,2))
            DiskStatus = if(([Math]::Round(($_.freespace/1GB)/ ($_.Capacity/1GB) * 100)) -lt 20){'NOTHEALTHY' }else {'HEALTHY'}
            }}|Select-Object SystemName,LABEL,SIZEInGB,UsedSizeInGB,FREESizeInGB,UsedPercentage,FreePercentage,DiskStatus |`
            ConvertTo-HTML -head $a -body "<H5>Disk Management $ServerName </H5>" |out-string
            $ColorFilter.Keys | foreach { $htmlDisk = $htmlDisk -replace ">$_<",($ColorFilter.$_) }
            $htmlDisk | Out-File -append $filename
            $OldInstanceName = $ServerName
            } ## If ends

            ## Database Information
            [string[]]$html = Invoke-Sqlcmd -ServerInstance $InsNames1 -Query $SQLQuery -TrustServerCertificate|`
            Select-Object ServerName,DBName,database_id,compatibility_level,page_verify_option_desc,log_reuse_wait_desc,DB_Status|`
            ConvertTo-HTML -head $a -body "<h5>Database Status $InsNames1 </h5>" |out-string
            $ColorFilter.Keys | foreach { $html = $html -replace ">$_<",($ColorFilter.$_) }
            $html | Out-File -append $filename


             ##backup information
            [string[]]$backupinfo = Invoke-Sqlcmd -ServerInstance $InsNames1 -Query $backupquery -TrustServerCertificate |`
            Select-Object Hostname, Database_name, Compressedsize_MB,Backup_start_date,Backup_finish_date,DurationMin,Physical_device_name|`
            ConvertTo-HTML -head $a -body "<h5>Backkup Info last 3 Days $InsNames1 </h5>" |out-string
            $ColorFilter.Keys | foreach { $backupinfo = $backupinfo -replace ">$_<",($ColorFilter.$_) }
            $backupinfo | Out-File -append $filename

            ## Log file usage
            [string[]]$logsize = Invoke-Sqlcmd -ServerInstance $InsNames1 -Query "dbcc sqlperf(logspace)" -TrustServerCertificate |`
            Select-Object @{Name='DatabaseName'; Expression={ $_.'Database Name' }}, @{Name='LogSize_MB'; Expression={ [math]::Round($_.'Log Size (MB)', 2) }}, `
            @{Name='LogSpaceUsed_%'; Expression={ [math]::Round($_.'Log Space Used (%)', 2) }}, `
            @{Name='Status'; Expression={
            $usage = [math]::Round($_.'Log Space Used (%)', 2)
            if ($usage -ge 90) {
            "CRITICAL"
            } elseif ($usage -ge 80) {
            "WARNING"
            } elseif ($usage -lt 70) {
            "HEALTHY"
            } else {
            "HEALTHY"
            }
            }}|ConvertTo-HTML -head $a -body "<h5>Log Space % $InsNames1 </h5>" |out-string
            $ColorFilter.Keys | foreach { $logsize = $logsize -replace ">$_<",($ColorFilter.$_) }
            $logsize | Out-File -append $filename


            }## Try block End
            
            ## Catch block Begin
            catch 
                { write-host "PING [NOT OK]" $InsNames1 -ForegroundColor Magenta }
} ## Looping End
### counting Number of Instances
$End = get-date
write-host "EndTime: "  $End
Write-host "Duration_Seconds :" (NEW-TIMESPAN –Start $start –End $End).Seconds
Write-host "Number of Instances :" $Counting
remove-variable Counting
remove-variable OldInstanceName
remove-variable start
remove-variable filename
remove-variable pathDir
remove-variable SqlQuery







