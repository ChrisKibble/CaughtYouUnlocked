Param(
    [switch]$all,
    [switch]$background,
    [switch]$iexplore,
    [switch]$notify,
    [switch]$search
)

Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;

public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 

if($background -or $all) {
    $images = Get-ChildItem "$PSScriptRoot\backgrounds\*" -Include *.png,*.jpg
    
    if(-not $images) {
        Write-Error "There are no background images in $PSScriptRoot\backgrounds"
    } else {
        $newBackground = Get-Random -InputObject $images
        
        Copy-Item $newBackground "$env:TEMP\UnlockedComputerBackground.bmp" -Force
                
        Try {
            # Source/Inspiration: https://stackoverflow.com/questions/28180893/how-to-change-wall-paper-by-using-powershell
            $SPI_SETDESKWALLPAPER = 0x0014
            $UpdateIniFile = 0x01
            $SendChangeEvent = 0x02
            
            $fWinIni = $UpdateIniFile -bor $SendChangeEvent 
            
            [void][Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, "$env:TEMP\UnlockedComputerBackground.bmp", $fWinIni)
            Write-Host "$($newBackground.Name) Applied"
        } Catch {
            Write-Error "Error Updating Background"            
        }
    }
}

if($iexplore -or $all) {

    $WshShell = New-Object -comObject WScript.Shell
    for($i = 1; $i -le 150; $i++) {
        $Shortcut = $WshShell.CreateShortcut("$($env:USERPROFILE)\Desktop\Internet Explorer $i.lnk")
        $Shortcut.TargetPath = "$($env:ProgramFiles)\Internet Explorer\iexplore.exe"
        $Shortcut.Save()
    }

}

if($notify -or $all) {
    Out-File -FilePath "$env:TEMP\LockYoComputer.txt" -InputObject "Hey, Maybe you should lock your computer the next time you walk away, huh?" -Force
    & "$env:temp\LockYoComputer.txt"
    Start-Sleep -Seconds 1
    Remove-Item  "$env:temp\LockYoComputer.txt"
}

if($search -or $all) {
    $queries = @(
        "does farting burn calories?"
        "are there any actors better than brendan frasier?"
        "when are you too old to learn how to `"douggie`""
        "proof that bigfoot is real"
        "what does it feel like to be in love?"
        "is mexico a state in the US?"
        "how do I do the macarena?"
    )
    
    $randomQuery = $(get-random -InputObject $queries) -replace " ", "+"

    Start-Process "https://www.google.com/search?safe=on&q=$randomQuery"
}