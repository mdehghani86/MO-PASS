function model=CreateModel
clear;
clc;

%% Patient Info
PatientsMix=[0.45, 0.30, 0.25];             % Follow-up SecondOpinion Consult
PatientsMixCum=cumsum(PatientsMix);             % Cumlative Distribution of Patients 

Types=size(PatientsMix,2);                  % Total Patient Types
Patients_Physician=30;                      % Total Number of Patients for each phycisian
nPhysicians=3;                              % Total Numbr of Physicians
nPatients=nPhysicians*Patients_Physician;	% Total Number of Patients
InterarrivalTimes=10:10:60;                   % Possible InterArrivalTimes
nVar=nPatients+Types^2;                 % Determine Patient Type Phycisian Type + InterArrival Times

% Phyciation_Types=randi([1,nPhysicians],1,nPatients);
%Phyciation_Types=[2,1,1,1,2,3,2,2,3,2,3,1,1,3,2,1,1,2,2,2,3,1,2,2,2,2,3,2,3,1,2,2,3,1,3,2,2,3,2,1,1,2,1,2,3,2,1,3,3,2,1,3,1,1,3,1,1,3,3,1,2,3,3,2,3,3,3,1,3,2,1,3,1,2,3,3,1,1,2,2,1,2,1,1,2,3,1,1,3,3];
Phyciation_Types=repmat(1:nPhysicians,1,Patients_Physician);
%% Capsulate model
model.PatientTypes=Types;
model.PatientsMix=PatientsMix;
model.nPatients=nPatients;
model.InterarrivalTimes=InterarrivalTimes;
model.nVar=nVar;
model.Patients_Physician=Patients_Physician;
model.nPhysicians=nPhysicians;
model.Phyciation_Types=Phyciation_Types;
model.PatientsMixCum=PatientsMixCum;
end