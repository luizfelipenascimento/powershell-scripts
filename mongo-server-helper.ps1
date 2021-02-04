

$arg = $args[0]

$interfaces = Get-NetAdapter * -Physical
$hostip = Get-NetIPAddress -InterfaceIndex $interfaces[0].ifIndex -AddressFamily IPv4

$mongoDbServerPath = 'D:\mongodb-4.4.3\bin\mongod.exe'
$dataPath = 'D:\mongo-data'

function printHelper() {
    $helpContent = @"
mongodb server helper - Help Info:

This is a simple script to help start and finishes mongodb server process

Commands

  start: start mongodb-server process
  stop: stop mongodb-server process
    
  -help: prints all possible arguments to script

"@ 

    Write-Host $helpContent
}


function startDB {
    $process = Get-Process -Name mongod -ErrorAction SilentlyContinue
    if (!$process) {
        Write-Host 'Starting mongodb-server'
        $arguments = '--dbpath='+ $dataPath + ' --bind_ip ' + $hostip.IPAddress
        Start-Process -FilePath $mongoDbServerPath -ArgumentList $arguments
        Write-Host 'Server started!' -ForegroundColor Green
    } else {
        Write-Host 'The mongodb-service is already running' -ForegroundColor Red
    }
}

function stopDB() {
    $process = Get-Process -Name mongod -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host 'Stoping mongodb-server...'
        Stop-Process -Id $process.Id
        Write-Host 'Process stoped' -ForegroundColor Green
    } 
    else { 
        Write-Warning 'mongodb is not running at the momment'
    }
}


if (!$arg) {
    Write-Host 'You need to provide an argument!' -ForegroundColor Red
    Write-Host
    printHelper
    return
}
elseif ($arg -eq 'start') {
    startDB   
}
elseif ($arg -eq 'stop') {
    stopDB
}
elseif ($arg -eq '-help') {
    printHelper
}
else {
    Write-Host 'You need to provide a valid argument!' -ForegroundColor Red
    Write-Host
    printHelper
}

