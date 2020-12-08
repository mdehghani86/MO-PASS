clc;
clear;
close all;
t = datetime('now');

%% Problem Definition

global NFE;
NFE=0;

model=CreateModel;
CostFunction=@(x) RunExperiment(x,model);  % Cost Function

nVar=model.nVar;                % Number of Decision Variables

VarSize=[1 nVar];               % Size of Decision Variables Matrix

VarMin=0;                       % Lower Bound of Variables
VarMax= 1;                      % Upper Bound of Variables
%% MOPSO Parameters

MaxIt=20;            % Maximum Number of Iterations

nPop=30;             % Population Size

nRep=15;             % Repository Size

w=0.5;              % Inert ia Weight
wdamp=0.99;         % Intertia Weight Damping Rate
c1=1;               % Personal Learning Coefficient
c2=2;               % Global Learning Coefficient

nGrid=5;            % Number of Grids per Dimension
alpha=0.1;          % Inflation Rate

beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.1;             % Mutation Rate

%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];

pop=repmat(empty_particle,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    pop(i).Velocity=zeros(VarSize);
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
    
    % Update Personal Best
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    
end

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        leader=SelectLeader(rep,beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        pop(i).Cost = CostFunction(pop(i).Position);
        
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
        NewSol.Cost=CostFunction(NewSol.Position);
        if Dominates(NewSol,pop(i))
            pop(i).Position=NewSol.Position;
            pop(i).Cost=NewSol.Cost;
            
        elseif Dominates(pop(i),NewSol)
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
            end
        end
        
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
            end
        end
        
    end
    
    pop=DetermineDomination(pop);
    
    % Add Non-Dominated Particles to REPOSITORY
    rep=[rep; pop(~[pop.IsDominated])];
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);

    % Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        
    end
    
%     Plot Costs
    figure(1);
    PlotCosts(pop,rep);
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of Rep Members = ' num2str(numel(rep))]);
    
    % Damping Inertia Weight
    w=w*wdamp;
    
end

%% Resluts
t2 = datetime('now')-t;
disp(t2);
%Play music
filename= 'Ship.wav';
[y,Fs] = audioread(filename);
sound(y,Fs);



















