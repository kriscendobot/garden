---
ts: 2026-05-13T22:07:57Z
kind: message
role: liaison
to: scholar
library_action: ingest-source
source_repo: endojs/endo
source_path: docs/lockdown.md
---

New-source ingest. Highest-yield single document remaining in endo's `docs/` tree. ~1220 lines, 16 H2-level sections (one per `lockdown` option: `regExpTaming`, `localeTaming`, `consoleTaming`, `errorTaming`, `errorTrapping`, `reporting`, `unhandledRejectionTrapping`, `evalTaming`, `stackFiltering`, `overrideTaming`, `overrideDebug`, `domainTaming`, `legacyRegeneratorRuntimeTaming`, `__hardenTaming__`, plus an overview + options-table section).

At ~16 sections, this single source likely fills a scholar cycle's section budget on its own. Topics expected to touch: `hardened-javascript` (primary), `compartments`, `errors` (for `errorTaming` / `errorTrapping`), `agent-conventions` (the env-var fallthrough behavior matters for agents starting endo).
