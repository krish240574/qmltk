
c:`URI`name`text;
colStr:"SSS";
.Q.fs[{`wiki insert flip c!(colStr;",")0:x}]`:people_wiki.csv;
//
numDocs:100;
wiki:wiki[til numDocs];
s:string wiki[`text];
spl:{" " vs s[x]}each til count wiki;

kspl:{key group spl[x]}each til count wiki;
gspl:{count each value group spl[x]}each til count wiki;
tf:{(enlist each kspl[x]),'gspl[x]}each til count gspl;

dr:distinct raze kspl;

lc:{dr in kspl[x]}each til count kspl;
o:(enlist each dr), ' sum lc;
 
fl:flip lc;
efl:where each fl;
o:o,'enlist each efl;

oo:(enlist each o[;0]),'(enlist each o[;1]),'flip {sum each x=o[;2]}each til numDocs;
fino:{oo[where "b"$oo[;x]][;0 1]}each (2+til numDocs);

tfidf:tf[;;1]*(log numDocs%fino[;;1]);

rt:raze tfidf
rt[where rt=0]:1.0

shp:shape each tfidf
reshp:{shp[x] # rt[x]}each til count tfidf
atlast:{(enlist each kspl[x]),'reshp[x]}each til numDocs

