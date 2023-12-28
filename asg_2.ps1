$filePath = "C:\Users\rashikasahu\OneDrive - Nagarro\Desktop\devOps\blackbaud asg\files\apache-logs.log"

# Check if file exist or not
if(-not (Test-Path $filePath -PathType Leaf)){
    Write-Host "File name you entered does not exist, please enter correct file name"
    return
}

# taking time as user input
Write-Host "Enter time in 24-hr format (e.g., '15:00:00')"
$start_time = Read-Host "Enter the start time"
$end_time = Read-Host "Enter the end time"

# coverting the user input into time format
$start_time = Get-Date $start_time -Format "HH:mm:ss"
$end_time = Get-Date $end_time -Format "HH:mm:ss"

#checking if startime is greater than endtime
if ($start_time -gt $end_time) {
    Write-Host "Start time cannot be greater than end time."
    return
} 

# initializing required variables
$no_of_req = 0
$url_count = @{}
$response_codes = @{}
$max_hit_url = ""
$max_hit_url_count = 0

# fetching timestamp, response code existing in the given time period
Get-Content $filePath | ForEach-Object{
    $url = [regex]::Match($_, '(GET|PROPFIND) [^"]+ HTTP/1\.[01]').value
    $response_code = [regex]::Match($_, '\s(\d{3})\s').Groups[1].Value     
    $timestamp = [regex]::Match($_, '[0-9]{2}:[0-9]{2}:[0-9]{2}').value

    if($timestamp -ne ''){
        $timestamp = [TimeSpan]::ParseExact($timestamp, 'hh\:mm\:ss', $null)
        if ($timestamp -ge $start_time -and $timestamp -le $end_time) {
            ++$no_of_req
            if ($url -ne ''){
                 $url = $url -replace '\[', '' -replace '\]', ''
                if($url_count.ContainsKey($url)){
                    $url_count[$url]++    
                } else {
                    $url_count[$url]=1
                }
            }
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

# calculating most visited URL
foreach ($key in $url_count.Keys){
    if( $url_count[$key] -gt $max_hit_url_count){
        $max_hit_url = $key
        $max_hit_url_count = $url_count[$key]
    }
}


# displaying the No of req, Max visited URL, & response codes 
Write-Host "Total no of request between $start_time and $end_time : $no_of_req"
if($max_hit_url_count -ne 0){
    Write-Host "Most visited URL: ${max_hit_url}, Hit-Count: ${max_hit_url_count}"
}
else{
   "There is not accessed URL between $start_time & $end_time"
}
foreach ($key in $response_codes.Keys){
    Write-Host "Response Code: $key, Count: $($response_codes[$key])"
}



