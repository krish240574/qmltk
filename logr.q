/ Logistic regression with l2 regularization
gd:{[w;lcost;itr]z: raze over features$w;
	p: (1%(1+exp(-1*z)));
	e:(p-yval);cne:count e;
	e:(1,cne)# e;
	tmp:raze over (e$features);
	w:w-(ssz%cne)*(tmp)-(ltwop%cne)*w;
	w[0]:w[0]-(ssz%cne)*tmp[0];
	kumar:(yval*(log(p))+(1-yval)*(log(1-p)));
	t:w[1+til (-1+count w)];
	c:(-1%cne)*(sum kumar)+((ltwop%(2*cne))*sum (t*t));
	show itr,c;
	$[itr<mi;gd[w;c;itr+1];w]}

crm:{mm:(flip x)$(x);
	sx:sum x;
	cm:mm - (sx *\:/: sx)%(count x);
	k:sum over(-1 # (shape x));
	idt:(k,k)#1f,k#0f;
	d:inv sqrt(idt*cm);
	t:cm$d;
	t:d$t;
	:t}

//k){[w;lcost;itr]z:features$w;p:1%(1+exp(-1*z));e:(p-yval);cne:#e;e:(1,cne)#(,/)(,/)e;tmp:,/e$features;w:w-(ssz%cne)*tmp-(l2_penalty%m)*w;w[0]:w[0]-(ssz%cne)*tmp[0];kumar:(yval*log(p)+(1-yval)*log(1-p));t:w[1+!(-1+#w)];c:(-1%cne)*(+/,/kumar)+(ltwop%(2*cne)*(t*t));$[itr<10;gd[w;c;itr+1];w]}

/c:`name`reviewiew`rating`sentiment`review_clean`baby`one`great`love`use`would`like`easy`little`seat`old`well`get`also`really`son`time`bought`product`good`daughter`much`loves`stroller`put`months`car`still`back`used`recommend`first`even`perfect`nice`bag`two`using`got`fit`around`diaper`enough`month`price`go`could`soft`since`buy`room`works`made`child`keep`size`small`need`year`big`make`take`easily`think`crib`clean`way`quality`thing`better`without`set`new`every`cute`best`bottles`work`purchased`right`lot`side`happy`comfortable`toy`able`kids`bit`night`long`fits`see`us`another`play`day`money`monitor`tried`thought`never`item`hard`plastic`however`disappointed`reviews`something`going`pump`bottle`cup`waste`return`amazon`different`top`want`problem`know`water`try`received`sure`times`chair`find`hold`gate`open`bottom`away`actually`cheap`worked`getting`ordered`came`milk`bad`part`worth`found`cover`many`design`looking`weeks`say`wanted`look`place`purchase`looks`second`piece`box`pretty`trying`difficult`together`though`give`started`anything`last`company`come`returned`maybe`took`broke`makes`stay`instead`idea`head`said`less`went`working`high`unit`seems`picture`completely`wish`buying`babies`won`tub`almost`either;
/ Loan Risk Analysis
c:`id`member_id`loan_amnt`funded_amnt`funded_amnt_inv`term`int_rate`installment`grade`sub_grade`emp_title`emp_length`home_ownership`annual_inc`verification_status`issue_d`loan_status`pymnt_plan`url`desc`purpose`title`zip_code`addr_state`dti`delinq_2yrs`earliest_cr_line`inq_last_6mths`mths_since_last_delinq`mths_since_last_record`open_acc`pub_rec`revol_bal`revol_util`total_acc`initial_list_status`out_prncp`out_prncp_inv`total_pymnt`total_pymnt_inv`total_rec_prncp`total_rec_int`total_rec_late_fee`recoveries`collection_recovery_fee`last_pymnt_d`last_pymnt_amnt`next_pymnt_d`last_credit_pull_d`collections_12_mths_ex_med`mths_since_last_major_derog`policy_code`application_type`annual_inc_joint`dti_joint`verification_status_joint`acc_now_delinq`tot_coll_amt`tot_cur_bal`open_acc_6m`open_il_6m`open_il_12m`open_il_24m`mths_since_rcnt_il`total_bal_il`il_util`open_rv_12m`open_rv_24m`max_bal_bc`all_util`total_rev_hi_lim`inq_fi`total_cu_tl`inq_last_12m`acc_open_past_24mths`avg_cur_bal`bc_open_to_buy`bc_util`chargeoff_within_12_mths`delinq_amnt`mo_sin_old_il_acct`mo_sin_old_rev_tl_op`mo_sin_rcnt_rev_tl_op`mo_sin_rcnt_tl`mort_acc`mths_since_recent_bc`mths_since_recent_bc_dlq`mths_since_recent_inq`mths_since_recent_revol_delinq`num_accts_ever_120_pd`num_actv_bc_tl`num_actv_rev_tl`num_bc_sats`num_bc_tl`num_il_tl`num_op_rev_tl`num_rev_accts`num_rev_tl_bal_gt_0`num_sats`num_tl_120dpd_2m`num_tl_30dpd`num_tl_90g_dpd_24m`num_tl_op_past_12m`pct_tl_nvr_dlq`percent_bc_gt_75`pub_rec_bankruptcies`tax_liens`tot_hi_cred_lim`total_bal_ex_mort`total_bc_limit`total_il_high_credit_limit

cnt : count c;

/colStr:"SSFFSFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
/ LRA
colStr : "SSFFFSSFSSSSSF",((cnt-14) # "S")
.Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:loansmaster.csv;

fs:`baby`one`great`love`use`would`like`easy`little`seat`old`well`get`also`really`son`time`bought`product`good`daughter`much`loves`stroller`put`months`car`still`back`used`recommend`first`even`perfect`nice`bag`two`using`got`fit`around`diaper`enough`month`price`go`could`soft`since`buy`room`works`made`child`keep`size`small`need`year`big`make`take`easily`think`crib`clean`way`quality`thing`better`without`set`new`every`cute`best`bottles`work`purchased`right`lot`side`happy`comfortable`toy`able`kids`bit`night`long`fits`see`us`another`play`day`money`monitor`tried`thought`never`item`hard`plastic`however`disappointed`reviews`something`going`pump`bottle`cup`waste`return`amazon`different`top`want`problem`know`water`try`received`sure`times`chair`find`hold`gate`open`bottom`away`actually`cheap`worked`getting`ordered`came`milk`bad`part`worth`found`cover`many`design`looking`weeks`say`wanted`look`place`purchase`looks`second`piece`box`pretty`trying`difficult`together`though`give`started`anything`last`company`come`returned`maybe`took`broke`makes`stay`instead`idea`head`said`less`went`working`high`unit`seems`picture`completely`wish`buying`babies`won`tub`almost`either;





// add true class column based on GRADE","SUB_GRADE","EMP_TITLE","EMP_LENGTH","HOME_OWNERSHIP","ANNUAL_INC","VERIFICATION_STATUS" for now - 
//if GRADE > smething and SUB_GRADE > something and EMP_LENGTH > something and ANNUAL_INC > something and delinq_2yrs > 0 
ct: count dataset;

grade: string select distinct grade from dataset
grade:grade[`grade]
grade:raze grade
sub_grade: string select sub_grade from dataset
sub_grade:sub_grade[`sub_grade]
s1:sub_grade[;0]
indices:grade?s1
ci: count indices
t:(ci,1)# til ci
indices:t,'indices
cg: count grade
z: (ci*cg) # 0;
z[(cg*indices[;0])+indices[;1]]:1
z:(ci,cg)#z;

/z:{[z;indices] z[indices 0; indices 1]:1;z}/[z;indices]
/z: (ci,cg) # 0;
/.[`z;;:;1] each indices;
/ mh-43 at 9789
gradetbl:([]GradeD:z[;0];GradeC:z[;1];GradeB:z[;2];GradeA:z[;3];GradeE:z[;4];GradeF:z[;5];GradeG:z[;6])

term: string select term from dataset;
term:term[`term];
t2:"I"$(2 # 'term);
sixty:(ct, 1) # (t2=60);
thsx:(ct, 1) # (t2=36);
m:thsx,'sixty
termtbl:([]term.36:m[;0];term.60:m[;1])

ho:string select distinct home_ownership from dataset;
ho:ho[`home_ownership]
cho:count ho;
allho:string select home_ownership from dataset;
allho:allho[`home_ownership];
caho: count allho;
hoi:ho?allho;
hoi:(til ct),'hoi
z:(caho*cho)#0;
z[(cho*hoi[;0])+hoi[;1]]:1;
z:(caho,cho)#z;
/z:{[z;hoi] z[hoi 0; hoi 1]:1; z}/[z;hoi]
/z:(caho*cho)#0;
/.[`z;;:;1] each hoi;
hotbl:([]home_ownership.MORTGAGE:z[;0];home_ownership.OWN:z[;1];home_ownership.RENT:z[;2])

el: string select distinct emp_length from dataset;
cel:count el;
el:el[`emp_length]
el1:el[;0]
el[where el1="n"]:"0"
el[where el1="<"]:"0"
t2:2 # 'el
demp:"I"$t2
el: string select emp_length from dataset;
el:el[`emp_length]
el1:el[;0]
el[where el1="n"]:"0"
el[where el1="<"]:"0"
el2:2 # 'el
emp:"I"$el2
iemp:demp?emp
z:(ct*cel)#0;
t:til ct;
hh:t,'iemp;
z[(cel*hh[;0])+hh[;1]]:1;
z:(ct,cel)#z;

/z:{[z;hh] z[hh 0;hh 1]:1;z}/[z;hh];
/z:(ct,cel)#0;
/.[`z;;:;1] each hh;

emptbl:([]emp10years:z[;0];emp5years:z[;1];emp8years:z[;2];empna:z[;3];emp1year:z[;4];emp4years:z[;5];emp9years:z[;6];emp6years:z[;7];emp2years:z[;8];emplt1year:z[;9];emp3years:z[;10];emp7years:z[;11]);

dataset[`int_rate]:string dataset[`int_rate];
ir:dataset[`int_rate];
ir:"F"$ -1 _ 'ir;
dataset[`int_rate]:ir;


/ append all binarised variables to the dataset from here
d:dataset;

d:d,'gradetbl;
d:delete grade from d;
d:d,'termtbl;
d:delete term from d;
d:d,'hotbl;
d:delete home_ownership from d;
d:d,'emptbl;
d:delete emp_length from d;
t:(ct,1)#0;
bad_loans:([]bad_loans:t);
bad_loans[where (d[`term.36] and (d[`GradeC] or d[`GradeD] or d[`GradeE] or d[`GradeF] or d[`GradeG]) and (d[`emp1year] or d[`emplt1year] or d[`empna] or d[`emp2years])and d[`home_ownership.RENT])]:1
d:d,'bad_loans;
/ Note - to work with `bad_loans, you need to raze it 

/ sampling now to balance data classes
nbadloans:sum over d[`bad_loans];
ngoodloans:ct - nbadloans;
p:(nbadloans%ngoodloans);
t:raze d[`bad_loans];
blraw:d[where t];
glraw:d[where t=0];
ptosample:"i"$p*ngoodloans;
randnos:distinct ptosample?ptosample;
samplegl:glraw[til ptosample];
loansdata:blraw,samplegl;

fs:`GradeD`GradeC`GradeB`GradeA`GradeE`GradeF`GradeG`term.36`term.60`home_ownership.MORTGAGE`home_ownership.OWN`home_ownership.RENT`emp10years`emp5years`emp8years`empna`emp1year`emp4years`emp9years`emp6years`emp2years`emplt1year`emp3years`emp7years;
features:"f"$flip loansdata[fs]; 
cf: count features;
/show cf;
const: (cf,1) # 1f;
features:const,'features;
/show count features;
iter:0;
fs:`intercept,fs;
tmp:count fs;
iw:tmp # 0f;
ssz:1e-7;
ltwop:0.0f;
yval:raze over "f"$loansdata[`bad_loans]=0;
mi:301;
cost:0.0;
show "Calling gd";
tol:1e-5;
//show count sum each features*\:iw
w:gd[iw;cost;iter];show w
/shape:{(ct x),1#ct x[0]}

b:(count loansdata) # 0 
b[where raze loansdata[`bad_loans]]:-1
b[where raze loansdata[`bad_loans]=0]:1
safe_loans:([]safe_loans:b);
loansdata:loansdata,'safe_loans;
loansdata:delete bad_loans from loansdata;
scores:features$w;
b:(count loansdata) # 0 ;
b[where scores>0]:1
b[where scores<0]:-1
predictions:([]predictions:b);
loansdata:loansdata,'predictions;
mistakes:sum over loansdata[`safe_loans] <> loansdata[`predictions];
misaccuracy:mistakes%(count loansdata)
show 1-misaccuracy;





























