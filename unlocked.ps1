Param(
    [switch]$background   # Keep a folder of ugly background images in a subfolder called backgrounds
)


$background = $true

if($background) {
    $images = Get-ChildItem "$PSScriptRoot\backgrounds\*" -Include *.png,*.jpg
    if(-not $images) {
        Write-Error "There are no background images in $PSScriptRoot\backgrounds"
    } else {
        $newBackground = Get-Random -InputObject $images
        Try {
            Copy-Item $newBackground $env:TEMP -Force
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$($env:temp)\$($newBackground.Name)"
        } catch {
            Write-Error "Unable to copy background to $($env:temp)"
        }

        Try {
            Start-Process "RunDll32.exe" -ArgumentList @("user32.dll,UpdatePerUserSystemParameters")
            Write-Host "$($newBackground.Name) Applied"
        } Catch {
            Write-Error "Error calling RunDll32 to Update Background"            
        }
    }
}
