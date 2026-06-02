# Automated Fixed Income Security Screening and Scoring Model

## Overview

This project builds an automated fixed income screening and scoring model in R that evaluates newly issued bonds against prevailing U.S. interest rate benchmarks to support fixed income investment analysis.

The model ingests new bond issues from Fidelity, benchmarks each security against the appropriate Treasury yield based on its maturity profile, calculates yield spreads, evaluates credit risk, and generates a composite investment score. Based on the total score, each security receives a recommendation ranging from **Strong Buy** to **Avoid**.

The objective is to provide a consistent, rules-based framework for screening fixed income securities and identifying attractive investment opportunities.

---

## Project Objective

The model systematically evaluates fixed income securities across key investment criteria including:

* Yield attractiveness
* Credit quality
* Duration exposure
* Call protection

The goal is to support investment screening through an automated scoring framework that reduces manual review and improves consistency in security selection.

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

### Step 1 – Duration Bucketing

Each bond is assigned to a maturity bucket based on years remaining to maturity:

* 0–1 Year
* 1–3 Years
* 3–5 Years
* 5+ Years

### Step 2 – Treasury Benchmark Matching

Each maturity bucket is matched to an appropriate Treasury benchmark:

| Duration Bucket | Benchmark              |
| --------------- | ---------------------- |
| 0–1 Year        | 1-Year Treasury Yield  |
| 1–3 Years       | 2-Year Treasury Yield  |
| 3–5 Years       | 5-Year Treasury Yield  |
| 5+ Years        | 10-Year Treasury Yield |

### Step 3 – Yield Spread Analysis

Yield spread is calculated as:

```text
Yield Spread = Coupon Rate − Treasury Benchmark Yield
```

Spread assessment:

* ≥ 1.0% → Excellent
* ≥ 0.5% → Good
* ≥ 0.2% → Fair
* < 0.2% → Poor

### Step 4 – Credit Risk Assessment

Moody's ratings are mapped into risk categories:

| Rating    | Risk Level |
| --------- | ---------- |
| Aaa / AAA | Very Low   |
| Aa / AA   | Low        |
| A         | Low-Medium |
| Baa / BBB | Medium     |
| Ba / BB   | High       |
| B / C     | Very High  |

### Step 5 – Composite Scoring

Each bond receives a composite score based on:

* Yield spread attractiveness
* Credit quality
* Call protection
* Duration profile

| Component       | Criteria         | Score |
| --------------- | ---------------- | ----- |
| Yield Spread    | ≥ 1.0%           | +3    |
| Yield Spread    | ≥ 0.5%           | +2    |
| Yield Spread    | ≥ 0.2%           | +1    |
| Yield Spread    | < 0%             | -2    |
| Credit Rating   | Very Low / Low   | +2    |
| Credit Rating   | Low-Medium       | +1    |
| Credit Rating   | High / Very High | -2    |
| Call Protection | Yes              | +2    |
| Call Protection | No               | -2    |
| Duration        | 0–1 Year         | +2    |
| Duration        | 1–3 Years        | +1    |
| Duration        | 3+ Years         | -1    |

### Step 6 – Investment Recommendation

Final recommendations are generated based on the total composite score:

| Score | Recommendation |
| ----- | -------------- |
| ≥ 7   | Strong Buy     |
| ≥ 5   | Good Candidate |
| ≥ 3   | Review         |
| < 3   | Avoid          |

---

## Key Outputs

For each security, the model generates:

* Treasury benchmark comparison
* Yield spread analysis
* Credit risk assessment
* Duration classification
* Call protection assessment
* Composite investment score
* Investment recommendation

---

## Automation Features

* Automatically detects whether a new Fidelity bond file has been downloaded before execution
* Preserves existing holdings flagged as "Existing Holding = Yes" during monthly refreshes
* Highlights newly added securities in the output workbook
* Pulls current Treasury benchmark rates directly from FRED via API
* Writes scored securities and recommendations to a master Excel workbook

---

## Tools & Technologies

* R
* Federal Reserve Economic Data (FRED) API
* Fidelity New Issues Data
* tidyverse
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
