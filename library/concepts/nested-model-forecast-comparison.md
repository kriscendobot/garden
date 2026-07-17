---
id: nested-model-forecast-comparison
aliases: [nested-model forecast comparison, nested forecast test, Clark-West test, Clark West test, MSPE-adjusted test, MSPE adjustment, MSPE-normal, nested predictive accuracy, equal predictive accuracy in nested models]
topics: [forecast-evaluation, financial-forecasting]
---

# nested-model-forecast-comparison

The problem and correction for comparing a pre-specified parsimonious forecast with a larger model that contains it. Under the no-incremental-predictability null, the larger model's added coefficients are zero in population, yet estimating them adds noise and inflates its realized MSPE. The ordinary raw squared-loss differential is therefore miscentered, so a conventional normal Diebold-Mariano-style test is badly undersized. Clark and West add back the squared difference between fitted forecasts, then use the West (1996) fitted-forecast inference route for an adjusted one-sided statistic. This is a **pairwise nesting correction**, not a search correction: Giacomini-White compares pre-specified finite-window methods, Romano-Wolf controls post-search FWER for named beaters, SPA tests whether any searched alternative beats a benchmark, and MCS returns a benchmark-free set of survivors. The loss still fixes the claim: variance-loss evidence concerns conditional-risk forecasts; return or directional loss evidence concerns that separate target.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Nested null makes the raw MSPE difference degenerate](../sections/papers--clark-nested-predictive-accuracy-2007--nested-null-makes-raw-mspe-difference-degenerate.md) | Estimated zero coefficients make raw nested-model MSPE differences miscentered and ordinary normal inference severely conservative. |
| [MSPE adjustment and the practical one-sided test](../sections/papers--clark-nested-predictive-accuracy-2007--mspe-adjustment-and-practical-one-sided-test.md) | Add the squared fitted-forecast gap back, then test a positive adjusted mean with a horizon-appropriate standard error. |
| [West inference route and the approximately normal boundary](../sections/papers--clark-nested-predictive-accuracy-2007--west-inference-route-and-approximately-normal-boundary.md) | Normal critical values are a practical conservative approximation in stated settings, not a universal nested-test limit. |
| [Pairwise nested correction and the post-search boundary](../sections/papers--clark-nested-predictive-accuracy-2007--pairwise-nested-correction-and-post-search-boundary.md) | Nested-pair correction, finite-window method evaluation, and model-search control answer different questions. |

## See also

- [[diebold-mariano-test]]
- [[data-snooping-bias]]
- [[walk-forward-validation]]
