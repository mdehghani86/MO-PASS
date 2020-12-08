function F=RunSimio(fileName)
%% Part 1- Simio File Directory Information
    %1-1: The Directory that SIMIO file is located
        filePath='C:\Test\1-Metaheuristic';   
    %1-2: The name of SIMIO file (*.spfx) 
        fileName=strcat(fileName,'.spfx');
%% Part 2- Scenarios
        Scenarios=strcat('001;MD;1');
%% Part 3- Run Simio Experiment
    Results=RunExperiment(filePath, fileName,Scenarios); 

    Results_string=strsplit(Results{1},';');
    f1=  str2num(Results_string{1,3}(1:6))';
    f2=  str2num(Results_string{1,5}(1:6))*60;
    f3=  str2num(Results_string{1,7}(1:end));
    f4=  str2num(Results_string{1,9}(1:end));
    f5=  str2num(Results_string{1,11}(1:4)); 


    F=[f1,f2,f3,f4,f5];
%% Part 4- Please do not change this part
    function Results=RunExperiment(filePath, fileName,Scenarios)
    % ? Please do not change or modify this section ?
    
    % 4-1: Add path
        addpath(filePath)
    % 4-1 Clear the txt file content
        TXTfilePathName=strcat(filePath ,'\SimioLink.txt');
        fid=fopen(TXTfilePathName,'wt');
    % 4-2: Store required info in txt file
        %info=[filePath;fileName;Scenarions];
        fprintf(fid, '%s\r\n', filePath,fileName, Scenarios);
        fclose(fid);
        
    % 4-3: Run EXE File to run Experiment
        EXEfilePathName=strcat(filePath ,'\RunExperimentDLLMD.exe');
        system(EXEfilePathName);                
        Results=textread(TXTfilePathName,'%s');        
    end
end