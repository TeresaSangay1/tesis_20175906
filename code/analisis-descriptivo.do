

ssc install asdoc

global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS" 

$data
use "data_final", clear

* agrupaciones : área geográfica, macroregion y ruralidad

global vars "nivel est_ge_originario total_equipo contratados_n nombrados_n mujer_n jornada_40_n jornada_30_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n clima capital_ugel trayectos_cap peligro_nat peligro_antropicos area_m2 vulnerabilidad servicios_basicos_cp servicios_cp infe_minmax servicios_ie area vraem frontera altitud tipoie ruralidad macroregion eib comunidad_leng_orig est_lengua_orig total_docentes topografia area" //distancia

* codebook $vars
* Variables con missing : est_ge_originario clima totpografia capital trayectos_cap peligro_nat peligro_antropicos area_m2 vulnerabilidad servicios* infe_minmax distancia_min eib comunidad_leng_orig est_lengua_orig total_docentes


* Estadisticas descriptivas (media, desv. std., min, max y n° obs )
* -----------------------------------------------------------------

asdoc summ $vars, save(estad_descriptivas.doc)

reg vac_prop $vars
logit vac_d $vars

* prueba de correlación
correlate vac_prop $vars


polychoric vac_prop nivel