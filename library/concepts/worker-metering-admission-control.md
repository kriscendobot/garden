---
id: worker-metering-admission-control
aliases: ["XS worker metering", "computrons", "meter-report", "budget as pre-payment", "admission control eliminates embargo", "worker quota refill"]
topics: [daemon, capability-security]
status: draft
---

# worker-metering-admission-control

Endo's XS worker meter counts deterministic computation steps as **computrons**
per crank and separates measurement from enforcement. Its key accounting shape
is admission control: a supervisor delivers a message only after the worker has
enough budget for the full hard-limit crank, then subtracts the actual
`meter-report`; this pre-payment bound avoids rolling back partial output. The
same meter supports measurement-only, fixed-quota, and rate-limited modes, with
explicit refills, a burst ceiling, and meter state preserved across worker
suspend/resume.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [daemon-xs-worker-metering/synthesis-target](../sections/endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--synthesis-target.md) | The reusable pattern: worst-case admission plus lazy refill and burst ceiling. |
| [daemon-xs-worker-metering/architectural-invariant](../sections/endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--the-architectural-invariant-admission-control.md) | Reserving a full hard-limit crank before delivery removes output embargo and rollback. |
| [daemon-xs-worker-metering/meter modes](../sections/endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter--three-modes-the-meter-mode-lattice.md) | Measurement, quota, and rate-limited modes form the worker-meter policy surface. |
| [gateway-package/resource ledger](../sections/endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations--resource-ledger-in-gateway-not-daemon-decision-8.md) | The gateway owns account resource balances while daemon instrumentation supplies compute measures. |

## See also

- [[monetization-gateway]] — the gateway-side resource ledger and payment-processor split.
- [[pay-per-request-monetization]] — the economic model that may price a metered unit.
