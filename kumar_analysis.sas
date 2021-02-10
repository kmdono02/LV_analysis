* Load observations used in analysis: see email.  Only want time pt 1;
proc freq data=kumar_data;
	table visit;
run;

* Add log transforms;
data kumar_data_edit;
	set kumar_data(rename=(TCV__cm3_=TCV Age__years_=Age));
	log_LV_tot_vol=log(LV_tot_vol__cm3_);
	log_LV_LatIndex=log(LV_LatIndex);
run;

data neha_kumar_slim_analysis2;
	set kumar_data_edit;
	where (LV_analys_v2=1)&(SA_DX_LV_v2="FXS");
	run;

* 51 observations in analysis dataset;

data neha_kumar_slim_analysis1;
	set kumar_data_edit;
	where (LV_analys_v2=1);
run;

* 146 obs.;

** For analysis 1;
* check time ponts;
proc freq data=neha_kumar_slim_analysis1;
	table visit;
run;

ods rtf body="\\Client\C$\Users\Kevin D\Desktop\analysis.rtf";
* Run linear regression analyses, save results and diagnostics;
proc glm data=neha_kumar_slim_analysis1 PLOTS(UNPACK)=(DIAGNOSTICS);
	class SA_DX_LV_v2;
	model LV_tot_vol__cm3_=TCV Age SA_DX_LV_v2 SA_DX_LV_v2*TCV SA_DX_LV_v2*Age/ solution;
run;

proc glm data=neha_kumar_slim_analysis1 PLOTS(UNPACK)=(DIAGNOSTICS);
	class SA_DX_LV_v2;
	model LV_LatIndex=TCV Age SA_DX_LV_v2 SA_DX_LV_v2*TCV SA_DX_LV_v2*Age/ solution;
run;

** Analysis 2;
* Run linear regression analyses, save results and diagnostics;
* Vineland ABC and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=vinelandii_abcomp_ss TCV vinelandii_abcomp_ss*TCV;
run;

* Vineland communication and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=vinelandii_comm_ss TCV vinelandii_comm_ss*TCV;
run;

* Vineland daily living and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=vinelandii_dls_ss TCV vinelandii_dls_ss*TCV;
run;

* Vineland motor and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=vinelandii_motor_ss TCV vinelandii_motor_ss*TCV;
run;

* Vineland GCA and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=dasii_sa_gca_stand TCV dasii_sa_gca_stand*TCV;
run;

* Vineland SNC and TCV;
proc glm data=neha_kumar_slim_analysis2 plots=PLOTS(UNPACK)=(DIAGNOSTICS);
	model LV_tot_vol__cm3_=dasii_sa_snc_stand TCV dasii_sa_snc_stand*TCV;
run;

ods rtf close;

* Let's try log transforms and see if diagnostics improve;
ods rtf body="\\Client\C$\Users\Kevin D\Desktop\transformed_analysis.rtf";
* Run linear regression analyses, save results and diagnostics;
proc glm data=neha_kumar_slim_analysis1 PLOTS(UNPACK)=(DIAGNOSTICS);
	class SA_DX_LV_v2;
	model log_LV_tot_vol=TCV Age SA_DX_LV_v2 SA_DX_LV_v2*TCV SA_DX_LV_v2*Age/ solution;
run;

proc glm data=neha_kumar_slim_analysis1 PLOTS(UNPACK)=(DIAGNOSTICS);
	class SA_DX_LV_v2;
	model log_LV_LatIndex=TCV Age SA_DX_LV_v2 SA_DX_LV_v2*TCV SA_DX_LV_v2*Age/ solution;
run;

** Analysis 2;
* Run linear regression analyses, save results and diagnostics;
* Vineland ABC and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=vinelandii_abcomp_ss TCV vinelandii_abcomp_ss*TCV;
run;

* Vineland communication and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=vinelandii_comm_ss TCV vinelandii_comm_ss*TCV;
run;

* Vineland daily living and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=vinelandii_dls_ss TCV vinelandii_dls_ss*TCV;
run;

* Vineland motor and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=vinelandii_motor_ss TCV vinelandii_motor_ss*TCV;
run;

* Vineland GCA and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=dasii_sa_gca_stand TCV dasii_sa_gca_stand*TCV;
run;

* Vineland SNC and TCV;
proc glm data=neha_kumar_slim_analysis2 PLOTS(UNPACK)=(DIAGNOSTICS);
	model log_LV_tot_vol=dasii_sa_snc_stand TCV dasii_sa_snc_stand*TCV;
run;
ods rtf close;


