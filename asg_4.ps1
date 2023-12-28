function average_success_response_time($filePath){
    $total_response_time = 0
    $success_response_code_count = 0

    # fetching the response code & time
    Get-Content $filePath | ForEach-Object{
        $response_code = [regex]::Match($_, '\s(\d{3})\s').Groups[1].Value
        $response_time = [regex]::Match($_, '(\d{3})').Value
        
        if($response_code -ne ''){
            $total_response_time += $response_time
            if($response_code -eq 200 -or $response_code -eq 201){
                $success_response_code_count++
            }
        }
    }

    # Calculating average response time
    $average_success_response_time = 0
    if($total_response_time -eq 0){
        $average_success_response_time = 0
    }else{
        $average_success_response_time = [math]::Round(($success_response_code_count/$total_response_time),2)
    }
    
    # Displaying result
    Write-Host "Average success response time : $average_success_response_time"
}

# Enter the file path & name
$filePath = "C:\Users\rashikasahu\OneDrive - Nagarro\Desktop\devOps\blackbaud asg\files\"
$fileName = Read-Host "Enter full file path & name" 
$filePath = $filePath + $fileName

# Check if file exist or not
if(-not (Test-Path $filePath -PathType Leaf)){
    Write-Host "File name you entered does not exist, please enter correct file name"
    return
}

# calculate average success response time
average_success_response_time $filePath


 