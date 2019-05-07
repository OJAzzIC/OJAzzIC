REM dir /s /b /o:n /ad > dir.txt  comment this line with REM after first creating the dir.txt file
for /F %%i in (dir.txt) do (
cd %%i
echo %%i
findstr /C:"may be applicable because condition bel(percept(color" /c:"insert(checked(P),checked(P))  holds" /C:"has been inserted into the belief base of GOAL agent " medic*.log | findstr "Room" | findstr "checked injuredLocatedAt color"  > checked6.txt
findstr /N /C:"checked('RoomB2') has been inserted into the belief base of GOAL agent" medic*.log > checkingB2.txt
findstr "pickedUp putDown" *beliefs.pl > rescues.txt
findstr "noticed" *beliefs.pl > notices.txt
findstr /C:"nroomsentered" BW*.txt > summary.txt
findstr /C:"idletime" BW*.txt >> summary.txt
findstr /C:"gooddrops" BW*.txt >> summary.txt
findstr "matched" *beliefs.pl > matchedGoalsconsidered.txt
findstr /N "collidedswap collisionswap collisionSwap collidedswapping" *beliefs.pl > collisions.txt
findstr /N "deletedaSP drop(aSP jumpingToagreedSP iwillGoInto okiwillwaitat stalledFLswap agreeadoptnolmk agreeToadopt iwillpickUp gotStretcher onStretcher" *beliefs.pl > roles.txt
findstr /N "onStretcherRescueunderway onStretcherRescuegoingahead stretcher coordinatingstretcherwith rescuedtogether initiatingnegotiationOfSharedPlan receivedDropSP" *beliefs.pl > stretcherinfo.txt
findstr /S "propose adopt" C:/"drop(aSP" *beliefs.pl  > proposalmails.txt
findstr /S "propose adopt" *beliefs.pl > proposalbeliefs.txt
findstr "delegated" *beliefs.pl > delegates.txt
cd ..
)



