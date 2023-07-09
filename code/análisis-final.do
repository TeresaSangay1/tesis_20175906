*ssc install estout, replace
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS\resources"
global fig cd "C:\Users\teresa\Documents\GIT\TESIS\fig"
$data
use "data_final", clear

*******************************************************
******************************************************

* variable dependiente
*-----------------------------------------------------
summ irp
gen d_irp=irp>=21.91 //=1 si irp está por encima de la media general

tab d_irp

* test de medias por area geográfica
*------------------------------------------------------
ttest d_irp, by(area)  

*correlacion entre IRP y características de la escuela
*------------------------------------------------------
$resources
estpost correlate irp nivel total_equipo aream2 infe tipoie eib servicios_ie fortalecimiento, matrix listwise
esttab using correlacion1.tex, unstack not noobs compress replace

estpost correlate irp convenio castellano_segunda_lengua tamclase material hrs bono_total, matrix listwise
esttab using correlacion2.tex, unstack not noobs compress replace

 * correlación entre IRP y caracteristicas del centro poblado
*------------------------------------------------------------
$resources
estpost correlate irp clima distancia capital_ugel trayectos_cap peligro_nat peligro_antropicos vulnerabilidad comunidad_leng_orig, matrix listwise
esttab using correlacion3.tex, unstack not noobs compress replace

estpost correlate irp servicios_basicos_cp servicios_cp macroregion ruralidad vraem frontera altitud, matrix listwise
esttab using correlacion4.tex, unstack not noobs compress replace

estpost correlate irp AB C D E, matrix listwise //proporción de pob segun situacion socioeconomica segun provincia
esttab using correlacion5.tex, unstack not noobs compress replace

* correlación entre IRP y caracteristicas de los estudiantes
*-----------------------------------------------------------
estpost correlate irp est_ge_originario d_est_l_orig talumno, matrix listwise
esttab using correlacion6.tex, unstack not noobs compress replace

* correlación entre IRP y docentes
*---------------------------------------------------------------- 
estpost correlate irp contratados_n nombrados mujer_n hombre jorn_40 jorn_30 edad30 edad31_60 edad60 salud, matrix listwise
esttab using correlacion7.tex, unstack not noobs compress replace

estpost correlate irp edad30 edad31_60 edad60 experiencia16_25 experiencia26_40 experiencia41 apoyo, matrix listwise
esttab using correlacion8.tex, unstack not noobs compress replace 
 
 *********************************************************************************
 

* Bondad del modelo - Test Hosmer y Lemeshow
*----------------------------------------------

* variables
global doc "contratados_n mujer_n jorn_40 jorn_30 edad30 edad31_60 edad60 experiencia16_25 experiencia26_40 experiencia41 salud" //apoyo
global est "d_est_ge d_est_l_orig"
global esc "inicial total_equipo unidocente multigrado completo eib agua_ie desague_ie electricidad_ie convenio tamclase material" //aream2 infe_estado fortalecimiento_gestion castellano_segunda_lengua hrs bono_total
global ent "clima vulnerabilidad agua_cp desague_cp electricidad_cp internet_cp macroreg_norte macroreg_sur macroreg_oriente macroreg_lima ruralidad urbana vraem frontera altitud distancia AB C D E" //capital_ugel trayectos_cap peligro_nat peligro_antropicos comunidad_leng_orig i.topografia

** Regresión LOGIT
*--------------------------------------------------------------------------------
clear results 
logit d_irp $est $esc $doc $ent //,  iterate(4) 
$resources
outreg2 using logit.txt //, cttop(Logit)

* calcular probabilidades estimadas 
predict inlf_Prob

** ODDS RATIO
logit d_irp $est $esc $ent $doc, or
$resources
outreg2 using odds.tex, cttop(Logit)

** Variables
summarize $est $esc $ent $doc, detail
$resources
esttab using sumario.tex, replace

** BONDAD DE AJUSTE
* -----------------------------------------------------------------------------

* Tabla de clasificación
estat classification
$resources
esttab using clasificacion.tex, replace

** curva ROC
lroc
$fig
graph export "roc.png", width(1000) replace

* specificity sensitivity
lsens
$fig
graph export "sens.png", width(1000) replace
