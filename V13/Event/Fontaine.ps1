function Fontaine {
param($Soin)
$SoinR = [Math]::Round(((([int]$HeroPV + [int]$Sauvegarde.HpItem)/100)*$Soin))
$global:heroRPV = $SoinR
cls
write-host $HeroRPV "points de vie."
sleep 2
}