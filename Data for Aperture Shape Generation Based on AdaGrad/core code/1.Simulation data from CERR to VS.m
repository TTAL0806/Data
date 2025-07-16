global planC optimS
structNamesC = {'paroi vesicale','paroi rectale','ptv2','Tissus sains'};
%=========Match structure names to indices============%
indexS = planC{end};
%loop to match structure names
ind = indexS.structures;
numStructs = length(planC{ind});
for i = 1 : length(structNamesC)
  match = 0;
  for j = 1 : numStructs
    toMatch = structNamesC{i};
    if ischar(toMatch)
      strName = planC{ind}(j).structureName;
      if strcmpi(toMatch,strName)==1
        structIndicesV(i) = j;
        match = 1;
      end
    else
      strName = planC{ind}(j).structureName;
      if structIndicesV(i) == toMatch; %using number instead
          structIndicesV(i) == j;
          match = 1;
      end
    end
  end
  if match ~=1
    error('Structure not found')
  end
end
%<=======传输数据=============================================>
optimS.structIndicesV = structIndicesV;
%========Build the influence matrices===========%
IM = planC{indexS.IM};
if length(IM) > 1
  warning('More than one IM structure.  Using the last computed...')
  IMIndex = length(IM);
end
IMIndex = 1;
IM = IM(IMIndex);  %takes the last computed plan.
%<========================设置优化参数====================================>%
influall = [];
for i = 1 : length(structIndicesV)
  inflTmp    = getInfluenceM(IM.IMDosimetry, structIndicesV(i));
  optimS.inflTmp{structIndicesV(i)} = inflTmp;
  influall   = [influall;inflTmp];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OrgNum = length(structIndicesV);

TotalNum = 0;
for i = 1:1:OrgNum
    [OrgLen(i),BeamletNum]=size(optimS.inflTmp{structIndicesV(i)});
    TotalNum = TotalNum + OrgLen(i);
end
%%%%%%Save Information%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename='C:\Users\DELL\Desktop\Result\test1.bin';
hfile=fopen(filename,'w');
%%%For dose deposition matrix%%%%%%%
fwrite(hfile,BeamletNum,'int');
fwrite(hfile,TotalNum,'int');
fwrite(hfile,OrgNum,'int');
for i = 1:1:OrgNum
    fwrite(hfile,OrgLen(i),'int');
end

for i=1:1:OrgNum
    inflTmp = optimS.inflTmp{structIndicesV(i)};
    len = 0;
    for j = 1:1:BeamletNum
        Idex  = find(inflTmp(:,j) > 0);
        len   = len + length(Idex);
    end
    fwrite(hfile,len,'int');%%%total number of no-zero value
end

for i=1:1:OrgNum
    inflTmp = optimS.inflTmp{structIndicesV(i)};
    for j = 1:1:BeamletNum
        Idex  = find(inflTmp(:,j) > 0);
        len   = length(Idex);
        Value = full(inflTmp(Idex,j));
        fwrite(hfile,len,'int');
        fwrite(hfile,Idex - 1,'int');
        fwrite(hfile,Value,'double');
    end
end
%%%Beam information%%%%%%%%%%%%%%%
Beams        = IM.IMDosimetry.beams;
numDirection = length(Beams);%%%%%%%total beam directions 
numBealets   = zeros(1,numDirection);%%%%%the number of beamlets for each direction
for i = 1:1:numDirection
    DataSave      = Beams(1,i).DataSave;
    numBealets(i) = length(DataSave.rowPBV);%%%%beamlets for current direction
end
TotalBeamlets = sum(numBealets);%%%%total beamlets for all direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(hfile,numDirection,'int');%%1  directions
fwrite(hfile,TotalBeamlets,'int');%%2 beamlets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:1:numDirection
    DataSave      = Beams(1,i).DataSave;
    
    fwrite(hfile,DataSave.beamlet_delta_x,'double');%%3  delta x
    fwrite(hfile,DataSave.beamlet_delta_y,'double');%%4  delta y
    
    xaxislen      = length(DataSave.edges_x);%%%%the number of x edges
    fwrite(hfile,xaxislen,'int');%%5
    fwrite(hfile,DataSave.edges_x,'double');%%6
    
    yaxislen      = length(DataSave.edges_y);%%%%the number of y edges
    fwrite(hfile,yaxislen,'int');%%7
    fwrite(hfile,DataSave.edges_y,'double');%%8
      
   len = length(DataSave.rowPBV);
   fwrite(hfile,len,'int');%%11
   fwrite(hfile,max(DataSave.colPBV),'int');%%12
   fwrite(hfile,max(DataSave.rowPBV),'int');%%13
      
   fwrite(hfile,DataSave.colPBV,'int');%%14
   fwrite(hfile,DataSave.rowPBV,'int');%%15
  
   fwrite(hfile,DataSave.xPosV,'double');%%16 
   fwrite(hfile,DataSave.yPosV,'double');%%17  
   
   fwrite(hfile,DataSave.StartPBV,'int');%%10
   fwrite(hfile,DataSave.StartPos,'double');%%10
end
%%%End%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose(hfile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
