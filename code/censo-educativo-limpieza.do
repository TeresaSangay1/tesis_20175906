** LIMPIEZA DE DATA CENSO EDUCATIVO 2022 **
*******************************************

* ---------------------------- DATA "LINEAL" ------------------------------
* --------------------------------------------------------------------------
cls
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global censo cd "C:\Users\teresa\Documents\GIT\TESIS\data\CENSO EDUCATIVO 2022"
$data

* DATA DE NIVEL INICIAL ESCOLARIZADA
* ----------------------------------
$censo
use "Lineal_1A_01", clear
merge 1:1 COD_MOD using "Lineal_1A_02", nogen
merge 1:1 COD_MOD using "Lineal_1A_03", nogen
* programas P112_1 P112_3 P112_4 P112_5 P112_6 P112_7 P112_8(ninguno) 
* P119_SI_2 P119_SI_3  salud docente
* p163 director dio soporte y apoyo a docentes
* hay alumnos de ge P175_1 P175_2 P175_3 P175_4 P175_5 P175_6 P175_7 P175_8 P175_9 (otro)
* P176 y P176_SI hay mayor ge, cual
* P177 EIB
* P180 conoce comunidad habla lengua originaria, (P180_si que lengua -> no se usa), 
* estudiantes hablan lengua originaria P181_SI_1 proporcion (P181_SI_LO cual, no se usa)
* p300_doc total docentes
* p401 materiales
* p721 experiencia como director
* P721_Q años

*codebook ANEXO 
drop if ANEXO!="0" 

gen est_ge_originario=0 if P175_1=="NO" & P175_2=="NO" & P175_3=="NO" & P175_4=="NO"
replace est_ge_originario=1 if est_ge_originario==. & P175_1=="SI" | P175_2=="SI" | P175_3=="SI" & P175_4=="SI"
replace est_ge_originario=2 if inlist(P176_SI,"1","2","3","4")

gen salud_docente = P119_SI_2=="X"
replace salud = salud + 1 if P119_SI_3 =="X"
gen apoyo_docente = P163 == "SI"

gen nuevos_docentes=P170_3_Q
gen acompañamiento = P171 =="SI" 

gen castellano_segunda_lengua = P178=="SI"
gen enseñanza_bilingue =P179== "SI"
gen fortalecimiento_gestion =P701=="SI" 

rename (P177 P181 P181_SI_Q P180) (eib estlo est_lengua_orig comunidad_leng_orig)
rename (P300_DOC P401 P721 P721_Q) (total_docentes material_edu experiencia_dir experiencia_dir_años)

 keep COD_MOD CODLOCAL NROCED est_ge_originario eib comunidad_leng_orig est_lengua_orig total_docentes experiencia_dir experiencia_dir_años estlo material_edu salud apoyo nuevos_docentes acompañamiento castellano_segunda_lengua enseñanza_bilingue fortalecimiento_gestion

save "Lineal_1A", replace 

* PRIMARIA
*-----------

use "Lineal_3AP_01", clear
merge 1:1 COD_MOD using "Lineal_3AP_02", nogen
merge 1:1 COD_MOD using "Lineal_3AP_03", nogen

codebook ANEXO 
drop if ANEXO!="0"

gen est_ge_originario = 0 if P178_1=="NO" & P178_2=="NO" & P178_3=="NO" & P178_4=="NO"
replace est_ge_originario=1 if est_ge_originario==. & P178_1=="SI" | P178_2=="SI" | P178_3=="SI" & P178_4=="SI"
replace est_ge_originario=2 if inlist(P179_SI,"1","2","3","4")

gen salud_docente = P118_2=="X" // coordinaciones con el centro de salud para brindar salud fisica a los docentes
replace salud = salud + 1 if P118_4 =="X" //salud mental
gen apoyo_docente = P161 == "SI" // soporte y apoyo en torno a desempeño en el marco de acompñamiento pedagogico
gen nuevos_docentes=P173_3_Q
gen acompañamiento = P174 =="SI" // El personal de este servicio/nivel educativo, ha recibido algún tipo de soporte o acompañamiento socioemocional de parte de equipos de UGEL o DRE

gen castellano_segunda_lengua = P181=="SI"
gen enseñanza_bilingue =P182== "SI"
gen fortalecimiento_gestion =P701=="SI" //. Este servicio/nivel educativo ¿coordina alguna acción con el gobierno local (distrital o provincial) para mejorar la prestación del servicio educativo?

rename (P180 P183 P184 P184_SI) (eib comunidad_leng_orig estlo est_lengua_orig)
rename (P300_DOC P401 P721 P721_Q) (total_docentes material_edu experiencia_dir experiencia_dir_años)

keep COD_MOD CODLOCAL NROCED est_ge_originario eib comunidad_leng_orig est_lengua_orig total_docentes experiencia_dir experiencia_dir_años estlo material_edu salud apoyo nuevos_docentes acompañamiento castellano_segunda_lengua enseñanza_bilingue fortalecimiento_gestion


save "Lineal_3AP", replace 

* SECUNDARIA
* ----------
use "Lineal_3AS_01", clear
merge 1:1 COD_MOD using "Lineal_3AS_02", nogen
merge 1:1 COD_MOD using "Lineal_3AS_03", nogen

codebook ANEXO 
drop if ANEXO!="0"

gen est_ge_originario = 0 if P191_1=="NO" & P191_2=="NO" & P191_3=="NO" & P191_4=="NO"
replace est_ge_originario=1 if est_ge_originario==. & P191_1=="SI" | P191_2=="SI" | P191_3=="SI" & P191_4=="SI"
replace est_ge_originario=2 if inlist(P192_SI,"1","2","3","4")

gen nuevos_docentes=P174_3_Q
gen acompañamiento = P175 =="SI" 

gen castellano_segunda_lengua = P193B=="SI"
gen enseñanza_bilingue =P193D== "SI"
gen fortalecimiento_gestion =P701=="SI" 

rename (P193A P193D P193E P193E_SI) (eib comunidad_leng_orig estlo est_lengua_orig)
rename (P300_TDOC P401 P721 P721_Q) (total_docentes material_edu experiencia_dir experiencia_dir_años)

keep COD_MOD CODLOCAL NROCED est_ge_originario eib comunidad_leng_orig est_lengua_orig total_docentes experiencia_dir experiencia_dir_años estlo castellano_segunda_lengua enseñanza_bilingue fortalecimiento_gestion nuevos_docentes acompañamiento

save "Lineal_3AS", replace 

** UNIÓN DE LOS TRES NIVELES
* ---------------------------
clear all
$censo

use "Lineal_1A", clear
append using "Lineal_3AP"
append using "Lineal_3AS"

local varlist5 "eib comunidad estlo" 
foreach var of local varlist5 {
	replace `var' = "1" if `var'=="SI"
	replace `var' = "0" if `var'=="NO"
	destring `var', replace
	}

label var est_ge_originario "alumnos pertenecientes a un grupo étnico originario"
label def est_ge_originario 0 "Ninguno" 1 "Algunos o pocos" 2 "Mayoría", modify
label val est_ge_originario est_ge_originario
tab est_ge_originario
label var comunidad "Comunidad habla lengua originaria"

destring experiencia_dir est_lengua, replace
label var est_lengua "Lengua originaria de los estudiantes"
replace est_lengua = 0 if estlo == 0 & est_lengua==.
label def est_lengua 0 "ninguno" 1 "Pocos" 2 "La mayoria" 3 "Todos"
label val est_lengua est_lengua

replace experiencia_dir_años = 12 if experiencia_dir_años==1212 //corrigir registros
*drop if experiencia_dir_años > 90 // eliminar errores
replace experiencia_dir_años =. if experiencia_dir_años > 90
drop if CODLOCAL==""

duplicates drop
isid COD_MOD

drop estlo

save "Lineal_total", replace  // Base linea para inicial (escolarizada), primaria y secundaria EBR

*************************************************************************

* Limpieza data equipamiento
----------------------------
$censo
use "Equipamiento", clear
keep if NROCED == "1A" | NROCED == "3AP" | NROCED == "3AS"
drop if ANEXO =="1"
destring(TIPDATO),replace
rename TIPDATO EQUIPO
drop if inlist(EQUIPO,5,12) // servidores (exclusivos del nivel) y modem
label define eequipo 1 "TELEVISOR(ES)" 2 "COMPUTADORAS (PC DE ESCRITORIO)" 3 "LAPTOP CONVENCIONALES" 4 "LAPTOP XO" 6 "TABLETS" 7 "PROYECTOR" 8 "RADIOGRABADORA" 9 "REPRODUCTOR DE DVD O BLUE RAY" 10 "IMPRESORAS" 11 "PIZARRAS DIGITALES" 13 "SERVICIO DE INTERNET" 
label values EQUIPO eequipo 
 replace D02 = 1 if EQUIPO ==13 & CHK1=="SI" // sevicio de internet operativo
drop CHK1 CHK2 DESCRIP ANEXO CUADRO D01 NIV_MOD GES_DEP NROCED CODGEO CODOOII AREA_CENSO
duplicates report
duplicates drop
reshape wide D02, i(CODLOCAL COD_MOD) j(EQUIPO)
rename (D021 D022 D023 D024 D026 D027 D028 D029 D0210 D0211 D0213) (tv pc laptop_conv laptop_xo tablets proyector radiograbadora dvd impresora pizarra_dig internet)
gen total_equipo = laptop_xo+impresora + pizarra_dig + proyector + radiograbadora + dvd + tv + pc+laptop_conv+tablets
drop impresora pizarra_dig proyector radiograbadora dvd tv laptop_xo pc laptop_conv tablets
isid CODLOCAL COD_MOD
save "Equipamiento_limpia", replace

***************************************************************************************
* Limpieza data trayectos

$censo
use "Local_Trayectos.dta", clear // trayecto Local- Capital distrital (plaza de armas)
*br if CUADRO =="C1172" 
drop if CUADRO =="C1171" // quitar trayecto UGEL-Local Educativo
drop CUADRO NROCED CODUGEL // NUMERO
sort CODLOCAL NUMERO
rename MEDIO medio
destring medio, replace
* 1 "vehicular por vía asfaltada" 2 "vehicular por vía afirmada" 3 "vehicular por trocha carrozable" 4 "peatonal" 5 "fluvial" 6 "otro"
recode medio (1 2 3 = 1) (4 = 2) (5 6=3) (6=4)
label def medio 1 "vehicular" 2 "peatonal" 3 "otro"
label val medio medio
keep if NUMERO < "06" // por mientras, constatar con data 2021
bysort CODLOCAL: gen id=_n
bysort CODLOCAL: gen re=_N
tab re
br if re >=3
bysort CODLOCAL medio: egen horas=mean(HORAS) if re>2
replace horas =round(horas)
replace horas = HORAS if horas==.  
drop HORAS 
gen minutos = horas*60 + MINUTOS
drop horas MINUTOS id re
bysort CODLOCAL: egen distancia_min = total(minutos)
drop NUMERO medio minutos 
duplicates drop
summ distancia_min
save "local_trayectos_limpia", replace

*****************************************************************

* limpieza data Servicio Básicos
* -------------------------------
$censo
use "Local_Servicios_Basicos.dta", clear
keep if CUADRO == "C206" //desague_ie
keep CODLOCAL NUMERO
rename NUMERO desague_ie
replace desague_ie=0 if inlist(desague_ie,2,3,4,5,6,7,8,9) 
label var desague_ie "desague conectado a red pública"
isid CODLOCAL
save "Local_Servicios_Basicos_limpia",replace


$censo
use "Local_Servicios_Basicos.dta", clear
keep if CUADRO == "C207" // energia electrica
keep CODLOCAL NUMERO
rename NUMERO electricidad_ie
tab electricidad_ie
replace electricidad_ie=0 if inlist(electricidad_ie,2,3,4,5,6,7,8,9) 
label var electricidad_ie "energia electrica conectado a red pública"
isid CODLOCAL
save "Local_Servicios_Basicos_limpia2",replace


$censo
use "Local_Servicios_Basicos.dta", clear
keep if CUADRO == "C202" // agua potable
keep CODLOCAL NUMERO
rename NUMERO agua_ie
tab agua_ie
recode agua_ie (1=1) (2 3 4 5 6 7=0)
label var agua_ie "agua potable (red pública) en el local"
isid CODLOCAL
save "Local_Servicios_Basicos_limpia3",replace

***************************************************************

* limpieza data caracteristicas local

$censo
use "Local_lineal", clear

foreach x in P120_1 P120_2 P120_3 P120_4 P120_5 P120_6 P120_7 P120_8 P120_9 P120_10 P120_11 P120_12 P120_13 P120_14 P120_15 {
replace `x'=0 if `x'==. 
}
gen peligro_nat=P120_1+P120_2+P120_3+P120_4+P120_5+P120_6+P120_7+P120_8+P120_9+P120_10+P120_11+P120_12+P120_13+P120_14+P120_15 // 15 peligros

tab P121_3
tab P121_4
tab P121_5
tab P121_7
rename (CLIMA P105_EN P105_DE P108 P109 P117_2 P117_3 P121_1 P121_2 P121_6 P201_1 P201_2 P201_3 P201_4 P201_5 P203 P210 P222 P118_1 P118_2 P118_3 P118_4 P118_5 P118_6 P118_7) (clima area_en area_de topografia suelo capital_ugel trayectos_cap zona_industrial zona_minera zona_agro electricidad_cp agua_cp desague_cp internet_cp salud_cp agua_local electricidad_local internet_local mar rio volcan huayco acequia erosion_suelo deslizamiento)

*zona_industrial -> Zona industrial emanación de gases y desperdicios tóxicos 
*codebook zona_industrial zona_minera zona_agro
gen peligro_antropicos=zona_industrial+zona_minera+P121_3+P121_4+P121_5+ zona_agro+P121_7 //7 peligros: comercio ambulatorio intenso microcomercializacion de droga, inseguridad ciudadadana y/o subversion, 

egen area_m2= concat(area_en area_de) if area_de!=0 & area_de!=., punct(.)
destring area_m2, replace
replace area_m2=area_en if area_m2==. 

// vulnerabilidad

gen vulnerabilidad = mar +rio + volcan + huayco + acequia + erosion_suelo + deslizamiento+P118_8 // indicadores de vulnerabilidad -> cercano a 
	/*P118_1 -> Cercano al mar
	  P118_2 -> Cercano a un rio
	  P118_3 -> Cercano a un volcan
	  P118_4 -> Cruce de huayco u quebrada
	  P118_5 -> Acequias o canales de regadio
	  P118_6 -> Erosion de suelos
	  P118_7 -> Deslizamiento de rocas
	  P118_8 -> Otro 	*/

drop if GESTION ==. // escuelas privadas

replace clima=2 if clima ==1 // desértico y desertico costero
codebook clima
recode clima (2=1) (3 4 5 6= 3) (7 8 9 = 2)
label def tipoclima 1 desertico 3 frío 2 tropical, modify
label val clima tipoclima

	codebook agua_cp electricidad_cp desague_cp
	gen servicios_basicos_cp= agua_cp+electricidad_cp+desague_cp+internet_cp
	replace servicios_basicos_cp=0 if servicios_basicos_cp==.
	gen servicios_cp=salud_cp+P201_7+P201_8+P201_9+P201_10+P201_11+P201_12

isid CODLOCAL
keep CODLOCAL clima topografia capital_ugel trayectos_cap servicios_basicos_cp servicios_cp peligro_nat peligro_antropicos vulnerabilidad area_m2 

save "Local_lineal_limpia", replace

*******************************************************************

* Limpieza data infraestructura
* -----------------------------
$censo
use "Local_Sec500.dta", clear

keep if inlist(P501_3_1, "A1", "A2", "A3", "B0", "F0") 
keep CODLOCAL NUMERO P501_8_2 P501_8_3 P501_11_1 P501_11_2 P501_12_1 P501_12_2 P501_13_1 P501_13_2 
rename (P501_8_2 P501_8_3 P501_11_1 P501_11_2 P501_12_1 P501_12_2 P501_13_1 P501_13_2) (puertas_estado puertas pared pared_estado techo techo_estado piso piso_estado)
duplicates drop

tab pared
gen pared_mat = 3 if inlist(pared,1,4)
replace pared_mat = 2 if inlist(pared, 2,3,5,6,7,8,9)
replace pared_mat = 1 if inlist(pared, 2,3,5,6,7,8,9)
label var pared_mat "Pared - material predominante"
label def material 3 "material noble" 2 "material rústico" 1 "material precario"
/* noble : ladrillo o concreto 
rústico: quincha, adobe o tapial, o piedra con barro, cal y/o cemento, madera
precario: eternit o fibra de concreto, estera, triplay, cartón o plástico, otros */
label val pared_mat material
drop pared
tab techo
gen techo_mat = 3 if inlist(techo,1)
replace techo_mat = 2 if inlist(techo, 2,3,4,5,6,7,9)
replace techo_mat = 1 if inlist(techo,8,10)
label var techo_mat "Techo - material predominante"
label def techomat 1 "material precario" 2 "material no noble" 3 "material noble"
/* noble: concreto armado
no noble: madera, teja, calamina, fibra de cemento, o similares (eternit, lata o laton)
precario: caña con barro, otro*/
label val techo_mat techomat
drop techo
tab piso
gen piso_mat = 1 if inlist(piso,6,7)
replace piso_mat = 2 if inlist(piso,5)
replace piso_mat = 3 if inlist(piso,1,2,3,4)
label var piso_mat "Piso - material predominante"
label def pisomat 1 "piso de tierra u otro" 2 "piso entablado" 3 "piso de cemento / Material adecuado" 
/* material adecuado: parquet o madera pulida, vinilico, pisopk, loseta, ceramico o similar
piso entablado: madera entablada
piso de cemento: cemento
piso de tierra u otro : tierra, otro
*/
label val piso_mat pisomat
drop piso 

drop puertas*
/*tab puertas
gen puerta_mat = 0 if inlist(puertas,)
replace puerta_mat = 1 if inlist(puertas,)
replace puerta_mat = 2 if inlist(puertas,)
replace puerta_mat = 3 if inlist(puertas,)
label var puerta_mat "Puerta - material predominante"
label def puertamat 0 " 
/* material adecuado: 
	*/
label val puerta_mat puertamat
drop puertas*/

*tab puertas_
tab pared_estado
tab techo_estado
tab piso_estado

recode piso_e techo_e pared_e (1 5=4)(2=3)(3=2)(4=1)
label def estado 1 "No tiene y lo requiere" 2 "Malo" 3 "Regular" 4 "bueno", modify
label val piso_e techo_e pared_e estado
*order CODLOCAL NUMERO puertas* pared* piso* techo*

local varlist2 "pared_estado techo_estado piso_estado pared_mat techo_mat piso_mat"
foreach var of local varlist2 {
	bysort CODLOCAL: egen vr= mean(`var') 
	replace `var' = vr
	drop vr 
	}

	drop NUMERO
	duplicates drop

gen infe_estado=((piso_e)+(techo_e)+(pared_e))/3
gen infe_material=(piso_mat+techo_mat+pared_mat)/3
drop pared_estado techo_estado piso_estado pared_mat techo_mat piso_mat

gen infra_indice= (0.6*infe_estado+0.4*infe_material)/2
 
egen infraestructura_z = std(infra_indice)
drop infe_material

duplicates drop
	
isid CODLOCAL

count // 48,706
save "Local_sec500_limpia", replace

***************************************************************************
$censo
use "horario.dta", clear
keep if inlist(NROCED, "1AP", "3AP", "3AS")
keep if ANEXO=="0"
summ HI_HORAS HI_MINUTOS HT_HORAS HT_MINUTOS
gen hrs=HT_HORAS-HI_HORAS
summ hrs // horas promedio -> 5
replace hrs= 13 if HT_HORAS==1 &hrs<0 // cambiar a formato 24 horas
replace hrs= 14 if HT_HORAS==2 &hrs<0
replace hrs= 18 if HT_HORAS==6 &hrs<0
keep COD_MOD hrs
duplicates drop COD_MOD, force
save "horario_limpia.dta", replace

******************************************************************************
* Limpieza data docentes
* ----------------------

$censo
use "Docentes_01", clear
append using "Docentes_02"
append using "Docentes_03"
keep if NROCED == "1A" | NROCED == "3AP" | NROCED == "3AS" 
replace CUADRO ="C313" if CUADRO=="C312" & NROCED=="1A"
replace CUADRO ="C315" if CUADRO=="C314" & NROCED=="1A"
keep if inlist(CUADRO,"C302", "C303", "C304","C305", "C308", "C313", "C315")
replace CUADRO="JORNADA LABORAL" if CUADRO=="C302"
replace CUADRO="GENERO" if CUADRO=="C303"
replace CUADRO="CONDICION LABORAL" if CUADRO=="C304"
replace CUADRO="NIVEL EDUCATIVO ALCANZADO" if CUADRO=="C305"
replace CUADRO="ESCALA MAGISTERIAL" if CUADRO=="C308"
replace CUADRO="EDAD" if CUADRO=="C313"
replace CUADRO="EXPERIENCIA LABORAL" if CUADRO=="C315"
tab CUADRO
/* 1A:
C302 : JORNADA LABORAL
		1 (40 HRS);	2 (30 HRS); 3 (25 HRS); 4 (24 HRS); 
		5 (MENOS DE 24 HRS); 6 (PRIVADA)
C303 : GENERO
		1 (HOMBRE); 2 (MUJER)
C304 : CONDICION LABORAL 
		1 (NOMBRADO); 2 (CONTRATADO)
C305 : MAX NIVEL EDUCATIVO ALCANZADO	
			1 : TOTAL ESTUDIOS SUPERIORES PEDAGÓGICOS
			2 : 	Concluidos con título.
			3 : 	Concluidos sin título.
			4 : 	No concluidos.
			5 : TOTAL ESTUDIOS SUPERIORES NO PEDAGÓGICOS
			6 : 	Concluidos con título.
			7 : 	Concluidos sin título.
			8 : 	No concluidos.
			9 : Secundaria.
			10 : Primaria.
C308 : ESCALA MAGISTERIAL
		9 : sin escala
C312 : EDAD
		1 (20 y menos);	2 (21-25); 3 (26-30); 	4 (31-35);	5 (36-40);
		6 (41-45);	7 (46-50);	8 (51-55);	9 (56-60);	10 (61-65)
		11 (66-70);	12 (70 a más)
C314: AÑOS DE EXPERIENCIA LABORAL
		"01" (00-05); "02"(06-10); "03" (11-15); "04" (16-20)	"05" (21-25)
		"06" (26-30); "07" (31-35);	"08" (36-40); "09" (41 a más)
		
3AP Y 3AS
C302: JORNADA LABORAL
C303: GENERO
C304: CONDICION LABORAL
C305: NIVEL EDUCATIVO ALCANZADO
C308: ESCALA MAGISTERIAL
C313: EDAD
C315: EXPERIENCIA LABORAL */ 

destring(TIPDATO), replace
drop if CUADRO =="JORNADA LABORAL" & TIPDATO==6 //ie privadas
keep if ANEXO=="0" 
drop ANEXO NIV_MOD
rename D09 docente_aula 
replace docente_aula=docente_aula+D10 if NROCED=="1A"
replace docente_aula=docente_aula+D14 if NROCED=="3AP"
gen otro_docente=D11 if NROCED=="1A"
replace otro_docente=0 if otro_docente==.
replace otro_docente=otro_docente+D10+D11+D12+D13+D15 if NROCED=="3AP"
replace otro_docente=otro_docente+D10+D11+D12+D13+D22+D23+D24+D25+D26 if NROCED=="3AS"
codebook otro_docente docente_aula
keep COD_MOD NROCED CUADRO TIPDATO docente_aula otro_docente CODLOCAL
order CODLOCAL COD_MOD NROCED CUADRO TIPDATO
sort CODLOCAL COD_MOD NROCED CUADRO TIPDATO
duplicates drop
gen docentes=otro_docente+docente_aula
drop otro_docente docente_aula
tab docentes

gen contratados_n=docentes if CUADRO=="CONDICION LABORAL" & TIPDATO==2
replace contratados_n=0 if contratados_n==.
gen nombrados_n=docentes if CUADRO=="CONDICION LABORAL" & TIPDATO==1
replace nombrados_n=0 if nombrados_n==.
gen mujer_n=docentes if CUADRO=="GENERO" & TIPDATO==2
replace mujer_n=0 if mujer_n==.
gen hombre_n=docentes if CUADRO=="GENERO" & TIPDATO==1
replace hombre_n=0 if hombre_n==.
gen jornada_40_n=docentes if CUADRO=="JORNADA LABORAL" & TIPDATO==1
gen jornada_30_n=docentes if CUADRO=="JORNADA LABORAL" & TIPDATO==2
gen jornada_25_n=docentes if CUADRO=="JORNADA LABORAL" & TIPDATO==3
gen jornada_24_n=docentes if CUADRO=="JORNADA LABORAL" & TIPDATO==4
gen jornada_23_n=docentes if CUADRO=="JORNADA LABORAL" & TIPDATO==5
gen edad_20_n=docentes if CUADRO == "EDAD" & TIPDATO==1
gen edad_21_25_n=docentes if CUADRO == "EDAD" & TIPDATO==2
gen edad_26_30_n=docentes if CUADRO == "EDAD" & TIPDATO==3
gen edad_31_35_n=docentes if CUADRO == "EDAD" & TIPDATO==4
gen edad_36_40_n=docentes if CUADRO == "EDAD" & TIPDATO==5
gen edad_41_45_n=docentes if CUADRO == "EDAD" & TIPDATO==6
gen edad_46_50_n=docentes if CUADRO == "EDAD" & TIPDATO==7
gen edad_51_55_n=docentes if CUADRO == "EDAD" & TIPDATO==8
gen edad_56_60_n=docentes if CUADRO == "EDAD" & TIPDATO==9
gen edad_61_65_n=docentes if CUADRO == "EDAD" & TIPDATO==10
gen edad_66_70_n=docentes if CUADRO == "EDAD" & TIPDATO==11
gen edad_71_n=docentes if CUADRO == "EDAD" & TIPDATO==12

gen experiencia_5_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==1 //1 (00-05); 2(06-10); 3 (11-15); 4 (16-20); 5 (21-25); 6 (26-30); 7 (31-35); 8 (36-40); 9 (41 a más)
gen experiencia_6_10_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==2
gen experiencia_11_15_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==3
gen experiencia_16_20_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==4
gen experiencia_21_25_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==5
gen experiencia_26_30_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==6
gen experiencia_31_35_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==7
gen experiencia_36_40_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==8
gen experiencia_41_n=docentes if CUADRO == "EXPERIENCIA LABORAL" & TIPDATO==9

local varlistdoc "mujer_n hombre_n jornada_40_n jornada_30_n jornada_25_n jornada_24_n jornada_23_n edad_20_n edad_21_25_n edad_26_30_n edad_31_35_n edad_36_40_n edad_41_45_n edad_46_50_n edad_51_55_n edad_56_60_n edad_61_65_n edad_66_70_n edad_71_n experiencia_5_n experiencia_6_10_n experiencia_11_15_n experiencia_16_20_n experiencia_21_25_n experiencia_26_30_n experiencia_31_35_n experiencia_36_40_n experiencia_41_n"
foreach var of local varlistdoc {
	replace `var' =0 if `var'==.
}

drop if inlist(CUADRO, "ESCALA MAGISTERIAL", "NIVEL EDUCATIVO ALCANZADO")

tab CUADRO
tab TIPDATO if CUADRO=="NIVEL EDUCATIVO ALCANZADO"
tab TIPDATO if CUADRO=="EDAD"
tab TIPDATO if CUADRO=="EXPERIENCIA LABORAL"

local varlist6 "contratados nombrados mujer hombre jornada_23_n jornada_24_n jornada_25_n jornada_30_n jornada_40_n edad_20_n edad_21_25_n edad_26_30_n edad_31_35_n edad_36_40_n edad_41_45_n edad_46_50_n edad_51_55_n edad_56_60_n edad_61_65_n edad_66_70_n edad_71_n experiencia_11_15_n experiencia_16_20_n experiencia_21_25_n experiencia_26_30_n experiencia_31_35_n experiencia_36_40_n experiencia_41_n experiencia_5_n experiencia_6_10_n"
foreach var of local varlist6 {
	bysort COD_MOD: egen vr=total(`var')
	replace `var'=vr
	drop vr
}

drop TIPDATO CUADRO docentes
duplicates drop
isid CODLOCAL COD_MOD

gen edad_30_n=edad_20+edad_21_25_n+edad_26_30_n
gen edad_31_60_n = edad_31_35+edad_36_40+edad_41+edad_46_50+edad_51_55_n+edad_56_60_n
gen edad_60_n =edad_61_65_n+edad_66_70_n+edad_71_n

gen experiencia_15_n=experiencia_5_n+experiencia_6_10_n+experiencia_11_15_n
gen experiencia_16_25=experiencia_16_20_n+experiencia_21_25_n
gen experiencia_26_40=experiencia_26_30_n+experiencia_31_35_n+experiencia_36_40_n

replace jornada_25_n=jornada_25_n+jornada_24_n+jornada_23_n

drop jornada_23_n jornada_24_n edad_66_70_n edad_71_n edad_20 edad_21_25_n edad_26_30_n edad_31_35 edad_36_40 edad_41 edad_46 edad_20 edad_21_25_n edad_26_30_n edad_31_35 edad_36_40 edad_41 edad_46_50_n edad_51_55_n edad_56_60_n edad_61_65_n experiencia_26_30_n experiencia_31_35_n experiencia_36_40_n experiencia_16_20_n experiencia_21_25_n experiencia_5_n experiencia_6_10_n experiencia_11_15_n

order CODLOCAL COD_MOD contratados_n nombrados_n mujer_n hombre_n jornada_40_n jornada_30_n jornada_25_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n

*drop NROCED
duplicates drop
isid COD_MOD CODLOCAL

save "Docentes_limpia", replace

/* 	1A
D01 Director General con sección
D02 Director General sin sección 
D03 Director con sección 
D04 Director sin sección 
D05 sub Director con sección 
D06 Sub Director sin sección 
D07 Coordinador, asesor con sección 
D08 Coordinador, asesor sin sección
D09 Docente de aula
D10 docente de aula con función o cargo directivo
D11 otro docente
D12 auxiliar de educación 

3AP
D09 Docente de aula
D10 docentes especiales EEFF
D11 docentes especiales COMPUTACIÓN
D12 docentes especiales AULA DE INNOVACIÓN PEDAGOGICA
D13 docentes especiales - otros
D14 docente de aula con función o cargo directivos
D15 otro docente
D16 Auxiliar de educación

3AS
D09 Docente por horas
D10 docente EEFF
D11 docente COMPUTACIÓN
D12 docente AULA DE INNOVACIÓN PEDAGOGICA
D13 otro docente
D14 director academico con horas
D15 director academico sin horas
D16 director de bienestar y desarrollo con horas 
D17 Director de bienestar y desarrollo sin horas
D18 Coordinador psicopedagógico con horas
D19 Coordinador psicopedagógico sin horas
D20 Asistente de dirección General / Académica / de Bienestar
Estudiantil con horas
D21 Asistente de dirección General / Académica / de Bienestar
Estudiantil sin horas
D22 Docente COAR
D23 Docente tutor
D24 Docente Acompañante
D25 Docente coordinador de monografia
D26 Docente monitor
D27 Auxiliar de educación
*/

****************************************************************

** Unión data censo educativo **
*--------------------------------

$censo
use "Lineal_total", clear 
merge 1:1 CODLOCAL COD_MOD using "Equipamiento_limpia", nogen
merge 1:1 COD_MOD using "horario_limpia", nogen
*merge 1:1 CODLOCAL COD_MOD using "recursos_acce_limpia", nogen
merge 1:1 CODLOCAL COD_MOD using "Docentes_limpia", nogen
merge m:1 CODLOCAL using "Local_lineal_limpia", nogen
merge m:1 CODLOCAL using "Local_sec500_limpia", nogen
merge m:1 CODLOCAL using "local_trayectos_limpia", nogen
merge m:1 CODLOCAL using "Local_Servicios_Basicos_limpia3", nogen
merge m:1 CODLOCAL using "Local_Servicios_Basicos_limpia", nogen
merge m:1 CODLOCAL using "Local_Servicios_Basicos_limpia2", nogen

duplicates drop
drop if COD_MOD==""
drop if CODLOCAL== ""
isid COD_MOD
*drop programa material_edu
*drop salud_docente topografia clima capital_ugel trayectos_cap
$data
save "censo_edu", replace


