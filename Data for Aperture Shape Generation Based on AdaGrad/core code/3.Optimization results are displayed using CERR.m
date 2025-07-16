global planC optimS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str = 'E:\Project\DAORes1.txt';
fid = fopen(str,'r+');%%
[a,count]=fscanf(fid,'%f');
status = fclose(fid);
%%%%%%%%%%%%%%%%%%%%
len = a(1);
x   = a(2:1:(len+1));
clear a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% <=======显示剂量分布=====================================================>
indexS = planC{end};
IM = planC{indexS.IM};

warning('More than one IM structure.  Using the last computed...')
IMIndex = length(IM);

IM = IM(IMIndex);  %takes the last computed plan.

structNamesC1 = {'PTV+6cm','PTV+5cm','Tissus sains'};%{'ptv2'};%{'PTV+6cm'};
dose3D = getIMDose1(IM.IMDosimetry, x,structNamesC1);%%%vseminales  prostate
showIMDose1(dose3D,'test-pc')
%put solution into planC
planC{indexS.IM}(IMIndex).IMDosimetry.solutions = x;