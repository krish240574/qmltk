
pi:acos -1

nor:{$[x=2*n:x div 2;raze sqrt[-2*log n?1f]*/:(sin;cos)@\:(2*pi)*n?1f;-1_.z.s 1+x]}

c:`URI`name`text;
colStr:"SSS";
.Q.fs[{`wiki insert flip c!(colStr;",")0:x}]`:people_wiki.csv;

//
numDocs:50;
wiki:wiki[til numDocs];
s:string wiki[`text];
spl: " " vs 's ;
gt: group each spl;

tmp:value each count each 'gt;

kspl:key each  group each  spl;

tf:{(enlist each kspl[x]),'tmp[x]}each til count tmp;

df: count each group raze kspl;

q:count each kspl;
h:til numDocs;
hehe:raze q#'h;
hehe:([]locations:hehe);
f:jt2t1,'hehe;
tfidf:([]tfidf:f[`tf]*(log numDocs%f[`v]))
f:f,'tfidf;

f1:([loc]k:f[`k];v:f[`v];tf:f[`tf];tfidf:f[`tfidf])

r:raze tf;
t1:([]k:r[;0];tf:r[;1])
t2:([]k:key df;v:value df)

jt2t1:ej[`k;t2;t1]


/ rnos: ((count dr),16)#nor ((count dr)*16);
/ nc:sum (-1#count oo[0]);
/ corpus:flip "f"$oo[;2+til(nc-2)];
/ dotprod:corpus $ rnos;
/ tmp:raze dotprod;
/ tmp[where tmp>0]:1.0;
/ tmp[where tmp<0]:0.0;
/ dotprod:((count dr),16)#tmp;
/ bni:sum each(2 xexp reverse (til 16)) */: dotprod;







