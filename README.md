# Mod Dev Tools
A simple toolset to make it easier to develop mods for factorio

## Parameters
    [ValidateSet("test", "build")]
    [string] $action = "test",
    [Parameter()]
    [string] $modIgnoreFile = ".\.modignore",
    [Parameter()]
    [string] $basePath = ".\",
    [Parameter()]
    [string] $zipPath = ".\zips"
1. ```-action``` takes "test" for [development](##Development) or "build" to [generate a zip](##Publish). 
1. ```-modIgnoreFile``` specifies where your .modignore files lies. It is good to have one of these to exclude stuff like .git and README.md from the zip if your mod uses source control.
1. ```-basePath``` the path where you develop the mod
1. ```-zipPath``` the path where the zip will be after running the script in build mode.
  
The default values only work if the script is copied into the mod folder itself.

## Development

Run the script with ```-action "test"``` to test the mod.  
This will copy the folder into %appdata%\factorio\mods with the correct name.  
The name is taken from info.json consists of name_version.

## Publish

To publish simply run ```-action "build"```.  
This generates a zip file with the correct name which can be uploaded to the [modportal](https://mods.factorio.com).