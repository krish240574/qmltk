/ Reco system for movies, based on latent factors for movies and users. 

/ basic logic - associate movies with characteristics, associate users with preferences, map them to each other and 
/ missing values based on past actions and inferences from these past actions; i.e mappings from past actions
/ A typical model associates each user u with a user-factors vector xu <belongsto> Rf, and
/ each item i with an item-factors vector yi <belongsto> Rf
/ The prediction is done by taking an inner product, i.e., rˆui = (xu.T).yi;

/ For a given item i, the elements of yi
/ measure the extent to which the item possesses those factors,
/ positive or negative. For a given user u,the elements of xu
/ measure the extent of interest the user has in items that are high
/ on the corresponding factors, again, positive or negative. The resulting dot product,
/ (xu.T).yi, captures the interaction between user u and item i—the user’s overall interest in
/ the item’s characteristics. 

/ Method - Find latent factors by matrix factorization
/ factorize (userXmovie) matrix into two matrices - (userXcharacteristics/factors) and (itemsXcharacteristics/factors)
/ use ALS for converging X and Y 
 

/ this is the ALS function
kals:{[i;X;Y]show i;
t:inv((Y mmu (flip Y)) + lambda*I );
t:t mmu Y;X:flip (t mmu (flip W));
t:inv(((flip X) mmu X) + lambda*I );
t:t mmu flip X;Y:(t mmu W);
$[i<numiter;kals[i+1;X;Y];(X;Y)]}

/ All data prep code here
/ Read csv for ratings
c:`u`m`r`t;
colStr:"IIII";
.Q.fs[{`r insert flip c!(colStr;",")0:x}]`:ratings.csv;

/ Read csv for movies
c:`m`t`g;
colStr:"ISS";
.Q.fs[{`m insert flip c!(colStr;",")0:x}]`:movies.csv;
/ equijoin movies and ratings  
mej:ej[`m;m;r];

h:mej.u,'mej.m;
j:mej.r;
h:h,'j;
/ Create pivot array and set appropriate values to 1 - a 1 indicates a non-zero rating
piv:((1+(max distinct mej.u)),(1+(max distinct mej.m)))#0;
f:{piv[x[0];x[1]]:x[2]};
f each h ;

mo: sum over 1 # count piv;
it: sum over -1 # count piv;

b:til it;
b:b,'b;
i:0;
C:(1+40*piv); / confidence values 1+alpha*ratings
numfact:100;
lambda:0.1;
W:"f"$piv>0.5;
nu:sum over 1#shape W;
nm:sum over -1#shape W;
/ Init X and Y, with random values
X:(nu,numfact)#5*((nu*numfact)?(nu*numfact))%(nu*numfact);
Y:(numfact,nm)#5*((nm*numfact)?(nm*numfact))%(nm*numfact);
1"Just entering ALS";
/ Identity matrix
I:(numfact,numfact) # 0;
/{x=/:x}til numfact; / Simpler method for I matrix
{I[x;x]:1}each til numfact;
i:0;
numiter:10;
final:kals[i;X;Y];
X:final[0];
Y:final[1];

qhat: raze X mmu Y;
qhat: qhat - min(qhat);
qhat: qhat * (5f % max(qhat));
qhat:(nu,nm)#qhat;
t:qhat  - 5 * W;
tm:max over 't;
tp:tm,'t;
/mindices:{sum over -1 # where tp[x;0] = tp[x]}each til nu;
mindices:{t:tp[x;0] = tp[x];t:where each t=1;tt:t[;1];tt}til nu;
mindices:(til nu), 'mindices, 'tm;
/ init X and Y 


