kumartree:{[i;num;master;root;indx]
  
  / start at root(root is always (enlist 1)), first time, if not first time, start at root of sub-tree
  shp:shape master;
  $[((1=sum over 1#shp) and (1=sum over -1#shp)) or indx=0; temp:enlist 1;temp:master[indx][0]];
  /temp:master[indx][0];
	$[num[i]<=root;nxt:enlist (temp),1;nxt:enlist (temp),2];
  / find if list exists - need better code here - http://code.kx.com/wiki/Reference/QuestionSymbol#find
  tidx:-1;
	if[sum over (-1 # shp) > 1;g:{x}each master[;0];tidx:count {where x~\:y}[g;raze over nxt];
    $[tidx=0;tidx:-1;tidx:sum over {where x~\:y}[g;raze over nxt]]]; 
  / 1 X N list and found e.g 1 2 ? 1 2 - in such a case, return nxt - change to 1,1 and 1,2
  if[((tidx=0) and ((count master) = 1));$[num[i]<=root;nxt:enlist (master[0][0],1);nxt:enlist (master[0][0],2)]]; 
  /show nxt;
  $[(tidx >= 0) and (tidx < count master) and (1 < count master);kumartree[i;num;master;sum over (-1 # master[tidx]);tidx];nxt]
  };

  createtree:{[i;num;master;root;kidx;tmp]nxt:kumartree[i;num;master;root;kidx];
  	
    tmp:tmp,enlist(nxt,num[i]);
    root:num[2];
  	$[i<(-1+count(num));createtree[i+1;num;tmp;root;kidx;tmp];tmp]
  };


  /master:(master;(nxt,num[i]));
  /num: 5 6 4 1 7 9 20 2 3  ;
  num : distinct 100?200;
  root:num[2];
  head:enlist (1,num[2]);
  tmp:head;
  master:tmp;
  i:0;
  kidx:0;
  r:createtree[i;num;master;root;kidx;tmp];
  /show r;
  final:r;
  show final;
  /show final;
  /show r;
