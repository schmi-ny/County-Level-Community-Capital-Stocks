****  	Manuscript: Measuring stocks of community wealth and their association with food systems efforts
****			in rural and urban places
****	Code developed by:  
**** 	Alessandro Bonanno (Colorado State University); 
**** 	Todd M. Schmit (Cornell University); 
****	Becca R.B. Jablonski (Colorado State University)
**** 	Last version: May 2021  
****	For ease of exposition, this code includes the final model specifications only (OLS & SDM) and excludes all of 
****            the robustness checks and model form testing discussed in the paper.

clear all
set more off
set matsize 800

** Change directory to folder with data files **
*  import excel "C:\Users\tms1\Documents\LocalFoods\GrowNYC\Capital Indecies paper\Todd\FullDataFile061521.xlsx", sheet("Data") firstrow

*** For data sources used see the article 


import excel "C:\Users\abonanno\Dropbox\Rural Wealth Indicators\Revision\Data\FullDataFile061521.xlsx", sheet("Data") firstrow

**** Principal Component Analysis
**** PCA For each Capital follow the same steps 

* 0) Check, for some of the variables, that they are divided by either population, 
* 	 square miles or other suitable variables - check "Stats file" 
* 1) run summary stats and obtain correlation matrix to look for variables that present missing observations 
*	 or those that have very large correlation  - the former will be omitted; the latter may or may not 
* 	 be omitted  - IMPORTANT: check notes for each capital to see what veriable has been omitted and why 
* 2) Run PCA on the final variables (TWICE - first showing all the components and then 
* 	 retaininig the components with eigenvactors greater than 1
* 3) Check rotated components' loadings - this is not important when only one component is retained but it 
* 	 may help assessing what variables "belong" to each component when there are multiple components to be retained 
* 4) save the loadings of the variables in each retained component and check correlation among components

*******************
** BUILT capital **
*******************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
replace foodbev_est_CBP=10000*foodbev_est_CBP/pop_15_CBP
replace est_CBP=10000*est_CBP/pop_15_CBP
replace broad=100*broad_prct
replace highway_km=1/(highway_popwtdist/1000)

** 1 summary stats and eliminate variables (check notes)
global built foodbev_est_CBP est_CBP broad highway_km
*describe $built
*summarize $built
*corr $built
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $built, comp ($ncomp)
pca $built, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1b pc2b, score 
*corr pc1b pc2b

**********************
** Cultural capital **
**********************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
** pub_lib create_indus museums art_cult already per 100000 popn so no need to change
replace create_jobs=100*create_jobs/total_emp
replace pub_lib=pub_lib
replace create_indus=create_indus
replace nonwhite_pop=100*nonwhite_pop/pop_15_CBP 
replace museums=museums 
replace art_cult=art_cult
replace RDI22010=RDI22010

** 1 summary stats and eliminate variables (check notes)
global cult create_jobs pub_lib create_indus RDI22010 museums 
*describe $cult
*summarize $cult
*corr $cult 
/* Note: the variables "museums" and "art_cult" will drop approximately 240 and 290 observations each 
			museums       2,906           1    5.130827   .0001215   159.8119
			art_cult      2,765           1    6.444793   .0026417   225.9223
			 - I decided to drop art_cult and to keep museums;  
			museums and pub_lib are correlated 0.6522  */

** 2 Principal Component Analysis
pca $cult, comp ($ncomp)
pca $cult, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1c pc2c, score 
*corr pc1c pc2c

***********************
** FINANCIAL capital **
***********************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
replace localgovfin=localgovfin/pop_12
replace deposits=deposits/pop_15_CBP
replace owner_occupied=owner_occupied/pop_15_CBP

** 1 summary stats and eliminate variables (check notes)
global finan localgovfin deposits owner_occupied
*describe $finan
*summarize $finan
*corr $finan
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $finan, comp ($ncomp)
pca $finan, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1f, score 

*******************
** HUMAN capital **
*******************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
replace ed_attain=100*ed_attain/adult_pop_15
replace food_secure_rev=100*food_secure_rev
replace insured_rev=100*insured_rev
replace mental_health=10000*mental_health/pop_15_CBP
replace primary_care=10000*primary_care/pop_15_CBP

** 1 summary stats and eliminate variables (check notes)
global human ed_attain health_factor food_secure_rev insured_rev primary_care health_outcome
*describe $human
*summarize $human
*corr $human
/* Note: 	the variable mental_health drops circa 250 observations 
			mental_hea~h 2,784    20.47034     124.034          0   3922.977
			 - I decided to drop mental_health */

** 2 Principal Component Analysis
pca $human, comp ($ncomp)
pca $human, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1h pc2h, score 
*corr pc1h pc2h
 
*********************
** Natural capital **
*********************
** 0 divide by acres 
replace prime_farmland=100*prime_farmland/acres
replace conserve_acre=100*conserve_acre/acre_all
replace acre_FSA = 100*acre_FSA/acre_all
replace acre_NFS = 100*acre_NFS/acre_all

** 1 summary stats and eliminate variables (check notes)
global nat natamen_scale prime_farmland conserve_acre acre_FSA acre_NFS 
*describe $nat
*summarize $nat
*corr $nat
/* Note: 	the variable "acre_org" and "crop_div" drop, respectively  circa 450 and 350 observations 
			acre_org 2,593    328.6205    2020.279          0      61159
			crop_div 2,687    4.043728    1.814345          1   21.69364  */

** 2 Principal Component Analysis
pca $nat, comp ($ncomp)
pca $nat, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1n pc2n, score 
*corr pc1n pc2n

********************
** SOCPOL capital **
********************
** 0 divide nccs14 by 100,000 pop
replace nccs14=1000*nccs14/pop_14
replace pvote12=100*pvote12
replace respn10=100*respn10

** 1 summary stats and eliminate variables (check notes)
global socpol assn14 pvote12 respn10 nccs14
*describe $socpol
*summarize $socpol
*corr $socpol
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $socpol, comp ($ncomp)
pca $socpol, mineigen (1)

** 3 Component rotations 
* rotate, varimax /* orthogonal */
* rotate, clear
  rotate, promax /* oblique */
* rotate, clear

** 4 Save loadings of the retained components 
matrix builtvarimaxloadings=e(r_L)
matrix list builtvarimaxloadings
predict pc1s pc2s, score 
*corr pc1s pc2s
*corr pc1b pc2b pc1c pc2c pc1f pc1h pc2h pc1n pc2n pc1s pc2s

*********************************************************************************
** 1 save all the components in a global and stanardize them into indexes (1-100)
*********************************************************************************
global caps pc1b pc2b pc1c pc2c pc1f pc1h pc2h pc1n pc2n pc1s pc2s

foreach var in $caps {
quietly sum `var'
scalar min_`var'=r(min)
scalar max_`var'=r(max)
replace `var'=100*(`var'-min_`var')/(max_`var'-min_`var')
}
sum $caps

*****************************************************************
** Regressions using d2c_total as dependent variable  
*****************************************************************

replace FM_capita=FM_capita*10000
replace d2c_total=d2c_total*100
quietly tab state, gen(dstate)
quietly tab ruccs, gen(drucc)
gen metro=0
replace metro=1 if ruccs<4
gen nonmetro=1-metro
gen nonmetro_NMA=0
replace nonmetro_NMA=1 if ruccs ==5 | ruccs ==7 | ruccs ==9
gen nonmetro_MA=nonmetro-nonmetro_NMA

*create interactions of capital indexes and nonmetro 
*create interactions of capital indexes and nonmetro NonMetro Adjacent (NMA)
foreach x in $caps {
quietly gen `x'_nm=`x'*nonmetro
quietly gen `x'_nm_NMA=`x'*nonmetro_NMA
}

 global caps_nm  pc1b_nm pc2b_nm pc1c_nm pc2c_nm pc1f_nm pc1h_nm pc2h_nm pc1n_nm pc2n_nm pc1s_nm pc2s_nm
 global caps_nm_NMA  pc1b_nm_NMA pc2b_nm_NMA pc1c_nm_NMA pc2c_nm_NMA pc1f_nm_NMA pc1h_nm_NMA pc2h_nm_NMA pc1n_nm_NMA pc2n_nm_NMA pc1s_nm_NMA pc2s_nm_NMA
 
*** summary stats for variables by metro / nonmetro status 

foreach var in $caps {
quietly sum `var'
scalar av_`var'=r(mean)

quietly sum `var'  if metro==1
scalar min_`var'_m=r(min)
quietly sum `var'  if metro==1
scalar av_`var'_m=r(mean)
quietly sum `var'  if metro==1
scalar max_`var'_m=r(max)

quietly sum `var'  if nonmetro==1
scalar av_`var'_nm=r(mean)
quietly sum `var'  if nonmetro==1
scalar min_`var'_nm=r(min) 
quietly sum `var'  if nonmetro==1
scalar max_`var'_nm=r(max)
}
sum $caps if metro==1
sum $caps if nonmetro==1

***************************
**** Spatial models *******
***************************

**** first: remove all observations that are not used in the estimation sample (W must be squared) 
reg d2c_total $caps drucc1-drucc8 dstate1-dstate48 
predict errors, residuals 
drop if errors==.

*** NOTE: 	different estimation routines require different sintax to obtain objects to be used as W 
*** 		for models that are estimated using ML and the routine spmlreg use spwmatrix
*** 		NOTE: the command below generates a W matrix where W(i,j)=1/(dist(i,j)) if dist(i.j)<=200 miles, 0 otherwise

spwmatrix gecon INTPTLAT INTPTLONG,  wname(W_mat1) wtype(inv) eignvar(eig_W_mat1) rowstand  r(3958.761) dband(0 200)

/** NOTE: Because we only use ~2.6k observations, W matrix with "short" max distance of inflence result in "islands" observations 
** where rows / columns of W are all 0s; these cannot be used with spmlreg - to verify run the followign two lines 
spwmatrix gecon INTPTLAT INTPTLONG,  wname(W_mat_50) wtype(inv) eignvar(eig_W_mat_50) rowstand  r(3958.761) dband(0 50)
spmlreg d2c_total $caps drucc1-drucc8 dstate1-dstate47, weights(W_mat_50) wfrom(Stata) eignvar(eig_W_mat_50) model(lag) 
*** The same types of matrixes also DO NOT work with spreg if the ml estimator is used - they do if FGS2SLS is used instead */

*** 		for models that are estimated using ML or FGS2SLS and the routine spreg use spmat 
*** 		Obtain 3 W matrixes, assuming three different areas of influence (50, 100, and 200 miles)

spmat idistance W_mat50 INTPTLONG INTPTLAT, id(GEOID) dfunction(dhaversine, miles) normalize(row) vtruncate(0.02)
spmat summarize W_mat50
spmat idistance W_mat100 INTPTLONG INTPTLAT , id(GEOID) dfunction(dhaversine, miles) normalize(row) vtruncate(0.01)
spmat summarize W_mat100
spmat idistance W_mat200 INTPTLONG INTPTLAT, id(GEOID) dfunction(dhaversine, miles) normalize(row) vtruncate(0.005)
spmat summarize W_mat200

eststo clear 

***** OLS **********************

eststo clear
eststo: reg d2c_total $caps $caps_nm $caps_nm_NMA drucc1-drucc8 dstate1-dstate47
test $caps_nm
test $caps_nm_NMA
test $caps_nm $caps_nm_NMA
 
 eststo: nlcom 	(pc1bnm_MA: _b[pc1b]+_b[pc1b_nm]) /// 
		(pc2bnm_MA: _b[pc2b]+_b[pc2b_nm]) /// 
		(pc1cnm_MA: _b[pc1c]+_b[pc1c_nm]) /// 
		(pc2cnm_MA: _b[pc2c]+_b[pc2c_nm]) ///
		(pc1fnm_MA: _b[pc1f]+_b[pc1f_nm]) ///
		(pc1hnm_MA: _b[pc1h]+_b[pc1h_nm]) ///
		(pc2hnm_MA: _b[pc2h]+_b[pc2h_nm]) /// 
		(pc1nnm_MA: _b[pc1n]+_b[pc1n_nm]) /// 
		(pc2nnm_MA: _b[pc2n]+_b[pc2n_nm]) ///
		(pc1snm_MA: _b[pc1s]+_b[pc1s_nm]) ///
		(pc2snm_MA: _b[pc2s]+_b[pc2s_nm]) ///
		(pc1bnm_NMA: _b[pc1b]+_b[pc1b_nm]+_b[pc1b_nm_NMA]) /// 
		(pc2bnm_NMA: _b[pc2b]+_b[pc2b_nm]+_b[pc2b_nm_NMA]) /// 
		(pc1cnm_NMA: _b[pc1c]+_b[pc1c_nm]+_b[pc1c_nm_NMA]) /// 
		(pc2cnm_NMA: _b[pc2c]+_b[pc2c_nm]+_b[pc2c_nm_NMA]) ///
		(pc1fnm_NMA: _b[pc1f]+_b[pc1f_nm]+_b[pc1f_nm_NMA]) ///
		(pc1hnm_NMA: _b[pc1h]+_b[pc1h_nm]+_b[pc1h_nm_NMA]) ///
		(pc2hnm_NMA: _b[pc2h]+_b[pc2h_nm]+_b[pc2h_nm_NMA]) /// 
		(pc1nnm_NMA: _b[pc1n]+_b[pc1n_nm]+_b[pc1n_nm_NMA]) /// 
		(pc2nnm_NMA: _b[pc2n]+_b[pc2n_nm]+_b[pc2n_nm_NMA]) ///
		(pc1snm_NMA: _b[pc1s]+_b[pc1s_nm]+_b[pc1s_nm_NMA]) ///
		(pc2snm_NMA: _b[pc2s]+_b[pc2s_nm]+_b[pc2s_nm_NMA]), post 
 

 
 **** Spatial durbin model - ML 
eststo: spmlreg  d2c_total $caps $caps_nm $caps_nm_NMA drucc1-drucc8 dstate1-dstate47, ///
weights(W_mat1) wfrom(Stata) eignvar(eig_W_mat1) model(durbin) 
estimates store lsdm_int
estat ic

test $caps_nm
test $caps_nm_NMA
test $caps_nm $caps_nm_NMA

test wx_pc1b wx_pc2b wx_pc1c wx_pc2c wx_pc1f wx_pc1h  wx_pc2h wx_pc1n wx_pc2n wx_pc1s wx_pc2s 
test wx_pc1b_nm wx_pc2b_nm wx_pc1c_nm wx_pc2c_nm wx_pc1f_nm wx_pc1h_nm  wx_pc2h_nm wx_pc1n_nm wx_pc2n_nm wx_pc1s_nm wx_pc2s_nm 
test wx_pc1b_nm_NMA wx_pc2b_nm_NMA wx_pc1c_nm_NMA wx_pc2c_nm_NMA wx_pc1f_nm_NMA wx_pc1h_nm_NMA wx_pc2h_nm_NMA /// 
wx_pc1n_nm_NMA wx_pc2n_nm_NMA wx_pc1s_nm_NMA wx_pc2s_nm_NMA

test wx_pc1b_nm wx_pc2b_nm wx_pc1c_nm wx_pc2c_nm wx_pc1f_nm wx_pc1h_nm  wx_pc2h_nm wx_pc1n_nm wx_pc2n_nm wx_pc1s_nm wx_pc2s_nm /// 
wx_pc1b_nm_NMA wx_pc2b_nm_NMA wx_pc1c_nm_NMA wx_pc2c_nm_NMA wx_pc1f_nm_NMA wx_pc1h_nm_NMA wx_pc2h_nm_NMA /// 
wx_pc1n_nm_NMA wx_pc2n_nm_NMA wx_pc1s_nm_NMA wx_pc2s_nm_NMA
 
test wx_pc1b wx_pc2b wx_pc1c wx_pc2c wx_pc1f wx_pc1h  wx_pc2h wx_pc1n wx_pc2n wx_pc1s wx_pc2s ///
wx_pc1b_nm wx_pc2b_nm wx_pc1c_nm wx_pc2c_nm wx_pc1f_nm wx_pc1h_nm  wx_pc2h_nm wx_pc1n_nm wx_pc2n_nm wx_pc1s_nm wx_pc2s_nm ///
wx_pc1b_nm_NMA wx_pc2b_nm_NMA wx_pc1c_nm_NMA wx_pc2c_nm_NMA wx_pc1f_nm_NMA wx_pc1h_nm_NMA wx_pc2h_nm_NMA /// 
wx_pc1n_nm_NMA wx_pc2n_nm_NMA wx_pc1s_nm_NMA wx_pc2s_nm_NMA

*** for simple comparison with OLS only 
 eststo: nlcom 	(pc1bnm_MA: _b[pc1b]+_b[pc1b_nm]) /// 
		(pc2bnm_MA: _b[pc2b]+_b[pc2b_nm]) /// 
		(pc1cnm_MA: _b[pc1c]+_b[pc1c_nm]) /// 
		(pc2cnm_MA: _b[pc2c]+_b[pc2c_nm]) ///
		(pc1fnm_MA: _b[pc1f]+_b[pc1f_nm]) ///
		(pc1hnm_MA: _b[pc1h]+_b[pc1h_nm]) ///
		(pc2hnm_MA: _b[pc2h]+_b[pc2h_nm]) /// 
		(pc1nnm_MA: _b[pc1n]+_b[pc1n_nm]) /// 
		(pc2nnm_MA: _b[pc2n]+_b[pc2n_nm]) ///
		(pc1snm_MA: _b[pc1s]+_b[pc1s_nm]) ///
		(pc2snm_MA: _b[pc2s]+_b[pc2s_nm]) ///
		(pc1bnm_NMA: _b[pc1b]+_b[pc1b_nm]+_b[pc1b_nm_NMA]) /// 
		(pc2bnm_NMA: _b[pc2b]+_b[pc2b_nm]+_b[pc2b_nm_NMA]) /// 
		(pc1cnm_NMA: _b[pc1c]+_b[pc1c_nm]+_b[pc1c_nm_NMA]) /// 
		(pc2cnm_NMA: _b[pc2c]+_b[pc2c_nm]+_b[pc2c_nm_NMA]) ///
		(pc1fnm_NMA: _b[pc1f]+_b[pc1f_nm]+_b[pc1f_nm_NMA]) ///
		(pc1hnm_NMA: _b[pc1h]+_b[pc1h_nm]+_b[pc1h_nm_NMA]) ///
		(pc2hnm_NMA: _b[pc2h]+_b[pc2h_nm]+_b[pc2h_nm_NMA]) /// 
		(pc1nnm_NMA: _b[pc1n]+_b[pc1n_nm]+_b[pc1n_nm_NMA]) /// 
		(pc2nnm_NMA: _b[pc2n]+_b[pc2n_nm]+_b[pc2n_nm_NMA]) ///
		(pc1snm_NMA: _b[pc1s]+_b[pc1s_nm]+_b[pc1s_nm_NMA]) ///
		(pc2snm_NMA: _b[pc2s]+_b[pc2s_nm]+_b[pc2s_nm_NMA]) /// 
		(wx_pc1bnm_MA: _b[wx_pc1b]+_b[wx_pc1b_nm]) /// 
		(wx_pc2bnm_MA: _b[wx_pc2b]+_b[wx_pc2b_nm]) /// 
		(wx_pc1cnm_MA: _b[wx_pc1c]+_b[wx_pc1c_nm]) /// 
		(wx_pc2cnm_MA: _b[wx_pc2c]+_b[wx_pc2c_nm]) ///
		(wx_pc1fnm_MA: _b[wx_pc1f]+_b[wx_pc1f_nm]) ///
		(wx_pc1hnm_MA: _b[wx_pc1h]+_b[wx_pc1h_nm]) ///
		(wx_pc2hnm_MA: _b[wx_pc2h]+_b[wx_pc2h_nm]) /// 
		(wx_pc1nnm_MA: _b[wx_pc1n]+_b[wx_pc1n_nm]) /// 
		(wx_pc2nnm_MA: _b[wx_pc2n]+_b[wx_pc2n_nm]) ///
		(wx_pc1snm_MA: _b[wx_pc1s]+_b[wx_pc1s_nm]) ///
		(wx_pc2snm_MA: _b[wx_pc2s]+_b[wx_pc2s_nm]) ///
		(wx_pc1bnm_NMA: _b[wx_pc1b]+_b[wx_pc1b_nm]+_b[wx_pc1b_nm_NMA]) /// 
		(wx_pc2bnm_NMA: _b[wx_pc2b]+_b[wx_pc2b_nm]+_b[wx_pc2b_nm_NMA]) /// 
		(wx_pc1cnm_NMA: _b[wx_pc1c]+_b[wx_pc1c_nm]+_b[wx_pc1c_nm_NMA]) /// 
		(wx_pc2cnm_NMA: _b[wx_pc2c]+_b[wx_pc2c_nm]+_b[wx_pc2c_nm_NMA]) ///
		(wx_pc1fnm_NMA: _b[wx_pc1f]+_b[wx_pc1f_nm]+_b[wx_pc1f_nm_NMA]) ///
		(wx_pc1hnm_NMA: _b[wx_pc1h]+_b[wx_pc1h_nm]+_b[wx_pc1h_nm_NMA]) ///
		(wx_pc2hnm_NMA: _b[wx_pc2h]+_b[wx_pc2h_nm]+_b[wx_pc2h_nm_NMA]) /// 
		(wx_pc1nnm_NMA: _b[wx_pc1n]+_b[wx_pc1n_nm]+_b[wx_pc1n_nm_NMA]) /// 
		(wx_pc2nnm_NMA: _b[wx_pc2n]+_b[wx_pc2n_nm]+_b[wx_pc2n_nm_NMA]) ///
		(wx_pc1snm_NMA: _b[wx_pc1s]+_b[wx_pc1s_nm]+_b[wx_pc1s_nm_NMA]) ///
		(wx_pc2snm_NMA: _b[wx_pc2s]+_b[wx_pc2s_nm]+_b[wx_pc2s_nm_NMA]), post 
		
*** The direct, indirect, and total spatial spillover effects of the capital stock variables (Table 7)
*** are obtained in Matlab with 1,000 draws and follow LeSage and Pace (2009, pp 114-115). 
*** Available from authors upon request. For more details, see footnote 13.
