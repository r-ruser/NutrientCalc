#' Split Nutrients
#'
#' @param df Data frame (nutrients_all)
#' @param output_csv_path Optional path to save CSV
#' @return List containing nut1 and nut2
#' @export
split_nutrients <- function(df, output_csv_path = NULL) {
  nutrients_all <- df %>% dplyr::select(`hospitalization number`, 673:ncol(df))

  if (!is.null(output_csv_path)) {
    write.csv(nutrients_all, 
              output_csv_path, 
              row.names = FALSE, 
              fileEncoding = "UTF-8")
  }

  nut2 <- nutrients_all %>%
    select(`hospitalization number`, (ncol(nutrients_all)-25):ncol(nutrients_all))
  nut1 <- nutrients_all %>%
    select(`hospitalization number`, 2:(ncol(nutrients_all)-26))
    
  return(list(nut1 = nut1, nut2 = nut2))
}
