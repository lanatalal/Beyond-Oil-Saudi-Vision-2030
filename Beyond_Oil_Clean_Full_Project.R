# BEYOND OIL: SAUDI ARABIA AND VISION 2030
# COMPLETE R SCRIPT - Run the entire file using Source in RStudio.
# Internet connection is required. No placeholders appear in this file.

# 1. INSTALL AND LOAD THE ONLY REQUIRED PACKAGE
if (!requireNamespace("WDI", quietly = TRUE)) {
  install.packages("WDI", repos = "https://cloud.r-project.org",
                   type = "binary")
}
if (!requireNamespace("WDI", quietly = TRUE)) {
  stop("WDI could not be installed. Check your internet connection.")
}

# 2. CREATE OUTPUT FOLDER
output_folder <- file.path(getwd(), "Beyond_Oil_Results")
dir.create(output_folder, showWarnings = FALSE, recursive = TRUE)
cat("Saving results to:", output_folder, "\n")

# 3. DOWNLOAD VERIFIED WORLD BANK INDICATORS
indicators <- c(
  gdp_growth = "NY.GDP.MKTP.KD.ZG",
  gdp_usd = "NY.GDP.MKTP.CD",
  gdp_per_capita_usd = "NY.GDP.PCAP.CD",
  oil_rents_pct = "NY.GDP.PETR.RT.ZS",
  fdi_pct = "BX.KLT.DINV.WD.GD.ZS",
  unemployment_pct = "SL.UEM.TOTL.ZS",
  exports_pct = "NE.EXP.GNFS.ZS",
  manufacturing_pct = "NV.IND.MANF.ZS",
  services_pct = "NV.SRV.TOTL.ZS"
)

saudi <- tryCatch(
  WDI::WDI(country = "SAU", indicator = indicators,
           start = 2000, end = 2025, extra = FALSE),
  error = function(e) {
    stop(paste("World Bank download failed:", conditionMessage(e)))
  }
)
if (nrow(saudi) == 0) stop("World Bank returned no rows.")
saudi <- saudi[order(saudi$year), c("year", names(indicators))]
row.names(saudi) <- NULL
write.csv(saudi, file.path(output_folder, "01_saudi_data.csv"),
          row.names = FALSE)
cat("\nDATA DOWNLOADED. First rows:\n")
print(head(saudi))

# 4. DATA COVERAGE
coverage <- data.frame(
  indicator = names(indicators),
  observations = sapply(saudi[names(indicators)],
                        function(x) sum(!is.na(x))),
  first_year = sapply(saudi[names(indicators)], function(x) {
    yrs <- saudi$year[!is.na(x)]
    if (length(yrs) == 0) return(NA_integer_)
    min(yrs)
  }),
  last_year = sapply(saudi[names(indicators)], function(x) {
    yrs <- saudi$year[!is.na(x)]
    if (length(yrs) == 0) return(NA_integer_)
    max(yrs)
  }),
  row.names = NULL
)
write.csv(coverage, file.path(output_folder, "02_data_coverage.csv"),
          row.names = FALSE)
print(coverage)

# 5. SUMMARY STATISTICS
safe_mean <- function(x) {
  if (all(is.na(x))) return(NA_real_)
  mean(x, na.rm = TRUE)
}
safe_sd <- function(x) {
  if (sum(!is.na(x)) < 2) return(NA_real_)
  sd(x, na.rm = TRUE)
}
summary_table <- data.frame(
  indicator = names(indicators),
  n = sapply(saudi[names(indicators)], function(x) sum(!is.na(x))),
  mean = sapply(saudi[names(indicators)], safe_mean),
  sd = sapply(saudi[names(indicators)], safe_sd),
  row.names = NULL
)
write.csv(summary_table, file.path(output_folder, "03_summary.csv"),
          row.names = FALSE)
print(summary_table)

# 6. BEFORE AND AFTER VISION 2030 LAUNCH
# 2016 excluded as transition year. Descriptive, NOT causal.
pre <- saudi[saudi$year < 2016, ]
post <- saudi[saudi$year > 2016, ]
comparison <- data.frame(
  period = c("2000-2015", "2017-2025"),
  years = c(nrow(pre), nrow(post)),
  avg_gdp_growth = c(safe_mean(pre$gdp_growth),
                     safe_mean(post$gdp_growth)),
  avg_oil_rents_pct = c(safe_mean(pre$oil_rents_pct),
                        safe_mean(post$oil_rents_pct)),
  avg_manufacturing_pct = c(safe_mean(pre$manufacturing_pct),
                            safe_mean(post$manufacturing_pct)),
  avg_services_pct = c(safe_mean(pre$services_pct),
                       safe_mean(post$services_pct)),
  avg_fdi_pct = c(safe_mean(pre$fdi_pct),
                  safe_mean(post$fdi_pct))
)
write.csv(comparison, file.path(output_folder, "04_comparison.csv"),
          row.names = FALSE)
print(comparison)

# 7. SAVE SIX CHARTS AS PNG FILES
plot_indicator <- function(column, title, ylabel, filename) {
  x <- saudi$year
  y <- saudi[[column]]
  good <- is.finite(x) & is.finite(y)
  if (sum(good) < 2) {
    cat("Skipping", title, "- insufficient data\n")
    return(invisible(NULL))
  }
  png(file.path(output_folder, filename),
      width = 1100, height = 650, res = 130)
  par(mar = c(5, 5, 5, 2))
  plot(x[good], y[good], type = "o", pch = 16,
       col = "#165A72", lwd = 2,
       main = title, xlab = "Year", ylab = ylabel)
  abline(v = 2016, col = "#B34A35", lty = 2, lwd = 2)
  mtext("Dashed line = Vision 2030 launch (2016)",
        side = 3, line = 0.4, cex = 0.8)
  mtext("Source: World Bank WDI", side = 1,
        line = 3.5, cex = 0.75)
  dev.off()
}
plot_indicator("gdp_growth", "Saudi Arabia: Real GDP Growth",
               "Annual growth (%)", "05_gdp_growth.png")
plot_indicator("oil_rents_pct", "Saudi Arabia: Oil Rents",
               "Oil rents (% of GDP)", "06_oil_rents.png")
plot_indicator("manufacturing_pct", "Manufacturing Value Added",
               "Manufacturing (% of GDP)", "07_manufacturing.png")
plot_indicator("services_pct", "Services Value Added",
               "Services (% of GDP)", "08_services.png")
plot_indicator("fdi_pct", "Foreign Direct Investment Inflows",
               "FDI net inflows (% of GDP)", "09_fdi.png")
plot_indicator("unemployment_pct", "Unemployment (ILO Modeled)",
               "Unemployment (% of labor force)", "10_unemployment.png")

# 8. REGRESSION: ASSOCIATION, NOT CAUSATION
regression_data <- saudi[
  is.finite(saudi$gdp_growth) & is.finite(saudi$oil_rents_pct),
  c("year", "gdp_growth", "oil_rents_pct")
]
regression_text <- "Insufficient observations for regression."
if (nrow(regression_data) >= 5 &&
    length(unique(regression_data$oil_rents_pct)) >= 2) {
  model <- lm(gdp_growth ~ oil_rents_pct, data = regression_data)
  regression_text <- capture.output(summary(model))
  writeLines(regression_text,
             file.path(output_folder, "11_regression_results.txt"))
  png(file.path(output_folder, "12_regression_chart.png"),
      width = 1100, height = 650, res = 130)
  plot(regression_data$oil_rents_pct,
       regression_data$gdp_growth,
       pch = 16, col = "#165A72",
       xlab = "Oil rents (% of GDP)",
       ylab = "Real GDP growth (%)",
       main = "Oil Rents and GDP Growth: Descriptive Association")
  abline(model, col = "#B34A35", lwd = 2)
  mtext("Source: World Bank WDI. Correlation does not imply causation.",
        side = 1, line = 3.5, cex = 0.75)
  dev.off()
} else {
  writeLines(regression_text,
             file.path(output_folder, "11_regression_results.txt"))
}
cat("\nREGRESSION:\n")
cat(paste(regression_text, collapse = "\n"), "\n")

# 9. CREATE RESEARCH REPORT DRAFT
format_num <- function(x) {
  if (length(x) == 0 || is.na(x)) return("not available")
  sprintf("%.2f", x)
}
report <- c(
  "# Beyond Oil: Saudi Arabia's Economic Transformation Under Vision 2030",
  "",
  "RESEARCH DRAFT - NOT YET READY FOR PUBLICATION",
  paste("Generated:", Sys.Date()),
  "",
  "## Research question",
  "How have selected indicators of Saudi Arabia's economy changed around the launch of Vision 2030?",
  "",
  "## Data and methods",
  "World Bank World Development Indicators, requested for 2000-2025.",
  "Missing observations are retained as missing; actual coverage varies by series.",
  "We compare pre-launch (2000-2015) and post-launch (2017-2025) averages.",
  "The launch year 2016 is excluded from the two period averages.",
  "A simple regression examines the association between oil rents and real GDP growth.",
  "",
  "## Descriptive results",
  paste("Average GDP growth before launch:",
        format_num(comparison$avg_gdp_growth[1]), "%"),
  paste("Average GDP growth after launch:",
        format_num(comparison$avg_gdp_growth[2]), "%"),
  paste("Average oil rents before launch:",
        format_num(comparison$avg_oil_rents_pct[1]), "% of GDP"),
  paste("Average oil rents after launch:",
        format_num(comparison$avg_oil_rents_pct[2]), "% of GDP"),
  paste("Average manufacturing share before launch:",
        format_num(comparison$avg_manufacturing_pct[1]), "%"),
  paste("Average manufacturing share after launch:",
        format_num(comparison$avg_manufacturing_pct[2]), "%"),
  paste("Average services share before launch:",
        format_num(comparison$avg_services_pct[1]), "%"),
  paste("Average services share after launch:",
        format_num(comparison$avg_services_pct[2]), "%"),
  "",
  "## Interpretation and limitations",
  "These figures are descriptive; they do not prove Vision 2030 caused changes.",
  "Oil rents are NOT the oil sector's GDP share and are NOT non-oil GDP.",
  "Manufacturing and services shares do not capture the entire non-oil economy.",
  "The unemployment series is an ILO modeled estimate, not Saudi-only unemployment.",
  "Annual data can reflect oil prices, global shocks, and other policy changes.",
  "GDP shares may change because the denominator changes.",
  "",
  "## Before publication",
  "Add official GASTAT real oil and non-oil GDP series.",
  "Verify all indicators, data coverage, units, and interpretation.",
  "Write a reviewed discussion and conclusion based on the results.",
  "",
  "## Sources",
  "World Bank WDI: https://databank.worldbank.org/source/world-development-indicators",
  "GASTAT: https://www.stats.gov.sa/",
  "SAMA: https://www.sama.gov.sa/",
  "Vision 2030: https://www.vision2030.gov.sa/"
)
writeLines(report, file.path(output_folder, "13_research_report_DRAFT.md"))

# 10. FINISHED
cat("\nSUCCESS: Project finished.\n")
cat("Your output folder is:\n", output_folder, "\n")
cat("Open 13_research_report_DRAFT.md to see the draft report.\n")
