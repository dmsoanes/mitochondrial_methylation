<h1>Using a linear mixed-effect model to look at linkage between co-variates and methylation</h1>

<b>R package:</b> lme4 https://cran.r-project.org/web/packages/lme4/index.html<br><br>

This model used each of the covariates of interest (age, sex and tissue) as fixed effects and the individual as the random effect. To determine the significance of each covariate in isolation, a second (null) model was fitted, which didn’t contain the covariate of interest. An analysis of variance (ANOVA) was then performed between the two models to identify significantly differentially methylated bases for each covariate using lme4. Nominal significance was deemed to be when p-value < 0.05 and to control for the effects of multiple testing, a Benjamani-Hochberg (BH) correction was applied to generate q-values.<br><br>
The R script used in this study can be found [here](lme4.r).
