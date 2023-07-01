* -------- DO - TESIS ----------
*    Estado de plazas 2022
*-------------------------------

cls
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"

* -----------------------------------------------------------------------------
* Limpieza de data de la relación de plazas para reasignación docente 2022 por intereés personal y/o unidad familiar-> lista de plazas vacantes para resignación publicada y actualizada entre mayo y junio del 2022 
$data
use "reasignacion2022.dta", clear // data con información de la reasignación docente 2022
*codebook
keep if MODALIDAD=="EBR" // mantener observaciones de escuelas de educación básica regular
drop if TIPODEGESTIÓN == "Privada" // mantener escuelas públicas
keep if CARGO== "PROFESOR" // Mantener solo docentes

drop if regexm(MOTIVO, "plaza creada") // eliminar plazas que fueron creadas después del inicio del año escolar 

replace MOTIVO =lower(MOTIVO)
replace MOTIVO = subinstr(MOTIVO, ".", "", .)

* Encargatura: proceso que permite a los docentes nombrados desempeñar, de manera temporal, cargos jerárquicos y directivos de instituciones educativas, y cargos directivos y especialista en Educación de las UGEL y DRE

* Reasignación: procedimiento que permite desplazar a un profesor de un cargo a otro igual, el cual no implica cambio de nivel, ciclo o modalidad educativa

* Abandono de cargo: inasistencia injustificada al centro de trabajo por más de tres (3) días consecutivos o cinco (5) discontinuos, en un período de dos (2) meses, correspondiéndole la sanción de cese temporal

gen motivo ="cese/cambio voluntario" if regexm(MOTIVO, "cese a solicitud") | regexm(MOTIVO, "cese por solicitud")| regexm(MOTIVO, "renuncia voluntaria") | regexm(MOTIVO, "abandono") | regexm(MOTIVO, "permuta") | regexm(MOTIVO, "reasig") | regexm(MOTIVO, "reas")
replace motivo ="cese/cambio involuntario" if regexm(MOTIVO, "limite de edad") | regexm(MOTIVO, "fallecimiento") | regexm(MOTIVO, "incapacidad") | regexm(MOTIVO, "separacion") | regexm(MOTIVO, "cese de personal nombrado") | regexm(MOTIVO, "retiro del servicio")
replace motivo ="cambio de cargo" if regexm(MOTIVO, "designac") | regexm(MOTIVO,"ascenso") | regexm(MOTIVO, "nombram") | regexm(MOTIVO, "reposicion") | regexm(MOTIVO, "encargatura") | regexm(MOTIVO, "retorno")
replace motivo ="reubicacion y/o adecuacion de plaza" if regexm(MOTIVO, "reub") | regexm(MOTIVO, "adecuacion de plaza") | regexm(MOTIVO, "transferencia")
replace motivo ="otro / no especifica"  if motivo ==""

tab motivo // motivo de vacante

drop DRE MODALIDAD AREADE NOMBRE DEPEN REQU AREACU ESPEC TIPODEGESTIÓN PROVINCIA DISTRITO LENGUA FORMAS MOTIVO CARGO 
rename (CÓDIGODEPLAZA CÓDIGOMODULAR) (CODPLAZA COD_MOD)

duplicates drop
 
 gen vacante = 1  // indicador de plaza vacante

save "reasignacion_limpia", replace // plazas vacantes mayo-junio para reasignacion 2022

use "reasignacion_limpia", clear
* ------------------------------------------------------------------------------

$data
use "EBR2022.dta", clear // Data transparencia 2022 - Estado de plazas docentes en octubre 2022 -> contiene información de todas las plazas ocupadas y vacantes y su estado a octubre del 2022
merge 1:1 CODPLAZA COD_MOD using "reasignacion_limpia", nogen // plazas vacantes entre mayo y junio


*codebook REG* TIPOPLAZA TIPODEPLAZA DESCNIV NIVEL JORN*
replace REGION = REGIÓN if REGION ==""
replace TIPOPLAZA = TIPODEPLAZA if TIPOPLAZA ==""
replace NIVEL =lower(NIVEL)
replace DESCNIV = 1 if regexm(NIVEL, "inicial") & DESCNIV==.
replace DESCNIV = 2 if regexm(NIVEL, "primaria") & DESCNIV==.
replace DESCNIV = 3 if regexm(NIVEL, "secun") & DESCNIV==.
replace JORNLAB= 30 if regexm(JORNADA, "30") & JORNLAB==.

replace ESTADO_PLAZA="VACANTE" if vacante==1

drop REGIÓN TIPODEPLAZA CODCATREM NIVEL JORNADA DESCSUB vacante motivo 

merge 1:1 CODPLAZA COD_MOD using "2022-NOV-vacantes" // plazas vacantes de noviembre
drop if _m==2

replace ESTADO_PLAZA = "VACANTE" if plaza =="VACANTE"
drop TIPO_REGIS plaza _m
drop if TIPOPLAZA=="PROYECTO"
drop if inlist(COD_MOD,"0000000","0000001","0000003") // códigos erroneos
drop if inlist(TIPOPLAZA,"EVENTUAL") // mantener solo plazas orgánicas
replace TIPODEIE = lower(TIPODEIE)

isid COD_MOD CODPLAZA

gen vacante=1 if ESTADO_PLAZA=="VACANTE"
bysort COD_MOD: egen plazas_total = count(COD_MOD) // numero total de plazas por código modular
bysort COD_MOD: egen plazas_vacantes = total(vacante) // numero total de plazas vacantes por código modular

gen contratado=1 if SITLAB_DOCENTE=="CONTRATADO"
gen nombrado=1 if SITLAB_DOCENTE=="NOMBRADO"
bysort COD_MOD: egen total_contratados = total(contratado)
bysort COD_MOD: egen total_nombrados = total(nombrado)

drop TIPOPLAZA CODPLAZA ESTADO_DOCENTE SITLAB_DOCENTE ESTADO_PLAZA JORNLAB vacante contratado nombrado  TIPODEIE BILINGÜE TIPODERURALIDAD FRONTERA VRAEM

sort COD_MOD
duplicates drop

merge m:1 COD_MOD using "codigos.dta", keep(3) nogen // Añadir códigos de local
duplicates drop

$data
save "relacion_plazas_limpia", replace

