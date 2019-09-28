$WoWPath = "C:\Program Files (x86)\World of Warcraft" # Check Me

Function Register-Watcher {
    param ($folder)
    $filter = ".flavor.info" # This file is "changed" every time Battle.Net completes an update
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }

    $changeAction = [scriptblock]::Create('
        ######################################################################################
        #### This is the code which will be executed every time a file change is detected ####
        #### This code will only create a simple file to confirm wow has updated          ####
        #### Feel free to enter your own code to be executed when an update takes place   #### 
        ######################################################################################

        $path = $Event.Sender.Path
        $timeStamp = $Event.TimeGenerated.ToString("s").Replace(":","")
        New-Item "$path\Updated_At_$timestamp" -ItemType File
    ')

    Register-ObjectEvent $Watcher -EventName "Changed" -Action $changeAction
}

# Start a Watcher for each installed game version
Get-ChildItem $WoWPath -Directory | foreach {
    if ($_.Name -match "_\w+_") { #regex to find folders that start and end with an underscore _
        Register-Watcher $_.FullName
        $_.FullName
    }
}


while ($true) {sleep 1}