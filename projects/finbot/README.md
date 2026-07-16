# Project: finbot

The garden's financial-forecasting / paper-trading agent, developed on the own fork [kriscendobot/finbot](https://github.com/kriscendobot/finbot). finbot is built in the Endo / object-capability idiom (CapTP transport, far-ref vending, a wallet capability behind an audit gate) and its substantive core is a **volatility-forecasting** engine — deterministic maximum-likelihood-fit GARCH-family surfaces (symmetric GARCH, GJR-GARCH leverage, EGARCH on the roadmap) — driving **regime-aware, volatility-targeting position sizing** through a seeded OODA loop. It is driven continuously by the `finbot-progress` press (a `builder` job every 6h; garden tracker [kriskowal/garden#54](https://github.com/kriskowal/garden/issues/54)), one concrete increment per cycle.

## Rules of engagement

- **Own fork; normal fork etiquette.** Routine work happens on `kriscendobot/finbot` under the `kriscendobot` bot identity. Leave the tree green (`npm test`) each cycle. There are no CI workflows on the repo, so verification is local (test suite + a seeded `finbot-ooda` dry run).
- **Live execution stays blocked.** As of 2026-07-16 every increment runs with `WALLET TOUCHED: false`. Live / test-net execution needs an explicit maintainer paper-wallet (or test-net) authorization *and* a chosen CapTP transport; do not touch a wallet without both.
- **One increment per cycle.** The design is ambitious and iterated, not landed whole; the press exists precisely so each dispatch advances one unblocked increment and hands off the rest.

## Identity and credentials

Standard bot identity (`kriscendobot`). finbot is a garden-owned fork, not an upstream third-party repo, so no ferry / escalated-identity path applies; there is no upstream to land to.

## Upstream

- Repo: <https://github.com/kriscendobot/finbot>
- Default branch: `main`
- Own-fork triage is auto-provisioned (`repos/kriscendobot-finbot`, sender-gated per CLAUDE.md § Monitoring safety constraint → own-fork auto-provisioning).

## Authority structure

Default authority rests with kriskowal as maintainer. finbot introduces no non-default authority actors; the forecasting-methodology choices are the maintainer's and the builder's.

## Per-topic detail

| Topic | Abstract |
|-------|----------|
| [financial-forecasting-literature-review.md](financial-forecasting-literature-review.md) | Consolidated survey of the academic financial-forecasting literature, aimed at the finbot builder: which methods are worth adopting and in what value-to-effort order, the evaluation and anti-overfitting discipline finbot must follow, and what the literature holds is *not* reliably forecastable. Cites the library entries created for the survey. |
