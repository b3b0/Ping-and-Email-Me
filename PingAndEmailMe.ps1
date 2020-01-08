# The Unlicense
# January 2020
# b3b0
# https://github.com/b3b0/checkPatch

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"
function emailMe($aliveComputer) 
{
    $eventime = Get-Date
    $EmailFrom = "ComputerIsAlive@yourdomain.com"
    $EmailTo = "you@yourdomain.com"
    $Subject ="$aliveComputer is pingable RIGHT NOW!"
    $Body = "We thought we lost him forever!"
    $SMTPServer = "yoursmtpserverorrleay.yourdomain.com"
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 25)
    #$SMTPClient.EnableSsl = $false or $true 
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

$running = 1

while ($running -eq 1)
{
    Write-Host "Starting up!" -ForegroundColor Yellow
    foreach ($server in (Get-Content C:\path\to\your\PingAndEmailMeList.txt))
    {
        Write-Host "Trying $server"
        if (Test-Connection -Quiet -ComputerName $server -Count 3)
        {
            $truly = 0
            Write-Host "$server is ALIVE from a network perspective! Checking further!" -ForegroundColor Green
            if (Invoke-Command -ComputerName $server -ScriptBlock { Get-ChildItem })
            {
                Write-Host "$server is truly alive!" -ForegroundColor Magenta
                emailMe $server
                $truly = 1
            }
            if ($truly -eq 0) 
            {
                Write-Host "False positive. DNS anomaly. Moving on." -ForegroundColor Red
            }
        }

        if (-not(Test-Connection -Quiet -ComputerName $server -Count 3))
        {
            Write-Host "$server is DEAD" -ForegroundColor Red
        }
    }
    Write-Host ""
    Write-Host "Waiting 10 minutes to try again. Goodnight." -ForegroundColor Blue
    Write-Host "zzZzzZzzZzzZzzZzzZzzZzzZzzZzzZzzZzzZzzZzzZ" -ForegroundColor Blue
    Write-Host ""
    Get-Date
    Write-Host ""
    Start-Sleep -Seconds 600
}
