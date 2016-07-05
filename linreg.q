
\d .Kumar
/ Regression with gradient descent
rgd:{[w;f;op;tl;s]p:sum each f*\:w;
   e:p-op;
   d:2*(sum each(flip f)*\:e);
   gss:sum (d*d);	
   gm:sqrt gss;
   $[gm[0]>tl;rgd[w-(s*d);f;op;tl;s];w]
   }

\d .

/ Read CSV for housing data.
  c:`id`price`sqftliving`sqftliving15;
  colStr:"S F  I             I ";
  .Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:e.csv;

/ Prep data
  sz: count dataset;
  trsz:"i"$0.8*sz;
  tssz:trsz+ til (sz-trsz);
  tr:dataset[til trsz]; / training
  ts:dataset[tssz];

/ mult regression
/ Initial weights
  w:3 1 # -100000., 1., 1.
/ features
  f:tr[`sqftliving`sqftliving15]
/ constant column for intercept
  c: 1 17290  # 1;
  f:flip c,f;
  op:tr[`price]
  tl:1e+009
  s:4.0e-12
  w:.Kumar.rgd[w;f;op;tl;s]
  show flip w


