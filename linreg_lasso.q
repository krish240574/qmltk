
lasso:{[i;ctr1]
      / Cycle through each weight
      / calculate ro, for each weight
      / update weight by lambda rule
      oldwt:w[i];
      ns:shape normtr;
      prediction:(count normtr)#normtr$(w);
      prediction[where prediction=0n]:0.0; 
      temp:((ns[0],1)#normtr[;i])$(1,ns[1])#w;
      roi:sum over (normtr[;i]*(o-prediction+(temp)));
      newweighti:0.0;
      if[i = 0;newweighti:roi];
      if[roi<(-1*l1penalty)%2.0;newweighti:roi+l1penalty%2];
      if[roi>l1penalty%2.0;newweighti:roi-l1penalty%2];
      w[i]:newweighti; / update weight[i]
      if[(oldwt-newweighti)<tolerance;ctr1:ctr1+1];
      $[i<(count w[0]);lasso[i+1;ctr1];ctr1]
      };

lassodriver:{[tmp]ctr:0;ctr:lasso[0;ctr];
  $[ctr<(count w);lassodriver;show "lasso finished"]
 };

/ Read CSV for housing data.
  c:`id`date`price`bedrooms`bathrooms`sqftliving`sqftlot`floors`waterfront`view`condition`grade`sqftabove`sqftbasement`yrbuilt`yrrenovated`zipcode`lat`long`sqftliving15`sqftlot15;

  colStr:"SSFIFFFFFFFFFFFFFFIII";
  .Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:kc_house_data.csv;

  f:`price`bedrooms`bathrooms`sqftliving`sqftlot`floors`waterfront`view`condition`grade`sqftabove`sqftbasement`yrbuilt`yrrenovated`zipcode`lat`long`sqftliving15`sqftlot15;
  / cleanup code, in this dataset, only `long has 0Ni - so we get one value in r. Need to generalize this code for multiple columns
  r:f[where 0<>{count where dataset[;x]=0Ni}each f];
  tmp:dataset[r[0]];
  tmp[where tmp=0Ni]:0;
  dataset[r[0]]:tmp; 

/ Prep data
  sz: count dataset;
  trsz:"i"$0.8*sz;
  tssz:trsz+ til (sz-trsz);
  tr:dataset[til trsz]; / training
  ts:dataset[tssz];

/ features to be normalized
f:`bedrooms`bathrooms`sqftliving`sqftlot`floors`waterfront`view`condition`grade`sqftabove`sqftbasement`yrbuilt`yrrenovated`zipcode`lat`long`sqftliving15`sqftlot15;
nf:count f;
t:flip tr[f];
d:(1,nf)#sqrt(sum t*t);
normtr:flip {t[;x]%(sum d[;x])}each til nf ;
/g:flip (f!flip normtr); /table with normalized values

ctr:0;
w:"f"$(nf)#0; / initial weights
o:tr[`price];
l1penalty:1e+07;
tolerance:1.0;
lassodriver[0];

     
