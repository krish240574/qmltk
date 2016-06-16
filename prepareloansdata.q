/ prepare loans data for classification
c:`id`member_id`loan_amnt`funded_amnt`funded_amnt_inv`term`int_rate`installment`grade`sub_grade`emp_title`emp_length`homeownership`annual_inc`verification_status`issue_d`loan_status`pymnt_plan`url`desc`purpose`title`zip_code`addr_state`dti`delinq_2yrs`earliest_cr_line`inq_last_6mths`mths_since_last_delinq`mths_since_last_record`open_acc`pub_rec`revol_bal`revol_util`total_acc`initial_list_status`out_prncp`out_prncp_inv`total_pymnt`total_pymnt_inv`total_rec_prncp`total_rec_int`total_rec_late_fee`recoveries`collection_recovery_fee`last_pymnt_d`last_pymnt_amnt`next_pymnt_d`last_credit_pull_d`collections_12_mths_ex_med`mths_since_last_major_derog`policy_code`application_type`annual_inc_joint`dti_joint`verification_status_joint`acc_now_delinq`tot_coll_amt`tot_cur_bal`open_acc_6m`open_il_6m`open_il_12m`open_il_24m`mths_since_rcnt_il`total_bal_il`il_util`open_rv_12m`open_rv_24m`max_bal_bc`all_util`total_rev_hi_lim`inq_fi`total_cu_tl`inq_last_12m`acc_open_past_24mths`avg_cur_bal`bc_open_to_buy`bc_util`chargeoff_within_12_mths`delinq_amnt`mo_sin_old_il_acct`mo_sin_old_rev_tl_op`mo_sin_rcnt_rev_tl_op`mo_sin_rcnt_tl`mort_acc`mths_since_recent_bc`mths_since_recent_bc_dlq`mths_since_recent_inq`mths_since_recent_revol_delinq`num_accts_ever_120_pd`num_actv_bc_tl`num_actv_rev_tl`num_bc_sats`num_bc_tl`num_il_tl`num_op_rev_tl`num_rev_accts`num_rev_tl_bal_gt_0`num_sats`num_tl_120dpd_2m`num_tl_30dpd`num_tl_90g_dpd_24m`num_tl_op_past_12m`pct_tl_nvr_dlq`percent_bc_gt_75`pub_rec_bankruptcies`tax_liens`tot_hi_cred_lim`total_bal_ex_mort`total_bc_limit`total_il_high_credit_limit

colStr : "SSFFFSSFSSSSSF",(((count c)-14) # "S")
.Q.fs[{`dataset insert flip c!(colStr;",")0:x}]`:loansmaster.csv;

ct: count dataset;
tmp:where ((dataset[`grade] = `C) or (dataset[`grade] = `D) or (dataset[`grade] = `E) or(dataset[`grade] = `F) or (dataset[`grade] = `G))
bad_loans:(count dataset)#0
bad_loans[tmp]:1
safeloans:(count dataset)#0
safeloans[where bad_loans=0]:1
safeloans[where bad_loans=1]:-1
safeloans:([]safeloans:safeloans)
dataset:dataset,'safeloans

backup:dataset
dataset:select grade, sub_grade, int_rate, 	term, homeownership,emp_length,safeloans from dataset / new dataset created with 5 columns - process this one from now. 

z:flip{dataset[`grade]=x}each distinct dataset[`grade]
gradetbl:([]GradeD:z[;0];GradeC:z[;1];GradeB:z[;2];GradeA:z[;3];GradeE:z[;4];GradeF:z[;5];GradeG:z[;6])

z:flip{dataset[`term]=x}each distinct dataset[`term]
termtbl:([]term36:z[;0];term60:z[;1])

z:flip{dataset[`homeownership]=x}each distinct dataset[`homeownership]
hotbl:([]homeownershipMORTGAGE:z[;0];homeownershipOWN:z[;1];homeownershipRENT:z[;2])

z:flip{dataset[`emp_length]=x}each distinct dataset[`emp_length]
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
d:delete homeownership from d;
d:d,'emptbl;
d:delete emp_length from d;
badloans:([]badloans:(count d)#0);
badloans[where (d[`GradeC] or d[`GradeD] or d[`GradeE] or d[`GradeF] or d[`GradeG])]:1

/badloans[where (d[`term36] and (d[`GradeC] or d[`GradeD] or d[`GradeE] or d[`GradeF] or d[`GradeG]) and (d[`emp1year] or d[`emplt1year] or d[`empna] or d[`emp2years])and d[`homeownershipRENT])]:1
d:d,'badloans;
/ Split into train - test 80-20
tmp:ceiling(0.8*count d)
train:d[til tmp]
test:d[tmp+til((count d)-tmp)]

fdata:select GradeD,GradeC,GradeB,GradeA,GradeE,GradeF,GradeG,term36,term60,homeownershipMORTGAGE,homeownershipOWN,homeownershipRENT,emp10years,emp5years,emp8years,empna,emp1year,emp4years,emp9years,emp6years,emp2years,emplt1year,emp3years,emp7years,badloans,safeloans from train

/data ready to process for decision tree 

