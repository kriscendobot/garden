---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
title: §Resource-ledger-in-gateway-not-daemon (Decision 8)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The gateway is the layer where HTTP/WS traffic accrues;
> it is the natural place to meter and gate.*

§Per-account-resource-counters (compute seconds, storage
bytes, network bytes). §getBalance + §chargeBalance +
§purchaseTokens.

§The-Chat-weblet-renders-purchase-UI-but-doesn't-own-
accounting-state; §the-gateway-does.

§Payment-processor-is-out-of-scope: the gateway holds an
abstract `PaymentProcessor` exo contract; the actual
processor (Stripe / Coinbase Commerce / Lightning) is
operator-supplied.

§Cycle-94's-OCPL paper's §principle-of-least-authority
informs the §payment-proof-validation-by-external-exo
split.
