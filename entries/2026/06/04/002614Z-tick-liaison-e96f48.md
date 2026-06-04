---
ts: 2026-06-04T00:26:14Z
kind: tick
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/205357Z-dispatch-liaison-4f338f.md
---

Referry of bots#411 **held at maintainer's request** to coordinate the Playwright pin. No ferry, no reshape, no changes to #3296 or bots#411.

State at hold: bots#411 was rebuilt (force-pushed, head `37440d0e2`, 3 commits all re-timestamped 2026-06-04T00:03Z) and **re-added a Playwright pin** — now `@playwright/test` -> `1.58.2` (3rd commit `37440d0e2 ci(browser-test): pin Playwright to 1.58.2 for reliable install`, touching package.json + package-lock.json). The workflow file (browser-test.yml, cache+timeout) is byte-identical (`f0e6d014d`) to what #3296 already carries (head `511c9e0a9`, 2 commits, DRAFT, MERGEABLE), so the ONLY new content is the pin.

The pin re-creates the coordination conflict that drove the earlier "cache+retry only" decision: naugtur's upstream #3254 (OPEN) pins `@playwright/test` -> `1.59.1`; the bot's 1.58.2 conflicts with and sits below it. endo master still has `^1.49.1` (neither pin merged).

Maintainer chose **Hold (I'll coordinate)** over keep-pin-free-noop / ferry-the-pin. So the pin-vs-#3254 reconciliation is the maintainer's to make; the liaison takes no action on #411/#3296 until told.

Recurrence note: the bot pipeline has now re-added the dropped pin once (1.49.1 -> dropped -> re-added as 1.58.2). If this recurs, the durable fix is bot-side (stop re-adding a pin that defers to naugtur's #3254), not repeated liaison reshapes.
