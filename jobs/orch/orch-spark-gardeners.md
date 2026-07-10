---
order: serial
children: scholar-muse-spark-harness design-spark-gardeners
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-10T21:19:53Z
---

# Orchestration: Spark gardeners — research then design

Serial, halt-on-failure orchestration of the maintainer's directive (2026-07-10):
research using Simon Willison's tool to harness Meta's **Muse Spark**
(<https://simonwillison.net/2026/Jul/9/muse-spark-1-1/>), then, once the research
lands, introduce **Spark gardeners** — a gardener fleet-worker variant harnessed
on Muse Spark instead of `claude -p`.

Runs in sequence; halts if the research fails so the design is not built on
nothing:

1. `scholar-muse-spark-harness` — scholar (fleet default): ingest the Willison
   post and assess whether/how Muse Spark can back a garden worker.
2. `design-spark-gardeners` — designer (Fable): design the Spark-gardener harness
   seam and fleet integration on the scholar's findings, landing a design under
   `designs/` on `main2`.
