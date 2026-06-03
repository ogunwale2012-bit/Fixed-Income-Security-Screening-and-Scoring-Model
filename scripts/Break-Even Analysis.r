# ============================================
# SCRIPT 03 — BREAK-EVEN ANALYSIS
# Evaluates existing holdings under current
# market conditions and generates Hold/Sell
# guidance based on opportunity cost and
# reinvestment analysis.
#
# Reads from:  Fixed Income - Master Watchlist
# Writes to:   Break-Even Analysis
# ============================================

...

# ============================================
# BREAK-EVEN ANALYSIS CALCULATIONS
# ============================================

breakeven_analysis <- holdings %>%
  mutate(

    Years_Remaining = round(Years_To_Maturity, 2),

    # -----------------------------------------------
    # RATE DELTA
    # Difference between current benchmark yield
    # and bond coupon rate
    # -----------------------------------------------
    Rate_Delta = round(Benchmark_Rate - Coupon_Numeric, 4),

    # -----------------------------------------------
    # OPPORTUNITY COST
    # Additional yield available from comparable
    # securities in the current market
    # -----------------------------------------------
    Annual_Opportunity_Cost_pct = round(Rate_Delta, 4),
    Total_Opportunity_Cost_pct  = round(Rate_Delta * Years_Remaining, 4),

    # -----------------------------------------------
    # ESTIMATED MARKET PRICE
    # Simplified duration-based approximation of
    # current market value
    # -----------------------------------------------
    Estimated_Market_Price = round(
      Purchase_Price * (1 - (Rate_Delta * Years_Remaining) / 100),
      2
    ),

    # -----------------------------------------------
    # ESTIMATED GAIN / LOSS
    # Approximate unrealized gain or loss if
    # position is sold at current market value
    # -----------------------------------------------
    Estimated_Gain_Loss_pct = round(
      ((Estimated_Market_Price - Purchase_Price) / Purchase_Price) * 100,
      2
    ),

    Estimated_Gain_Loss_Label = case_when(
      Estimated_Gain_Loss_pct > 0  ~ paste0(
        "+", round(Estimated_Gain_Loss_pct, 2), "% — Capital Gain"
      ),
      Estimated_Gain_Loss_pct < 0  ~ paste0(
        round(Estimated_Gain_Loss_pct, 2), "% — Capital Loss"
      ),
      TRUE ~ "At Par — No Gain or Loss"
    ),

    # -----------------------------------------------
    # REINVESTMENT ANALYSIS
    # Potential incremental yield from reallocating
    # into current market alternatives
    # -----------------------------------------------
    Annual_Reinvestment_Gain_pct = round(Rate_Delta, 4),
    Total_Reinvestment_Gain_pct  = round(Rate_Delta * Years_Remaining, 4),

    # -----------------------------------------------
    # BREAK-EVEN ANALYSIS
    # Estimated time required for reinvestment
    # benefits to offset any realized loss on sale
    # -----------------------------------------------
    Break_Even_Years = case_when(
      Rate_Delta <= 0               ~ NA_real_,
      Annual_Reinvestment_Gain_pct == 0 ~ NA_real_,
      TRUE ~ round(
        abs(Estimated_Gain_Loss_pct) / Annual_Reinvestment_Gain_pct,
        2
      )
    ),

    Break_Even_Label = case_when(
      is.na(Break_Even_Years) ~ "N/A — No Loss to Recover",
      Break_Even_Years > Years_Remaining ~ paste0(
        round(Break_Even_Years, 1),
        " yrs — Exceeds remaining maturity of ",
        Years_Remaining, " yrs. Hold to maturity."
      ),
      TRUE ~ paste0(
        round(Break_Even_Years, 1),
        " yrs — Within remaining maturity of ",
        Years_Remaining, " yrs. Selling may be justified."
      )
    ),

    # -----------------------------------------------
    # RATE ENVIRONMENT ASSESSMENT
    # Summary of current market conditions relative
    # to the bond's coupon rate
    # -----------------------------------------------
    Rate_Environment = case_when(
      Rate_Delta <= -0.5 ~ "Rates Fell — Bond at Premium",
      Rate_Delta <=  0.2 ~ "Rates Flat — No Action Needed",
      Rate_Delta <=  0.5 ~ "Rates Rose Moderately",
      Rate_Delta >   0.5 ~ "Rates Rose Significantly",
      TRUE               ~ "Review"
    ),

    # -----------------------------------------------
    # HOLD / SELL RECOMMENDATION
    # Generated using break-even analysis and
    # current market conditions
    # -----------------------------------------------
    Hold_Sell_Signal = case_when(

      Rate_Delta <= -0.5 ~
        "Hold or Sell at Premium — Rates Fell Since Purchase",

      Rate_Delta <=  0.2 ~
        "Hold — Rate Environment Unchanged",

      Rate_Delta >   0.2 & !is.na(Break_Even_Years) &
        Break_Even_Years > Years_Remaining ~
        "Hold to Maturity — Break-Even Exceeds Remaining Life",

      Rate_Delta >   0.2 & !is.na(Break_Even_Years) &
        Break_Even_Years <= Years_Remaining ~
        "Consider Selling — Break-Even Achievable Before Maturity",

      TRUE ~ "Review Manually"
    ),

    # -----------------------------------------------
    # ANALYSIS NOTES
    # summary of the holding review
    # -----------------------------------------------