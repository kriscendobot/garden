CI is GREEN (5/5 checks passed, 0 failed). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #891 gauntlet — FIX round 6 (design PR `design(zone): back-port portable @endo/zone`, `designs/endo-zone.md`).

**Panel verdict applied:** Round-6 aggregate disposition was must-fix, driven by two request-changes seats (pedant, novice) plus should-fix items from critic, skeptic, decomplector, ergonomist, and copyeditor. I applied all of them in one prose-only pass (159 insertions / 88 deletions, single file):

- **pedant** — Removed all 27 em-dashes from prose (rewritten as periods/colons/parentheses per the em-dash-style skill, judgment not substitution); replaced the U+2026 ellipsis in the `fc.property(..., ...)` code span with ASCII `...`; title-cased `### A Portable Allocation Contract` to match sibling headings (anchor `#a-portable-allocation-contract` unchanged, all internal links still resolve).
- **novice** — Glossed ERTP/vat-durability jargon in the opening sentence and pointed to the terms-of-art list; made the hardening paragraph's forward references explicit ("detailed below") instead of asserting mechanisms as established; split the ~10-claim `hostIsStorable` paragraph into three (naming / composition / seams); converted the eleven-scenario Phase-1 test sentence into a bulleted sub-list.
- **critic** — Named the `coreIsStorable` superset relationship as a Phase-1 exit test drawn from `@agoric/store`'s own fixtures, not an asserted fact (also added as a Phase-1 test bullet).
- **skeptic** — Reconciled the contradictory retry passages: inner-key marking is backend-agnostic, so the heap Phase-1 "allocates-then-throws-then-retries" test expects the retry to *fail on the used inner key*; only the durable-rollback obligation moves to Phase 3.
- **decomplector** — Named the detached-brand revival path as a deliberately weaker (adapter-discipline + conformance-test) guarantee than the core-structural mint path, rather than claiming parity.
- **ergonomist** — Explained why `zone.isStorable` keeps the bare name (binding-site disambiguation) while `hostIsStorable` earns a distinct one; instructed that `detached()`'s narrowed contract live in its own JSDoc at code-review time.
- **copyeditor** — Fixed the write-through-failure tense shift to present tense; split the double-`which` `detachedStoreProvider` sentence; added SES/CapTP to terms of art.

**Push:** commit `561659487` advanced `origin/design/endo-zone` (`7a6a2cd6a..561659487`) via `safe-push-pr-head.sh`.

**CI:** GREEN — `total=5 failed=0` at 426s, well within the 3600s deadline (rc 0).

Stopped without re-running the panel (the driver re-posts panel-7). No follow-ups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4247699 cached reads)
- Output: 35851 tokens
- Cost: $4.015806499999999
- Wall-clock: 992s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
