
*ssc install geodist

** UNIÓN RELACION DE PLAZAS + CENSO + PADRON DE IE
cls
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
$data
use "relacion_plazas_limpia2",clear
merge 1:1 COD_MOD CODLOCAL using "censo_edu", keep(3) nogen  // + censo 
merge m:1 CODLOCAL COD_MOD using "padron.dta", keep(3) nogen // + padron
merge m:1 CODLOCAL using "padron_ruralidad.dta" // + padron ruralidad
drop if _m==2
drop _m

recode vraem (1 = 2) (2 = 1)
label def vraem 2 "directa" 1 "influencia"
label val vraem vraem

replace dpto = substr(CODGEO,1,2)
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

drop ruralidad
codebook GESTION
gen convenio_priv = GESTION==2
drop GESTION CODGEO CODOOII 
rename Ruralidad ruralidad 
 replace bilingue=1 if eib==1 & bilingue==0
 tab eib bilingue
 replace frontera=1 if DIS_FRONT==1 

gen bono_bilingue=100 if eib ==1
replace bono_biling=0 if eib==0
replace bono_biling=0 if bono_biling==.

gen bono_tipoie= 200 if tipoie == 3 
replace bono_tip=140 if tipoie== 2
replace bono_tip=140 if tipoie==3
replace bono_tip=0 if tipoie==0 | tipoie==1
gen bono_frontera= 100 if frontera ==1
gen bono_rural=500 if ruralidad==1
replace bono_rural=100 if ruralidad==2
replace bono_rural = 70 if ruralidad== 3
gen bono_vraem =300 if vraem ==1 | vraem==2
replace bono_vraem=0 if vraem==0

replace bono_front=0 if frontera==0

replace bono_rural = 0 if ruralidad ==0
replace bono_rural = 0 if ruralidad ==.

gen bono_total=bono_bilingue +bono_front+bono_rural+bono_tipoie+bono_vraem
drop bono_bilingue bono_front bono_tipoie bono_vraem bono_rural NROCED D_DPTO total_docentes 
rename (DESCN ALTITUD NLAT NLONG TALUM_HOM TALUM_MUJ TALUMNO TDOCENTE TSECCION) (nivel altitud latitud longitud talum_hom talum_muj talumno tdocente tseccion) 

gen rural = area ==2

** indice de rotacion parcial (asumiendo nuevas contratciones = 0 por limitacion de la data)
gen irp = (plazas_vacantes*100)/(plazas_total)
replace irp=0 if irp==. //escuelas sin plazas vacantes -> irp=0
summ irp // indice de rotción promedio = 24%

merge m:m cod_prov using "coord-cap-prov-limpia", nogen
replace dpto = 15 if dpto ==7 //incluir Callao en lima
merge m:m dpto using "pob-socioecon-limpia" , nogen
drop distancia  // variable del censo contiene missing y errores

* calcular distancia IE - Capital provincial con coordenadas manualmente
geodist latitud longitud Y X, gen(distancia) // en km
summ dist

label def frontera 1 "IE de Frontera" 0 "No Frontera" 
label val frontera frontera
label var irp "Indice de rotación parcial"
label var area "Área geográfica"
label var region_nat "Región Natural"
label var ruralidad "Ruralidad" 
label def eib 1 "EIB" 0 "NO EIB"
label val eib eib
label var comunidad_leng "Mayoría de la comunidad habla lengua nativa"
 
replace material="1" if material=="SI" //recibio material eductivo
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

foreach x in jorn_40 jorn_25 jorn_30 edad30 edad31_60 edad60 experiencia16_25 experiencia26_40 experiencia41 contratados_n nombrados_n{
replace `x'=0 if `x'==.
}

gen d_est_l_orig = inlist(est_lengua_orig, 1,2,3)
label var d_est_l_orig "Estudiantes hablan lengua originaria"
label def dlengest 1 "Sí" 0 "No"
label val d_est_l_orig dlengest

drop X Y CODLOCAL longitud latitud cod_prov Rasgo jornada* edad_* experiencia_* TIPODEIE

recode nuevos_doc (.=0)
replace apoyo_docente = acompañamiento + apoyo // docente recibe apoyo y/o acompañamiento
drop acompañamiento

** Ratio alumnos por seccion (aproximado tamño de clase)
gen tamclase=talumno/tseccion
replace tamclase=0 if tamclase==.
drop if tdocente==.
duplicates drop
recode material (.=0)
*drop salud

gen servicios_ie=agua_ie+desague_ie+electricidad_ie+internet
*drop agua_ie desague_ie electricidad_ie internet
egen aream2_z = std(area_m2)
replace hrs=5 if hrs==. // asignar horas promedio a missing

local varlist "eib est_ge_originario fortalecimiento_gestion total_equipo clima topografia capital_ugel trayectos_cap peligro_nat peligro_antropicos area_m2 servicios_ie experiencia15"
foreach var of local varlist {
  drop if missing(`var')
}

*dummys
gen inicial=nivel==1
gen primaria=nivel==2
gen secundaria=nivel==3

gen unidocente=tipoie==3
gen multigrado=inlist(tipoie, 2, 3)
gen completo=tipoie==1

gen macroreg_norte=macroregion==1
gen macroreg_centro=macroregion==2
gen macroreg_lima=macroregion==3
gen macroreg_oriente=macroregion==4
gen macroreg_sur=macroregion==5

gen urbana=rural==0

gen rural1=ruralidad==1
gen rural2=ruralidad==2
gen rural3=ruralidad==3

gen costa=region_nat==1
gen selva=region_nat==3
gen sierra=region_nat==2

gen d_est_ge=est_ge_originario==1
$data
save "data_final", replace