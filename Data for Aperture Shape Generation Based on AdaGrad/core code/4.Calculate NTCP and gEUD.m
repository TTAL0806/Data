%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
global planC 
%%%%%%%%%NTCP1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structNum = [10   11  17];
a         = [8    8   -10];
D50       = [79   78];
m         = [0.17 0.14];
[doseBinsV1, volsHistV1] = getDVH(structNum(1), 1,planC);
[doseBinsV2, volsHistV2] = getDVH(structNum(2), 1,planC);

EUD1 = calc_EUD(doseBinsV1, volsHistV1, a(1))
EUD2 = calc_EUD(doseBinsV2, volsHistV2, a(2))

tmp1 = (EUD1 - D50(1))/(m(1)*D50(1));
ntcp1 = 1/2 * (1 + erf(tmp1/2^0.5))
tmp2 = (EUD2 - D50(2))/(m(2)*D50(2));
ntcp2 = 1/2 * (1 + erf(tmp2/2^0.5))