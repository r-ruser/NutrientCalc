#' Split Nutrients
#'
#' @param df Data frame (nutrients_all)
#' @param output_csv_path Optional path to save CSV
#' @return List containing nut1 and nut2
#' @export
split_nutrients <- function(df, output_csv_path = NULL) {
  nutrient_start <- match("water", names(df))
  if (is.na(nutrient_start)) {
    stop("Cannot find nutrient start column 'water'.")
  }

  nutrients_all <- df %>% dplyr::select(`hospitalization number`, nutrient_start:ncol(df))

  if (!is.null(output_csv_path)) {
    write.csv(nutrients_all,
              output_csv_path,
              row.names = FALSE,
              fileEncoding = "UTF-8")
  }

  micronutrient_start <- match("total_vitamin_A", names(nutrients_all))
  if (is.na(micronutrient_start)) {
    micronutrient_start <- 2
  }

  nut2 <- nutrients_all %>%
    select(`hospitalization number`, micronutrient_start:ncol(nutrients_all))
  nut1 <- nutrients_all %>%
    select(`hospitalization number`, 2:(micronutrient_start - 1))

  return(list(nut1 = nut1, nut2 = nut2))
}
