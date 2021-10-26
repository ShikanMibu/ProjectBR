<#  Projet BR
Copyright (C) 02/07/2021  Roland Meunier

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses #>

#Import des dotsource
. D:\GEFLEX\ProjetA\Test\V13\Event\Fontaine.ps1
. D:\GEFLEX\ProjetA\Test\V13\Event\Experience.ps1
. D:\GEFLEX\ProjetA\Test\V13\Event\Salleduchoix.ps1

#On prend l'emplacement du dossier racine dans une variable
$Location = Get-Location

#Import du cvs de Questions Réponses
$QA=Import-Csv -path $Location\Questions.csv -Delimiter ";"

#Import du csv des niveaux du Hero
$HeroLvl=Import-Csv -path $Location\Niveau.csv -Delimiter ";"

#Import du csv des Items
$Item=Import-Csv -path $Location\Item.csv -Delimiter ";"

#Import du script des monstres
$script:monstre=Import-Csv -path $Location\monstre1.csv -Delimiter ";"
#Fin des imports de CSV

#Import du fichier de sauvegarde :
$script:Sauvegarde = [ordered]@{
Niveau = (get-content -path $Location\Sauvegarde\Save.txt)[0]
HPitem = (get-content -path $Location\Sauvegarde\Save.txt)[1]
DmgItem = (get-content -path $Location\Sauvegarde\Save.txt)[2]
xp = (get-content -path $Location\Sauvegarde\Save.txt)[3]
combo = (get-content -path $Location\Sauvegarde\Save.txt)[4]
HeroPots = (get-content -path $Location\Sauvegarde\Save.txt)[5]
PositionHero = (get-content -path $Location\Sauvegarde\Save.txt)[6]
HeroBourse = (get-content -path $Location\Sauvegarde\Save.txt)[7]
Loyaute = (get-content -path $Location\Sauvegarde\Save.txt)[8]
LoyauteCounter = (get-content -path $Location\Sauvegarde\Save.txt)[9]
Miniboss = (get-content -path $Location\Sauvegarde\Save.txt)[10],(get-content -path $Location\Sauvegarde\Save.txt)[11],(get-content -path $Location\Sauvegarde\Save.txt)[12]
Minibosscount = [int](get-content -path $Location\Sauvegarde\Save.txt)[13],(get-content -path $Location\Sauvegarde\Save.txt)[14],(get-content -path $Location\Sauvegarde\Save.txt)[15]
MiniBossnumber = (get-content -path $Location\Sauvegarde\Save.txt)[16]
MBSubCount = (get-content -path $Location\Sauvegarde\Save.txt)[17],(get-content -path $Location\Sauvegarde\Save.txt)[18],(get-content -path $Location\Sauvegarde\Save.txt)[19]
MBSubNumber = (get-content -path $Location\Sauvegarde\Save.txt)[20]
HeroKey = (get-content -path $Location\Sauvegarde\Save.txt)[21],(get-content -path $Location\Sauvegarde\Save.txt)[22],(get-content -path $Location\Sauvegarde\Save.txt)[23],(get-content -path $Location\Sauvegarde\Save.txt)[24]
}
$script:FirstEvent =@((get-content -path $Location\Sauvegarde\Event.txt))

#Imports des score précedents
$AdvScore = Get-Content -Path $Location\score\AdventureScore.txt
$AdvPB = Get-Content -Path $Location\score\AdventurePB.txt

#Imports de la MAP
$MAP=Import-Csv -path $Location\Map\Map.csv -Delimiter ";"

#Variable des points de victoire
$script:Points = 0

#les randoms questions
$script:Qrandom = 0

#les randoms monstres
$script:Mrandom = 0
$script:EtatA = 0
$script:Etat = 0
[int]$Script:PVmonstre = 0

#Les variables des Miniboss et du boss
$script:Boss = 1

#tableau count question
[string]$script:QTrandom=@()
$script:QTcount = 0
$script:QASujet = @()
$script:QASujetName = @()
for ($x=0;$x -lt $QA.count;$x++){
if ($script:QASujet -notcontains $QA[$x].Letters){
$script:QASujet += $QA[$x].Letters
$script:QASujetName += $QA[$x].Fullname
}
}

#Variable Hero
$Save = Get-Content -Path $Location\sauvegarde\save.txt
$script:HeroName = Get-Content -Path $Location\Hero\Nom.txt
$HeroPV = $HeroLvl.HP[$Sauvegarde.niveau]
[int]$global:HeroRPV = ([int]$HeroPV + [int]$HpItem)
$HeroDMG = $HeroLvl.DMG[$Sauvegarde.niveau]
$script:DeplacementTemp
$script:PositionTemp
$script:NbMort = 0

#Variable du marchand
$Marchand = Import-Csv -Path $location\Marchand.csv -Delimiter ";"

#Création d'un chrono
$script:stopWatch = New-Object -TypeName System.Diagnostics.Stopwatch


cls

function question {
param($A)
cls
do {
$B = $QA.IDM | Where-Object {$_ -match $A}
$Qrandom = Get-Random -Minimum 0 -Maximum $B.count
[string]$QuestionID = $B[$Qrandom]
}
while ($QTrandom -match $QuestionID)
$script:QTrandom += $QuestionID
do {
cls
$QAtemp = $QA |Where-Object {$_.IDM -eq $QuestionID}
write-host $QAtemp.question
$reponse = read-host "1 : " $QAtemp.Panswer0 `n"2 : " $QAtemp.Panswer1 `n"3 : " $QAtemp.Panswer2 `n"4 : " $QAtemp.Panswer3 `n"Réponse"
}
while ($reponse -notmatch "[1-4]")
cls
$script:QTcount ++
correction
}

function correction {
cls
if ($reponse -eq $QAtemp.answer) {
$script:EtatA = 1
}
Else {
$script:EtatA = 2
}
}
#Fin du bloc question

function choix {
Sauvegarde
if ($script:QTcount -gt 10) {
$script:QTrandom=@()
}
else {}
cls
#Fonctionne comme un menu qui donne des options au joueur
write-host ("Que voulez vous faire ?")
("-"*35)
"1 : Se Deplacer 
2 : Prendre une potion de soins
3 : Regarder les statistiques
4 : Ouvrir la carte"
("-"*35)
$a = read-host "Reponse"
if ($a -eq 1) {
ChoixDep
}
elseif ($a -eq 2){
Soigner
}
elseif ($a -eq 3) {
EcranStats
}
elseif ($a -eq 4){
if ($MAP[[int]$sauvegarde.PositionHero].Etage -eq "RDC"){
start -FilePath $Location\Map\RDC.png
}
else {start -FilePath $Location\Map\Etage.png}
}
else {
cls
write-host "Choisis une option dans la liste !"
pause
choix
}
}

function ChoixDep {
#La salle actuelle est mise dans $positiontemp
$script:PositionTemp = $MAP[[int]$sauvegarde.PositionHero]
cls
Write-Host " Lieux : "$script:PositionTemp.FullName (" "*10) "Etage : "$script:PositionTemp.Etage
sleep 1
#Creation d'un tableau avec les valeurs ABCD de la salle actuelle
$MapTabTemp = @()
for ($i=0; $i -le 3;$i++){
$e=[char](65+$i)
if (($script:PositionTemp).$e -ne ""){
$MapTabTemp += ($script:PositionTemp).$e 
}
}
#On ecrit les proposition de deplacement
""
write-host "Se diriger vers : "
Write-Host ("-"*35)
Write-host "0 : " $PositionTemp.E
write-host "1 : " $PositionTemp.F
write-host "2 : " $PositionTemp.G
write-host "3 : " $PositionTemp.H
Write-Host ("-"*35)
""
#choix du déplacement
do {
$ChoixDepA = Read-Host "Ou voulez vous vous déplacez ?"
}
while ($ChoixDepA -gt $MapTabTemp.count-1)
#On prend la valeur dans le tableau $maptabtemp a partir du choix de déplacement et on le met dans $deplacementTemp
$script:DeplacementTemp = ($MapTabTemp[$ChoixDepA]) 
if ($Sauvegarde.HeroKey -notcontains $Map[$DeplacementTemp].Clefs){
ecriture ($ecrit = "Vous ne possedez pas la clef necessaire pour venir ici !")
sleep 1.3
Choixdep
}
else {
Deplacement ($script:DeplacementTemp)
}
}

function ecriture {
param($ecrit)
$i = $ecrit.Length
for ($e = 0;$e -le $i;$e++){
Write-Host -NoNewline $ecrit[$e]
sleep -Milliseconds 20
}
write-host ""
}

function Deplacement {
param($script:DeplacementTemp)
cls
#on fais un tableau avec la colonne ID de map
$ChoixDepB = $Map.ID
#on remplace la position du hero par la valeur à l'emplacement "$deplacementtemp" dans la colonne ID de map
[int]$sauvegarde.PositionHero = $ChoixDepB[$DeplacementTemp]
$script:PositionTemp = $MAP[[int]$sauvegarde.PositionHero]
ecriture ($ecrit = "Vous entrez dans "+$script:PositionTemp.Fullname)
pause
CheckEvent
CheckSpawn
if ($script:PositionTemp.shopevent -eq 1){
ShopEvent
}
Else{}
}

Function Soigner {
cls
if ([int]$sauvegarde.HeroPots -ieq 0){
write-host "Vous n'avez aucune potions..."
pause
Choix
}
elseif ($HeroRPV -eq ([int]$HeroLvl.HP[[int]$Sauvegarde.niveau] + [int]$Sauvegarde.HpItem)){
write-host "Vos point de vie sont deja au maximum !"
sleep 1.5
choix
}
else {
$stopWatch.Reset()
[int]$script:Reussite = 0
cls
Write-Host "Soyez rapide ! Soyez vif !"
sleep 1
"3"
sleep 1
"2"
sleep 1
"1"
write-host "GO" -ForegroundColor Green
sleep 1
$timeSpan = New-TimeSpan -Seconds 30
do {
$c = get-random -Minimum 1 -Maximum 4
$A = Get-Random -Minimum 1 -Maximum 21
$B = Get-Random -Minimum 1 -Maximum 21
$stopWatch.Start()
if ($c -eq 1){
$E = $A + $B
cls
write-host "Résoudre :"
write-host $A "+" $B
$D = read-host "Réponse "
}
elseif ($c -eq 2){
$E = $A - $B
cls
write-host "Résoudre :"
write-host $A "-" $B
$D = read-host "Réponse "
}
elseif ($c -eq 3){
$E = $A * $B
cls
write-host "Résoudre :"
write-host $A "*" $B
$D = read-host "Réponse " 
}
else {}
If ($D -eq $E) {
[int]$Reussite ++
}
Else {}
}
while ($timeSpan -gt $stopWatch.Elapsed)
[int]$Pvrecup = ($Reussite * 3)
if ($Pvrecup -gt ([int]$HeroLvl.HP[[int]$Sauvegarde.niveau] - $HeroRPV)){
$Pvrecup = ([int]$HeroLvl.HP[[int]$Sauvegarde.niveau] - $HeroRPV)
}
cls
Write-Host "Vous avez réussit "$Reussite "bonne réponse !"
sleep 1
Write-Host -nonewline "La potion vous rend " 
Write-host -NoNewline $PvRecup -ForegroundColor Red
Write-Host -NoNewline " PV !"
pause
[int]$script:HeroPV += $Pvrecup
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
[int]$sauvegarde.HeroPots -= 1
Choix
}
}

function matiere {
cls
write-host ("Avec Quel matière on attaque ?")
do {
for ($x=0;$x -lt $script:QASujet.count;$x++){
write-host ($x+1) ":" $script:QASujetName[$x]
}
[int]$c = read-host "Réponse"
}
while (1..$QAsujet.count -notcontains $c)
$A = $QAsujet[$c-1]
Question($A)
}

function boucle {
#La fonction boucle s'assure de la condition de fin du jeux et de continuer a jouer tant que celle ci n'est pas rempli
do {
cls
choix
}
while ($script:Boss -eq 1 )
ecriture ($ecrit = "Roland Meunier : Eh Salut toi !")
ecriture ($ecrit = "Merci beaucoup d'avoir jouer a mon jeu !")
ecriture ($ecrit = "et fellicitation d'avoir reussit a battre le boss final !!")
sleep 1
cls
ecriture ($ecrit = "Roland Meunier : J'espère que ce jeu t'aura permis de revoir tes cours.")
ecriture ($ecrit = "Merci aux membres de la promo 195 de m'avoir aider.")
ecriture ($ecrit = "Bastien Parrondo et Agnes Vilain surtout :)")
ecriture ($ecrit = "Courage pour la suite de ta formation !")
sleep 1
cls
ecriture ($ecrit = "Roland Meunier : Le jeu va maintenant s'arreter...") 
ecriture ($ecrit = "mais n'hesite pas a relancer une partie !!")
ecriture ($ecrit = "A bientôt !!")
sleep 1
cls
ecriture ($ecrit = "vous allez quittez le jeu")
pause
exit
}

function Accueil {
"Bienvenue dans Projet BR"
pause
#Namaewa dit bonjour avec le prénom ou le demande si il est inconnue
Namaewa
cls
#Si un précedent score existe il est affiché
cls
"Prêt ? c'est partit !"
pause
MinibossSpawn
#Appel de la fonction Boucle
boucle
}

function Appears {
param($Type)
do {
$Mrandomtype = Get-Random -Minimum 1 -Maximum 11
$Mrandom = $Mrandomtype * $Type
}
while ($Mrandom -gt $monstre.count)
cls
write-host "Un(e)" $monstre.fullname[$Mrandom] "apparaît !"
sleep 1
write-host "Debut du combat !"
pause
[int]$Script:PVmonstre = $monstre.pv[$Mrandom]
combat
}

function combat {
$Etat = 1
while ($Etat -eq 1){
ecrancombat
attaque
ecrancombat
if ($PVmonstre -gt 0){
riposte
}
else {}
if ($heroRPV -lt 1) {
$Etat = 3
}
elseif ($PVmonstre -lt 1){
$Etat = 2
}
else {
write-host "error"
}
}
if ($Etat -eq 2){
Victoire
}
Elseif ($Etat -eq 3){
Defaite
}
else{
write-host "error"
}
}

function ecrancombat {
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
cls
write-host $HeroName" : "$global:HeroRPV "/" ([int]$herolvl.HP[[int]$Sauvegarde.niveau] + [int]$Sauvegarde.HpItem)" Pts de vie"
write-host "------------------------------------|" -ForegroundColor DarkYellow 
write-host $monstre.fullname[$Mrandom]" : "$PVmonstre "/" $monstre.pv[$Mrandom] "Pts de vie"
pause
}

function attaque {
$script:EtatA = 0
matiere
if ($EtatA -eq 1) {
$script:PVmonstre -= ([int]$HeroDMG + [int]$sauvegarde.combo + [int]$Sauvegarde.DmgItem)
cls
write-host "Bravo tu as reussit ton attaque !"
write-host "Tu inflige"([int]$HeroDMG + [int]$Sauvegarde.DmgItem) "pts de dégats plus" $sauvegarde.combo "pts de dégats de combo !"
pause
[int]$sauvegarde.combo += 1
}
elseif ($EtatA -eq 2){
if ([int]$sauvegarde.combo -gt 0){
[int]$sauvegarde.combo -= 1
write-host "Aie ! ton attaque à échouer...ton combo diminue..."
}
else {
write-host "Aie ! ton attaque à échouer"
}
pause
}
else {
write-host "error"
}
}

function riposte {
cls
write-host "Le" $monstre.fullname[$Mrandom] "vous attaque !!" -ForegroundColor Red
pause
$script:EtatA = 0
#Récupere une lettre random grace au code ASCII
$A =($script:QASujet) | get-random | % {[char]$_}
Question($A)
if ($EtatA -eq 2) {
$script:HeroPV -= $monstre.dmg[$Mrandom]
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
[int]$sauvegarde.combo -= 1
cls
write-host "Aie ca fait mal ! Tu prends" $monstre.dmg[$Mrandom] "points de dégats !"
pause
if ($monstre.volvie[$Mrandom] -gt 0){
[int]$Monstrelifesteal = $Monstre.volvie[$Mrandom]
if ($Monstrelifesteal -gt ($Monstre.pv[$Mrandom] - $Script:PVmonstre)){
$Monstrelifesteal = ($Monstre.pv[$Mrandom] - $Script:PVmonstre)
}
cls
write-host "le monstre récupere" $Monstrelifesteal "Pts de vie en attaquant !"
pause
$script:PVmonstre += $Monstrelifesteal
$PVmonstre
}
else {
}
}
elseif ($EtatA -eq 1){
cls
write-host "tu reussis à esquiver l'attaque !!"
pause
}
else {
write-host "error"
}
}

function victoire {
cls
write-host $monstre.win[$Mrandom]
sleep 1
write-host "Vous avez vaincu 1 " $monstre.fullname[$Mrandom]
pause
Exp
Loot
$script:Points ++
}

function defaite {
cls
write-host $monstre.loose[$Mrandom]
ecriture ($ecrit = "Vous vous reveillez dans le Hall d'entree...")
pause
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)/2
$script:NbMort ++
choix
}

function exp {
[int]$sauvegarde.Xp += $monstre.exp[$Mrandom]
cls
write-host "Vous obtenez" $monstre.exp[$Mrandom] "pts d'experience"
pause
if ([int]$sauvegarde.Xp -ge [int]$HeroLvl.exp[[int]$Sauvegarde.niveau]) {
cls
write-host "Vous monter de niveau ! "
sleep 2
[int]$script:Sauvegarde.niveau += 1
$script:HeroPV = $HeroLvl.HP[[int]$Sauvegarde.niveau]
$script:HeroDMG = $HeroLvl.DMG[[int]$Sauvegarde.niveau]
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
$Pniveau = ([int]$HeroLvl.exp[[int]$Sauvegarde.niveau] - [int]$sauvegarde.Xp)
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

function loot {
$Gloot = Get-Random -Minimum 1 -Maximum 6
Write-Host "Vous trouvez "$Gloot "Pièces d'or"
[int]$script:Sauvegarde.HeroBourse += $Gloot
Write-Host "Bourse : "$sauvegarde.HeroBourse
$lootr = get-random -Minimum 1 -Maximum 101
if ($lootr -le $script:monstre.chanceloot[$Mrandom]){
cls
$Rloot = Get-Random -Minimum 1 -max 3
write-host "Incroyable !! vous avez trouvé :" ($Rloot*$script:monstre.chanceloot[$Mrandom]) "Pièces d'or supplementaire !!"
[int]$script:Sauvegarde.HeroBourse += ($Rloot*$script:monstre.chanceloot[$Mrandom])
Pause
cls
}
else {}
}

function newloot {
param($loota)
write-host "Cet objet vous offre" $item.Hp[$loota] "Pts de vie ," $item.dmg[$loota] "Pts de dégats et" $item.Pots[$loota] "Potions de soins !"
pause
[int]$Sauvegarde.DmgItem += $Item.dmg[$loota]
[int]$Sauvegarde.HpItem += $Item.Hp[$loota]
[int]$sauvegarde.HeroPots += $Item.pots[$Loota]
$global:HeroRPV= $Sauvegarde.HpItem + $HeroLvl.HP[$sauvegarde.niveau]
}

function Namaewa {
if ($HeroName -lt 2) {
cls
write-host "C'est la 1er fois que je te vois ici."
sleep 1
$NameTemp = Read-Host "Quel est ton nom ?
Reponse"
$NameTemp | Set-Content -Path $Location\Hero\nom.txt 
$script:HeroName = Get-Content -Path $Location\Hero\Nom.txt
cls
Write-Host "Bienvenue" $HeroName "on va vivre un belle aventure !"
pause
}
else {
cls
write-host "Content de te revoir"$HeroName "!"
sleep 1
write-host "J'attendais ton retour !"
pause
}
}

Function EcranStats {
Cls
write-host "|"("-"*58)"|" -BackgroundColor Black -ForegroundColor DarkYellow
write-host (" "*25)"Statisques"(" "*25)-BackgroundColor Black -ForegroundColor DarkYellow
write-host "|"("-"*58)"|"-BackgroundColor Black -ForegroundColor DarkYellow
write-host (" "*4)" - Points de vie : "$global:HeroRPV(" "*5)"- Dégats d'Attaque : "([int]$HeroDMG + [int]$sauvegarde.combo + [int]$Sauvegarde.DmgItem)"  " -BackgroundColor Black -ForegroundColor DarkYellow
write-host "|"("-"*58)"|"-BackgroundColor Black -ForegroundColor DarkYellow
write-host (" "*4)" - Potions de soins : " $sauvegarde.HeroPots (" "*8)"- Combo : "$sauvegarde.combo (" "*10)-BackgroundColor Black -ForegroundColor DarkYellow
write-host "|"("-"*58)"|"-BackgroundColor Black -ForegroundColor DarkYellow
write-host (" "*4)" - Bourse : "$Sauvegarde.HeroBourse "- Experience avant niveau Superieur : "([int]$HeroLvl[[int]$Sauvegarde.niveau].exp - [int]$sauvegarde.Xp) (" ")-BackgroundColor Black -ForegroundColor DarkYellow
write-host "|"("-"*58)"|"-BackgroundColor Black -ForegroundColor DarkYellow
" "
Pause
MenuP
}

Function CheckEvent {
if ($script:PositionTemp.FirstEvent -gt 0) {
if ($FirstEvent -notcontains $script:PositionTemp.ID) {
$script:FirstEvent += $script:PositionTemp.ID
FirstEvent ($FE = $script:PositionTemp.FirstEvent)
}
else {
}
}
}

Function FirstEvent {
Param($FE)
#Check le type de l'event

cls
ecriture ($ecrit = $script:PositionTemp.FirstEventChat)
sleep 2
switch ($FE) {
2 {Appears($Type = $script:PositionTemp.FirstEventValue)}
3 {newloot ($loota = $script:PositionTemp.FirstEventValue)}
4 {Boss}
5 {Eboulement}
6 {Fontaine($Soin = $script:PositionTemp.FirstEventValue)}
7 {Experience($xp = $script:PositionTemp.FirstEventValue)}
8 {Salleduchoix}
}
Sauvegarde
} 

Function Eboulement {
$timeSpan = New-TimeSpan -Seconds 3
cls
ecriture ($ecrit = "Des rochers vous tombe dessus !")
sleep 1
ecriture ($ecrit = "Des mots vont apparaitre a l'ecran")
sleep 1
ecriture ($ecrit = "Ecris les le plus vite possible et appuie sur entree !")
sleep 1
cls
"3"
sleep 1
cls
"2"
sleep 1
cls
"1"
sleep 1
cls
"GO"
sleep 1
cls
for ($x = 0; $x -lt 10; $x ++){
$stopWatch.Reset()
$stopWatch.Start()
$EbouRep = "Reset"
$Eboutemp = get-random "haut","bas","gauche","droite"
Write-Host $Eboutemp
do {
$EbouRep = Read-Host "Reponse"
}
while (($EbouRep -ne $Eboutemp) -and ($stopWatch.Elapsed -lt $timeSpan))
$stopWatch.Stop()
if ($timeSpan -gt $stopWatch.Elapsed) {
cls
write-host "Tu réussit ton esquive !"
sleep 1
}
else {
cls
write-host "Aie, pas assez rapide ! tu perd 1hp"
sleep 1
$script:HeroPV -= 1
[int]$global:HeroRPV = ([int]$HeroPV + [int]$Sauvegarde.HpItem)
if ($global:HeroRPV -lt 1){defaite}
else{}
}
}
write-host "L'eboulement s'arrete, tu est hors de danger."
}

Function ShopEvent {
$script:TempItem = @()
[int[]]$script:Tempshop = @(8)
for ($j=1; $j -le $Marchand[[int]$Sauvegarde.loyaute].Nbitem; $j++){
$script:Tempshop += $j
}
cls
Write-Host "Le marchand est présent dans ce lieux"
Do {
Write-Host "Voulez vous acheter des objets ?"
$Rep = Read-Host "Y/N ?"
}
while ($Rep -notmatch "[Y,N]")
if ($Rep -eq "N"){
ecriture ($ecrit = "Vous quittez le marchand.")
sleep 1
choix
}
Else {
[int]$x = $Marchand[[int]$Sauvegarde.loyaute].Nbitem
for ($x = $Marchand[[int]$Sauvegarde.loyaute].Nbitem;$x -gt 0; $x--){
$RandomItem = Get-Random -Minimum 0 -Maximum $Item.count
$script:TempItem += $Item[$RandomItem]
}

cls
ecriture ($ecrit = "Vous arrivez dans le shop")
ecriture ($ecrit = "Le Marchand vous propose "+$Marchand[[int]$Sauvegarde.loyaute].Nbitem+" objets :")
write-host
write-host "Numéros " "|" (" "*7) "Objets" (" "*7) "|" "   Prix"
Write-Host ("-"*50)
for ([int]$r=0;$r -lt $Marchand[[int]$Sauvegarde.loyaute].Nbitem; $r++){
write-host ($r+1) (" "*7) $TempItem[$r].Fullname (" "*(27-($TempItem[$r].Fullname).Length)) ([math]::Round(([int]$TempItem[$r].Prix)*$Marchand[[int]$Sauvegarde.loyaute].Ristourne))
}
write-host ("-"*50)
write-host
Write-host "Votre Bourse : "$Sauvegarde.HeroBourse
Write-host "Entrer le numéros de l'objet choisis ou appuyer sur 8 pour quitter"
do {
[int]$Repitem = Read-host "Réponse :"
if ($Sauvegarde.HeroBourse -lt ([math]::Round([int]$script:TempItem[$Repitem-1].prix*$Marchand[[int]$Sauvegarde.loyaute].Ristourne))){
Write-Host "Vous n'avez pas assez d'argent pour acheter cet objet"
}
}
while ($script:Tempshop -notcontains $Repitem -or $sauvegarde.HeroBourse -lt ([math]::Round([int]$script:TempItem[$Repitem-1].prix*$Marchand[[int]$Sauvegarde.loyaute].Ristourne)))
if ($Repitem -eq 8){choix}
Else {
$loota = ($script:TempItem[$Repitem-1].ID)
cls
Write-Host  "Vous achetez" $script:TempItem[$Repitem-1].Fullname "pour" ([math]::Round([int]$script:TempItem[$Repitem-1].prix*$Marchand[[int]$Sauvegarde.loyaute].Ristourne)) "pièce d'Or"
$script:sauvegarde.HeroBourse -= ([math]::Round([int]$script:TempItem[$Repitem-1].prix*$Marchand[[int]$Sauvegarde.loyaute].Ristourne))
[int]$Sauvegarde.LoyauteCounter += 1
if ([int]$Sauvegarde.LoyauteCounter -eq $Marchand[[int]$Sauvegarde.loyaute].Loyautelvlup){
[int]$Sauvegarde.loyaute += 1
}
else {}
Newloot ($loota)
}
cls
ecriture ($ecrit = "La boutique disparait...")
write-host ""
pause
Choix
}
}

Function CheckSpawn {
if ($Sauvegarde.Miniboss -notcontains $map[[int]$sauvegarde.PositionHero].ID){
if ($MAP[[int]$sauvegarde.PositionHero].SpawnChance -ne 0){
$chancespawn = get-random -min 0 -Maximum 101
if ($MAP[[int]$sauvegarde.PositionHero].SpawnChance -ge $chancespawn){
Appears($Type = $MAP[[int]$sauvegarde.PositionHero].Typedespawn)
}
else {}
}
else {}
}
elseif ($Sauvegarde.Miniboss -notcontains 0) {
if ($Sauvegarde.Minibosscount -notcontains $map[[int]$sauvegarde.PositionHero].ID) {
Miniboss($Numb = $map[[int]$sauvegarde.PositionHero].ID)}}
else {}
}

Function MinibossSpawn{
cls
if ($Sauvegarde.Miniboss -contains 0 -and $script:QASujet.Length -ge 3){
for ($x = 0; $x -lt $script:QASujet.Length; $x++){
$Tempo = $QA | Where-Object {$_.idm -match $script:QASujet[$x]}
if ($Tempo.Length -ge 10){$Tempo1 ++}
}
if ($Tempo1 -ge 3){
ecriture ($ecrit = "les 3 terrible exam du manoir viennent d'apparaitre dans le manoir")
sleep 2
[int]$Sauvegarde.Miniboss[0] = Get-Random 31, 32
[int]$Sauvegarde.Miniboss[1] = Get-Random 39, 46
[int]$Sauvegarde.Miniboss[2] = Get-Random 16, 23
}
}
}

Function Miniboss{
param($Numb)
do {
$MBsub = get-random -min 0 -Maximum $script:QASujet.Length}
while ($Sauvegarde.MBSubCount -contains $MBsub)
$Sauvegarde.MBSubCount[[int]$Sauvegarde.MBSubNumber] = $MBsub
[int]$Sauvegarde.MBSubNumber += 1
$Tempo = $QA | Where-Object {$_.idm -match $script:QASujet[$MBsub]}
[int]$NombreQuestion = $Tempo.Length
do {$NombreQuestion --}
while ($NombreQuestion -ne 10 -and $NombreQuestion -ne 20 -and $NombreQuestion -ne 30)
$script:QTrandom=@()
cls
Write-host "Vous tombez nez a nez contre le terrible exam :"$script:QASujetName[$MBsub]
write-host "Pour le vaincre vous devrez repondre correctement a"($NombreQuestion/2) "Questions sur"$NombreQuestion
pause
for ($x=1; $x -le $NombreQuestion;$x++){
Question ($A=$QASujet[$MBsub])
if ($script:EtatA -eq 1){
write-host "Bravo !"
sleep 1
$scoretemp ++}
else {
write-host "Dommage"
sleep 1}
}
ecriture ($ecrit = "Le combat contre l'exam : "+ $QASujetName[$MBsub] + " est terminer !!")
sleep 2
if ($scoretemp -ge ($NombreQuestion/2)){
ecriture ($ecrit =  "Vous etes victorieux !")
sleep 1
[int]$Sauvegarde.Minibosscount[[int]$sauvegarde.minibossnumber] = $numb
[int]$Sauvegarde.MiniBossnumber += 1
if ($Sauvegarde.MiniBossnumber -eq 1){
$Sauvegarde.HeroKey[1] = 2
ecriture ($ecrit = "Vous obtenez une cle... que pourrait-elle ouvrir ?")
sleep 3
}
elseif ($Sauvegarde.MiniBossnumber -eq 2){
$Sauvegarde.HeroKey[2] = 3
ecriture ($ecrit = "Alors que l'exam disparait dans un nuage de vapeur... une cle tombe dans vos mains...")
sleep 3
}
elseif ($Sauvegarde.MiniBossnumber -eq 3){
ecriture ($ecrit = "un crie semble venir du plus profond de la terre...")
sleep 1
$Sauvegarde.HeroKey[3] = 4
ecriture ($ecrit = "Une nouvelle cle.... a quoi sert-elle ?")
sleep 3
}
}
else{
write-host "Vous avez echouez !"
defaite
}
}

Function Boss {
cls
ecriture ($ecrit = "Les murs tremblent !!")
ecriture ($ecrit = ".....")
sleep 2
cls
ecriture ($ecrit = "Le Seigneur de ce dongeon apparait dans un fracas !!")
sleep 2
cls
ecriture ($ecrit = " Seigneur Exam : Reussit mon test ou paie le de ta vie !")
sleep 3
cls
"3"
sleep 1
cls
"2"
sleep 1
cls
"1"
sleep 1
cls
$script:QTrandom=@()
$Bosspoint = 0
$Bosscount = 0
for ($x=0;$x -lt $script:QASujet.count;$x++){ 
$Tempo = $QA | Where-Object {$_.idm -match $script:QASujet[$x]}
for ($y=0;($y -lt $tempo.count) -and ($y-lt 5);$y++){
$Bosscount ++
Question ($A=$QASujet[$x])
if ($script:EtatA = 1){$Bosspoint++}
else{}
}
}
cls
ecriture ($ecrit = ".....")
ecriture ($ecrit = "L'Exam te regarde...")
sleep 1.5
cls
ecriture ($ecrit = "Il juge ton niveau...")
sleep 1
$resultat = [Math]::Round(($Bosspoint/$Bosscount)*20,1)
if ($resultat -ge 10) {
ecriture ($ecrit = "....")
ecriture ($ecrit = "Ton score est de...")
ecriture ($ecrit = [string]$resultat + " sur 20")
sleep 2
cls
ecriture ($ecrit = "vous avez reussit a passer le test ultime...")
ecriture ($ecrit = "Vous avez conquis ce royaume !")
sleep 3
$script:Boss = 0
cls
}
else {
ecriture ($ecrit = "...")
ecriture ($ecrit = [string]$resultat +" point... ce n'est pas suffisant...")
ecriture ($ecrit = "Retournez donc vous entrainer...")
sleep 1
defaite
}
}

Function Sauvegarde {
clear-content -path $Location\Sauvegarde\Save.txt
clear-content -path $Location\Sauvegarde\Event.txt
set-content -Path $Location\sauvegarde\Event.txt -Value $FirstEvent
$sauvegarde.Values | ForEach-Object{
add-content -Path $Location\Sauvegarde\Save.txt -Value $_
}
}
cls
#On débute avec la fonction accueil
Accueil