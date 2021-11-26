#Building mixed-effect model and running ANOVA to look at linkage between methylation and co-variates. Output is p-value and q-value (p-value adjusted for multiple testing using Benjamini-Hochberg method) for each position.

#Example data
#First column is sample ID, next four columns are covariates - then each subsequent column is percentage methylation at each cystosine (position is column heading)
#Sample	Individual	Age	Sex	Tissue	4	6	8	9	11
#A1	1	82	1	STG	0	0	0.985221675	0.436681223	0
#A2	2	81	1	STG	0	1.492537313	0.564971751	0.975609756	0
#A3	3	80	1	STG	1.19047619	1.754385965	1.799485861	0.650759219	1.351351351
#A5	5	86	0	STG	0	0.925925926	1.160092807	1.026694045	0
#A6	6	87	1	STG	0	0.917431193	0.340136054	0.573065903	2.205882353
#A7	7	81	0	STG	0	2.312138728	0.877192982	0.751879699	0.454545455
#A8	8	77	0	STG	0	0.675675676	0.301204819	0.533333333	0
#B1	1	82	1	CER	0	0.952380952	1.840490798	0.544959128	0
#B2	2	81	1	CER	1.886792453	0	0.737463127	1.248439451	0.675675676
#B3	3	80	1	CER	4.347826087	2.173913043	1.194029851	0.536193029	0.833333333
#B5	5	86	0	CER	0	0.497512438	0.850340136	0.91047041	1.265822785
#B6	6	87	1	CER	0	0	1.149425287	0.515463918	1.388888889
#B7	7	81	0	CER	0	1.19760479	0.892857143	1.5625	2.358490566
#B8	8	77	0	CER	0	1.587301587	1.310043668	0.754716981	2.53164557

library(lme4)
#Effect of Sex
#assign function to output p-value of effect of sex on methylation at given position
sex_anova <- function(position){
  fm1 <- as.formula(paste(position, "~", "Age + Sex + Tissue + (1|Individual)"))
  fm0 <- as.formula(paste(position, "~", "Age + Tissue + (1|Individual)"))
  model1 = lmer(fm1, data=methylation, REML=FALSE)
  model0 = lmer(fm0, data=methylation, REML=FALSE)
  an <- anova(model0,model1)
  p <- an$`Pr(>Chisq)`[2]
  return(p)
}
#loop sex anova
p<-NULL
n<-NULL
for(i in 6:7179){
  p <- c(p,sex_anova(colnames(methylation[i])))
  n <- c(n,colnames(methylation[i]))
}
#join columns together
sex_anova_results <- data.frame(n,p)
#add q-value column
sex_anova_results$q <- p.adjust(sex_anova_results$p, method = "BH")

#Effect of Tissue
#assign function to output p-value of effect of tissue on methylation at given position
tissue_anova <- function(position){
  fm1 <- as.formula(paste(position, "~", "Age + Sex + Tissue + (1|Individual)"))
  fm0 <- as.formula(paste(position, "~", "Age + Sex + (1|Individual)"))
  model1 = lmer(fm1, data=methylation, REML=FALSE)
  model0 = lmer(fm0, data=methylation, REML=FALSE)
  an <- anova(model0,model1)
  p <- an$`Pr(>Chisq)`[2]
  return(p)
}
#loop tissue anova
p<-NULL
n<-NULL
for(i in 6:7179){
  p <- c(p,tissue_anova(colnames(methylation[i])))
  n <- c(n,colnames(methylation[i]))
}
#join columns together
tissue_anova_results <- data.frame(n,p)
#add q-value column
tissue_anova_results$q <- p.adjust(tissue_anova_results$p, method = "BH")

#Effect of age
#assign function to output P-value of effect of age on methylation at given position
age_anova <- function(position){
  fm1 <- as.formula(paste(position, "~", "Age + Sex + Tissue + (1|Individual)"))
  fm0 <- as.formula(paste(position, "~", "Sex + Tissue + (1|Individual)"))
  model1 = lmer(fm1, data=methylation, REML=FALSE)
  model0 = lmer(fm0, data=methylation, REML=FALSE)
  an <- anova(model0,model1)
  p <- an$`Pr(>Chisq)`[2]
  return(p)
}
#loop age anova
p<-NULL
n<-NULL
for(i in 6:7179){
  p <- c(p,age_anova(colnames(methylation[i])))
  n <- c(n,colnames(methylation[i]))
}
#join columns together
age_anova_results <- data.frame(n,p)
#add q-value column
age_anova_results$q <- p.adjust(age_anova_results$p, method = "BH")

#Generate correlation coefficient between age and methylation at each position
p<-NULL
n<-NULL
for(i in 6:7179){
  cr <-cor.test(methylation$Age,methylation[,i],method = "pearson")
  n <- c(n,colnames(methylation[i]))
  p<- c(p,cr$estimate)
}
age_correlation_results <- data.frame(n,p)
age_correlation_results <- data.frame(n,p)