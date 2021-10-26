<#  Projet BR
    Copyright (C) 02/07/2021 Roland Meunier

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

$Location = Get-Location
$QA=Import-Csv -path $Location\Questions.csv -Delimiter ";"
$reponse = 0
$script:ReScore = Get-Content -Path $Location\score\RevisionScore.txt
$script:RePB = Get-Content -Path $Location\score\RevisionPB.txt
$script:Points = 0
$script:Pcounts = 0
#Question Random
$script:Qrandom = 0
$script:Mrandom = 0
$script:Nchoix = 0
$script:EtatA = 0
$script:Etat = 0
[string]$script:QTrandom=@()
$script:HeroName = Get-Content -Path $Location\Hero\Nom.txt
$script:QASujet = @()
$script:QASujetName = @()
for ($x=0;$x -lt $QA.count;$x++){
if ($script:QASujet -notcontains $QA[$x].Letters){
$script:QASujet += $QA[$x].Letters
$script:QASujetName += $QA[$x].Fullname
}
}

function Accueil {
Namaewa
Write-Host "Bienvenue dans Projet BR" $script:HeroName
pause
cls
write-host "Votre précédent score est de" $ReScore "Points ! Bravo !"
pause
cls
"Prêt ? c'est partit !"
pause
choix
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
}
}

function choix {
cls
write-host ("Choisir la matière ou toute les matières ensemble ?")
$a = read-host "1 : Choix de la matière :"`n"2 : Toutes les matières ensemble"
if ($a -eq 1) {
matiere
}
else{
Briposte
}
}

function matiere {
cls
do {
do {
for ($x=0;$x -lt $script:QASujet.count;$x++){
write-host ($x+1) ":" $script:QASujetName[$x]
}
[int]$c = read-host "Réponse"
}
while (1..$QAsujet.count -notcontains $c)
$A = $QAsujet[$c-1]
Question($A)
if ($EtatA -eq 2) {
$ty = $QAtemp.Answer-1
$to = "panswer"+$ty
cls
write-host "Aie mauvaise réponse !"
write-host
write-host "La bonne réponse etait : "
write-host
write-host $QAtemp.$to
write-host
pause
$script:Pcounts ++
}
elseif ($EtatA -eq 1){
$ty = $QAtemp.Answer-1
$to = "panswer"+$ty
cls
write-host "Bonne réponse !!"
write-host
write-host $QAtemp.$to
write-host
pause
$script:Points ++
$script:Pcounts ++
}
else {
write-host "error"
}
}
while ($script:Pcounts -ne ($script:TempCount))
score
}

function question {
param($A)
cls
do {
$B = $QA.IDM | Where-Object {$_ -match $A}
$script:TempCount = $B.count
$Qrandom = Get-Random -Minimum 0 -Maximum $B.count
[string]$QuestionID = $B[$Qrandom]
}
while ($QTrandom -match $QuestionID)
$script:QTrandom += $QuestionID
do {
cls
$script:QAtemp = $QA |Where-Object {$_.IDM -eq $QuestionID}
write-host $QAtemp.question
$reponse = read-host "1 : " $QAtemp.Panswer0 `n"2 : " $QAtemp.Panswer1 `n"3 : " $QAtemp.Panswer2 `n"4 : " $QAtemp.Panswer3 `n"Réponse"
}
while ($reponse -notmatch "[1-4]")
cls
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

function score {
cls
write-host "Ton score est de : " $script:Points "/" $script:Pcounts
write-host
write-host "Fellicitation !"
pause
$script:Points | Set-Content -Path $Location\score\RevisionScore.txt 
$script:Points = 0
$script:Pcounts = 0
Choix
}

function riposte {
cls
$script:EtatA = 0
$script:Pcounts ++
$A =($script:QASujet) | get-random | % {[char]$_}
Question($A)
if ($EtatA -eq 2) {
$ty = $QAtemp.Answer-1
$to = "panswer"+$ty
cls
write-host "Aie mauvaise réponse !"
write-host
write-host "La bonne réponse etait : "
write-host
write-host $QAtemp.$to
write-host
pause
cls
}
elseif ($EtatA -eq 1){
cls
write-host "Bonne réponse !!"
pause
$script:Points ++
}
else {
write-host "error"
}
}

function briposte {
do {
cls
riposte
}
while ($script:Pcounts -ne 20 )
Write-host "Fellicitation tu à obtenue un score de "$script:Points"/20 !"
pause
set-content -Path $Location\score\RevisionScore.txt -Value $script:Points
$script:ReScore = Get-Content -Path $Location\score\RevisionScore.txt
$script:RePB = Get-Content -Path $Location\score\RevisionPB.txt
if ($script:ReScore -gt $script:RePB) {
cls
"Wow bravo tu as battu ton précedent meilleur score qui etait de :"
write-host " " $script:RePB "/ 20" -ForegroundColor Yellow
set-content -Path $Location\score\RevisionPB.txt -Value $script:Points
}
else {}
Choix
}

cls
Accueil