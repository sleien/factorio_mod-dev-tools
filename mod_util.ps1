param(
    [Parameter()]
    [ValidateSet("test", "build")]
    [string] $action = "test",
    [Parameter()]
    [string] $modIgnoreFile = ".\.modignore",
    [Parameter()]
    [string] $basePath = ".\",
    [Parameter()]
    [string] $zipPath = ".\zips"
)

$basePath = Resolve-Path $basePath
Write-Host "Using path:" $basePath

$modIgnoreFile = $basePath + $modIgnoreFile
if (!(Test-Path $modIgnoreFile)) {
    write-verbose "No modIgnoreFile found."
}
else {
    $modIgnore = Get-Content $modIgnoreFile
}

$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    throw "7 zip file '$7zipPath' not found"
}

Set-Alias 7zip $7zipPath

$infoJsonPath = $basePath + ".\info.json"
if (!(Test-Path $infoJsonPath)) {
    write-error "No info.json found."
    exit
}

$info = Get-Content $infoJsonPath | ConvertFrom-Json
$folderName = $info.name + "_" + $info.version
write-host "ModFolderName" $folderName
write-host "Factorio version" $info.factorio_version

if ($action -eq "test") {

    if ($zipPath -ne ".\zips") {
        Write-Host "ZipPath is only used if the action is set to build" -ForegroundColor Red
    }

    $path = [Environment]::GetFolderPath('ApplicationData') + "\Factorio\mods"

    write-host "Creating" $folderName "in" $path

    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Force -Path $path
    }

    $modPath = $path + "\" + $folderName

    if (Test-Path $modPath) {
        Remove-Item $modPath"\*" -Recurse
    }
    else {
        New-Item -ItemType Directory -Force -Path $modPath
    }
    Get-ChildItem $basePath | Where-Object { $_.Name -notin $modIgnore } | Copy-Item -Destination $modPath -Recurse -Force

}
elseif ($action -eq "build") {
    $zipPath = $zipPath + "\" + $folderName + ".zip"
    if (Test-Path $zipPath) {
        Remove-Item $zipPath
    }
    $tempFolder = $env:TEMP + "\" + $folderName
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder"\*" -Recurse
    }
    else {
        New-Item -ItemType Directory -Force -Path $tempFolder
    }
    Get-ChildItem $basePath | Where-Object { $_.Name -notin $modIgnore } | Copy-Item -Destination $tempFolder -Recurse -Force
    #Compress-Archive -Path $tempFolder -DestinationPath $zipPath -CompressionLevel "Fastest" #Does only work for windows (not modportal)
    7zip a -mx=9 $zipPath $tempFolder
    Remove-Item $tempFolder -Recurse

}
else {
    Write-Host "The action parameter was used incorrectly"
}