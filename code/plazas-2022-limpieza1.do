* -------- DO - TESIS ----------
*    Estado de plazas 2022
*-------------------------------

cls
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
$data

* -----------------------------------------------------------------------------
* Limpieza de data de la relación de plazas para reasignación docente 2022 por intereés personal y/o unidad familiar-> lista de plazas vacantes para resignación publicada y actualizada entre mayo y junio del 2022 

use "reasignacion2022.dta", clear // data con información de la reasignación docente 2022
*codebook
keep if MODALIDAD=="EBR" // mantener observaciones de escuelas de educación básica regular
drop if TIPODEGESTIÓN == "Privada" // mantener escuelas públicas
keep if CARGO== "PROFESOR" // Mantener solo docentes

replace MOTIVO ="REUBICACIÓN DE PLAZA VACANTE"  if regexm(MOTIVO, "REUBICACION DE PLAZA VACANTE")
replace MOTIVO ="92 DCF LEY 29951"  if regexm(MOTIVO, "NONAGESIMA SEGUNDA DISPOSICION COMPLEMENTARIA FINAL")
replace MOTIVO ="70 DF LEY 29289"  if regexm(MOTIVO, "70º Disposición Final de la Ley Nº 29289")
replace MOTIVO ="REASIGNACION POR INTERÉS PERSONAL"  if regexm(MOTIVO, "REASIGNACION POR INTERES PERSONAL")
replace MOTIVO ="REASIGNACION POR INTERÉS PERSONAL"  if regexm(MOTIVO, "REASIGNACION POR INTERES PERSONAL")
replace MOTIVO ="DESIGNACION EXCEPCIONAL COMO DIRECTOR DE UGEL" if regexm(MOTIVO, "DESIGNACION EXCEPCIONAL COMO DIRECTOR DE UGEL")
replace MOTIVO ="CESE A SOLICITUD" if regexm(MOTIVO, "CESE A SOLICITUD")
replace MOTIVO ="CESE POR LIMITE DE EDAD" if regexm(MOTIVO, "CESE POR LIMITE DE EDAD")
replace MOTIVO ="DESIGNACION COMO DIRECTIVO" if regexm(MOTIVO, "DESIGNACION COMO DIRECTIVO")

drop DRE MODALIDAD AREADE NOMBRE DEPEN REQU AREACU ESPEC TIPODEGESTIÓN CARGO PROVINCIA DISTRITO LENGUA FORMAS
rename (CÓDIGODEPLAZA CÓDIGOMODULAR) (CODPLAZA COD_MOD)
 
save "reasignacion_limpia", replace



use "reasignacion_limpia", clear
* ------------------------------------------------------------------------------

use "EBR2022.dta", clear // Data transparencia 2022 - Estado de plazas
merge 1:1 CODPLAZA COD_MOD using "reasignacion_limpia", nogen // plazas vacantes por reasignación 



