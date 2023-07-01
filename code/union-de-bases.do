
** UNIÓN RELACION DE PLAZAS + CENSO + PADRON DE IE
cls
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
$data
use "relacion_plazas_limpia",clear
merge 1:1 COD_MOD CODLOCAL using "censo_edu", keep(3) nogen  // + censo 
merge m:1 CODLOCAL using "padron_local.dta", keep(3) nogen // + padron
merge m:1 CODLOCAL using "padron_ruralidad.dta" // + padron ruralidad
drop if _m==2
drop _m

rename DIS_VRAEM vraem
label def vraem 1 "directa" 2 "influencia"
label val vraem vraem

gen vac_prop = (plazas_vacantes / plazas_total) *100 // proporcion de plazas vacantes por codigo modular

gen dpto = substr(CODGEO,1,2)
	destring dpto, replace	
	label define dpto 1 "Amazonas" 	2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco"	9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
	label values dpto dpto 

gen macroregion = 1 if inlist(dpto,2,6,13,14,20,24)
	replace macroregion = 2 if inlist(dpto,4,8,17,18,21,23)
	replace macroregion = 3 if inlist(dpto, 7,15)
	replace macroregion = 4 if inlist(dpto, 1,16,22,25) 
	replace macroregion = 5 if inlist(dpto,3, 5,9,10,12,19,11)
	label define macroreg 1 "NORTE" 2 "CENTRO" 3 "LIMA" 4 "ORIENTE" 5 "SUR"
	label val macroregion macroreg

codebook GESTION
drop GESTION CODGEO CODOOII

gen vac_d=1 if vac_prop != 0 // dummy =1 si presenta plazas vacantes
replace vac_d=0 if vac_prop==0

gen bono_bilingue=100 if eib ==1
gen bono_tipoie= 200 if tipoie == 3
replace bono_tip=140 if tipoie== 2
gen bono_frontera= 100 if DIS_FRONT ==1
gen bono_rural=500 if ruralidad==1
replace bono_rural=100 if ruralidad==2
replace bono_rural = 70 if ruralidad== 3
gen bono_vraem =300 if vraem ==1 | vraem==2
replace bono_vraem=0 if vraem==0
replace bono_biling=0 if eib==0
replace bono_biling=0 if bono_biling==.
replace bono_front=0 if DIS_FRONT==0
replace bono_tip=0 if tipoie==0 | tipoie==1
replace bono_rural = 0 if ruralidad ==0
replace bono_rural = 0 if ruralidad ==.

gen bono_total=bono_bilingue +bono_front+bono_rural+bono_tipoie+bono_vraem
drop bono_bilingue bono_front bono_tipoie bono_vraem bono_rural

*drop total_equipo topografia capital_ugel clima
*drop  infe_std distancia_min vraem DIS_FRONT

replace ruralidad=0 if AREA_CENSO==1 & ruralidad==.
rename (ALTITUD NLAT NLONG AREA_CENSO DIS_FRONT) (altitud latitud longitud area frontera) 

$data
save "data_final", replace