
lasso:{[i;ctr1]
      / Cycle through each weight
      / calculate ro, for each weight
      / update weight by lambda rule
      /show i;
      oldwt:w[i];
      
      ns:shape normtr;
      prediction:(count normtr)#(normtr)$(w);
      prediction[where prediction=0n]:0.0; 
      temp:sum each normtr[;i]*\:w[i];

      roi:sum over(normtr[;i]*(o-prediction+temp));
      show i;
      newweighti:0.0;
      if[i = 0;newweighti:roi];
      if[i>0; if[roi<(-1*l1penalty)%2.0;newweighti:roi+(l1penalty%2.0)];
               if[roi>l1penalty%2.0;newweighti:roi-(l1penalty%2.0)]] ;

      w[i]:newweighti; / update weight[i]
      show roi, newweighti;
      ctr2:ctr1;
      if[(oldwt-newweighti)<tolerance;ctr2:ctr1+1];
      $[i<(-1+count w);lasso[i+1;ctr2];ctr2]
      };

lassodriver:{[vbl]show "lasso";
  ret:lasso[0;0];
  /show ret;
  $[ret<(count w);lassodriver[0];show "lasso finished"]
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

/ intercept
  cc: "f"$(1 ,(count tr))  # 1.0;

/ features to be normalized
f:`bedrooms`bathrooms`sqftliving`sqftlot`floors`waterfront`view`condition`grade`sqftabove`sqftbasement`yrbuilt`yrrenovated`zipcode`lat`long`sqftliving15`sqftlot15;
/f:`sqftliving`bedrooms`sqftliving15;
nf:count f;
t:flip cc,tr[f];
t:t[til 6500];
d:(1,nf+1)#sqrt(sum "j"$t*t);
normtr:flip {t[;x]%(sum d[;x])}each til (nf+1) ;
ctr:0;
w:"f"$(nf+1)#0; / initial weights
o:tr[`price];
o:o[til 6500];
l1penalty:1e+07;
tolerance:1.0;
lassodriver[0];

/ testing dataset
cc: "f"$(1 ,(count ts))  # 1.0;
t:flip cc,ts[f];
t:t[til 3000];
d:(1,nf+1)#sqrt(sum "j"$t*t);
normts:flip {t[;x]%(sum d[;x])}each til (nf+1);

p:sum each normts*\:w;
o:ts[`price]
o:o[til 3000];

err: p-o;
sumsqerr: "j"$sum (err*err);
show sum sumsqerr;
