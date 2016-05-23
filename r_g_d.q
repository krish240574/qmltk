//k) prepdata:{[data]
/		sz:#data;
/		trsz: "i"$0.8*sz;
/		tssz:trsz + !(sz-trsz);
/		htr:data[!trsz];
/		hts:data[tssz];
/		iw: 2 1 # -47000.0 1.0;
/		features:htr[`sqftliving];
/		const: 17290 # 1;
/		features:const,'features;
/		data
/		/(htr;hts;features;iw)
/		/features
/}

k) funct:{[x;y]
	x*10;
y*100}

/id,date,price,bedrooms,bathrooms,sqft_living,sqft_lot,floors,waterfront,view,condition,grade,sqft_above,sqft_basement,
/yr_built,yr_renovated,zipcode,lat,long,sqft_living15,sqft_lot15


c:`id`price`sqftliving`sqftliving15
.Q.fs[{`dataset insert flip c!("S F  I             I ";",")0:x}]`:e.csv
/prepdata[dataset]
/kdata:.Kumar.preparedata

/show dataset
/features:preppeddata[2]
/iw:preppeddata[3]
/show preppeddata
/weights:rgd[iw;features]
/show features
/weights:rgd iw features

funct[100;200]

