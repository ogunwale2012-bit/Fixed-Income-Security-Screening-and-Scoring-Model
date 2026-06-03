# Fixed Income Portfolio Screening and Monitoring Model

## Overview

This project builds an automated fixed income portfolio screening and monitoring model in R that evaluates both newly issued bonds and existing holdings against prevailing U.S. interest rate benchmarks.

The model ingests new bond issues from Fidelity, benchmarks each security against the appropriate Treasury yield based on its maturity profile, calculates yield spreads, evaluates credit risk, and generates a composite investment score. Based on the results, securities receive Buy, Hold, Review, Sell, or Avoid recommendations.

For existing holdings, the model evaluates whether a position remains attractive under current market conditions by comparing the bond's coupon rate, maturity profile, and credit quality against comparable newly issued securities.

The objective is to provide a consistent, rules-based framework for fixed income security selection, portfolio monitoring, and reinvestment decision-making.

---

## Project Objective

The model systematically evaluates fixed income securities across key investment criteria including:

* Yield attractiveness relative to Treasury benchmarks
* Credit quality
* Duration exposure and interest rate sensitivity
* Call protection
* Relative value versus current market alternatives
* Existing holding review and reinvestment analysis

---

## Data Sources

### Fidelity New Issues (CSV)

New bond issue data including:

* Security description
* Coupon rate and coupon frequency
* Maturity date
* Call protection status
* Credit rating (Moody's)

### Federal Reserve Economic Data (FRED)

U.S. interest rate benchmarks retrieved via the FRED API, including:

* Federal Funds Rate
* Secured Overnight Financing Rate (SOFR)
* 1-Year Treasury Yield
* 2-Year Treasury Yield
* 5-Year Treasury Yield
* 10-Year Treasury Yield
* Consumer Price Index (CPI)

---

## How the Model Works

### Step 1 — Duration Bucketing

Each bond is assigned to a maturity bucket based on years remaining to maturity:

| Duration Bucket | Years to Maturity |
| --------------- | ----------------- |
| 0–1 Year        | ≤ 1 year          |
| 1–3 Years       | 1–3 years         |
| 3–5 Years       | 3–5 years         |
| 5+ Years        | Over 5 years      |

### Step 2 — Treasury Benchmark Matching

Each maturity bucket is matched to the appropriate Treasury benchmark rate pulled live from FRED:

| Duration Bucket | Benchmark              |
| --------------- | ---------------------- |
| 0–1 Year        | 1-Year Treasury Yield  |
| 1–3 Years       | 2-Year Treasury Yield  |
| 3–5 Years       | 5-Year Treasury Yield  |
| 5+ Years        | 10-Year Treasury Yield |

### Step 3 — Yield Spread Analysis

Yield spread is calculated as:

```text
Yield Spread = Coupon Rate − Treasury Benchmark Yield
```

The model evaluates whether the bond provides sufficient compensation above the risk-free Treasury rate for its maturity profile.

### Step 4 — Credit Risk Assessment

Moody's credit ratings are mapped into risk categories and incorporated into the scoring framework.

### Step 5 — Composite Scoring

Each bond receives a composite score based on:

* Yield spread attractiveness
* Credit quality
* Call protection
* Duration risk relative to yield compensation

### Step 6 — Investment Recommendation

Based on the composite score, the model generates one of the following recommendations:

| Score | Recommendation |
| ----- | -------------- |
| ≥ 6   | Strong Buy     |
| ≥ 4   | Good Candidate |
| ≥ 2   | Review         |
| < 2   | Avoid          |

### Step 7 — Existing Holding Review (Hold vs Sell)

For securities flagged as existing holdings, the model evaluates whether the position remains attractive relative to current market conditions.

The analysis compares:

* Current coupon rate
* Remaining maturity
* Credit quality
* Current Treasury benchmark
* Comparable newly issued alternatives

The model estimates the trade-off between continuing to hold the security and selling to reinvest into higher-yielding opportunities.

#### Hold vs Sell Framework

| Condition                                       | Signal                            |
| ----------------------------------------------- | --------------------------------- |
| Coupon materially above comparable market rates | Hold / Potential Premium Sale     |
| Coupon broadly in line with market rates        | Hold                              |
| Coupon moderately below market rates            | Review                            |
| Coupon significantly below market rates         | Evaluate Reinvestment Opportunity |

#### Break-Even Analysis

For each existing holding, the model calculates:

* Rate Delta versus current benchmark
* Annual Opportunity Cost
* Total Opportunity Cost over remaining maturity
* Estimated break-even period for switching into a higher-yielding alternative

---

## Key Outputs

### Fixed Income Master Watchlist

* Treasury benchmark comparison
* Yield spread analysis
* Credit risk assessment
* Duration classification
* Call protection assessment
* Composite investment score
* Investment recommendation

### Holding Analysis

* Hold / Sell recommendation
* Rate delta versus benchmark
* Opportunity cost estimates
* Break-even analysis
* Reinvestment assessment

### Fixed Income Rates

Live FRED benchmark rates updated each run:

* Federal Funds Rate
* SOFR
* Treasury yields (1Y, 2Y, 5Y, 10Y)
* CPI

---

## Automation Features

* Pulls live Treasury benchmark rates from FRED via API
* Reads new bond issue data from Fidelity CSV downloads
* Preserves existing holdings during monthly refreshes
* Highlights newly added securities in the output workbook
* Performs Hold / Sell analysis for existing positions
* Writes all results to a master Excel workbook

---

## Tools & Technologies

* R
* Federal Reserve Economic Data (FRED) API
* Fidelity Fixed Income Data
* dplyr
* openxlsx
* httr2
* jsonlite
* Git & GitHub

---

## Repository Structure

```text
Fixed-Income-Screening-Model/
│
├── data/
├── scripts/
├── outputs/
└── README.md
```

---

## Disclaimer

This project is intended for educational and research purposes only and does not constitute financial or investment advice. Investors should conduct their own due diligence and consult qualified financial professionals before making investment decisions.
