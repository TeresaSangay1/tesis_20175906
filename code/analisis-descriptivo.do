
*ssc install asdoc
*ssc install schemepack, replace
set scheme white_jet 
. graph set window fontface       "Times New Roman"
. graph set window fontfacemono   "Times New Roman"
. graph set window fontfacesans   "Times New Roman"
. graph set window fontfaceserif  "Times New Roman"
. graph set window fontfacesymbol "Symbol"

global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS\resources" 
global fig cd "C:\Users\teresa\Documents\GIT\TESIS\fig"


* Estadisticas descriptivas (media, desv. std., min, max y n° obs )
* -----------------------------------------------------------------
global doc "contratados_n mujer_n jorn_40 jorn_30 edad30 edad31_60 edad60 experiencia16_25 experiencia26_40 experiencia41 salud apoyo"
global est "est_ge_originario d_est_l_orig"
global esc "nivel total_equipo aream2_z infe_es tipoie eib servicios_ie fortalecimiento_gestion convenio castellano_segunda_lengua enseñanza_bilingue talumno tamclase material hrs bono_total"
global ent "clima capital_ugel trayectos_cap peligro_nat peligro_antropicos vulnerabilidad servicios_basicos_cp servicios_cp macroregion ruralidad rural vraem frontera altitud  comunidad_leng_orig topografia distancia"

asdoc summ $doc $est $esc $ent, save(estad_descriptivas.doc)


* IRP promedio según dpto macroregion y area geográfica
-------------------------------------------------------
foreach x in irp irp10 irp21{
table  dpto, c(mean `x')
table macror, c(mean `x') 
table area, c(mean `x')
}

mean irp
tabstat irp, stat(mean cv) by(dpto)

* DOCENTES 2008 - 2022
$data
import excel using "DOCENTES PUBLICOS SEGUN DEPARTAMENTO 2008-2020", sheet(EBR PÚBLICO) firstrow clear
drop in 16
destring Año, replace
$fig
twoway (line Total Año) (line Rural Año) (line Urbano Año), title("") ytitle("Cantidad de docentes") xtitle("Año") note("Fuente: Censo Educativo 2022 - MINEDU. Elaboración propia") ///
legend(label(1 "Total") label(2 "Rural") label(3 "Urbano"))  xlabel(2008(2)2022) graphregion(fcolor(white) ifcolor(white)) name(gd0, replace)
$graf
graph export "gd0.png", as(png) replace

* IRP PROMEDIO POR GRUPOS
-------------------------------------------------------
*Grafico 1
$data
use "data_final", clear
grmeanby macror area region ruralidad frontera vraem, summarize(irp) ytitle("Media") name(gd1, replace) title("")
$fig
graph export "gd1.png", width(2000) replace
*grafico 2
grmeanby nivel est_ge_originario eib est_lengua_orig, summarize(irp) ytitle("Media") name(gd2a, replace) title("")
$fig
graph export "gd2a.png", width(2000) replace

gr combine gd1 gd2a, note(Elaboración propia) name(gd2b, replace)
$fig
graph export "gd11.png", width(1000) replace


* IRP promedio por dpto
-------------------------------------------------------
local mean_irp=r(mean irp) 
display `mean_irp'
graph hbar (mean) irp, over(dpto)  blabel(total, size(small) format(%2.1f)) ytitle("promedio")  yline(`mean_irp') name(gd3, replace)
$fig
graph export "gd3.png", width(1000) replace



* irp promedio segun servicios básicos
*------------------------------------------------------
ttest irp, by(servicios_cp)
ttest irp, by(servicios_ie)

$data
use "data_final", clear
bysort servicios_basicos_cp: egen irp_m1=mean(irp)
bysort servicios_cp: egen irp_m2=mean(irp)
bysort servicios_ie: egen irp_m3=mean(irp)
label var irp_m1 "Servicios básicos en CP"
label var irp_m2 "Otros Servicios en CP"
label var irp_m3 "Servicios básicos I.E."
 twoway (scatter irp_m1 servicios_basicos_cp) (scatter irp_m2 servicios_cp) (scatter irp_m3 servicios_ie, msymbol(circle_hollow)), ytitle(IRP promedio) xtitle(Cantidad) name(gd4, replace)
$fig
graph export "gd4.png", width(1000) replace


** IRP y distancia
*------------------------------------------------------
$data
use "data_final", clear
collapse (mean) distancia, by(irp)
twoway (scatter distancia irp) (qfit distancia irp), legend(off) ytitle(distancia promedio (km)) name(gd7, replace)
$fig
graph export "gd7.png", width(1000) replace

* IRP y bono acumulado
*------------------------------------------------------
$data
use "data_final", clear
collapse (mean) bono_total, by(irp)
twoway (scatter bono_total irp)(qfit bono_total irp), legend(off) ytitle(bono acumulado promedio (s/.)) name(gd8, replace)
$fig
graph export "gd8.png", width(1000) replace

* IRP y área del local educativo (m2) 
* -----------------------------------------------------
$data
use "data_final", clear
collapse (mean) area_m2, by(irp)
twoway (scatter area irp)(lfit area irp), legend(off) ytitle(área promedio (m2)) name(gd9, replace)
$fig
graph export "gd9.png", width(1000) replace

* IRP y horas escolares
* -----------------------------------------------------
$data
use "data_final", clear
collapse (mean) hrs, by(irp)
twoway (scatter hrs irp)(lfit hrs irp), legend(off) ytitle(duración de clases (horas promedio)) name(gd10, replace)
$fig
graph export "gd10.png", width(1000) replace

gr combine gd7 gd8 gd9 gd10, note(Elaboración propia) name(gd11, replace)
$fig
graph export "gd11.png", width(1000) replace


** irp y docentes
*-----------------------------------------------------
* tipo de docentes
$data
use "data_final", clear
collapse (mean) contratados_n nombrados_n mujer_n hombre, by(irp)
label var contratados_n "Contratados" 
label var nombrados_n "Nombrados"
label var hombre_n "Hombre"
label var mujer_n "Mujer"
twoway (scatter contratados_n irp), title(Contratados) ytitle(porcentaje promedio) name(gd12a, replace)
twoway (scatter nombrados_n irp), title(Nombrados) ytitle(porcentaje promedio) name(gd12b, replace)
$fig
graph combine gd12a gd12b, note(Elaboración propio) name(gd12, replace)
graph export "gd12.png", width(1000) replace

* sexo de docentes
twoway (scatter hombre_n irp), title(Hombre) ytitle(porcentaje promedio) name(gd13a, replace) 
twoway (scatter mujer_n irp), title(Mujer) ytitle("") name(gd13b, replace)
$fig
graph combine gd13a gd13b, note(Elaboración propio) name(gd13, replace)
graph export "gd13.png", width(1000) replace


**  ENDO 2021 // ENDO 2022 no disponible
$data
use "endo2021", clear
destring cod_ie, replace
duplicates drop
sort cod_ie
gen byte area =1 if AREA== "Rural"
replace area=0 if area==.
label def area 1 "Rural" 0 "Urbana"
label val area area
label def condicion 1 "Bono Salarial" 2 "Bono de Movilidad" 3 "Vivienda o alojamiento" 4 "Puntaje adicional en alguna de las evaluaciones" 5 "Aceptaría sin necesidad de condiciones" 6 "No trabajaría o volvería a trabajar en esa plaza" 7 "Otro"
label val P1_2 condicion

graph hbar [pw=FACTOR], over(P1_2, descending) by(area, note("Fuente: Encuesta Nacional a Docentes 2021 - MINEDU. Elaboración propia",size(6pt))) asyvars blabel(bar,format(%4.2f) size(4)) ylabel(#4, labsize(3)) ytitle("%") 
$fig
graph export "endo.png", width(1000) replace 

Principal condición para trabajar en una plaza rural










* prueba chi2
*---------------
foreach x in nivel est_ge_originario clima capital_ugel trayectos_cap area vraem frontera tipoie ruralidad macroregion eib comunidad_leng_orig est_lengua_orig  topografia {
	tab vac_d  `x', chi2
}



