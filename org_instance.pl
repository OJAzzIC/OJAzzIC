%org_instance.pl
%eventually will have a separate org_instance file for each org: -medic org and officer org and global system org?
% plan and activeplan added by KKEOGH

%responsible_org(Org, Obj, Scene, Role) in organizational_reasoning defines that the org has objective Obj, 
% with organizational members with the responsible role to fulfill this objective


%org(Org, Objlist, Memberlist, Rolelist, CurrPlanID, BeliefSet ) Defines an organization 
%hard code create org for each of 2 core organizations - medicOrg and officerOrg and 1 combinedOrg
%07092017 set up default knowledge that all medic agents are avail, add next 5 lines for situation when there is no orgs
avail(medic1).
avail(medic2).
avail(medic3).
avail(medic4).
avail(medic5).
%23012017 comment out next line so that there is no medicOrg as such
%07092017 org(medicOrg, [injuredRescuedLmk], [medic1,medic2,medic3,medic4,medic5], [medic], [injuredRescuePlan], [orgname(medicOrg)]).  %31032017 added medic5
%org(medicOrg, [injuredRescuedLmk], [medic1,medic2,medic3], [medic], [injuredRescuePlan], [orgname(medicOrg)]).
%org(medicOrg, [injuredRescuedLmk], [medic1,medic2], [medic], [injuredRescuePlan], [orgname(medicOrg)]).
%org(medicOrg, [injuredRescuedLmk], [medic1,medic2,medic4], [medic], [injuredRescuePlan], [orgname(medicOrg)]).
%org(medicOrg, [injuredRescuedLmk], [medic1,medic2], [medic], [injuredRescuePlan], [orgname(medicOrg)]).
%org(officerOrg, [injuredLocatedLmk, blockingBystanderRemovedLmk, fightLocatedLmk, fightStoppedLmk], [officer1,officer2,officer3], [officer], [injuredLocPlan,blockingBystanderRemovedPlan,fightLocatedPlan,fightStoppedPlan], [orgname(OfficerOrg)]).
org(officerOrg, [blockingBystanderRemovedLmk, fightLocatedLmk, fightStoppedLmk], [officer1,officer2,officer3], [officer], [blockingBystanderRemovedPlan,fightLocatedPlan,fightStoppedPlan], [orgname(OfficerOrg)]).
%23012017 comment out next line so that there is no combinedOrg as such %31032017 uncomment next line so combinedOrg exists again
%07092017 org(combinedOrg, [blockingBystanderRemovedLmk,injuredLocatedLmk], [medic1, officer1], [medic,officer], [blockingBystanderRemovedPlan,injuredLocPlan], [orgname(combinedOrg)]).

% to do test if you create a plan incorporating 2 ordered landmarks see if it works

%plan(planID, landmarkId-Objective, subTaskStates, taskList)
plan(injuredLocPlan, injuredLocatedLmk, [checkedRooms, injuredLocated], injuredLocatedGoal).
%kk added (_) after injured on next line 16062014
plan(injuredRescuePlan, injuredRescuedLmk, [not(injured(_))], injuredRescuedGoal).
plan(blockingBystanderRemovedPlan, blockingBystanderRemovedLmk, [blockingBystanderRemoved], blockingBystanderRemovedGoal).
 
plan(fightLocatedPlan, fightLocatedLmk, [checkAreas, fightloc], fightLocatedGoal).
plan(fightStoppedPlan, fightStoppedLmk, [not(fightloc)], fightStoppedGoal).

plan(rescueOnStretcherPlan, rescueOnStretcherLmk, [not(injured(_))], injuredRescuedGoal).
plan(rescueOnStretcherPlan, rescueOnStretcherLmk, [not(injured(_))], rescueOnStretcherGoal).   %02012015
%Todo, this should be created dynamically as belief by org ? or as agents consider and adopt landmark goals then they update their beliefs re: active plan?
% activeplan(planID, [task-Obj, agentResponsible-either rea-role or agent] )


% landmark(LId-Objective, subTaskOutcomesList, RequiredCapabilitiesList)
landmark(injuredLocatedLmk, [checkedRooms, injuredLocated], [at(Ag,_), injured(Ag)]).
%landmark(injuredLocatedLmk, [checkedRooms, injured], [at(Ag,_), injured(Ag)]).
%changed not(injured) to not(injured(_)) on next line kk 16062014, should it instead by injuredRescued
landmark(injuredRescuedLmk, [not(injured(_))], [holds(Ag), injured(Ag), at('DropZone')]).
landmark(blockingBystanderRemovedLmk, [blockingBystanderRemoved], [not(at(_,_))]).
landmark(fightLocatedLmk, [checkedAreas, fightloc], [fight(_)]).
%landmark(fightLocatedLmk, [fightLocated], [fight(_)]).
landmark(fightStoppedLmk, [not(fightloc)], [fight(X), not(at(_,X))]).
%landmark(fightStoppedLmk, [fightStopped], [fight(X), not(at(_,X))]).

%uncomment next line if want to test rescue on stretcher as a landmark objective (can be chosen by capability matching)
landmark(rescueOnStretcherLmk, [onStretcher(Ag), in('DropZone')], [onStretcher(Ag), carryStretcher(Ag,O,L1,L2), at('DropZone')]). 
%concurrent_tasks(onStretcher(Ag),carryStretcher(Ag)).

% before(LId1, LId2)
before(injuredLocatedLmk, injuredRescuedLmk).
before(fightLocatedLmk, fightStoppedLmk).
%03012017 added next line
before(injuredLocatedLmk, rescueOnStretcherLmk).

% role(RId, ObjectiveList)
role(medic, [injuredLocatedLmk,injuredRescuedLmk,blockingBystanderRemovedLmk,rescueOnStretcherLmk]).
%role(medic, [injuredLocatedLmk,injuredRescuedLmk,blockingBystanderRemovedLmk,rescueOnStretcherLmk]).
%29102016 added injuredLocatedLmk to role list for officer
role(officer, [injuredLocatedLmk,fightLocatedLmk,fightStoppedLmk,blockingBystanderRemovedLmk]). %KK added blockingBystanderRemoved to Obj list for officer to test initiative of officer
role(bystander, []).
role(injured, []).

% scene(SId, RoleList, ResultList)
scene(stopFightSc, [officer,bystander], [fightStoppedLmk,fightLocatedLmk]).
scene(rescueInjuredSc, [medic,injured,officer,bystander], [injuredLocatedLmk,injuredRescuedLmk,blockingBystanderRemovedLmk,rescueOnStretcherLmk]).

% dependency(RId1, RId2, ObjectiveList, DepType)
dependency(medic, officer, [injuredLocatedLmk], network).
dependency(officer, medic, [fightLocatedLmk], network).
dependency(medic, officer, [blockingBystanderRemovedLmk], hierachical).
dependency(medic, injured, [injuredLocatedLmk, injuredRescuedLmk, rescueOnStretcherLmk], network).
dependency(officer, bystander, [fightLocatedLmk], market).
dependency(officer, bystander, [fightStoppedLmk], hierachical).
