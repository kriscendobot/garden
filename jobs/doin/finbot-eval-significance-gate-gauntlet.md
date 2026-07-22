Repository: kriscendobot/finbot. Branch `feat/eval-significance-gate` (head fe7cd85) carries a complete, tested feature: finbot-eval gains a `--significance-alpha=A` CLI flag that engages the Diebold-Mariano QLIKE significance gate on the auto-garch-family selector in `walkForwardVolEval`, with tests in `packages/simulator/test/vol-eval.test.js` and a design-doc update in `designs/ensemble-forecasting.md`. Default (null) leaves the vol-eval table byte-identical. Form a PR from this branch against its base (open one if none exists) and run the full gauntlet: clean → panel review → fix-loop → un-draft. Pay attention to the panel confirming the "default leaves table byte-identical" invariant and to the still-pending design decision (whether `significanceAlpha` should become the live default) — surface that decision to the maintainer rather than resolving it in-band.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-22T03:55:32Z
