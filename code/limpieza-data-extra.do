*Limpieza de bases de datos adcionales



* Estructura socioeconomica por departamento
*-------------------------------------------
*Data con información sobre proporcion de poblacion en niveles socieconomicos AB C D E segun departamento

global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
$data
clear
import excel "C:\Users\teresa\Documents\GIT\TESIS\data\poblacion-estructura-socioecon.xlsx", sheet("poblacion2022") cellrange(A1:F25) firstrow
drop Pob


gen dpto = 1 if Dep =="Amazonas" 
replace dpto =2 if Dep== "Ancash" 
replace dpto =3 if Dep =="Apurímac" 
replace dpto =4 if Dep =="Arequipa" 
replace dpto =5  if Dep =="Ayacucho" 
replace dpto =6 if Dep == "Cajamarca" 
replace dpto =7 if Dep =="Callao" 
replace dpto =8 if Dep =="Cusco"	
replace dpto =9 if Dep =="Huancavelica" 
replace dpto =10 if Dep =="Huánuco" 
replace dpto =11 if Dep =="Ica" 
replace dpto =12 if Dep =="Junín" 
replace dpto =13 if Dep =="La Libertad" 
replace dpto =14 if Dep =="Lambayeque" 
replace dpto =15 if Dep =="Lima"
replace dpto =16 if Dep =="Loreto" 
replace dpto =17 if Dep =="Madre de Dios" 
replace dpto =18 if Dep =="Moquegua" 
replace dpto =19 if Dep =="Pasco" 
replace dpto =20 if Dep =="Piura" 
replace dpto =21 if Dep =="Puno" 
replace dpto =22 if Dep =="San Martín" 
replace dpto =23 if Dep =="Tacna" 
replace dpto =24 if Dep =="Tumbes" 
replace dpto =25 if Dep =="Ucayali"
	
	destring dpto, replace	
	label define dpto 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco"	9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
	label values dpto dpto 
	
drop Dep

save "pob-socioecon-limpia", replace


** Coordenadas de capitales provinciales
*----------------------------------------
 $data
 use "coord-cap-prov.dta", clear

 rename Cod_D dpto
 sort Cod_Prov
 label define dpto 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco"	9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
	label values dpto dpto 

	keep Rasgo dpto X Y Cod_Prov
	rename Cod_Prov cod_prov
save "coord-cap-prov-limpia", replace