$filePath = "C:\Users\rashikasahu\OneDrive - Nagarro\Desktop\devOps\blackbaud asg\files\apache-logs.log"

# Check if file exist or not
if(-not (Test-Path $filePath -PathType Leaf)){
    Write-Host "File name you entered does not exist, please enter correct file name"
    return
}

# fetching the required information & displaying
Get-Content $filePath | ForEach-Object{
    $ip = [regex]::Match($_, '([0-9,x]{1,3}\.){3}[0-9,x]{1,3}').value
    $url = [regex]::Match($_, '(GET|PROPFIND) [^"]+ HTTP/1\.[01]').value
    $timestamp = [regex]::Match($_, '\[[0-9]{2}/[A-Za-z]{3}/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2} -[0-9]{4}\]').value
    $responseCode = [regex]::Match($_, '(401|200|404|201|500|403) | head -n1').value

    $output = ""
    if ($ip -ne '') {
        $output += "IP Address: $ip, "
    }
    if ($url -ne '') {
        $output += "URL: $url, "
    }
    if ($timestamp -ne '') {
        $output += "Timestamp: $timestamp, "
    }
    if ($responseCode -ne '') {
        $output += "Response Code: $responseCode "
    }

    if($output -ne ''){
        Write-Host $output
    }
}