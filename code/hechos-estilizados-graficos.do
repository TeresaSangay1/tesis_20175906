
* Gráficos para hechos estilizados
* ---------------------------------
ssc install schemepack, replace 	
set scheme white_w3d
	
*  evolucion dotacion docente 2008 - 2022

global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global graf cd "C:\Users\teresa\Documents\GIT\TESIS\fig"
$data

import excel using "DOCENTES PUBLICOS SEGUN DEPARTAMENTO 2008-2020", sheet(EBR PÚBLICO) firstrow clear
drop in 16
destring Año, replace

twoway (line Total Año) (line Rural Año) (line Urbano Año), note("Fuente: Censo Educativo 2022 - MINEDU. Elaboración propia") legend(label(1 "Total") label(2 "Rural") label(3 "Urbano")) xlabel(2008(2)2022) graphregion(fcolor(white) ifcolor(white)) name(g1, replace)
$graf
graph export "1.png", as(png) replace

