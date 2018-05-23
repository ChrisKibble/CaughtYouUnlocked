Param(
    [switch]$background,
    [switch]$iexplore,
    [switch]$notify
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

if($background) {
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

if($iexplore) {

    $WshShell = New-Object -comObject WScript.Shell
    for($i = 1; $i -le 150; $i++) {
        $Shortcut = $WshShell.CreateShortcut("$($env:USERPROFILE)\Desktop\Internet Explorer $i.lnk")
        $Shortcut.TargetPath = "$($env:ProgramFiles)\Internet Explorer\iexplore.exe"
        $Shortcut.Save()
    }

}

if($notify) {
    Out-File -FilePath "$env:TEMP\LockYoComputer.txt" -InputObject "Hey, Maybe you should lock your computer the next time you walk away, huh?" -Force
    & "$env:temp\LockYoComputer.txt"
    Start-Sleep -Seconds 1
    Remove-Item  "$env:temp\LockYoComputer.txt"
}

$search = $true

if($search) {
    Start-Process "https://www.google.com/search?safe=on&q=does+farting+burn+calories"
}