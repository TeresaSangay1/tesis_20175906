
*ssc install asdoc


global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS" 

$data
use "data_final", clear

* irp promedio según dpto macroregion y arae geográfica:

foreach x in irp irp10 irp25{
table  dpto, c(mean `x')
table macror, c(mean `x') 
table area_g, c(mean `x')
}

* agrupaciones : área geográfica, macroregion y ruralidad

global vars "nivel est_ge_originario total_equipo contratados_n nombrados_n mujer_n jornada_40_n jornada_30_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n clima capital_ugel trayectos_cap peligro_nat peligro_antropicos area_m2 vulnerabilidad servicios_basicos_cp servicios_cp infe_minmax servicios_ie rural vraem frontera altitud tipoie ruralidad macroregion eib comunidad_leng_orig est_lengua_orig topografia distancia AB C D E" 
logit irp25 $vars 
logit irp10 $vars 
logit vac_d $vars

regress irp $vars
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



