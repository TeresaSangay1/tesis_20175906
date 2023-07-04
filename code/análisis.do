
global data cd "C:\Users\teresa\Documents\GIT\TESIS\data"
global resources cd "C:\Users\teresa\Documents\GIT\TESIS\resources"
$data
use "data_final", clear
*REGRESION

* test de medias
ttest irp25, by(area)  

*correlacion
pcorr irp25 


* Bondad del modelo



** Regresión
global doc "contratados_n mujer_n jorn_40 jorn_30 edad30 edad31_60 edad60 experiencia16_25 experiencia26_40 experiencia41 salud apoyo"
global est "i.est_ge_originario d_est_l_orig"
global esc "i.nivel total_equipo c.aream2_z c.infe_es i.tipoie eib servicios_ie fortalecimiento_gestion convenio castellano_segunda_lengua enseñanza_bilingue ape tamclase material hrs bono_total"
global ent "clima capital_ugel trayectos_cap peligro_nat peligro_antropicos vulnerabilidad servicios_basicos_cp servicios_cp i.macroregion ruralidad rural i.vraem frontera c.altitud  comunidad_leng_orig i.topografia c.distancia AB C D E"
logit irp22 $est $esc $ent $doc,  iterate(4) 
$resources
outreg2 using myfile, cttop(Logit)

test contratados_n
test contratados_n mujer_n
test altitud
margins, dydx(*) // atmean post
outreg2 using myfile2, cttop(Logit)

* Hosmer-Lemeshow goodness of fit test
estat gof, group(10)

* clasificación
estat classification, all
estat classification, cut(0.68)

*running the model and requesting odds ratios using the odds ratio option
logit irp24 $est $esc $ent $doc, or

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
