
*ssc install geodist

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
recode vraem (1 = 2) (2 = 1)
label def vraem 2 "directa" 1 "influencia"
label val vraem vraem

gen dpto = substr(CODGEO,1,2)
	destring dpto, replace	
	label define dpto 1 "Amazonas" 	2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
	label values dpto dpto 

gen cod_prov = substr(CODGEO, 1,4)
	
gen macroregion = 1 if inlist(dpto,2,6,13,14,20,24)
	replace macroregion = 2 if inlist(dpto,4,8,17,18,21,23)
	replace macroregion = 3 if inlist(dpto, 7,15)
	replace macroregion = 4 if inlist(dpto, 1,16,22,25) 
	replace macroregion = 5 if inlist(dpto,3, 5,9,10,12,19,11)
	label define macroreg 1 "NORTE" 2 "CENTRO" 3 "LIMA" 4 "ORIENTE" 5 "SUR"
	label val macroregion macroreg

codebook GESTION
gen convenio_priv = GESTION==2
drop GESTION CODGEO CODOOII

** indice de rotacion parcial (asumiendo nuevas contratciones = 0 por limitacion de la data)
gen irp = (plazas_vacantes*100)/(plazas_total)
replace irp=0 if irp==. //escuelas sin salidas de docentes -> irp=0
summ irp  // indice de rotción promedio = 25.7%

gen vac_d=plazas_vacantes != 0 // dummy =1 si presenta almenos 1 plaza vacantes
gen irp10=irp >=10 // =1 si presenta de 10%  más de irp
gen irp25=irp>=25 //=1 si presenta de 25% a más de irp

summ irp irp10 irp25

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
drop bono_bilingue bono_front bono_tipoie bono_vraem bono_rural NROCED

replace ruralidad=0 if AREA_CENSO==1 & ruralidad==.
rename (DESCN ALTITUD NLAT NLONG AREA_CENSO DIS_FRONT) (nivel altitud latitud longitud area_g frontera) 

gen rural = area_g ==2

merge m:m cod_prov using "coord-cap-prov-limpia", nogen
replace dpto = 15 if dpto ==7 //incluir Callao en lima
merge m:m dpto using "pob-socioecon-limpia" , nogen
drop distancia  // variable del censo contiene missing y errores

* calcular distancia IE - Capital provincial con coordenadas manualmente
geodist latitud longitud Y X, gen(distancia) // en km
summ dist

label def frontera 1 "IE de Frontera" 0 "No Frontera" 
label val frontera frontera
label def ruralidad 1 "Rural 1" 2 "Rural 2" 3 "Rural 3"
label val ruralidad ruralidad
label var irp "Indice de rotación parcial"
label var area_g "Área geográfica"
label var region_nat "Región Natural"
label var ruralidad "Ruralidad" 
label def eib 1 "EIB" 0 "NO EIB"
label val eib eib
label var comunidad_leng "Mayoría de la comunidad habla lengua nativa"
 
replace material="1" if material=="SI"
replace material="0" if material=="NO"
destring material, replace 
 
replace mujer_n = (mujer_n/(mujer_n+hombre_n))*100 //proporcion de docentes mujeres
 replace hombre_n =100-mujer_n
 
replace contratados = (contratados_n/(contratados_n+nombrados_n))*100 //proporcion de docentes mujeres
 replace nombrado=100-contratado

gen jorn_40= (jornada_40/(jornada_40+jornada_30+jornada_25))*100
gen jorn_30= (jornada_30/(jornada_40+jornada_30+jornada_25))*100 
gen jorn_25= (jornada_25/(jornada_40+jornada_30+jornada_25))*100

gen edad30=(edad_30/edad_30_n+edad_31_60_n+edad_60_n)*100
gen edad31_60=(edad_31/edad_30_n+edad_31_60_n+edad_60_n)*100
gen edad60=(edad_60/edad_30_n+edad_31_60_n+edad_60_n)*100

gen experiencia15=(experiencia_15/(experiencia_15_n+experiencia_16_25+experiencia_26_40+experiencia_41_n))*100
gen experiencia16_25=(experiencia_16/(experiencia_15_n+experiencia_16_25+experiencia_26_40+experiencia_41_n))*100
gen experiencia26_40=(experiencia_26/(experiencia_15_n+experiencia_16_25+experiencia_26_40+experiencia_41_n))*100
gen experiencia41=(experiencia_41/(experiencia_15_n+experiencia_16_25+experiencia_26_40+experiencia_41_n))*100

foreach x in jorn_40 jorn_25 jorn_30 edad30 edad31_60 edad60 experiencia15 experiencia16_25 experiencia26_40 experiencia41 mujer_n hombre_n{
replace `x'=0 if `x'==.
}

gen d_est_l_orig = inlist(est_lengua_orig, 1,2,3)
label var d_est_l_orig "Estudiantes hablan lengua originaria"
label def dlengest 1 "Sí" 0 "No"
label val d_est_l_orig dlengest

drop X Y REGION CODLOCAL longitud latitud cod_prov Rasgo jornada* edad_* experiencia_*

recode nuevos_doc (.=0)
replace apoyo_docente = acompañamiento + apoyo // docente recibe apoyo y/o acompañamiento
$data
save "data_final", replace