function average_success_response_time{
    param(
        [string] $filePath
    )

    $total_response_time = 0
    $success_response_code_count = 0

    # fetching the response code & time
    Get-Content $filePath | ForEach-Object{
        $regexPattern1 = '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$'
        $regexPattern2 = '^(\S+) - - \[([^\]]+)\] "(GET|POST) .+" (\d+) (\d+)'
 
        if ($_ -match $regexPattern1 -or $_ -match $regexPattern2) {
            $response_code = $matches[4]
 
            # Add logic to calculate response time for successful requests (status code 200)
            if ($response_code -eq '200') {
                $success_response_code_count += 1
                $response_time = $matches[5]
                $total_response_time += [int]$response_time
            }
        }
    }

    # Calculating average response time & displaying result
    $average_success_response_time = 0
    if($total_response_time -eq 0){
        $average_success_response_time = 0
        Write-Host "No successfull requests found in the log file."
    }else{
        $average_success_response_time = [math]::Round(($total_response_time/$success_response_code_count),2)
         Write-Host "Average success response time : $average_success_response_time milliseconds"
    }
}

# Enter the file path & name
$filePath = Read-Host "Enter the path to the log file " 

# Check if file exist or not
if ([string]::IsNullOrWhiteSpace($filePath)) {
    Write-Host "Path is empty. Please enter a valid path."
    return
}
elseif (-not (Test-Path $filePath -PathType Leaf)){
    Write-Host "Log file does not exist"
    return
}

# calculate average success response time
average_success_response_time $filePath


 