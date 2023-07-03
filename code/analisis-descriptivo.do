
*ssc install asdoc

global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS\resources" 
global fig cd "C:\Users\teresa\Documents\GIT\TESIS\fig"
$data
use "data_final", clear

* irp promedio según dpto macroregion y arae geográfica:

foreach x in irp irp10 irp25{
table  dpto, c(mean `x')
table macror, c(mean `x') 
table area_g, c(mean `x')
}

mean irp

tabstat irp, stat(mean cv) by(dpto)
ttest irp, by(area_g)

* IRP PROMEDIO POR GRUPOS
*Grafico 1
grmeanby macror area_g region ruralidad frontera vraem, summarize(irp) ytitle("Media") title("Promedio de IRP por grupos") name(gd1, replace)
$fig
graph export "gd1.png", width(500) replace
*grafico 2
grmeanby nivel est_ge_originario servicios_basicos_cp servicios_ie, summarize(irp) ytitle("Media") name(gd2a, replace)
$fig
graph export "gd2a.png", width(500) replace

grmeanby eib comunidad_leng_orig est_lengua_orig , summarize(irp) ytitle("Media") name(gd2b, replace) title("")
$fig
graph export "gd2b.png", width(500) replace


* IRP promedio por dpto
local mean_irp=r(mean irp) 
display `mean_irp'
graph hbar (mean) irp, over(dpto)  blabel(total, size(small) format(%2.1f)) ytitle("promedio")  yline(`mean_irp') name(gd3, replace)
$fig
graph export "gd3.png", width(500) replace

global vars " apoyo_docente salud_docente acompañamiento castellano_segunda_lengua enseñanza_bilingue"



* codebook $vars
* Variables con missing : est_ge_originario clima totpografia capital trayectos_cap peligro_nat peligro_antropicos area_m2 vulnerabilidad servicios* infe_minmax distancia_min eib comunidad_leng_orig est_lengua_orig total_docentes

* Estadisticas descriptivas (media, desv. std., min, max y n° obs )
* -----------------------------------------------------------------
asdoc summ $vars, save(estad_descriptivas.doc)

* Proporción de IE segun sus plazas vacantes y ubicacion geográfica
* ------------------------------------------------------------------
graph bar (percent), over(vac_d) over(area) asyvars percent stack blabel(total) ytitle("%") note("Fuente: MINEDU" "Elaboración propia",size(6pt)) name(d1, replace)

graph export "d1.png", as(png) replace


gen peligros=peligro_antropicos+peligro_nat
reg vac_prop nivel est_ge_originario total_equipo contratados_n nombrados_n mujer_n jornada_40_n jornada_30_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n clima capital_ugel trayectos_cap peligros area_m2 vulnerabilidad servicios_basicos_cp servicios_cp infe_minmax servicios_ie area vraem frontera altitud tipoie ruralidad macroregion eib comunidad_leng_orig est_lengua_orig topografia
reg vac_prop $vars

global continuas "total_equipo contratados_n nombrados_n mujer_n jornada_40_n jornada_30_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n peligro_nat peligro_antropicos vulnerabilidad servicios_basicos_cp servicios_cp infe_minmax servicios_ie  area_m2 altitud"

* prueba chi2

foreach x in nivel est_ge_originario clima capital_ugel trayectos_cap area vraem frontera tipoie ruralidad macroregion eib comunidad_leng_orig est_lengua_orig  topografia {
	tab vac_d  `x', chi2
}



