inm:{[labelsinnode]if[0=(count labelsinnode);0];p:sum over (1=labelsinnode);n:sum over (0=labelsinnode); $[p>n;n;p]}
fbf:{[f;t;besterror;bestfeature;bestl;bestr;i]leftsplit:fdata[f[i]]=0;rightsplit:fdata[f[i]]=1;error:(inm[leftsplit]+inm[rightsplit])%(count fdata);if[error<=besterror;besterror:error;bestfeature:f[i];bestl:leftsplit;bestr:rightsplit];$[(i+1)>=(count f);(bestfeature;bestl;bestr);fbf[f;target;besterror;bestfeature;bestl;bestr;i+1]]}
createleaf:{[targetvalues]leaf:("none";"none";"none";1);num1s:count where targetvalues = 1;numm1s:count where targetvalues = -1;$[num1s>numm1s;leaf:leaf,1;leaf:leaf,-1];leaf}


/ call preparedata here - to setup data
preparedata;;
f: cols fdata;target:`safeloans;besterror:10;bestfeature:"none";indx:0;
kumartree:{[master;data;f;target;besterror;bestfeature;indx]
  
  / some exit condition here
  if[inm[data[target]] = 0; :createleaf(data[target])]
  if[count f = 0;show "Stopping, no more features"; :(createleaf(data[target]))]

  show "------------";
  show master;
  temp:master[indx][0];

  splitdata:fbf[data;f;target;besterror;bestfeature;i:0];
  f:f[where f<>bestfeature];


  if[count splitdata[1] = count data;:createleaf(splitdata[1][target])] 
  if[count splitdata[2] = count data;:createleaf(splitdata[2][target])] 

  nxtl:enlist (temp,1)
  master:master,enlist(nxtl;splitdata[1]);
  kumartree[master;splitdata[1];f;target;10;"none"indx+1,temp]

  nxtr:enlist (temp,2)
  master:master,enlist(nxtr;splitdata[2]);
  kumartree[master;splitdata[2];f;target;10;"none"indx+1,temp]

  / return subtree here
  /is_leaf;bestfeature;left_tree;right_tree;prediction=0 - no prediction yet
  subtree:(0;bestfeature;splitdata[1];splitdata[2];0) 
  subtree
  };

splitdata:fbf[f: cols fdata;target:`safeloans;besterror:10;bestfeature:"none";bestl:0;bestr:0;i:0] / will return lspl and rspl too
head:enlist (1,splitdata[0],splitdata[1],splitdata[2]) / top level split

f: cols fdata;target:`safeloans;besterror:10;bestfeature:"none";indx:0
kumartree[head;fdata;f;target;besterror;bestfeature;indx] 
