function Experience {
param($Xp)
cls
ecriture ($ecrit= "Vous obtenez "+ $Xp+ " point d'experience !")
sleep 1
[int]$global:Sauvegarde.xp += $Xp
if ([int]$sauvegarde.Xp -ge [int]$HeroLvl.exp[[int]$Sauvegarde.niveau]) {
cls
ecriture ($ecrit= "Vous monter de niveau !! ")
sleep 2
[int]$Global:Sauvegarde.niveau += 1
$Global:HeroPV = $HeroLvl.HP[[int]$Sauvegarde.niveau]
$Global:HeroDMG = $HeroLvl.DMG[[int]$Sauvegarde.niveau]
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
[int]$global:Pniveau = ([int]$HeroLvl.exp[[int]$Sauvegarde.niveau] - [int]$sauvegarde.Xp)
cls
write-host "Niveau" $Sauvegarde.niveau
sleep 1
write-host $HeroRPV "PV"
sleep 1
write-host $HeroDMG "DMG"
sleep 1
write-host "Prochain niveau dans" $Pniveau "points d'experience !"
sleep 1
pause
}
else {
}
}