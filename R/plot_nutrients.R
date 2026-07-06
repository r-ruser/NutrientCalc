#' Plot Nutrients
#'
#' @param df Data frame from calculate_nutrients
#' @return ggplot object
#' @export
plot_nutrients <- function(df) {
  nutrients_all <- df %>%
    select(`hospitalization number`, 673:ncol(df))

  nutrients <- nutrients_all %>%
    select((ncol(nutrients_all) - 25):ncol(nutrients_all))

  var_order <- colnames(nutrients)

  nutrients_long <- nutrients %>%
    pivot_longer(
      cols = everything(),
      names_to = "variable",
      values_to = "value"
    ) %>%
    mutate(variable = factor(variable, levels = var_order))

  ggplot(nutrients_long, aes(x = variable, y = value)) +
    geom_boxplot(outlier.size = 1) +
    scale_y_log10() +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 60, hjust = 1, size = 9),
      plot.title = element_text(size = 14, face = "bold")
    ) +
    labs(
      title = "Boxplot of Nutrients (log10 scale)",
      x = "Nutrient",
      y = "log10(Value)"
    )
}
