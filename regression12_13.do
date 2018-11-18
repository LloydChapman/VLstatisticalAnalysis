* Load cleaned dataset
use DataWithMergedCorrections4, clear

* Make age group variable
gen agegrp=0 if VLvsPKDL!=1
replace agegrp=1 if Age>=5
replace agegrp=2 if Age>=10
replace agegrp=3 if Age>=15
replace agegrp=4 if Age>=20
replace agegrp=5 if Age>=25
replace agegrp=6 if Age>=30
replace agegrp=7 if Age>=35
replace agegrp=8 if Age>=40
replace agegrp=9 if Age>=45
replace agegrp=10 if Age>=50
replace agegrp=11 if Age>=55
replace agegrp=12 if Age>=60
replace agegrp=13 if Age>=65
replace agegrp=14 if Age>=70
replace agegrp=15 if Age>=75
replace agegrp=16 if Age>=80&Age!=.
tab agegrp if VLvsPKDL!=1

* Count number of pre-diagnosis treatments (PDTs)
gen PDT=0 if New_DATE==.&New_DATE2==.&New_DATE3==.&New_DATE4==.
replace PDT=1 if New_DATE!=.&New_DATE2==.&New_DATE3==.&New_DATE4==.
replace PDT=2 if New_DATE2!=.&New_DATE3==.&New_DATE4==.
replace PDT=3 if New_DATE3!=.&New_DATE4==.
replace PDT=4 if New_DATE4!=.

* Generate onset-to-diagnosis (OD) time variable
gen OD=Diagnosis-Onset
replace OD=. if OD<0
replace OD=. if VLvsPKDL==1

* Destring type of house variable (D9_New_Type_of_House)
destring D9_New_Type_of_House, replace

* Destring wall type variable (D10) and overwrite missing entries
destring D10,replace
replace D10=. if D10==99

* Destring roof and floor type variables (D11 and D12)
destring D11 D12,replace

* Make binary variable, D13bin2, for number of rooms (<=2 vs >2)
gen D13bin2=0
destring D13,replace
replace D13bin2=1 if D13>2 
replace D13bin2=. if D13==.

* Recode cattle ownership variable
destring D14_New_Cattleowner, replace
replace D14_New_Cattleowner=. if D14_New_Cattleowner==0
replace D14_New_Cattleowner=0 if D14_New_Cattleowner==2

* Make treatment payment variable from capsule payment (D54KMC1) and injection payment variables (D62KMC1)
destring D54KMC1 D62KMC1 A13A,replace
gen treatpay=0 if D54KMC1!=.|D62KMC1!=.
replace treatpay=1 if D54KMC1==1|D62KMC1==1

* Make scheduled caste variable, Caste1
gen Caste1=A13A
replace Caste1=0 if A13A!=1&A13A!=.

* Make diagnosis in a public facility variable, publicD
destring D32 D41KMC1,replace
gen publicD=0 if D32==1|D32==2
replace publicD=1 if D32==3|D32==4

* Make treatment in a public facility variable, publicT
gen publicT=0 if D41KMC1!=999
replace publicT=1 if D41KMC1==8|D41KMC1==9|D41KMC1==10

* Destring paid-for diagnostic test variable (D35)
destring D35, replace

* Rename variables (OT = onset-to-treatment time)
rename OnsetToTreatment1 OT
rename SameDiagnosisResidenceDistricts Dmatch
rename SameDiagnosisResidenceBlocks Bmatch

*** ONSET-TO-DIAGNOSIS AND ONSET-TO-TREATMENT TIME REGRESSIONS ***
* Make variable for inclusion in single variable regressions (Jan 2012 < onset < Jun 2013)
gen elig=1
replace elig=2 if OnsetYear==.|OnsetMonth==.
replace elig=0 if OnsetYear==2013&OnsetMonth>6
replace elig=0 if OnsetYear<2012
replace elig=1 if OnsetYear==2012

* Make variable for exclusion of PKDL cases
gen splitter=0
replace splitter=1 if VLvsPKDL!=1
replace splitter=0 if elig!=1

* Single variable negative binomial regressions for OD
nbreg OD Age if splitter==1,irr
nbreg OD Sex if splitter==1,irr
nbreg OD ib5.District if splitter==1,irr
nbreg OD i.D9_New_Type_of_House if splitter==1,irr
nbreg OD i.D10 if splitter==1,irr
nbreg OD i.D11 if splitter==1,irr
nbreg OD i.D12 if splitter==1,irr
nbreg OD D13 if splitter==1,irr
nbreg OD i.D13bin2 if splitter==1,irr
nbreg OD D14_New_Cattleowner if splitter==1,irr
nbreg OD D35 if splitter==1,irr
nbreg OD treatpay if splitter==1,irr
nbreg OD publicD if splitter==1,irr 
nbreg OD publicT if splitter==1,irr 
nbreg OD i.PDT if splitter==1,irr
nbreg OD Caste1 if splitter==1,irr
nbreg OD Dmatch if splitter==1,irr
nbreg OD Bmatch if splitter==1,irr

* Single variable negative binomial regressions for OT
nbreg OT Age if splitter==1,irr
nbreg OT Sex if splitter==1,irr
nbreg OT ib5.District if splitter==1,irr
nbreg OT i.D9_New_Type_of_House if splitter==1,irr
nbreg OT i.D10 if splitter==1,irr
nbreg OT i.D11 if splitter==1,irr
nbreg OT i.D12 if splitter==1,irr
nbreg OT D13 if splitter==1,irr
nbreg OT i.D13bin2 if splitter==1,irr
nbreg OT D14_New_Cattleowner if splitter==1,irr
nbreg OT D35 if splitter==1,irr
nbreg OT treatpay if splitter==1,irr
nbreg OT publicD if splitter==1,irr 
nbreg OT publicT if splitter==1,irr
nbreg OT i.PDT if splitter==1,irr
nbreg OT Caste1 if splitter==1,irr
nbreg OT Dmatch if splitter==1,irr
nbreg OT Bmatch if splitter==1,irr

* Make variable for inclusion in multivariable regressions (i.e. cases with values for all significant factors in single variable regressions)
gen multivar1=1
replace multivar1=0 if VLvsPKDL==1
replace multivar1=0 if elig!=1
replace multivar1=0 if Age==.|District==.|D10==.|D13==.|D14_New_Cattleowner==.|D35==.|treatpay==.|PDT==.|Caste1==.|publicD==.
replace multivar1=0 if Dmatch==.|Bmatch==.

* Multivariable negative binomial regressions for OD
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store Mfull
* Exclude one variable at a time (backwards selection)
nbreg OD Age i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11Dist
nbreg OD Age ib5.District D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11wall
nbreg OD Age ib5.District i.D10 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11room
nbreg OD Age ib5.District i.D10 D13bin2 D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11cow
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11dpay
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11tpay
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store M11PDT
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT publicD Dmatch Bmatch if multivar1==1, irr
estimates store M9caste
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M11pubD
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Bmatch if multivar1==1, irr
estimates store Mdmatch
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch if multivar1==1, irr
estimates store Mbmatch

* Determine which variable to eliminate based on likelihood ratio test (LRT)
lrtest Mfull M11Dist,stats
lrtest Mfull M11wall,stats
lrtest Mfull M11room,stats
lrtest Mfull M11cow,stats
lrtest Mfull M11dpay,stats
lrtest Mfull M11tpay,stats
lrtest Mfull M11PDT,stats
lrtest Mfull M9caste,stats
lrtest Mfull M11pubD,stats
lrtest Mfull Mdmatch,stats
lrtest Mfull Mbmatch,stats

* Remove public diagnosis and test whether treatment payment or number of rooms should be removed 
nbreg OD Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M10pay
nbreg OD Age ib5.District i.D10 D14_New_Cattleowner D35 treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M10room

lrtest M11pubD M10pay,stats
lrtest M11pubD M10room,stats

* No significant loss of quality of it removing either treatment payment or number of rooms, so test removing both
nbreg OD Age ib5.District i.D10 D14_New_Cattleowner D35 i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M9roompay

lrtest M11pubD M9roompay,stats
lrtest M9roompay M10room,stats
lrtest M9roompay M10pay,stats

* Remove both treatment payment and number of rooms and test removing cattle ownership and paid-for diagnosis
nbreg OD Age ib5.District i.D10 D35 i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M8cow
nbreg OD Age ib5.District i.D10 D14_New_Cattleowner i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M8test

lrtest M9roompay M8cow,stats
lrtest M9roompay M8test,stats

* No significant loss of quality of it removing either cattle ownership or paid-for diagnosis, so test removing both
nbreg OD Age ib5.District i.D10 i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M7testcow

lrtest M7testcow M9roompay,stats
lrtest M7testcow M8cow,stats
lrtest M7testcow M8test,stats

* Remove both cattle ownership and paid-for diagnosis. and test removing wall type, caste, and matching diagnosis and residence district and block
nbreg OD Age ib5.District i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store M6wall
nbreg OD Age ib5.District i.D10 i.PDT Caste1 Bmatch if multivar1==1, irr
estimates store M6dmatch
nbreg OD Age ib5.District i.D10 i.PDT Dmatch Bmatch if multivar1==1, irr
estimates store M6caste
nbreg OD Age ib5.District i.D10 i.PDT Caste1 Dmatch if multivar1==1, irr
estimates store M6bmatch

lrtest M7testcow M6wall,stats
lrtest M7testcow M6caste,stats
lrtest M7testcow M6dmatch,stats
lrtest M7testcow M6bmatch,stats

* Test removing matching diagnosis and residence block and wall type
nbreg OD Age ib5.District i.PDT Caste1 Dmatch if multivar1==1, irr
estimates store M5bwall

lrtest M7testcow M5bwall,stats

* Test inclusion and exclusion of treatment payment, wall type, and caste
nbreg OD Age ib5.District i.D10 i.PDT treatpay Caste1 Dmatch if multivar1==1, irr
estimates store M7castall
nbreg OD Age ib5.District ib2.D10 i.PDT Caste1 Dmatch if multivar1==1, irr
estimates store M6TP
nbreg OD Age ib5.District i.PDT treatpay Caste1 Dmatch if multivar1==1, irr
estimates store M6wall
nbreg OD Age ib5.District i.D10 i.PDT treatpay Dmatch if multivar1==1, irr
estimates store M6cast

lrtest M6cast M7castall,stats
lrtest M6TP M7castall,stats
lrtest M6wall M7castall,stats

* M6TP is final model

* Repeat backwards selection process for OT multivariable model
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT12full
nbreg OT Age i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11Dist
nbreg OT Age ib5.District D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11wall
nbreg OT Age ib5.District i.D10 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11room
nbreg OT Age ib5.District i.D10 D13bin2 D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11cow
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11Dpay
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11Tpay
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT11PDT
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay publicD i.PDT Dmatch Bmatch if multivar1==1, irr
estimates store OT11caste
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store OT11pubD
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Bmatch if multivar1==1, irr
estimates store OT11dmatch
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch if multivar1==1, irr
estimates store OT11bmatch

lrtest OT12full OT11Dist,stats
lrtest OT12full OT11wall,stats
lrtest OT12full OT11room,stats
lrtest OT12full OT11cow,stats
lrtest OT12full OT11Dpay,stats
lrtest OT12full OT11Tpay,stats
lrtest OT12full OT11PDT,stats
lrtest OT12full OT11caste,stats
lrtest OT12full OT11pubD,stats
lrtest OT12full OT11dmatch,stats
lrtest OT12full OT11bmatch,stats

nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner D35 treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT12full
nbreg OT Age ib5.District i.D10 D14_New_Cattleowner treatpay i.PDT Caste1 publicD Dmatch Bmatch if multivar1==1, irr
estimates store OT10roompay
nbreg OT Age ib5.District i.D10 D13bin2 D14_New_Cattleowner treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store OT10paypub
nbreg OT Age ib5.District i.D10 D14_New_Cattleowner D35 treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store OT10roompubD

lrtest OT10roompay OT12full,stats
lrtest OT10paypub OT12full,stats
lrtest OT10roompubD OT12full,stats

nbreg OT Age ib5.District ib2.D10 treatpay i.PDT Caste1 Dmatch Bmatch if multivar1==1, irr
estimates store OT8roompubpay

nbreg OT Age ib5.District ib2.D10 treatpay i.PDT Dmatch Bmatch if multivar1==1, irr
estimates store OTdecast

nbreg OT Age ib5.District ib2.D10 treatpay i.PDT Caste1 Dmatch if multivar1==1, irr
estimates store OTdeblock

lrtest OT8roompubpay OTdecast,stats
lrtest OT8roompubpay OTdeblock,stats
lrtest OT8roompubpay OT12full,stats

* OTdecast is final model

*** MORTALITY RISK REGRESSIONS ***
* Make 1st KA treatment time variable
gen TT1=TreatmentDuration1Injection if TreatmentDuration1Capsule==.
replace TT1=TreatmentDuration1Capsule if TreatmentDuration1Capsule!=.

* Make 2nd KA treatment time variable
gen TT2=TreatmentDuration2Injection if TreatmentDuration2Capsule==.
replace TT2=TreatmentDuration2Capsule if TreatmentDuration2Capsule!=.

* Make total treatment time variable
gen treattime=.
replace treattime=TT1+TT2 if TT1!=.&TT2!=.
replace treattime=TT1 if TT1!=.&TT2==.
replace treattime=TT2 if TT1==.&TT2!=.

* Make binary death status variable
gen DEAD=0 if AliveOrDead==1
replace DEAD=1 if AliveOrDead==2

* Single-variable logistic regressions of mortality risk
logistic DEAD Age if splitter==1
logistic DEAD Sex if splitter==1
logistic DEAD i.District if splitter==1
logistic DEAD i.D9_New_Type_of_House if splitter==1
logistic DEAD i.D10 if splitter==1
logistic DEAD i.D11 if splitter==1
logistic DEAD i.D12 if splitter==1
logistic DEAD D13 if splitter==1
logistic DEAD i.D13bin2 if splitter==1
logistic DEAD i.D14_New_Cattleowner if splitter==1
logistic DEAD OD if splitter==1
logistic DEAD OT if splitter==1
logistic DEAD treattime if splitter==1
logistic DEAD D35 if splitter==1 
logistic DEAD treatpay if splitter==1
logistic DEAD i.PDT if splitter==1
logistic DEAD Caste1 if splitter==1
logistic DEAD publicD if splitter==1
logistic DEAD publicT if splitter==1
logistic DEAD Dmatch if splitter==1
logistic DEAD Bmatch if splitter==1

* Make variable for inclusion in multivariable regressions
gen multivar2=0
replace multivar2=1 if Age!=.&District!=.&D14_New_Cattleowner!=.&D35!=.&OD!=.&OT!=.&treattime!=.&VLvsPKDL!=1
replace multivar2=0 if publicD==.
replace multivar2=0 if splitter!=1
*replace multivar2=0 if Dmatch==.|Bmatch==.

* Multivariable logistic regressions of mortality risk
logistic DEAD Age i.District OD OT treattime D14_New_Cattleowner D35 publicD if multivar2==1
estimates store D8full
* Test excluding one variable at a time (backwards selection)
logistic DEAD Age OD OT treattime D14_New_Cattleowner D35 publicD if multivar2==1
estimates store D7dist
logistic DEAD Age i.District OT treattime D14_New_Cattleowner D35 publicD if multivar2==1
estimates store D7lagg
logistic DEAD Age i.District OD treattime D14_New_Cattleowner D35 publicD if multivar2==1
estimates store D7OT
logistic DEAD Age i.District OD OT D14_New_Cattleowner D35 publicD if multivar2==1
estimates store D7DT
logistic DEAD Age i.District OD OT treattime D35 publicD if multivar2==1
estimates store D7cow
logistic DEAD Age i.District OD OT treattime D14_New_Cattleowner publicD if multivar2==1
estimates store D7pay
logistic DEAD Age i.District OD OT treattime D14_New_Cattleowner D35 if multivar2==1
estimates store D7pub

lrtest D8full D7dist,stats
lrtest D8full D7lagg,stats
lrtest D8full D7OT,stats
lrtest D8full D7DT,stats
lrtest D8full D7cow,stats
lrtest D8full D7pay,stats
lrtest D8full D7pub,stats

* Test removing both public diagnosis and OD
logistic DEAD Age ib6.District OT treattime D14_New_Cattleowner D35 if multivar2==1
estimates store D6publag
* Test also removing district
logistic DEAD Age OT treattime D14_New_Cattleowner D35 if multivar2==1
estimates store D5distlag

lrtest D8full D5distlag,stats
lrtest D8full D6publag,stats
lrtest D7pub D6publag,stats
lrtest D7pub D5distlag,stats
lrtest D6publag D5distlag,stats

* D6publag is final model
