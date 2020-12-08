function ParseSolution(q,model,fileName)
PatientsMix=model.PatientsMix;                  % Patient Mix Distribution
PatientsMixCum=model.PatientsMixCum;            % Cumlative Distribution of Patients 
nPatients=model.nPatients;                      % Total Number of Patients   
InterarrivalTimes=model.InterarrivalTimes;      % Possible Interarival Time of Patients
Phyciation_Types=model.Phyciation_Types;        % Number of Physicians
Patients_Physician=model.Patients_Physician;    % Number of Patient for each Physician
nPhysicians=model.nPhysicians;
fileName=strcat(fileName,'.xlsx');
%% Form Patients info
Patient.Type=[];            % Patient Type
Patient.PhysicianType=0;    % Physician Type
Patient.IA=0;               % Patient InerArrival Time

Patients=repmat(Patient,nPatients,1);

% Determine the Patient Type
for i=1:nPatients   
    % Determine Patient Type
    if q(i)<PatientsMixCum(1)
        Patients(i).Type=1;
    elseif q(i)<PatientsMixCum(2)
        Patients(i).Type=2;
    else
        Patients(i).Type=3;
    end   
    
    % Determine PhysiciationType
    Patients(i).PhysicianType=Phyciation_Types(i);
end
q(q<0)=0.01;

%Determine Patients Interarrival Time
p=q(nPatients+1:end);             % random number to generate timer inervals
k=size(InterarrivalTimes,2);        % total possible time intervals

% Creating the Time Intervals Matrix
InterArrivals=reshape(InterarrivalTimes(min(floor(p*(k)+1),k)),[3,3]);

% Determine Patients Arrival time for each physician
for m=1:nPhysicians
    for k=nPhysicians+m:nPhysicians:nPatients
        i=Patients(k-nPhysicians).Type;
        j=Patients(k).Type;
        Patients(k).IA=InterArrivals(i,j);
    end
end
%% Upadate Excel File

% Write Patients Arrival Time
A=[Patients.IA]';

sheet='MatlabInput';
xlRange='C2';
xlswrite(fileName,A,sheet,xlRange)

% Write Patients Type
B=[Patients.Type]';
xlRange='D2';
xlswrite(fileName,B,sheet,xlRange)

% Write Patients PhysiciationType
C=[Patients.PhysicianType]';
xlRange='E2';
xlswrite(fileName,C,sheet,xlRange)
end