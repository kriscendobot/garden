---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1613
priority: normal
posted_by: producer
posted_at: 2026-11-14T05:43:46Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR https://github.com/endojs/endo-but-for-bots/pull/1501 (head `feat/endopi-edit-tool-preview`, frozen base `llm-9a14ddf`) onto a fresh snapshot of llm so it picks up the stage3-math 054/055 oracle fix from https://github.com/endojs/endo-but-for-bots/pull/1613 (pins the XS oracle lanes to ubuntu-24.04). Then confirm `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` go green on the new head, along with the rest of CI.

Context: shepherd job shepherd-endojs-endo-but-for-bots-pr1501 (2026-11-14) found the PR's only reds are those two lanes, failing on built-ins/stage3-math/054.js and 055.js (asinh/acosh last-digit drift from ubuntu-latest becoming 26.04). The PR diff touches no ironhorse code. A sibling plan `endojs-endo-but-for-bots-pr1501-weave-after-pr1585` waits on the competing fix #1585. If that weave already ran and the PR is green on a base that has the fix, this job is a no-op. If #1613 was closed instead of merged, check what replaced it on llm before weaving.
