function Salleduchoix {
cls
ecriture ($ecrit= "Trois porte devant vous...")
sleep 1
ecriture ($ecrit="Un seul choix...")
sleep 1
cls
ecriture ($ecrit="Qu'elle porte souhaitez vous franchir ?")
sleep 1
do {

ecriture ($ecrit="1 - La Salle de l'Ame")
ecriture ($ecrit="2 - La Salle de la Vie")
ecriture ($ecrit="3 - La Salle de la Guerre")
$reptemp = Read-Host "Reponse "
cls
}
while ( (1,2,3) -notcontains [int]$reptemp)
switch ($reptemp){
1 {[int]$global:Sauvegarde.niveau += 2
$global:Sauvegarde.xp = [int]$HeroLvl.exp[[int]$Sauvegarde.niveau]
ecriture($ecrit="Vous entrez dans la Salle de L'Ame")
ecriture($ecrit="Vous sentez l'energie de la piece augmenter")
ecriture($ecrit="...")
sleep 1
cls
sleep 1
ecriture($ecrit="...")
sleep 1
cls
ecriture($ecrit="Vous prenez 2 niveau !!")
ecriture($ecrit="Vous etes maintenant niveau "+$Sauvegarde.niveau+" !!")
sleep 1
cls
ecriture($ecrit="Votre stats augmente !")
ecriture($ecrit="Points de Vie : " +$HeroLvl.HP[$Sauvegarde.niveau])
ecriture($ecrit="Points de Degats : "+$HeroLvl.DMG[$Sauvegarde.niveau])
sleep 1
cls
}
2 {
cls
ecriture($ecrit="Un autel trone seul")
ecriture($ecrit="en plein milieu de la salle....")
sleep 2
cls
ecriture($ecrit="Poser sur son plateau, un Coeur entourer de cable electrique,")
ecriture($ecrit="bat encore fortement...")
sleep 2
cls
ecriture($ecrit="A peine rapprocher du coeur, ce dernier se jette sur vous !")
ecriture($ecrit="Vous perdez connaissance....")
sleep 2
cls
ecriture($ecrit="........")
sleep 2
cls
ecriture($ecrit="Vous vous reveillez... ")
ecriture($ecrit="vous venez de fusionner avec ce Coeur")
sleep 2
cls
ecriture($ecrit="Vous portez maintenant la marque des maudits.")
ecriture($ecrit="Mais vous vous sentez plus puissant qu'avant !")
sleep 2
cls
newloot($loota = 17)
}
3 {
cls
ecriture ($ecrit="La Salle de la Guerre est désordonnée et l'air presque irrespirable")
ecriture ($ecrit="Une tablette en pierre flottant au milieu de la salle")
ecriture ($ecrit="affiche des inscriptions gravées")
sleep 1
cls
ecriture ($ecrit="Sans meme connaitre la langue, les mots vous viennent naturellement")
sleep 1
cls
ecriture ($ecrit="EkZar It LuMshaK !!!")
sleep 1
cls
ecriture ($ecrit="....")
sleep 1
ecriture ($ecrit="Tout les objets qui vous entoures, les epees et boucliers présent dans la pieces")
ecriture ($ecrit="se mettent tout a coup a tournoyer autour de vous !")
sleep 1
cls
ecriture ($ecrit="Soudain, tout disparait...")
ecriture ($ecrit="Vous sentez votre sang bouillonnant")
sleep 1
cls
ecriture ($ecrit="Vous venez de revetir l'enchantement de feu !")
newloot($loota=18)
}
}
cls
ecriture ($ecrit="A peine remis de ce qu'il vient de se passer")
ecriture ($ecrit="Vous sentez une force qui vous ejecte de la piece")
ecriture ($ecrit="Vous entendez un verrou se refermer")
sleep 1
cls
ecriture ($ecrit="Les portes semblent s'etre scellees pour toujours...")
sleep 2
}