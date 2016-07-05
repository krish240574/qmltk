
\d .Kumar
out:{x}
prepdata:{[k]
  sz: count k;
  trsz:"i"$0.8*sz;
  tssz:trsz+ til (sz-trsz);
  tr:k[til trsz]; / training
  ts:k[tssz]; / test 
  w:2 1#-47000.0 1.0; / initial weights
  f:tr[`sqftliving];
  c: 17290 1 # 1;
  f:c,'f;
  (tr;ts;f;w)}
  
/ Regression with gradient descent
rgd:{[w;f;op;tl;s]p:sum each f*\:w;
   e:p-op;
   d:2*(sum each(flip f)*\:e);
   gss:sum (d*d);	
   gm:sqrt gss;
   $[gm[0]>tl;rgd[w-(s*d);f;op;tl;s];w]
   }

\d .

/ Prep data code here

/ Read CSV for housing data.
c:`id`price`sqftliving`sqftliving15;
colStr:"S F  I             I ";
.Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:e.csv;
initdata:.Kumar.prepdata[dataset]

/w:initdata@3
/f:initdata@2
/tr:initdata@0
/op:tr[`price]
/tl:2.5e+007
/s:7.0e-012
/w:.Kumar.rgd[w;f;op;tl;s]
/show flip w


/ mult regression
/ Initial weights
w:3 1 # -100000., 1., 1.
/ train data
tr:initdata@0
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


