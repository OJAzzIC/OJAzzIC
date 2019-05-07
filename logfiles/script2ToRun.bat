REM dir /s /b /o:n /ad > dir.txt  comment this line with REM after first creating the dir.txt file
for /F %%i in (dir4.txt) do (
cd %%i
echo %%i > summary2.txt
findstr /C:"may be applicable because condition bel(percept(color" /c:"insert(checked(P),checked(P))  holds" /C:"has been inserted into the belief base of GOAL agent " medic*.log | findstr "Room" | findstr "checked injuredLocatedAt color"  > checked6.txt
findstr /N /C:"checked('RoomB2') has been inserted into the belief base of GOAL agent" medic*.log > checkingB2.txt
findstr "pickedUp putDown" *beliefs.pl > rescues.txt
findstr "noticed" *beliefs.pl > notices.txt
findstr /C:"time" BW*.txt >> summary2.txt
findstr /C:"nroomsentered" BW*.txt >> summary2.txt
findstr /C:"idletime" BW*.txt >> summary2.txt
findstr /C:"gooddrops" BW*.txt >> summary2.txt
REM find /C   "string" filename.txt will find the string in the filename and produce a count of the number of lines it was found on
echo "count sent messages injuredLocated : " >> summary2.txt
findstr /C:"sent("  *beliefs.pl | find /C "injuredLocatedAt" >> summary2.txt
echo "count sent messages rescued : " >> summary2.txt
findstr /C:"sent("  *beliefs.pl | find /C "rescued" >> summary2.txt
echo "count sent messages adopt : " >> summary2.txt
findstr /C:"sent("  *beliefs.pl | find /C "adopt" >> summary2.txt
findstr "pickedUp putDown" *beliefs.pl >> summary2.txt
findstr "stretcher" *beliefs.pl >> summary2.txt
findstr "swap Swap" *beliefs.pl >> summary2.txt
findstr "delegated" *beliefs.pl >> summary2.txt
echo "belief about rescued" >> summary2.txt
findstr "rescued" *beliefs.pl >> summary2.txt
echo "reached in belief base" >> summary2.txt
findstr "reached" *beliefs.pl >> summary2.txt
findstr /C:"the goal base" medic*.log > goalsMedics.txt
findstr /C:"the belief base" medic*.log > beliefsMedics.txt
findstr /C:"the goal base" officer*.log > goalsOfficers.txt
findstr /C:"the belief base" officer*.log > beliefsOfficers.txt
findstr /C:"received(" medic*.log | findstr /C:"has been deleted" | findstr "rescued" > rescuedd.txt
echo done >> summary2.txt 
findstr "matched" *beliefs.pl > matchedGoalsconsidered.txt
findstr /N "collidedswap collisionswap collisionSwap collidedswapping" *beliefs.pl > collisions.txt
findstr /N "deletedaSP drop(aSP jumpingToagreedSP iwillGoInto okiwillwaitat stalledFLswap agreeadoptnolmk agreeToadopt iwillpickUp gotStretcher onStretcher" *beliefs.pl > roles.txt
findstr /N "onStretcherRescueunderway onStretcherRescuegoingahead stretcher coordinatingstretcherwith rescuedtogether initiatingnegotiationOfSharedPlan receivedDropSP" *beliefs.pl > stretcherinfo.txt
findstr /S "propose adopt" C:/"drop(aSP" *beliefs.pl  > proposalmails.txt
findstr /S "propose adopt" *beliefs.pl > proposalbeliefs.txt
findstr "delegated" *beliefs.pl > delegates.txt
findstr "clear" *beliefs.pl > clearRoom.txt
cd ..
)



