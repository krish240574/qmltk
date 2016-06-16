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

prepareData; / function to do all the pre-processing on the loans dataset

cnt : count c;
ssz:1e-7;
ltwop:0.0f;
yval:raze over "f"$loansdata[`bad_loans]=0;
mi:301;
cost:0.0;
show "Calling gd";
tol:1e-5;
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
