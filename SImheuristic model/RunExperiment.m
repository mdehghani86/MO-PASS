function z=RunExperiment(q,model)

global NFE;
NFE=NFE+1;

    fileName='Metaheuristic';
    ParseSolution(q,model,fileName);
    F=RunSimio(fileName);   
    %F=rand([1,5]);
    

    % F(2) LOS
    % F(3) Num of visited patients
    % F(4) OverTime
    
    
    if F(4)>0
        % if overtime is >0, remove the solution from pop
       F(2)=1000;
       F(3)=-1000;       
    end

    %     w1=-1/100;      % Average Utilization of hysicians
    %     w2=1/150;       % LOS
    %     w3=-1/90;       % Max Number of Patients
    %     w4=100;         % Overtime
 
    z=[F(2) -F(3)]';
end