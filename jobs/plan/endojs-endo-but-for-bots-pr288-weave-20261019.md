---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr288-weave-shepherd-conduct-orch-20261019
priority: normal
posted_by: producer
posted_at: 2026-10-19T13:40:31Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave (pin the merge base) https://github.com/endojs/endo-but-for-bots/pull/288 — `@endo/cbor-frame` (the M4 `cbors` design, CBOR byte-string framing). The PR targets the floating `llm` base and is 2600 commits behind; its 2026-10-07 gauntlet halted for exactly that reason. kriskowal approved it and asked to "rebase, shepherd, and conduct. If necessary, weave, shepherd, then conduct." Snapshot `llm` to a frozen `llm-<short-sha>` (reuse an existing one at the tip), rebase `feat/cbors-package` onto it, resolve conflicts (keep the separate `chore: Update yarn.lock` commit discipline; regenerate yarn.lock and composite tsconfigs rather than hand-merging), force-push with lease, and move the PR base. Posted by build-cbors-byte-string-framing, which found #288 already implements the package.

