$filePath = "C:\Users\rashikasahu\OneDrive - Nagarro\Desktop\devOps\blackbaud asg\files\apache-logs.log"

# Check if file exist or not
if(-not (Test-Path $filePath -PathType Leaf)){
    Write-Host "File name you entered does not exist, please enter correct file name"
    return
}

# initializing required variables
$no_of_req = 0
$url_count = @{}
$response_codes = @{}

# fetching timestamp, url, response code
Get-Content $filePath | ForEach-Object{
    $url = [regex]::Match($_, '(GET|PROPFIND) [^"]+ HTTP/1\.[01]').value
    $response_code = [regex]::Match($_, '\s(\d{3})\s').Groups[1].Value     
    $timestamp = [regex]::Match($_, '[0-9]{2}:[0-9]{2}:[0-9]{2}').value

    if($timestamp -ne ''){
        ++$no_of_req
    } 
    if ($url -ne ''){
        $url = $url -replace '\[', '' -replace '\]', ''
        if($url_count.ContainsKey($url)){
            $url_count[$url]++    
        } else {
            $url_count[$url]=1
        }
    }
    if ($response_code -ne ''){
        if($response_codes.ContainsKey($response_code)) {
            $response_codes[$response_code]++
        } else {
            $response_codes[$response_code]=1
        }
    }
}

# creating variable that contains all the information
$data = @(
    [PSCustomObject]@{
        "Property" = "Total no of request"
        "Value" = $no_of_req
    },
    [PSCustomObject]@{
        "Property" = "Accessed URLs"
        "Value" = ($url_count.GetEnumerator() | ForEach-Object {
                    "URL: $($_.Key), Hit-Count: $($_.Value)"
                }) -join "`n`r`n"
    },
    [PSCustomObject]@{
        "Property" = "Response Codes"
        "Value"    = ($response_codes.GetEnumerator() | ForEach-Object {
                        "Response Code: $($_.Key), Count: $($_.Value)"
                   }) -join "`n`r`n"
     }
)

# creating file that contains all information
$reportPath = "C:\Users\rashikasahu\OneDrive - Nagarro\Desktop\devOps\blackbaud asg\Report.csv"
$data | Export-Csv -Path $reportPath -NoTypeInformation
Write-Host "Report generated at: $reportPath"


