---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1585
priority: normal
posted_by: producer
posted_at: 2026-10-31T06:26:35Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR https://github.com/endojs/endo-but-for-bots/pull/1501 (head `feat/endopi-edit-tool-preview`, currently on frozen base `llm-9a14ddf`) onto a fresh snapshot of llm, so it picks up the stage3-math asinh/acosh ubuntu-26.04 libm fix from https://github.com/endojs/endo-but-for-bots/pull/1585. Then confirm that `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` go green on the new head, along with the rest of CI.

Context: shepherd job endojs-endo-but-for-bots-pr1501-shepherd-20261031 found the PR's other reds (the bwrap timeout flake and the fuzz `differential_regexp` timeout) were flakes that cleared on rerun. Its only remaining reds come from llm itself (the corpus 054/055 libm drift). If https://github.com/endojs/endo-but-for-bots/pull/1585 is closed instead of merged, check what replaced it on llm before weaving.
