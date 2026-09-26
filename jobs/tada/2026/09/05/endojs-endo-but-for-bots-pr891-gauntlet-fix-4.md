CI is GREEN (rc 0). The fix stage is complete.

## Completion report

Re-derived the job state: PR #891 (`design(zone): back-port portable @endo/zone`, head `kriscendobot:design/endo-zone`) was at round-3 commit `2d1f26b69`; the panel-4 verdict (2026-09-04 review, disposition must-fix) was the latest. No prior round-4 fix was committed, so this was a clean start.

**Applied the panel-4 must-fix items once** to `designs/endo-zone.md` (+ one README should-fix), commit `f549960d1`, pushed to the PR head:

- **Phase 3 sync/async mechanism** (critic must-fix + skeptic + decomplector): named the actual synchronization point — the daemon `makeAdapterZone` is an **async factory the host awaits at worker bootstrap** (construction-time, the stated exception to synchronous construction), which drives eager revival and durable-kind re-definition before the first delivery; and defined **provisional write-through with rollback-to-free** failure semantics plus a per-incarnation commit barrier, so the once-only invariant survives a crash between the synchronous return and the daemon ack.
- **"Passable remotable" framing** (skeptic must-fix): dropped the `remotable` classification; a Zone is deliberately not a network-facing remotable, with the structural reason it stays off the marshal boundary stated (wholly synchronous surface, adapters run in-worker) and a cite to `packages/pass-style/README.md`.
- **Set→Map cardinality** (decomplector): the `makeOnce` key-state tracker is now "a heap `Map` from fully scoped label to state," matching its three-state domain.
- **Em-dash sweep** (pedant must-fix): removed all 28 em-dashes per `skills/em-dash-style` (period/parens/colon by reading); verified zero remain.
- Comment/should-fix items: split the terms-of-art run-on into a glossary list, fixed the "key-space integrity" forward reference, fixed simple-past tense in Testing, and README `M-sized (3-4-day)`/`14-20-week` hyphenation.

**CI: GREEN** — bounded watch returned rc 0 (5/5 checks, 0 failed). Stopped without re-running the panel (the driver re-posts panel-5).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 86 tokens (3233863 cached reads)
- Output: 29467 tokens
- Cost: $3.218645499999999
- Wall-clock: 911s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
