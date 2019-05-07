%org_reasoning.pl
% transitivity of landmarks
lt(L1, L2) :- before(L1,L2).
lt(LX, LZ) :- before(LX, LY), lt(LY, LZ).

% 1) Find active objectives
active_landmark_org(L, Org) :-
	org(Org, Objlist, Memberlist, Rolelist, CurrPlanID, BeliefSet ),
	member(L, Objlist), %this landmark is in the org's Objective list
	active_landmark(L).  
	% ? may need to also check L is in CurrPlanID for org?
	
active_landmark(L) :-
	setof(L1, lt(L1, L), List),
	setof(L1, (lt(L1, L), reached(L1)), List),
	\+ reached(L).  % active landmark  is not reached
active_landmark(L) :- before(L,_), \+ before(_, L), \+ reached(L).
active_landmark(L) :- landmark(L,_,_), \+ before(L,_), \+ before(_, L), \+ reached(L).

% 2) Who is responsible? (i.e. which role is responsible for Objective Obj in the Scene, Scene.
% Scenes include multiple roles (each may have a set of role objectives), scenes also include multiple Objectives that are matched to role objectives

% Org is responsible for objective Obj in Scene , note here that we only define org by roles, not direct agent members
responsible_org(Org, Obj, Scene, Role) :-
	org(Org, Objlist, Memberlist, Rolelist, CurrPlanID, BeliefSet ),  %memberlist contains agents that may each also be organizations
	scene(Scene, Roles, Ojbectives),
	member(Role, Rolelist),
	member(Obj, Objlist), %org has objective Obj
	responsible(Obj, Scene, Role).
	
% Role is responsible for Obj in Scene (when no organization is present)
responsible(Obj, Scene, Role) :-
	scene(Scene, Roles, Objectives),
	member(Role, Roles),
	member(Obj, Objectives),
	role(Role, RoleObjectives),
	member(Obj, RoleObjectives).
	
responsible_landmark(L, S, R) :-
	active_landmark(L),
	responsible(L,S,R).

%05092016
orgMember(Org,A) :- org(Org,Lmk,AgList,RoleList,PlanList,OrgNameList), member(A,AgList).

%05092016  if I am an orgMember of org O then myorg is org O
myorg(O) :- orgMember(O,M), me(M).

% Are [some or all] objectives of landmark achievable by me
capable_some(AgId, LId) :-
	agent(AgId,AgCap),
	landmark(LId,_,ReqCap),
	intersection(AgCap,ReqCap,[_|_]). % [_|_] is a non empty list
	
% list of agents who have all objectives of landmark achievable by their capabilities
% 24012017 added next rule 
agents_capableList (Alist, Lmk) :-
	bagof(A, capable_some(A, Lmk), Alist).
	
capable_all(AgId, LId) :-
	agent(AgId,AgCap),
	landmark(LId,_,ReqCap),
	intersection(AgCap,ReqCap,Caps),  %intersection set of capabilities
	msort(ReqCap,S), msort(Caps,S).   % sorted list S is common to both lists ReqCap and CaOrgps

%KKEOGH todo insert new rules here to define a composite landmark objective - comprising concurrent subtasks
capable_simultaneously(AgList,LId) :-
	member(AgId,AgList),
	member(OthAgId, AgList), OthAgId \= Agid,
	landmark(LId, SubTaskOutcomesList, ReqCapList),
	member(Task1ReqCap, ReqCapList),  
	member(Task2ReqCap, ReqCapList), Task2ReqCap \= Task1ReqCap,
	concurrent_tasks(Task1ReqCap, Task2ReqCap),  %Task1 and Task2 are concurrent, must be done together
    agent(AgId, AgCap), intersection(AgCap,Task1ReqCap),
	agent(OthAgId, OAgCap), intersection(OAgCap, Task2ReqCap).
	
	
%insert rule than an org may be considered an agent capable of Landmark LId
org_agent(Org, LId) :-
	org(Org, Objlist, Memberlist, Rolelist, CurrPlanId, BeliefSet),
	capable_together(Memberlist, LId).
	

% need a representation of a plan adopted by an org - with an active plan and allocated agents to each landmark in the plan	
	
%KKEOGH todo insert new rules here to define capable_together(AgId, AgOId, LId) to say an Agent AgId, together with agent AgOId can combine
% capabilities to achieve landmark LId (set it up so that AgOId may be an organizational agent
% not tested
capable_together(AgList, LId) :-
	landmark(LId,_,ReqCap),
	agent(OthAg, AgOthCap),
	agent(AgId,AgCap),
	AgId \= OthAg,  % check that AgId \= OthAg
	intersection(AgCap,AgOthCap,CommonCap),  % CommonCap is the list of common capabilities between OthAg and AgId
	%union(AgCap,AgOthCap, Caplist),
	%intersection(Caplist,ReqCap,[_|_]), % [_|_] is a non empty list
	member(AgId, AgList),
	member(OthAg,AgList).
	%msort(ReqCap,S), msort(Caplist,S),   % sorted list S is common to both lists ReqCap and Capslist
	


%KKEOGH todo insert new rules here to define policies for collaboration - who can i collaborate with? - agents in an organization with me
	
% who can I delegate to?
delegate_in_org(Org, Me, Objective, Scene, OtherAg, Type) :-
	org(Org, Objlist, Memberlist, Rolelist, CurrPlanId, BeliefSet), 
	member(Me, Memberlist), % I am in Org
	member(OtherAg, Memberlist), % Other agent is in Org
	% do i need to check Me \= OtherAg
	delegate(Me, Objective, Scene, OtherAg, Type). % my role can delegate to other agent role
	
	
delegate(Me, Objective, Scene, OtherAg, Type) :-
	rea(Me, MyRole, Scene),
	rea(OtherAg, OtherRole, Scene),
	dependency(MyRole, OtherRole, Objectives, Type),
	member(Objective, Objectives).
