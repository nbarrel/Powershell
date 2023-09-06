#Nicholas Barillas March 2023
#Needed to update ERP software that does not have auto updates

$ShopedgeNetwork = "Path to network share"
$LocalSEPath = "C:\ShopEdgeDist"
$SENETPATH = Test-Path -Path "PATH TO Folder" -IsValid
$SELOCALPATH = test-path -path $LocalSEPath 

"Preparing to install Closing any open instances of Shop Edge"

If (Get-Process -Name shopedge.erp) {
    Stop-Process -Name shopedge.erp -Force
    "Closing Shop Edge"
}
Else{
"Shop edge is not running preparing install"
}

If ($SENETPATH -eq 1) {
    "We see ShopEdgeDist in the network"
}
Else {
    "ensure network connectivity"
    "Exiting Script"
    Start-Sleep -Seconds 1
    Exit
}

If ($SELOCALPATH -eq 0) {
    New-Item -ItemType Directory -Name "ShopEdgeDist" -Path "C:\"
    "Creating SE Local Path"
    Start-Sleep -Seconds 1
    "SE Local Path Available"
}
Else {
    "SE Path Available"
    Start-Sleep -Seconds 1
}

"COPYING SHOP EDGE PLEASE WAIT"
Copy-Item -Path $ShopedgeNetwork -Destination $LocalSEPath -recurse -force
Start-Sleep -Seconds 1
"Shop Edge Copied"

"Creating Shortcut Please Wait"
$TargetFile = "C:\ShopEdgeDist\Binaries\ShopEdge.ERP.exe"
$ShortcutFile = "$env:Public\Desktop\ShopEdgeERP.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()
Start-Sleep -Seconds 1
"Testing Shortcut"
if (Get-ChildItem "C:\Users\Public\Desktop\ShopEdgeERP.lnk") {
"Shop Edge Shortcut available"
}