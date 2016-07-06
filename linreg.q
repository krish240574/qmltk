
/ Regression with gradient descent
rgd:{[w;f;op;tl;s;counter]p:f$w;
	show counter;
	e:p-op;
	d:(2*(flip f)$e)+(2*l2_p*w); / L2 - ridge regression derivative
	gss:sum (d*d);
	gm:sqrt gss; 
	show flip w; 
	$[(counter<niter);rgd[w-(s*d);f;op;tl;s;counter+1]; w]}	;

/ Read CSV for housing data.
  c:`id`date`price`bedrooms`bathrooms`sqft_living`sqft_lot`floors`waterfront`view`condition`grade`sqft_above`sqft_basement`yr_built`yr_renovated`zipcode`lat`long`sqft_living15`sqft_lot15;

  colStr:"SSFIFISSSSSSSSSSSSSII";
  .Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:kc_house_data.csv;

/ Prep data
  sz: count dataset;
  trsz:"i"$0.8*sz;
  tssz:trsz+ til (sz-trsz);
  tr:dataset[til trsz]; / training
  ts:dataset[tssz];
     
/ mult regression  
/ Initial weights
/ intercept, sqft_living, sqft_living15
  w:"f"$3 1 # -100000.0 1.0 1.0;
/ features
  f:"f"$tr[`sqft_living`sqft_living15];
/ constant column for intercept
  cc: "f"$(1 ,(count tr))  # 1.0;
  f:flip cc,f;
  op:"f"$tr[`price];
  tl:"f"$1e+009;
  s:"f"$1.0e-12;
  l2_p:0.0;
  counter:0;
  niter:1000;
  show "Calling rgd";
  w:rgd[w;f;op;tl;s;counter];
  show "Weights :"
  show flip w;

  / Test dataset features
  tf:"f"$ts[`sqft_living`sqft_living15];
  cc: "f"$(1 ,(count ts))  # 1.0;
  tf:flip cc,tf;

  preds:tf$w;
  err:preds - ts[`price];
  sqerr:sum (err*err);
  show "Sum of squared errors:"
  show sum sqerr;
