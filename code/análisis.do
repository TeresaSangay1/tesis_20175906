
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS\resources"
*REGRESION

* test de medias
ttest irp25, by(area_g)  

*correlacion
pcorr irp25 


* Bondad del modelo



** Regresión
global vars "i.nivel i.est_ge_originario total_equipo contratados_n nombrados_n mujer_n jornada_40_n jornada_30_n edad_30_n edad_31_60_n edad_60_n experiencia_15_n experiencia_16_25 experiencia_26_40 experiencia_41_n clima capital_ugel trayectos_cap peligro_nat peligro_antropicos c.area_m2 vulnerabilidad servicios_basicos_cp servicios_cp c.infraes servicios_ie rural i.vraem frontera c.altitud i.tipoie ruralidad i.macroregion eib comunidad_leng_orig i.est_lengua_orig i.topografia c.distancia apoyo_docente salud_docente acompañamiento castellano_segunda_lengua enseñanza_bilingue fortalecimiento_gestion convenio AB C D E "

logit irp25 $vars,  iterate(4) 
$resources
outreg2 using myfile, cttop(Logit)

margins, dydx(*) atmean post
outreg2 using myfile2, cttop(Logit)

* Hosmer-Lemeshow goodness of fit test
estat gof, group(10)

* clasificación
estat classification, all
estat classification, cut(0.68)

*running the model and requesting odds ratios using the odds ratio option
logit pass anxiety mastery interest, or

*to generate predicted probabilities (Y=1)

predict p

*to generate predicted group memberships

generate prgp = .
replace prgp=0 if(p<.50) 
replace prgp=1 if(p>=.50)


***********************************************************************

*to generate unstandardized residuals, which is the difference between the 
*observed group membership and predicted probability that Y=1.

generate unres=pass-p

*to generate Pearson's residuals, which can be useful for identifying outliers
predict PearsonResid, residuals


*to generate leverage (hat); useful for identifying cases that potentially have
*high influence on the model, since they are potential multivariate outliers
*on the predictors (see Darlington & Hayes, 2017). 
predict leverage, hat

*to generate standardized dfbetas you will need to install the 'ldfbeta' package
*once installed use the following code to generate the standardized betas
*for your predictors
ldfbeta anxiety mastery interest

*you can also evaluate casewise regression diagnostics through the use of 
*index plots, where you plot the diagnostic index against case number

*first you need to generate case identifiers
gen case_id = _n

*Once this is added, you can generate bar plots for each diagnostic measure.
*For example I will plot the leverage values against case identifier
twoway (bar leverage case_id)


***********************************************************************
*generating collinearity diagnostics
collin anxiety mastery interest

***********************************************************************
*briefly, if you wish to see what the null (intercept-only) model looks like
logit pass
