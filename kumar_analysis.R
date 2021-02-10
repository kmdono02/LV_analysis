library(readxl)
library(tidyverse)
library(formula.tools)
library(car)
library(gridGraphics)

# Load data
kumar_data <- read_excel("SA_sMRI_LV_beh_2018-04-12masterspreadsheetPK.xlsx")
kumar_data <- kumar_data %>% 
  filter(LV_analys_v2==1) %>%
  mutate(SA_DX_LV_v2=factor(SA_DX_LV_v2) %>%
           relevel(ref="TD"),
         log_LV_tot_vol=log(`LV_tot_vol_(cm3)`),
         log_LV_LatIndex=log(LV_LatIndex)) %>% 
  select(SA_DX_LV_v2, `LV_tot_vol_(cm3)`, LV_LatIndex, log_LV_tot_vol, log_LV_LatIndex, `TCV_(cm3)`, `Age_(years)`,
         vinelandii_abcomp_ss, vinelandii_comm_ss, vinelandii_dls_ss, vinelandii_motor_ss, 
         dasii_sa_gca_stand, dasii_sa_snc_stand)

# Center continous variables
kumar_data_center <- kumar_data
kumar_data_center[, -1] <- lapply(kumar_data_center[, -1], function(x){scale(x, scale=FALSE)})

## Regression analyses
# Analysis function
lm_analysis_fn <- function(frmla){
  output <- list()
  fit <- lm(frmla, kumar_data_center)
  output[["Model_name"]] <- gsub("`","",paste(formula.tools::get.vars(frmla)[1], formula.tools::get.vars(frmla)[2], sep="_by_"))
  output[["Parameter_estimates"]] <- summary(fit)$coefficients
  output[["Type_III_results"]] <- Anova(fit, type="III", test.statistic = "F")
  output[["Fitted_values_residuals"]] <- data.frame("Fitted_values"=fit$fitted.values, 
                                                    "Residuals"=fit$residuals)
  
  residual_dataset <- data.frame("fitted_vals"=fit$fitted.values, 
                                 "residuals"=fit$residuals)
  ggplot(data=residual_dataset, 
         mapping=aes(x=fitted_vals, y=residuals))+
    geom_point()+
    ggtitle(paste(output[["Model_name"]],
                      ":\nFitted value by residual scatterplot",
                      sep=""))

  output[["Fitted_values_residuals_plot"]] <- 
    ggplot(data=residual_dataset, 
           mapping=aes(x=fitted_vals, y=residuals))+
      geom_point()+
      ggtitle(paste(output[["Model_name"]],
                    ":\nFitted value by residual scatterplot",
                    sep=""))

  output[["Residuals_QQ_plot"]] <- 
    ggplot(data=residual_dataset, 
           mapping=aes(sample=residuals))+
    geom_qq()+
    geom_qq_line()+
    ggtitle(paste(output[["Model_name"]],":\nQQ plot of residuals", 
                  sep=""))
  return(output)
}

untransformed_models <- list(`LV_tot_vol_(cm3)`~`TCV_(cm3)`+`Age_(years)`+SA_DX_LV_v2+SA_DX_LV_v2*`TCV_(cm3)`+
                               SA_DX_LV_v2*`Age_(years)`,
                             LV_LatIndex~`TCV_(cm3)`+`Age_(years)`+SA_DX_LV_v2+SA_DX_LV_v2*`TCV_(cm3)`+
                               SA_DX_LV_v2*`Age_(years)`,
                             `LV_tot_vol_(cm3)`~vinelandii_comm_ss+`TCV_(cm3)`,
                             `LV_tot_vol_(cm3)`~vinelandii_dls_ss+`TCV_(cm3)`,
                             `LV_tot_vol_(cm3)`~vinelandii_motor_ss+`TCV_(cm3)`,
                             `LV_tot_vol_(cm3)`~dasii_sa_gca_stand+`TCV_(cm3)`,
                             `LV_tot_vol_(cm3)`~dasii_sa_snc_stand+`TCV_(cm3)`)
untransformed_output <- lapply(untransformed_models, lm_analysis_fn)

transformed_models <- list(log_LV_tot_vol~`TCV_(cm3)`+`Age_(years)`+SA_DX_LV_v2+SA_DX_LV_v2*`TCV_(cm3)`+
                             SA_DX_LV_v2*`Age_(years)`,
                           log_LV_tot_vol~`TCV_(cm3)`+`Age_(years)`+SA_DX_LV_v2+SA_DX_LV_v2*`TCV_(cm3)`+
                             SA_DX_LV_v2*`Age_(years)`,
                           log_LV_tot_vol~vinelandii_comm_ss+`TCV_(cm3)`,
                           log_LV_tot_vol~vinelandii_dls_ss+`TCV_(cm3)`,
                           log_LV_tot_vol~vinelandii_motor_ss+`TCV_(cm3)`,
                           log_LV_tot_vol~dasii_sa_gca_stand+`TCV_(cm3)`,
                           log_LV_tot_vol~dasii_sa_snc_stand+`TCV_(cm3)`)
transformed_output <- lapply(transformed_models, lm_analysis_fn)

  
