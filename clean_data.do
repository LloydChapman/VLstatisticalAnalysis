clear all

**** IMPORT RAW DATA ****
import delimited "Situational Analysis.csv", case(preserve)
destring New_D6_Patient_aliveORdead D7DD D7MM D7YY D18DD D18MM D18YYYY D24 D25C* D25G* D25H* D27 D27DAY D31DD D31MM D31YYYY D42KMC1 D42KMC2 D53KMC1 D61KMC1 D53KMC2 D61KMC2 D69KMC1 D69KMC2 D73 A26 A26A A26B A27 A28 A28ATIMES A29 A29ATIMES, replace

* Correct wrong A1_ID
replace A1_ID=TOOLID if A1_ID=="10_02_0020_008"&TOOLID=="10_02_0015_008"
replace ID=A1_ID if A1_ID=="10_02_0015_008"
* Correct A1_ID with typo
replace A1_ID="10_12_0007_053" if A1_ID=="10_12_007_053"

** CORRECT DISTRICT INFORMATION **
** Relabel districts **
/* Old labels:
1=Patna
2=Samastipur
3=Begusarai
4=East Champaran
5=West Champaran
6=Saharsa
7=Khagaria
8=Gopalganj

New labels (in order of total incidence):
1=Saharsa
2=East Champaran
3=Samastipur
4=Gopalganj
5=Begusarai
6=Khagaria
7=Patna
8=West Champaran
*/
gen New_District=A3_New_Patient_District
replace New_District=1 if A3_New_Patient_District==6
replace New_District=2 if A3_New_Patient_District==4
replace New_District=3 if A3_New_Patient_District==2
replace New_District=4 if A3_New_Patient_District==8
replace New_District=5 if A3_New_Patient_District==3
replace New_District=6 if A3_New_Patient_District==7
replace New_District=7 if A3_New_Patient_District==1
replace New_District=8 if A3_New_Patient_District==5

* Correct district names from Tool A1
replace A3="EAST CHAMPARAN" if A3=="EAST CHAMPAEAN"|A3=="EAST CHAMPAERA"|A3=="EASTCHAMPARAN"|A3=="East Champaran"|A3=="east champaran"|A3=="KALYANPUR"
replace A3="KHAGARIA" if A3=="KHAGRIA"
replace A3="GOPALGANJ" if A3=="BAIKUNTHPUR"

* Create proper case district name variable
gen New_District_Name=proper(A3)

** CORRECT BLOCK INFORMATION **
* Make new block number variable
bysort New_District A4_New_Block: gen New_Block=1 if _n==1
replace New_Block=sum(New_Block)

* Make new block name variable
gen New_Block_Name=Block_Masterlistt
gsort New_District A4_New_Block -New_Block_Name
replace New_Block_Name=New_Block_Name[_n-1] if (New_Block_Name==" "|New_Block_Name=="0")&A4_New_Block==A4_New_Block[_n-1]&_n!=1
replace New_Block_Name=proper(A4_New_Block) if New_Block_Name==" "

* Correct block number and names for mislabelled blocks
replace New_Block_Name="Ghorasahan" if New_Block_Name=="Block :GHORASAHAN"
replace New_Block_Name="Gopalganj" if New_Block_Name=="Sadar"
replace New_Block=64 if New_Block==61
replace New_Block_Name="Hathwa" if New_Block_Name=="Chabuwa"
replace New_Block=72 if New_Block==62
replace New_Block_Name="Uchakagaon" if New_Block_Name=="Dorapur"

** CLEAN DIAGNOSIS DISTRICT DATA **
replace D33DISTRICT="ARWAL" if D33DISTRICT=="ARWAL`"
replace D33DISTRICT="GOPALGANJ" if D33DISTRICT=="BAIKUNTHPUR"
replace D33DISTRICT="VARANASI (U.P.)" if D33DISTRICT=="BANARAS"|D33DISTRICT=="BANARS"|D33DISTRICT=="VARANASI"
replace D33DISTRICT="BEGUSARAI" if D33DISTRICT=="BEGUSARIA"
replace D33DISTRICT="SARAN" if D33DISTRICT=="CHAPRA"|D33DISTRICT=="CHHAPRA"
replace D33DISTRICT="DHARBHANGA" if D33DISTRICT=="DARBHANGA"
replace D33DISTRICT="DEVRIYA (U.P.)" if D33DISTRICT=="DEVRIYA (U.P)"|D33DISTRICT=="DEWARIYA UP"
replace D33DISTRICT="GOPALGANJ" if D33DISTRICT=="DIAGNOSTIC CENTRE"|D33DISTRICT=="GOPLAGANJ"
replace D33DISTRICT="EAST CHAMPARAN" if D33DISTRICT=="E CHMPARAN"|D33DISTRICT=="EAST CHMAPARAN"|D33DISTRICT=="MOTIHARI"|D33DISTRICT=="SHIVHAR"
replace D33DISTRICT="GORAKHAPUR (U.P.)" if D33DISTRICT=="GORAKHAPUR"|D33DISTRICT=="GORAKHPUR"|D33DISTRICT=="GORKHAPUR"
replace D33DISTRICT="KHAGARIA" if D33DISTRICT=="HAGARIA"|D33DISTRICT=="KHAGRIA"|D33DISTRICT=="KKHAGARIA"
replace D33DISTRICT="VAISHALI" if D33DISTRICT=="HAJIPUR"
replace D33DISTRICT="KASEYA (U.P.)" if D33DISTRICT=="KASEYA"
replace D33DISTRICT="KUSHINAGAR (U.P.)" if D33DISTRICT=="KUSHI NAGAR"|D33DISTRICT=="KUSHI NAGAR U.P"|D33DISTRICT=="KUSHI NAGAR U.P."|D33DISTRICT=="KUSHI NAGAR(UP)"|D33DISTRICT=="KUSHINAGAR"|D33DISTRICT=="KUSI NAGAR (UP)"|D33DISTRICT=="PADRAUNA"|D33DISTRICT=="TAMKHUHEE ROAD"
replace D33DISTRICT="LAKHISARAI" if D33DISTRICT=="LAKHI SARAI"
replace D33DISTRICT="WEST CHAMPARAN" if D33DISTRICT=="MJK HOSPITAL"|D33DISTRICT=="PHC"|D33DISTRICT=="W CHAMPARAN"|D33DISTRICT=="WEST CHAMPRAN"
replace D33DISTRICT="MUZAFFARPUR" if D33DISTRICT=="MUZFARPUR"|D33DISTRICT=="MUZFFARPUR"|D33DISTRICT=="MUZZFARPUR"
replace D33DISTRICT="SAHARSA" if D33DISTRICT=="NAUHATTA"
replace D33DISTRICT="PARSA (NEPAL)" if D33DISTRICT=="NEPAL"
replace D33DISTRICT="PURNIA" if D33DISTRICT=="PURNIYA"
replace D33DISTRICT="SAMASTIPUR" if D33DISTRICT=="SAMSTIPUR"
replace D33DISTRICT="SIWAN" if D33DISTRICT=="SIVAN"

** CLEAN DIAGNOSIS BLOCK DATA **
replace D33BLOCK="MOTIHARI" if D33BLOCK==" MOTIHARI"
replace D33BLOCK="ALAULI" if D33BLOCK=="ALULI"|D33BLOCK=="PHC"
replace D33BLOCK="BAIKUNTHPUR" if D33BLOCK=="BAIKUNTH PUR"|D33BLOCK=="BAIKUNTPUR"
replace D33BLOCK="BAKHRI" if D33BLOCK=="BAKHARI"|D33BLOCK=="BKHARI"
replace D33BLOCK="BARHARIYA" if D33BLOCK=="BARHARIA"|D33BLOCK=="BHRIHYA"
replace D33BLOCK="BEGUSARAI" if D33BLOCK=="BEGUSARIA"
replace D33BLOCK="BELDAUR" if D33BLOCK=="BELDAR"
replace D33BLOCK="BETTIAH" if D33BLOCK=="BETTIHA"
replace D33BLOCK="BHOREY" if D33BLOCK=="BHORE"
replace D33BLOCK="BRAHMPUTRA" if D33BLOCK=="BRAHMPUTRA,MUZFFARPUR"
replace D33BLOCK="NARKATIA (CHHAURADANO)" if D33BLOCK=="CHAURADANO"
replace D33BLOCK="CHERIA BARIARPUR" if D33BLOCK=="C.B.PUR"
replace D33BLOCK="CHHAPRA" if D33BLOCK=="CHAPRA"
replace D33BLOCK="DALSINSARAI" if D33BLOCK=="DALSING SARAI"
replace D33BLOCK="DULHIN BAJAR" if D33BLOCK=="DULHIN BAZAR"
replace D33BLOCK="FATHUA CIRCLE" if D33BLOCK=="FATHUA"|D33BLOCK=="FATUHA"
replace D33BLOCK="GARHPURA" if D33BLOCK=="GARHAPURA"
replace D33BLOCK="GOGRI" if D33BLOCK=="GOGARI"
replace D33BLOCK="GOPALGANJ" if D33BLOCK=="GOPLAGANJ"
replace D33BLOCK="KHAGARIA" if D33BLOCK=="HAGARIA"
replace D33BLOCK="HARSIDHI" if D33BLOCK=="HARISIDHI"
replace D33BLOCK="HAZIPUR" if D33BLOCK=="HAZIPUR,"
replace D33BLOCK="KAHRA" if D33BLOCK=="KAHARA"
replace D33BLOCK="KASYA" if D33BLOCK=="KASEYA U.P"
replace D33BLOCK="KHAGARIA" if D33BLOCK=="KHAGRIA"
replace D33BLOCK="KHODABANDPUR" if D33BLOCK=="KHODWANDPUR"
replace D33BLOCK="KHUSRUPUR" if D33BLOCK=="KHUSHRUPUR"
replace D33BLOCK="KUCHIKOT" if D33BLOCK=="KUCHAIKOT"|D33BLOCK=="KUCHGAW"
replace D33BLOCK="KUSHINAGAR" if D33BLOCK=="KUSHINAGAR U.P"
replace D33BLOCK="MOHIUDDINAGR" if D33BLOCK=="MAHUDDI NAGAR"|D33BLOCK=="MOHOUDDINAGAR"|(D33BLOCK=="MOHADDINAGAR"&D33DISTRICT=="SAMASTIPUR")
replace D33BLOCK="MAJHAULIA" if D33BLOCK=="MAJHULIA"
replace D33BLOCK="MANSOOR CHAK" if D33BLOCK=="MANSOORCHAK"
replace D33BLOCK="MANER" if D33BLOCK=="MENER"
replace D33BLOCK="MUZAFFARPUR" if D33BLOCK=="MUZAFARPUR"|D33BLOCK=="MUZFFARPUR"|D33BLOCK=="MUZZFARPUR"
replace D33BLOCK="BIRGANJ" if D33BLOCK=="NEPAL" /*DISTRICT=PARSA*/
replace D33BLOCK="NAUTAN" if D33BLOCK=="NORTAN"|D33BLOCK=="NOVTAY"
replace D33BLOCK="PACHDEVRI" if D33BLOCK=="PACHCEVRI"|D33BLOCK=="PANCHDEVARI"
replace D33BLOCK="PANDARAKH" if D33BLOCK=="PANDARAKHA"
replace D33BLOCK="PATNA RURAL" if D33BLOCK=="PATNA"
replace D33BLOCK="PATORI" if D33BLOCK=="PATORY"
replace D33BLOCK="PHULWARIA" if D33BLOCK=="PHULWARIYA"
replace D33BLOCK="SAHEBPUR KAMAL" if D33BLOCK=="S KAMAL"|D33BLOCK=="S,KAMAL"
/* DEAL WITH SADAR*/
replace D33BLOCK="SAHARSA" if D33BLOCK=="SADAR"&D33DISTRICT=="SAHARSA"
replace D33BLOCK="BEGUSARAI SADAR" if D33BLOCK=="SADAR"&D33DISTRICT=="BEGUSARAI"
replace D33BLOCK="SAMASTIPUR SADAR" if D33BLOCK=="SADAR"&D33DISTRICT=="SAMASTIPUR"
replace D33BLOCK="GOPALGANJ" if D33BLOCK=="SADAR"&D33DISTRICT=="GOPALGANJ"
replace D33BLOCK="PATNA RURAL" if D33BLOCK=="SADAR"&D33DISTRICT=="PATNA"
replace D33BLOCK="KHAGARIA" if D33BLOCK=="SADAR"&D33DISTRICT=="KHAGARIA"
replace D33BLOCK="SAMASTIPUR SADAR" if D33BLOCK=="SAMASTIPUR"
replace D33BLOCK="SAKARPURA" if D33BLOCK=="SAKARPUNA"
replace D33BLOCK="SATTER KATIYA" if D33BLOCK=="SATTAR KATIYA"|D33BLOCK==" SATTAR KATIYA"
replace D33BLOCK="SEWRAHI TAMKUHI ROAD" if D33BLOCK=="SEWARHI(TAMKUHI ROAD)"
replace D33BLOCK="SHIVAJINAGAR" if D33BLOCK=="SHIVAJI NAGAR"
replace D33BLOCK="SIMRIBAKHTIYARPUR" if D33BLOCK=="SIMIRIBAKTIYARPUR"|D33BLOCK=="SIMRIBAKTIYARPUR"|D33BLOCK=="SIMRIBKHATIYARPUR"
replace D33BLOCK="SONBRSA" if D33BLOCK=="SONBARSA"|D33BLOCK=="SONBARSA RAJ"|D33BLOCK=="SONBARSAS RAJ"
replace D33BLOCK="SAUR BAZAR" if D33BLOCK=="SOURBAZAR"
replace D33BLOCK="TEGHRA" if D33BLOCK=="TEGAHRA"|D33BLOCK=="TGEHRA"
replace D33BLOCK="TETARIYA" if D33BLOCK=="TETARIA"
replace D33BLOCK="THAKARAHA" if D33BLOCK=="TTHAKRAHA"
replace D33BLOCK="TURKAULIYA" if D33BLOCK=="TURKUALIYA"
replace D33BLOCK="VIDYAPATINAGR" if D33BLOCK=="VIDYAPATINAGAR"
replace D33BLOCK="BIKRAM" if D33BLOCK=="VIKARM"
replace D33BLOCK="WARISNAGAR" if D33BLOCK=="WARISHNAGAR"

** CLEAN RELATIONSHIP DATA FOR OTHER CASES FROM TOOL A1 **
program CleanRltnshpData

replace `1'=" " if `1'=="0"
replace `1'="" if `1'==" "
replace `1'="AUNT" if `1'=="AUNTY"|`1'=="CHACHI"|`1'=="MAAMI"|`1'=="MAMI"|`1'=="UNTI"
replace `1'="BROTHER" if `1'=="BHAI"|`1'=="BHAE"|`1'=="BIG BROTHE"|`1'=="BROTER"|`1'=="BROTHAER"|`1'=="BROTHAR"|`1'=="BROTHERR"|`1'=="CHOTA BHAI"|`1'=="BRUTHER"
replace `1'="BROTHER IN LAW" if `1'=="BROTHER IN"|`1'=="DEVAR"|`1'=="DEWAR"|`1'=="DEVER"|`1'=="JIJA"|`1'=="JIJA JI"
replace `1'="COUSIN" if `1'=="COUSION"|`1'=="COUSIN BRO"|`1'=="COSOUN BRO"|`1'=="COSSAN BRO"|`1'=="CUSION BRO"|`1'=="CHACHERA B"|`1'=="BHAE CHA."
replace `1'="SON" if `1'=="BETA"|`1'=="son"
replace `1'="DAUGHTER" if `1'=="BETI"|`1'=="BETI RILAT"|`1'=="DAUGHTAR"|`1'=="DAUGHTER I"|`1'=="DAUGHTERQ"|`1'=="DOUGHTER"
replace `1'="DAUGHTER IN LAW" if `1'=="BAHU"|`1'=="PUTOH"|`1'=="PUTOHU"
replace `1'="DOCTOR" if `1'=="DR. K"
replace `1'="FATHER IN LAW" if `1'=="F IN LAW"
replace `1'="FATHER" if `1'=="FATHER`"|`1'=="SSUR"
replace `1'="FRIEND" if `1'=="FREAND"|`1'=="FRIEND'S"|`1'=="FREANDS"|`1'=="FREND"|`1'=="FREANDKA S"
replace `1'="FRIEND'S SON" if `1'=="FRINDE SON"
replace `1'="GRANDFATHER" if `1'=="DADA"|`1'=="DADA'"|`1'=="DRAND FATH"|`1'=="GRAND FATH"|`1'=="NANA"
replace `1'="GRANDMOTHER" if `1'=="DADI"|`1'=="GRAND MOTH"|`1'=="GRAND MOTHER"|`1'=="GREAND MOT"|`1'=="BADI MAA"|`1'=="NANI"	
replace `1'="VILLAGER" if `1'=="IN VILLAGE"|`1'=="OF VILLAGE"|`1'=="TO VILLAGE"|`1'=="GAU KAY"|`1'=="GAUAKA"|`1'=="GAW"|`1'=="GAW KA"|`1'=="GAW KAY"|`1'=="VIILAGE"|`1'=="VILAGERS"|`1'=="VILLAGE"|`1'=="VILLAGE MAN"|`1'=="VILLAGE MANE"|`1'=="VILLAGE ME"|`1'=="VILLAGERS"|`1'=="VILLAGES"|`1'=="VILLAGESS"|`1'=="VILLEGE"|`1'=="VILLEGER"|`1'=="VILLEGERS"|`1'=="VILLEGES"
replace `1'="NEIGHBOUR" if `1'=="PROSI"|`1'=="PADOSI"|`1'=="PAROSI"|`1'=="PRISI"|`1'=="PROSIA"|`1'=="PROSIN"|`1'=="PROSSI"|`1'=="PRSI"|`1'=="PROIS"|`1'=="PROSI KA DMAD"|`1'=="PADOS KA G"|`1'=="PADOSAN"|`1'=="PDOSI"|`1'=="PAROSHI"|`1'=="MEIGHBOUR"|`1'=="MNEIGHBOUR"|`1'=="NAGBAOUR"|`1'=="NEBOUR"|`1'=="NEGHBOUR"|`1'=="NEGHIBOUR"|`1'=="NEI"|`1'=="NEIBHOUR"|`1'=="NEIBOUR"|`1'=="NEIGBOUR"|`1'=="NEIGH"|`1'=="NEIGH."|`1'=="NEIGHAUR"|`1'=="NEIGHBAV"|`1'=="NEIGHBLURS"|`1'=="NEIGHBO;UR"|`1'=="NEIGHBOR"|`1'=="NEIGHBORHO"|`1'=="NEIGHBORHOOD"|`1'=="NEIGHBOUR (PAROSI)"|`1'=="NEIGHBOUR'"|`1'=="NEIGHBOURHOOD"|`1'=="NEIGHBOURS"|`1'=="NEIGHBOUS"|`1'=="NEIGHBOUT"|`1'=="NEIGHOURS"|`1'=="NEIGHTWSI"|`1'=="NEIGHVER"|`1'=="NEIHGNOUS"|`1'=="NEIOGBOUR"|`1'=="NEVER"|`1'=="NEVERHOOD"|`1'=="NIBHOUR"|`1'=="NIEGHBORHO"|`1'=="NIGBAR"|`1'=="NIGBAUAR"|`1'=="NIGBONAR"|`1'=="NIGBOUR"|`1'=="NIGBOURT"|`1'=="NIGBUNR"|`1'=="NIGBURS"|`1'=="NIGHABOUR"|`1'=="NIGHBOUAR"|`1'=="NIGHBOUR"|`1'=="NIGHOUR"|`1'=="NIGHOWR"|`1'=="NIGNOUR"|`1'=="NAGBAOUR"|`1'=="NAGHIBOUR"|`1'=="NEIHOUR"
replace `1'="NIECE" if `1'=="BHATIJI"|`1'=="BHAITIJI"|`1'=="NICE"
replace `1'="NEPHEW" if `1'=="BHATIJA"|`1'=="BAHTIJA"|`1'=="BHTIJA"|`1'=="BTIJA"|`1'=="NEFUE"|`1'=="NEPHU"
replace `1'="MOTHER" if `1'=="MOTHESR"|`1'=="MA"
replace `1'="SAME HOUSE" if `1'=="OF HOME"|`1'=="ON HOME"
replace `1'="SISTER IN LAW" if `1'=="BHABHI"|`1'=="BHBHI"|`1'=="BHIBHI"|`1'=="NANAD"|`1'=="NAND"|`1'=="SISTERINLW"
replace `1'="SISTER" if `1'=="BAHAN"|`1'=="DIDI"|`1'=="FOUR SISTE"|`1'=="FUWA DIDI"|`1'=="SISITER"|`1'=="SISTAR"|`1'=="SISTER\"|`1'=="SISTER`"|`1'=="SSISTER"|`1'=="SISTER BET"
replace `1'="RURAL PERSON" if `1'=="GARAMIN"|`1'=="GRAMIN"|`1'=="GRA."|`1'=="GRAMEEN"|`1'=="GRAMIN PAD"|`1'=="GRAMIN PAR"
replace `1'="UNCLE" if `1'=="CHACHA"|`1'=="MAAMA"|`1'=="MAMA"|`1'=="UNCAL"|`1'=="UNCEL"
replace `1'="GRANDSON" if `1'=="POTA"
replace `1'="GRANDDAUGHTER" if `1'=="POTI"|`1'=="NATIN"|`1'=="GRANDDAUGH"
replace `1'="GRANDCHILD" if `1'=="NATINI"|`1'=="NATNI"

end

CleanRltnshpData RSHIP1
CleanRltnshpData RSHIP2
CleanRltnshpData RSHIP3
CleanRltnshpData RSHIP4
CleanRltnshpData RSHIP5

** Show number of individuals who know more than 1 other case in each district
* tab New_District if SEX1!=" "&SEX2!=" "&SEX1!="0"&SEX2!="0"
** Show number of each type of relationship with (first) other case for each district
* tab RSHIP1 New_District, column rowsort

** MAKE NEW AGE VARIABLE **
gen Age=New_D19_Age
replace Age=. if Age==9999

** FUNCTION TO CORRECT DATES AS THE EXCEL DATE FUNCTION DOES **
program ExcelDateFn

gen wrng_dt1=1 if `1'==0
gen wrng_dt2=1 if `2'==2&`1'!=.&`1'>28&`3'!=2012
gen wrng_dt3=1 if `2'==2&`1'!=.&`1'>29&`3'==2012
gen wrng_dt4=1 if (`2'==4|`2'==6|`2'==9|`2'==11)&`1'!=.&`1'>30
gen jan_mnth=1 if `2'==1

* Shift dates with 0 for day to last day of previous month
replace `1'=. if wrng_dt1==1

* Shift Feb dates with too many days in to equivalent date in March
replace `1'=`1'-28 if wrng_dt2==1
replace `1'=`1'-29 if wrng_dt3==1
replace `2'=3 if wrng_dt2==1|wrng_dt3==1 
  
* Shift dates with 31 for day in months with 30 days to first day of next month
replace `1'=1 if wrng_dt4==1
replace `2'=`2'+1 if wrng_dt4==1

drop wrng_dt* jan_mnth

end

ExcelDateFn D18DD D18MM D18YYYY
ExcelDateFn D31DD D31MM D31YYYY
ExcelDateFn D25CDD1MC D25CMM1MC D25CYY1MC

gen Onset=mdy(D18MM,D18DD,D18YYYY)
gen Diagnosis=mdy(D31MM,D31DD,D31YYYY)
gen D25DATE=mdy(D25CMM1MC,D25CDD1MC,D25CYY1MC)

* Calculate onset-diagnosis time
gen Lag=Diagnosis-Onset

* Combine day, month and year columns for 2nd to 4th pre-diagnosis treatment (PDT) dates and death date
gen D25DATE2=mdy(D25CMM2MC,D25CDD2MC,D25CYY2MC)
gen D25DATE3=mdy(D25CMM3MC,D25CDD3MC,D25CYY3MC)
gen D25DATE4=mdy(D25CMM4MC,D25CDD4MC,D25CYY4MC)
gen Death=mdy(D7MM,D7DD,D7YY) if New_D6_Patient_aliveORdead==2

destring A11 A12DD A12MM A12YY A15DD A15MM A15YY A19DD A19MM A19YY A23B1DD A23B1MM A23B1YYYY A23B2DD A23B2MM A23B2YY A23B3DD A23B3MM A23B3YY A23B4DD A23B4MM A23B4YY, replace
replace A15YY=2012 if (A15YY==2017|A15YY==2021|A15YY==2102|A15YY==1582)
replace A23B1YYYY=2012 if (A23B1YYYY==2102|A23B1YYYY==2201|A23B1YYYY==1582)
replace A23B2YY=2012 if A23B2YY==1582
replace A23B3YY=2012 if A23B3YY==2102|A23B3YY==1582
replace A23B4YY=2012 if A23B4YY==1582
replace A23B1YYYY=2013 if A23B1YYYY==1583
replace A23B2YY=2013 if A23B2YY==1583
replace A23B3YY=2013 if A23B3YY==1583
replace A23B4YY=2013 if A23B4YY==1583
gen Original_Onset=mdy(A15MM,A15DD,A15YY)
gen Original_DATE=mdy(A23B1MM,A23B1DD,A23B1YYYY)
gen Original_DATE2=mdy(A23B2MM,A23B2DD,A23B2YY)
gen Original_DATE3=mdy(A23B3MM,A23B3DD,A23B3YY)
gen Original_DATE4=mdy(A23B4MM,A23B4DD,A23B4YY)
gen Original_Diagnosis=mdy(A19MM,A19DD,A19YY)
gen Original_Death=mdy(A12MM,A12DD,A12YY)

* Change display format for dates
format Onset D25DATE* Diagnosis Death Original_Onset Original_DATE* Original_Diagnosis Original_Death %tdDD/NN/YY

** FILL IN MISSING DATA WHERE POSSIBLE AND WHERE GENERATED DATES ARE CONSISTENT **
* Fill in Onset where Onset is missing but PDTi and OPDTi are available and OD>0 if Diagnosis is available, i=1,2,3,4
replace Onset=D25DATE-D25C1MCDAY if Onset==.&D25DATE!=.&D25C1MCDAY!=.&Diagnosis!=.&D25DATE-D25C1MCDAY<Diagnosis&D25DATE<=Diagnosis
replace Onset=D25DATE2-D25C2MCDAY if Onset==.&D25DATE2!=.&D25C2MCDAY!=.&Diagnosis!=.&D25DATE2-D25C2MCDAY<Diagnosis&D25DATE2<=Diagnosis
replace Onset=D25DATE3-D25C3MCDAY if Onset==.&D25DATE3!=.&D25C3MCDAY!=.&Diagnosis!=.&D25DATE3-D25C3MCDAY<Diagnosis&D25DATE3<=Diagnosis
replace Onset=D25DATE4-D25C4MCDAY if Onset==.&D25DATE4!=.&D25C4MCDAY!=.&Diagnosis!=.&D25DATE4-D25C4MCDAY<Diagnosis&D25DATE4<=Diagnosis

replace Onset=D25DATE-D25C1MCDAY if Onset==.&D25DATE!=.&D25C1MCDAY!=.&Diagnosis==.
replace Onset=D25DATE2-D25C2MCDAY if Onset==.&D25DATE2!=.&D25C2MCDAY!=.&Diagnosis==.
replace Onset=D25DATE3-D25C3MCDAY if Onset==.&D25DATE3!=.&D25C3MCDAY!=.&Diagnosis==.
replace Onset=D25DATE4-D25C4MCDAY if Onset==.&D25DATE4!=.&D25C4MCDAY!=.&Diagnosis==.

* Fill in Diagnosis where Diagnosis is missing but Onset and PDTi are present and person tested positive for KA at PDTi, i=1,2,3,4
replace Diagnosis=D25DATE if Diagnosis==.&Onset!=.&D25DATE!=.&D25G1MC==1&D25H1MC==1&Onset<D25DATE
replace Diagnosis=D25DATE2 if Diagnosis==.&Onset!=.&D25DATE2!=.&D25G2MC==1&D25H2MC==1&Onset<D25DATE2
replace Diagnosis=D25DATE3 if Diagnosis==.&Onset!=.&D25DATE3!=.&D25G3MC==1&D25H3MC==1&Onset<D25DATE3
replace Diagnosis=D25DATE4 if Diagnosis==.&Onset!=.&D25DATE4!=.&D25G4MC==1&D25H4MC==1&Onset<D25DATE4

** MAKE TIMELINE VARIABLE TO SHOW WHERE ORDER OF DATES IS WRONG **
gen timeline=1
* Missing one of onset date, diagnosis date or onset-KA-treatment time
replace timeline=10 if (Onset==.|D42KMC1==.|Diagnosis==.)
* Negative onset-diagnosis (OD) lag
replace timeline=0 if Lag<0&timeline==1
* Onset after pre-diagnosis treatment 1
replace timeline=11 if Onset>D25DATE&timeline==1&Onset!=.
* Onset after pre-diagnosis treatment 2
replace timeline=12 if Onset>D25DATE2&timeline==1&Onset!=.
* Onset after pre-diagnosis treatment 3
replace timeline=13 if Onset>D25DATE3&timeline==1&Onset!=.
* Onset after pre-diagnosis treatment 4
replace timeline=14 if Onset>D25DATE4&timeline==1&Onset!=.

* Diagnosis before PDT1
replace timeline=-1 if Diagnosis<D25DATE&timeline==1&D25DATE!=.
* Diagnosis before PDT2
replace timeline=-2 if Diagnosis<D25DATE2&timeline==1&D25DATE2!=.
* Diagnosis before PDT3
replace timeline=-3 if Diagnosis<D25DATE3&timeline==1&D25DATE3!=.
* Diagnosis before PDT4
replace timeline=-4 if Diagnosis<D25DATE4&timeline==1&D25DATE4!=.

** MAKE ERROR VARIABLE TO SHOW TYPE OF ERROR **
gen error=.
* Onset same as diagnosis
replace error=0 if Onset==Diagnosis
* Onset date 1 day after one PDTs
replace error=-1 if Onset!=.&(Onset==D25DATE+1|Onset==D25DATE2+1|Onset==D25DATE3+1|Onset==D25DATE4+1)
* Remove above error (error=-1) if Onset is more than 1 day after any of PDTs
replace error=.  if Onset!=.&(Onset>D25DATE+1|Onset>D25DATE2+1|Onset>D25DATE3+1|Onset>D25DATE4+1)&error==-1
* Onset exactly a year after one of the PDTs
replace error=-100 if Onset!=.&(Onset==D25DATE+365|Onset==D25DATE2+365|Onset==D25DATE3+365|Onset==D25DATE4+365)
* Diagnosis is 1 day before one of the PDTs
replace error=1 if Diagnosis!=.&(Diagnosis==D25DATE-1|Diagnosis==D25DATE2-1|Diagnosis==D25DATE3-1|Diagnosis==D25DATE4-1)
* Remove above error (error=1) if diagnosis is more than 1 day before any of the PDTs
replace error=. if Diagnosis!=.&Diagnosis<D25DATE-1&D25DATE!=.&error==1
replace error=. if Diagnosis!=.&Diagnosis<D25DATE2-1&D25DATE2!=.&error==1
replace error=. if Diagnosis!=.&Diagnosis<D25DATE3-1&D25DATE3!=.&error==1
replace error=. if Diagnosis!=.&Diagnosis<D25DATE4-1&D25DATE4!=.&error==1
* Diagnosis is exactly a year before one of the PDTs (366 days for 2012 as it was a leap year)
replace error=100 if Diagnosis!=.&(Diagnosis==D25DATE-365|Diagnosis==D25DATE2-365|Diagnosis==D25DATE3-365|Diagnosis==D25DATE4-365)
replace error=101 if Diagnosis!=.&(Diagnosis==D25DATE-366|Diagnosis==D25DATE2-366|Diagnosis==D25DATE3-366|Diagnosis==D25DATE4-366)

* Diagnosis is before one PDT and difference between onset-to-pre-diagnosis treatment times (OPDTi-OPDT1) is more than 300 days different from PDTi-PDT1
replace error=99 if D25C4MCDAY!=.&D25C1MCDAY!=.&timeline==-4&(D25DATE4-D25DATE>D25C4MCDAY-D25C1MCDAY+300|D25DATE4-D25DATE<D25C4MCDAY-D25C1MCDAY-300)
replace error=99 if D25C3MCDAY!=.&D25C1MCDAY!=.&timeline==-3&(D25DATE3-D25DATE>D25C3MCDAY-D25C1MCDAY+300|D25DATE3-D25DATE<D25C3MCDAY-D25C1MCDAY-300)
replace error=99 if D25C2MCDAY!=.&D25C1MCDAY!=.&timeline==-2&(D25DATE2-D25DATE>D25C2MCDAY-D25C1MCDAY+300|D25DATE2-D25DATE<D25C2MCDAY-D25C1MCDAY-300)
replace error=99 if D25C2MCDAY!=.&D25C1MCDAY!=.&timeline==-1&D25DATE2-D25DATE<0&D25C2MCDAY-D25C1MCDAY>=0
* Onset is after one PDT and difference between onset-to-pre-diagnosis treatment times (OPDTi-OPDT1) is more than 300 days different from PDTi-PDT1
replace error=-99 if D25C4MCDAY!=.&D25C1MCDAY!=.&timeline==14&(D25DATE4-D25DATE>D25C4MCDAY-D25C1MCDAY+300|D25DATE4-D25DATE<D25C4MCDAY-D25C1MCDAY-300)
replace error=-99 if D25C3MCDAY!=.&D25C1MCDAY!=.&timeline==13&(D25DATE3-D25DATE>D25C3MCDAY-D25C1MCDAY+300|D25DATE3-D25DATE<D25C3MCDAY-D25C1MCDAY-300)
replace error=-99 if D25C2MCDAY!=.&D25C1MCDAY!=.&timeline==12&(D25DATE2-D25DATE>D25C2MCDAY-D25C1MCDAY+300|D25DATE2-D25DATE<D25C2MCDAY-D25C1MCDAY-300)
replace error=-99 if D25C2MCDAY!=.&D25C1MCDAY!=.&timeline==11&D25DATE2-D25DATE<0&D25C2MCDAY-D25C1MCDAY>=0

**** CORRECT DATES ****
* Make new variables for overwriting dates
gen New_Onset=Onset
gen New_Diagnosis=Diagnosis
gen New_DATE=D25DATE
gen New_DATE2=D25DATE2
gen New_DATE3=D25DATE3
gen New_DATE4=D25DATE4
gen New_Death=Death
* Put them in easier to read format
format New_Onset New_DATE New_DATE2 New_DATE3 New_DATE4 New_Diagnosis New_Death %tdDD/NN/YY

** CORRECT DATES WHICH APPEAR TO BE OUT BY A YEAR
* Move PDT1 back by 1 year if diagnosis is exactly a year before it, and onset and diagnosis years are the same
replace New_DATE=New_DATE-365 if error==100&timeline==-1&D18YYYY==D31YYYY&D31YYYY==D25CYY1MC-1
* Move PDT3 back by 1 year if diagnosis is exactly a year before it, and onset and diagnosis years are the same
replace New_DATE3=New_DATE3-365 if error==100&timeline==-3&D18YYYY==D31YYYY&D31YYYY==D25CYY3MC-1
* There are no changes for PDT2 and PDT4 with the above

* Move diagnosis forward by 1 year if OD<0 and diagnosis is exactly 1 year before PDT
replace New_Diagnosis=New_Diagnosis+365 if error==100&Lag<0
replace New_Diagnosis=New_Diagnosis+366 if error==101&Lag<0
* Recalculate onset-diagnosis time
replace Lag=New_Diagnosis-New_Onset
* Move diagnosis forward by 1 year if OD<0 and Onset year = PDT1 year = PDT2 year = diagnosis year + 1
replace New_Diagnosis=New_Diagnosis+365 if New_DATE!=.&New_DATE2!=.&D18YYYY==D25CYY1MC&D18YYYY==D25CYY2MC&D18YYYY==D31YYYY+1&Lag<0
* Recalculate onset-diagnosis time
replace Lag=New_Diagnosis-New_Onset
* Move PDTi forward by 1 year if PDTi<Onset and diagnosis year = onset year = PDTi year + 1, i=1,2
replace New_DATE=New_DATE+365 if timeline==11&D31YYYY==D18YYYY&D31YYYY==D25CYY1MC+1
replace New_DATE2=New_DATE2+365 if timeline==12&D31YYYY==D18YYYY&D31YYYY==D25CYY2MC+1
replace New_DATE3=New_DATE3+365 if timeline==13&D31YYYY==D18YYYY&D31YYYY==D25CYY3MC+1
replace New_DATE4=New_DATE4+365 if timeline==14&D31YYYY==D18YYYY&D31YYYY==D25CYY4MC+1
* Move PDT1 forward by 1 year if PDT1<Onset and diagnosis is more than a year after PDT1
replace New_DATE=New_DATE+365 if timeline==11&New_Diagnosis>New_DATE+365

** CORRECT NEGATIVE ONSET-DIAGNOSIS **
* Replace Onset with PDT1-OPDT1 if OD<0 and diagnosis is after or same as PDT1
replace New_Onset=New_DATE-D25C1MCDAY if New_DATE!=.&D25C1MCDAY!=.&New_Diagnosis>=New_DATE&Lag<0
* Recalculate onset-diagnosis time
replace Lag=New_Diagnosis-New_Onset
* Move Onset and PDT1 back by 1 year if OD<0 and Onset year=PDT1 year and PDT2<Onset<PDT1 and Onset-365<=PDT1-365<=PDT2
gen New_Onset_temp=New_Onset
replace New_Onset=New_Onset-365 if New_DATE!=.&New_DATE2!=.&New_Onset<=New_DATE&D18YYYY==D25CYY1MC&New_DATE2<New_Onset&Lag<-200&New_Onset-365<=New_DATE-365&New_DATE-365<=New_DATE2
replace New_DATE=New_DATE-365 if New_DATE!=.&New_DATE2!=.&New_Onset_temp<=New_DATE&D18YYYY==D25CYY1MC&New_DATE2<New_Onset_temp&Lag<-200&New_Onset_temp-365<=New_DATE-365&New_DATE-365<=New_DATE2
drop New_Onset_temp
replace Lag=New_Diagnosis-New_Onset

* Replace diagnosis date by PDT date if OD<0 and individual tested positive for KA at PDT
replace New_Diagnosis=New_DATE if New_DATE!=.&D25G1MC==1&D25H1MC==1&D26_New==1&Lag<0
replace New_Diagnosis=New_DATE2 if New_DATE2!=.&D25G2MC==1&D25H2MC==1&D26_New==1&Lag<0
replace New_Diagnosis=New_DATE3 if New_DATE3!=.&D25G3MC==1&D25H3MC==1&D26_New==1&Lag<0
replace New_Diagnosis=New_DATE4 if New_DATE4!=.&D25G4MC==1&D25H4MC==1&D26_New==1&Lag<0
replace Lag=New_Diagnosis-New_Onset

** CORRECT DIAGNOSIS BEFORE PRE-DIAGNOSIS TREATMENT **
* Replace PDT1 with Onset+OPDT1 if Diagnosis<PDT1 and PDT1 is more than a year after Onset
replace New_DATE=New_Onset+D25C1MCDAY if timeline==-1&D25C1MCDAY!=.&New_DATE>New_Onset+365
* Replace PDT1 with Onset+OPDT1 if Diagnosis<PDT1 and PDT2-PDT1 disagrees with OPDT2-OPDT1
replace New_DATE=New_Onset+D25C1MCDAY if New_DATE!=.&New_DATE2!=.&New_Diagnosis<New_DATE&error==99
* Replace Diagnosis with PDT1 if Diagnosis<PDT1 and Onset=Diagnosis
replace New_Diagnosis=New_DATE if timeline==-1&New_DATE!=.&error==0&D25G1MC==1&D25H1MC==1&D26_New==1
* Replace Diagnosis with PDT2 if Diagnosis<PDT1 and Onset=Diagnosis
replace New_Diagnosis=New_DATE2 if timeline==-1&New_DATE2!=.&error==0&D25G2MC==1&D25H2MC==1&D26_New==1
* Replace PDT2 with Diagnosis if PDT1!=Diagnosis<PDT2, individual tested positive for KA at PDT2 and documents were seen, and there were no further PDTs
replace New_DATE2=New_Diagnosis if timeline==-2&New_DATE!=.&New_DATE!=New_Diagnosis&D25G2MC==1&D25H2MC==1&D26_New==1&New_DATE3==.&New_DATE4==.
* Replace PDT2 with PDT1+(OPDT2-OPDT1) if Diagnosis<PDT2 still and PDT1+(OPDT2-OPDT1)<Diagnosis
replace New_DATE2=New_DATE+D25C2MCDAY-D25C1MCDAY if New_DATE!=.&New_DATE2!=.&New_Diagnosis!=.&D25C2MCDAY!=.&D25C1MCDAY!=.&New_Diagnosis<New_DATE2&New_DATE+D25C2MCDAY-D25C1MCDAY<New_Diagnosis
* Replace PDT1 with Diagnosis if PDT1-Onset>OPDT1 and patient had positive KA test at PDT1 and no PDT2 and OD is close to OPDT1
replace New_DATE=New_Diagnosis if timeline==-1&New_DATE-New_Onset>D25C1MCDAY&New_DATE2==.&D25G1MC==1&D25H1MC==1&abs(Lag-D25C1MCDAY)<=5

* Replace Diagnosis with PDT if PDT is 1 day after diagnosis and individual tested positive for KA at PDT and diagnosis documents were not seen
replace New_Diagnosis=New_DATE4 if New_DATE4!=.&New_DATE4==New_Diagnosis+1&D25G4MC==1&D25H4MC==1&D26_New!=1
replace New_Diagnosis=New_DATE3 if New_DATE3!=.&New_DATE3==New_Diagnosis+1&D25G3MC==1&D25H3MC==1&D26_New!=1
replace New_Diagnosis=New_DATE2 if New_DATE2!=.&New_DATE2==New_Diagnosis+1&D25G2MC==1&D25H2MC==1&D26_New!=1
replace New_Diagnosis=New_DATE if New_DATE!=.&New_DATE==New_Diagnosis+1&D25G1MC==1&D25H1MC==1&D26_New!=1

** CORRECT ONSET AFTER PRE-DIAGNOSIS TREATMENT **
* Replace PDT1 by Diagnosis if PDT1<Onset and individual tested positive for KA at PDT1 and diagnosis documents were not seen
replace New_DATE=New_Diagnosis if timeline==11&D25G1MC==1&D25H1MC==1&D26_New!=1
* Replace onset by PDT1-OPDT1 if PDT1<Onset and Onset=Diagnosis
replace New_Onset=New_DATE-D25C1MCDAY if timeline==11&error==0&D25C1MCDAY!=. 
* Replace PDT1 with Onset+OPDT1 if PDT1<Onset<PDT2 and Onset+OPDT1<=PDT2
replace New_DATE=New_Onset+D25C1MCDAY if timeline==11&New_DATE2!=.&New_Onset+D25C1MCDAY<=New_DATE2
* Replace PDT1 with Onset+OPDT1 if PDT1<Onset and Onset+OPDT1<=Diagnosis if there is no PDT2
replace New_DATE=New_Onset+D25C1MCDAY if timeline==11&New_DATE2==.&New_Onset+D25C1MCDAY<=New_Diagnosis
* Replace Onset with PDT1-OPDT1 if PDT1<Onset<Diagnosis still
replace New_Onset=New_DATE-D25C1MCDAY if New_Onset!=.&New_DATE!=.&New_Diagnosis!=.&New_DATE<New_Onset&New_Onset<New_Diagnosis

* Replace PDT2 with PDT1+(OPDT2-OPDT1) if PDT2<Onset and PDT2<PDT1
replace New_DATE2=New_DATE+D25C2MCDAY-D25C1MCDAY if timeline==12&D25C2MCDAY!=.&D25C1MCDAY!=.
* Replace PDT3 with PDT1+(OPDT3-OPDT1) if PDT3<Onset and PDT3<PDT1
replace New_DATE3=New_DATE+D25C3MCDAY-D25C1MCDAY if timeline==13&D25C3MCDAY!=.&D25C1MCDAY!=.

** CORRECT DATES WHEN THEY ARE CONSISTENT BUT ONSET-DIAGNOSIS TIME IS TOO LONG **
* Replace Onset with PDT1-OPDT1 if OD is more than 200 days longer than onset-to-KA-treatment time and Onset is more than a year before PDT1
replace New_Onset=New_DATE-D25C1MCDAY if timeline==1&New_DATE!=.&D25C1MCDAY!=.&Lag>D42KMC1+200&New_Onset<New_DATE-365
* Replace Diagnosis with last PDT if it is exactly a year after last PDT and OD is more than 200 days longer than onset-to-KA-treatment time
replace New_Diagnosis=max(New_DATE,New_DATE2,New_DATE3,New_DATE4) if timeline==1&Lag>D42KMC1+200&(New_Diagnosis==max(New_DATE,New_DATE2,New_DATE3,New_DATE4)+365|New_Diagnosis==max(New_DATE,New_DATE2,New_DATE3,New_DATE4)+366)
* Move diagnosis back by 1 year if it is more than a year after last PDT and OD is more than 200 days longer than onset-to-KA-treatment time
replace New_Diagnosis=New_Diagnosis-365 if timeline==1&Lag>D42KMC1+200&max(New_DATE,New_DATE2,New_DATE3,New_DATE4)<New_Diagnosis-365

** CHECK CONSISTENCY OF DATES WITH MISSING ONSET, DIAGNOSIS OR ONSET-TO-KA-TREATMENT TIME AND CORRECT WHERE POSSIBLE **
gen timeline10=1 if timeline==10
replace timeline10=0 if Lag<0&timeline10==1
replace timeline10=11 if New_Onset>New_DATE&New_Onset!=.&timeline10==1
replace timeline10=12 if New_Onset>New_DATE2&New_Onset!=.&timeline10==1
replace timeline10=13 if New_Onset>New_DATE3&New_Onset!=.&timeline10==1
replace timeline10=14 if New_Onset>New_DATE4&New_Onset!=.&timeline10==1
replace timeline10=-1 if New_Diagnosis<New_DATE&New_DATE!=.&timeline10==1
replace timeline10=-2 if New_Diagnosis<New_DATE2&New_DATE2!=.&timeline10==1
replace timeline10=-3 if New_Diagnosis<New_DATE3&New_DATE3!=.&timeline10==1
replace timeline10=-4 if New_Diagnosis<New_DATE4&New_DATE4!=.&timeline10==1

* N.B. Negative ODs here (timeline10=0) corrected by hand *

* Onset>PDT1 *
* Replace Onset with PDT1-OPDT1 where D42KMC1 is missing and Onset>PDT1 and Onset=Diagnosis 
replace New_Onset=New_DATE-D25C1MCDAY if timeline10==11&New_Diagnosis!=.&New_Onset==New_Diagnosis
* Replace PDT1 with Onset+OPDT1 where D42KMC1 is missing and PDT1<Onset-1yr or PDT2>New_Onset
replace New_DATE=New_Onset+D25C1MCDAY if timeline10==11&(New_DATE<New_Onset-366|(New_DATE2!=.&New_DATE2>New_Onset))

* Onset>PDT3 *
* Replace Onset, PDT1 and PDT2 years for individual whose diagnosis year was a year earlier and documents were seen
replace New_Onset=New_Onset-365 if timeline10==13&D18YYYY==D25CYY1MC&D18YYYY==D25CYY2MC&D18YYYY==D31YYYY+1&D26_New==1
replace New_DATE=New_DATE-365 if timeline10==13&D18YYYY==D25CYY1MC&D18YYYY==D25CYY2MC&D18YYYY==D31YYYY+1&D26_New==1
replace New_DATE2=New_DATE2-365 if timeline10==13&D18YYYY==D25CYY1MC&D18YYYY==D25CYY2MC&D18YYYY==D31YYYY+1&D26_New==1
* Revert earlier change in diagnosis year to 2013
replace New_Diagnosis=New_DATE3 if timeline10==13&D18YYYY==D25CYY1MC&D18YYYY==D25CYY2MC&D18YYYY==D31YYYY+1&D26_New==1
* Replace PDT3 with Onset+OPDT3 for individual whose other PDT dates are consistent
replace New_DATE3=New_Onset+D25C3MCDAY if timeline10==13&D25C3MCDAY!=.&New_DATE4!=.&New_Onset+D25C3MCDAY<New_DATE4

* Diagnosis<PDT3 *
* Replace Diagnosis with PDT3 for individual whose diagnosis is exactly a year before PDT3 and tested positive for KA at PDT3 
replace New_Diagnosis=New_DATE3 if timeline10==-3&New_DATE3==New_Diagnosis+365&D25G3MC==1&D25H3MC==1
* Fill in onset for this individual now that dates are consistent
replace New_Onset=New_DATE3-D25C3MCDAY if timeline10==-3&D25C3MCDAY!=.&New_Diagnosis==Diagnosis+365&D25G3MC==1&D25H3MC==1

* Diagnosis<PDT1 *
* Replace Diagnosis date where it's been miscopied (documents not seen) and Onset is missing and PDT1 and Diagnosis are in the same year
replace New_Diagnosis=max(New_DATE,New_DATE2,New_DATE3,New_DATE4) if timeline10==-1&New_Onset==.&D25CYY1MC==D31YYYY&D26!=1
* Fill in Onset dates for these individuals
replace New_Onset=New_DATE-D25C1MCDAY if timeline10==-1&New_Onset==.&D25C1MCDAY!=.&D25CYY1MC==D31YYYY&D26!=1

* Replace PDT1 with Diagnosis if Diagnosis<PDT1 still and Onset is missing & Diagnosis date=Original Diagnosis date
replace New_DATE=New_Diagnosis if New_Diagnosis<New_DATE&New_DATE!=.&New_Onset==.&New_Diagnosis==Original_Diagnosis
* Fill in Onset dates for these individuals
replace New_Onset=New_DATE-D25C1MCDAY if New_Diagnosis<D25DATE&D25DATE!=.&D25C1MCDAY!=.&New_Onset==.&New_Diagnosis==Original_Diagnosis

* Replace PDT1 with Diagnosis for individual with date of death before PDT1
replace New_DATE=New_Diagnosis if timeline10==-1&Lag==0&New_DATE==New_Diagnosis+366
* Replace Onset with PDT1-OPDT1 for this individual
replace New_Onset=New_DATE-D25C1MCDAY if timeline10==-1&D25C1MCDAY!=.&Lag==0&D25DATE==New_Diagnosis+366

** FILL IN ONSET AND DIAGNOSIS DATES FROM ORIGINAL SURVEY (TOOL A1) IF New_Onset/New_Diagnosis DATE IS MISSING AND Original_Onset/Original_Diagnosis DATE IS CONSISTENT **
replace New_Onset=Original_Onset if New_Onset==.&Original_Onset!=.&Original_Diagnosis!=.&New_Diagnosis!=.&Original_Diagnosis==New_Diagnosis&Original_Onset<New_Diagnosis
replace New_Diagnosis=Original_Diagnosis if New_Diagnosis==.&Original_Diagnosis!=.&New_Onset!=.&New_Onset<Original_Diagnosis
replace New_Diagnosis=Original_Diagnosis if New_Diagnosis==.&Original_Diagnosis!=.&New_Onset==.&Original_Onset!=.&Original_Onset<Original_Diagnosis
replace New_Diagnosis=Original_Diagnosis if New_Diagnosis==.&Original_Diagnosis!=.&Original_Onset==.&New_Onset==.
replace New_Onset=Original_Onset if New_Onset==.&Original_Onset!=.&New_Diagnosis!=.&Original_Onset<New_Diagnosis
replace New_Onset=Original_Onset if New_Onset==.&Original_Onset!=.&New_Diagnosis==.&Original_Diagnosis==.

** CORRECT DEATH DATES WHICH ARE OUT BY A YEAR OR A FEW DAYS **
* Move Death date forward by a year when it's a year behind Diagnosis date
replace New_Death=New_Death+365 if New_Death!=.&D7YY==year(New_Diagnosis)-1
* Replace Diagnosis date for individual with Death<Diagnosis that died during treatment
replace New_Diagnosis=New_DATE+D27DAY if New_Diagnosis!=.&New_Death<New_Diagnosis&D69KMC1==3
* Replace Death date with last date from PDTs/Diagnosis if Death<Diagnosis
replace New_Death=max(New_DATE,New_DATE2,New_DATE3,New_DATE4,New_Diagnosis) if New_Diagnosis!=.&New_Death<New_Diagnosis

** FILL IN DEATH DATES FROM TOOL A1 WHERE THEY ARE CONSISTENT **
replace New_Death=Original_Death if Original_Death!=.&New_Death==.&New_Diagnosis<=Original_Death&New_D6_Patient_aliveORdead==2

** MAKE NEW VARIABLES FOR MONTHS AND YEARS OF ONSET AND DIAGNOSIS DATES WITH MISSING DAY **
gen OnsetMonth=month(New_Onset)
gen OnsetYear=year(New_Onset)
gen DiagnosisMonth=month(New_Diagnosis)
gen DiagnosisYear=year(New_Diagnosis) 
gen DeathMonth=month(New_Death)
gen DeathYear=year(New_Death)

** FILL IN MONTH AND YEAR OF ONSET, DIAGNOSIS AND DEATH IF THEY ARE MISSING BUT PRESENT IN ORIGINAL SURVEY AND CONSISTENT **
* Use Tool A1 to fill in month and year for Onset and Diagnosis rather than Tool D1, as individuals with just month and year in Tool D1 are subset of those from Tool A1 
replace OnsetMonth=A15MM if (A15DD==.|A15DD==0)&A15MM!=.&A15YY!=.&New_Onset==.&New_Diagnosis!=.&ym(A15YY,A15MM)<=mofd(New_Diagnosis)
replace OnsetYear=A15YY if (A15DD==.|A15DD==0)&A15MM!=.&A15YY!=.&New_Onset==.&New_Diagnosis!=.&ym(A15YY,A15MM)<=mofd(New_Diagnosis)
replace OnsetMonth=A15MM if (A15DD==.|A15DD==0)&A15MM!=.&A15YY!=.&New_Onset==.&New_Diagnosis==.
replace OnsetYear=A15YY if (A15DD==.|A15DD==0)&A15MM!=.&A15YY!=.&New_Onset==.&New_Diagnosis==.

replace DiagnosisMonth=A19MM if (A19DD==.|A19DD==0)&A19MM!=.&A19YY!=.&New_Diagnosis==.&New_Onset==.
replace DiagnosisYear=A19YY if (A19DD==.|A19DD==0)&A19MM!=.&A19YY!=.&New_Diagnosis==.&New_Onset==.
replace DiagnosisMonth=A19MM if (A19DD==.|A19DD==0)&A19MM!=.&A19YY!=.&New_Diagnosis==.&New_Onset!=.&mofd(New_Onset)<=ym(A19YY,A19MM)
replace DiagnosisYear=A19YY if (A19DD==.|A19DD==0)&A19MM!=.&A19YY!=.&New_Diagnosis==.&New_Onset!=.&mofd(New_Onset)<=ym(A19YY,A19MM)

* Fill in onset year and diagnosis year for individual without onset or diagnosis month
replace OnsetYear=D18YYYY if D18MM==.&D31MM==.
replace DiagnosisYear=D31YYYY if D18MM==.&D31MM==.
* Fill in onset month and year from Tool D1 for individual without onset day
replace OnsetMonth=D18MM if OnsetYear==.&D18MM!=.&D18YYYY!=.
replace OnsetYear=D18YYYY if OnsetYear==.&D18MM!=.&D18YYYY!=.

replace DeathMonth=A12MM if (A12DD==.|A12DD==0)&A12MM!=.&A12YY!=.&New_Death==.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2
replace DeathYear=A12YY if (A12DD==.|A12DD==0)&A12MM!=.&A12YY!=.&New_Death==.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2
replace DeathMonth=D7MM if (D7DD==.|D7DD==0)&D7MM!=.&D7YY!=.&A12MM==.&New_Death==.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(D7YY,D7MM)&New_D6_Patient_aliveORdead==2
replace DeathYear=D7YY if (D7DD==.|D7DD==0)&D7MM!=.&D7YY!=.&A12MM==.&New_Death==.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(D7YY,D7MM)&New_D6_Patient_aliveORdead==2
* Fill in death month and year for individual with diagnosis and month and year but no diagnosis day or death day
replace DeathMonth=A12MM if (A12DD==.|A12DD==0)&A12MM!=.&A12YY!=.&New_Death==.&New_Diagnosis==.&DiagnosisMonth!=.&DiagnosisYear!=.&ym(DiagnosisYear,DiagnosisMonth)<=ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2
replace DeathYear=A12YY if (A12DD==.|A12DD==0)&A12MM!=.&A12YY!=.&New_Death==.&New_Diagnosis==.&DiagnosisMonth!=.&DiagnosisYear!=.&ym(DiagnosisYear,DiagnosisMonth)<=ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2
* Replace death month and year for individual with missing death day and original death month and year that are inconsistent with diagnosis month and year
replace DeathMonth=D7MM if (D7DD==.|D7DD==0)&D7MM!=.&D7YY!=.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(D7YY,D7MM)&mofd(New_Diagnosis)>ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2
replace DeathYear=D7YY if (D7DD==.|D7DD==0)&D7MM!=.&D7YY!=.&New_Diagnosis!=.&mofd(New_Diagnosis)<=ym(D7YY,D7MM)&mofd(New_Diagnosis)>ym(A12YY,A12MM)&New_D6_Patient_aliveORdead==2

**** EXAMINE CHANGES TO DATES ****
* Recalculate onset-diagnosis time and timeline variable
gen Lag2=New_Diagnosis-New_Onset

gen timeline2=1
replace timeline2=10 if (New_Onset==.|D42KMC1==.|New_Diagnosis==.)
replace timeline2=0 if Lag2<0&timeline2==1
replace timeline2=11 if New_Onset>New_DATE&timeline2==1&New_Onset!=.
replace timeline2=12 if New_Onset>New_DATE2&timeline2==1&New_Onset!=.
replace timeline2=13 if New_Onset>New_DATE3&timeline2==1&New_Onset!=.
replace timeline2=14 if New_Onset>New_DATE4&timeline2==1&New_Onset!=.
replace timeline2=-1 if New_Diagnosis<New_DATE&timeline2==1&New_DATE!=.
replace timeline2=-2 if New_Diagnosis<New_DATE2&timeline2==1&New_DATE2!=.
replace timeline2=-3 if New_Diagnosis<New_DATE3&timeline2==1&New_DATE3!=.
replace timeline2=-4 if New_Diagnosis<New_DATE4&timeline2==1&New_DATE4!=.

tab timeline timeline2

* Make variables to show where individuals' dates have changed and where they are now in the right order
gen Changed=0
replace Changed=1 if (timeline2!=timeline|Lag2!=Lag|New_Onset!=Onset|New_DATE!=D25DATE|New_DATE2!=D25DATE2|New_DATE3!=D25DATE3|New_DATE4!=D25DATE4|New_Diagnosis!=Diagnosis|New_Death!=Death)
gen Fixed=.
replace Fixed=1 if Changed==1&(timeline2==1|(timeline==10&timeline2==10))
replace Fixed=0 if Changed==1&timeline2!=1&!(timeline==10&timeline2==10)
* Count how many individuals have had their dates changed and how many have been "fixed"
count if Changed==1
count if Fixed==1

order A1_ID New_District New_Block D24 New_D6_Patient_aliveORdead A2 Age Onset D25DATE D25DATE2 D25DATE3 D25DATE4 Diagnosis Death D25C1MCDAY D25C2MCDAY D25C3MCDAY D25C4MCDAY Lag D42KMC1 D42KMC2 D73 D25G1MC D25H1MC D25G2MC D25H2MC D25G3MC D25H3MC D25G4MC D25H4MC D26_New timeline error Original_Onset Original_DATE Original_DATE2 Original_DATE3 Original_DATE4 Original_Diagnosis Original_Death New_Onset New_DATE New_DATE2 New_DATE3 New_DATE4 New_Diagnosis New_Death Lag2 timeline2 Changed Fixed

**** SAVE CLEANED DATES AND MERGE WITH HAND CORRECTIONS ****
* Sort individuals by ID and save as .dta file
sort A1_ID
save DataWithCodeCorrectedDates3, replace

* Save to "VL_data_LC_cleaned.csv"
export delimited VL_data_LC_cleaned3, replace

* Import dates corrected by hand
import delimited CorrectedDatesWithHandCorrections4.csv, clear case(preserve)
* Correct wrong A1_ID
replace A1_ID="10_02_0015_008" if A1_ID=="10_02_0020_008"&New_Onset_HC!=.
* Correct A1_ID with typo
replace A1_ID="10_12_0007_053" if A1_ID=="10_12_007_053"
* Convert Excel dates to Stata dates
replace New_Onset_HC=New_Onset_HC-21916
replace New_DATE_HC=New_DATE_HC-21916
replace New_DATE2_HC=New_DATE2_HC-21916
replace New_DATE3_HC=New_DATE3_HC-21916
replace New_DATE4_HC=New_DATE4_HC-21916
replace New_Diagnosis_HC=New_Diagnosis_HC-21916
* Change date display format
format New_Onset_HC New_DATE* New_Diagnosis_HC %tdDD/NN/YY

* Sort individuals by ID and save as .dta file
sort A1_ID
save DatesWithHandCorrections3, replace

* Merge data with code corrected dates with dates corrected by hand
merge A1_ID using DataWithCodeCorrectedDates3 DatesWithHandCorrections3

* Replace dates with hand corrected dates
replace New_Onset=New_Onset_HC if Hand_corrected==1&New_Onset_HC!=.
replace New_DATE=New_DATE_HC if Hand_corrected==1&New_DATE_HC!=.
replace New_DATE2=New_DATE2_HC if Hand_corrected==1&New_DATE2_HC!=.
replace New_DATE3=New_DATE3_HC if Hand_corrected==1&New_DATE3_HC!=.
replace New_DATE4=New_DATE4_HC if Hand_corrected==1&New_DATE4_HC!=.
replace New_Diagnosis=New_Diagnosis_HC if Hand_corrected==1&New_Diagnosis_HC!=.

* Update Months and Years for hand corrected Onset and Diagnosis dates
replace OnsetMonth=month(New_Onset_HC) if Hand_corrected==1&New_Onset_HC!=.
replace OnsetYear=year(New_Onset_HC) if Hand_corrected==1&New_Onset_HC!=.
replace DiagnosisMonth=month(New_Diagnosis_HC) if Hand_corrected==1&New_Diagnosis_HC!=.
replace DiagnosisYear=year(New_Diagnosis_HC) if Hand_corrected==1&New_Diagnosis_HC!=.

* Make variables to show if diagnosis district and block match residence district and block
gen SameDiagnosisResidenceDistricts=0 if D33DISTRICT!=" "
replace SameDiagnosisResidenceDistricts=1 if D33DISTRICT==A3
gen SameDiagnosisResidenceBlocks=0 if D33BLOCK!=" "
replace SameDiagnosisResidenceBlocks=1 if D33BLOCK==A4_New_Block&D33DISTRICT==A3

* Rename variables with simpler/better names
rename A1_ID PatientID
rename New_District District
rename New_District_Name DistrictName
rename New_Block Block
rename New_Block_Name BlockName
rename A2 Sex
rename D24 VLvsPKDL
rename New_D6_Patient_aliveORdead AliveOrDead
drop Onset
rename New_Onset Onset
drop Diagnosis
rename New_Diagnosis Diagnosis
drop Death
rename New_Death Death
rename D42KMC1 OnsetToTreatment1
rename D53KMC1 TreatmentDuration1Capsule
rename D61KMC1 TreatmentDuration1Injection
rename D42KMC2 OnsetToTreatment2
rename D53KMC2 TreatmentDuration2Capsule
rename D61KMC2 TreatmentDuration2Injection
rename D73 IllnessDuration

* Save merged dataset
save DataWithMergedCorrections4, replace
export excel DataWithMergedCorrections4.xlsx, replace firstrow(variables)
export delimited DataWithMergedCorrections4, replace

* Calculate summary statistics - number, mean, SD, percentiles, etc.
gen OD=Diagnosis-Onset
rename OnsetToTreatment1 OT

sort District
by District:sum Age,detail
by District:sum OD if VLvsPKDL!=1,detail
by District:sum OD if VLvsPKDL!=1&OD>=0,detail
by District:sum OT if VLvsPKDL!=1,detail

* Plot histograms of age distribution, OD time with and without negatives, OT time
hist Age if VLvsPKDL!=1,freq width(5) by(District)
gr export age_distn.png, replace

hist Age if VLvsPKDL!=1,freq width(5) by(Sex)
gr export age_distn_male_vs_female.png, replace
hist Age if VLvsPKDL!=1&Sex==1,freq width(5) by(District)
gr export male_age_distns_by_district.png, replace
hist Age if VLvsPKDL!=1&Sex==2,freq width(5) by(District)
gr export female_age_distns_by_district.png, replace

hist OD if VLvsPKDL!=1&OD<999&OD>0&District<5,freq width(10) by(District)
gr export onset_diagnosis_time_by_district1to4.png, replace
hist OD if VLvsPKDL!=1&OD<999&OD>0&District>=5,freq width(10) by(District)
gr export onset_diagnosis_time_by_district5to8.png, replace

hist OD if VLvsPKDL!=1&OD<999&OD>=0,freq width(10) by(District)
gr export onset_diagnosis_time_by_district.png, replace

hist OT if VLvsPKDL!=1&OT<400&District<5,freq width(10) by(District)
gr export onset_treatment_time_by_district1to4.png, replace
hist OT if VLvsPKDL!=1&OT<400&District>=5,freq width(10) by(District) 
gr export onset_treatment_time_by_district5to8.png, replace

* Plot box-and-whisker plots of same residence and diagnosis district and block status and OD and OT
bysort SameDiagnosisResidenceDistricts: sum OD if VLvsPKDL!=1&OD>=0,detail
bysort SameDiagnosisResidenceBlocks: sum OD if VLvsPKDL!=1&OD>=0,detail

graph box OD if VLvsPKDL!=1&OD>=0&OD<200, over(SameDiagnosisResidenceDistricts)
gr export onset_diagnosis_time_by_residence_district_diagnosis_district_match.png, replace
graph box OD if VLvsPKDL!=1&OD>=0&OD<200, over(SameDiagnosisResidenceBlocks)
gr export onset_diagnosis_time_by_residence_block_diagnosis_block_match.png, replace
