# Beyond Oil: Saudi Arabia's Economic Transformation Around Vision 2030

**Independent Economic Research | Saudi Arabia | 2000–2025**

**Author:** lana Alharbi
**Michigan State University | Statistics**

[**Read the Complete Research Paper**](Beyond_Oil_Final_Research_Paper.md)

## Project Overview

This independent research study examines Saudi Arabia's economic transformation around the introduction of Vision 2030 in 2016.

Using World Bank economic data and statistical programming in R, the project investigates changes in oil rents, GDP growth, manufacturing, services, foreign direct investment, and unemployment.

The research combines data analysis, statistical modeling, and visualization to examine patterns associated with economic diversification.

**Research scope:** Completed descriptive economic study. The findings do not establish the causal impact of Vision 2030.

## Key Research Findings

The analysis compares average annual economic indicators before and after the introduction of Vision 2030.

| Economic Indicator                | 2000–2015 | 2017–2025 |
| --------------------------------- | --------: | --------: |
| GDP Growth                        |     4.54% |     3.16% |
| Oil Rents (% GDP)                 |    41.50% |  23.14%\* |
| Manufacturing (% GDP)             |    10.11% |    14.37% |
| Services (% GDP)                  |    38.62% |    47.52% |
| Foreign Direct Investment (% GDP) |     0.46% |     1.47% |

*The post-launch oil-rents average covers 2017–2021 because later observations were unavailable in the dataset.*

### Main Observations

- Average oil rents as a percentage of GDP were lower in the available post-launch observations.
- Manufacturing and services accounted for larger average shares of GDP in the later period.
- Foreign direct investment inflows were higher on average relative to GDP.
- Average annual GDP growth was lower in the later period.
- These patterns document economic changes but do not establish their causes.

## Statistical Analysis

A linear regression model was estimated to examine the historical relationship between oil rents and GDP growth.

**Model:** GDP Growth = β₀ + β₁(Oil Rents % GDP) + ε

| Regression Metric     | Result |
| --------------------- | -----: |
| Observations          |     22 |
| Oil Rents Coefficient | 0.1732 |
| P-value               | 0.0095 |
| R²                    | 0.2913 |

The model identifies a statistically significant positive association between oil rents and GDP growth in the observed sample.

This relationship is correlational and should not be interpreted as causal evidence.

## Economic Data Visualizations

### GDP Growth



### Oil Rents



### Manufacturing



### Services



### Foreign Direct Investment



### Unemployment



### Regression Analysis



## Research Methodology

**Data source:** World Bank World Development Indicators (WDI)

**Study period:** 2000–2025, depending on indicator availability

**Programming language:** R

**Methods:**

- Economic data collection and cleaning
- Exploratory data analysis
- Descriptive statistics
- Pre/post period comparisons
- Ordinary least squares regression
- Economic data visualization

The research uses annual observations and compares 2000–2015 with 2017–2025, excluding the 2016 launch year.

## Repository Contents

| File                                                          | Description                                                   |
| ------------------------------------------------------------- | ------------------------------------------------------------- |
| [Complete Research Paper](Beyond_Oil_Final_Research_Paper.md) | Full study, methodology, findings, discussion, and references |
| [R Analysis Script](Beyond_Oil_Clean_Full_Project.R)          | Statistical programming and analysis                          |
| [World Bank Dataset](01_world_bank_saudi_data.csv)            | Economic indicators                                           |
| [Data Coverage](02_data_coverage.csv)                         | Indicator availability                                        |
| [Summary Statistics](03_summary.csv)                          | Descriptive statistics                                        |
| [Period Comparison](04_comparison.csv)                        | Before-and-after economic comparisons                         |

Seven additional PNG files contain the project's economic visualizations.

## Research Limitations

This is a descriptive economic study rather than a causal policy evaluation.

Oil rents do not directly measure non-oil GDP, and changes in economic indicators may reflect oil prices, international economic conditions, domestic policy, and other factors.

The analysis therefore documents economic patterns without attributing those changes exclusively to Vision 2030.

## Data Sources

- [World Bank — World Development Indicators](https://databank.worldbank.org/source/world-development-indicators)
- [Saudi General Authority for Statistics](https://www.stats.gov.sa/)
- [Saudi Central Bank](https://www.sama.gov.sa/)
- [Saudi Vision 2030](https://www.vision2030.gov.sa/)

The statistical dataset analyzed in this study was obtained from the World Bank. The other websites are additional institutional references.

---

**Research by Alana Alharbi | Michigan State University | November 2026**

*An independent undergraduate research project demonstrating statistical programming, quantitative analysis, economic research, and data visualization.*
