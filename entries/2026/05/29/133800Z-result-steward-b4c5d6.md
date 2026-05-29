---
ts: 2026-05-29T13:38:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/05/29/132130Z-dispatch-steward-f2a3b4.md
  - entries/2026/05/29/132300Z-dispatch-steward-a3b4c5.md
  - entries/2026/05/29/133600Z-result-fixer-af3bda.md
  - entries/2026/05/29/132630Z-result-solicitor-d9bc09.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 376
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 377
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 375
    role: observed
---

# result: fixer (#377) + judge (#376) — both complete, plus #375 ownership transition

After the 13-cycle quiet streak, the maintainer kriskowal landed on
endo-but-for-bots at 13:20Z and produced three signals in two minutes:

1. **PR #377 comment 4575582541** (13:20:27Z) — substantive pushback on
   retry strategy.
2. **PR #376 review** (13:21:32Z) — **APPROVED** the rebased design.
3. (Concurrently, 0xpatrickbot at 13:25:46Z on #375 — see below.)

Dispatched fixer (`af3bda`) for #377 and judge/solicitor (`8418fa`)
for #376 in parallel.

## Fixer `af3bda` outcomes (PR #377)

Result entry: `entries/2026/05/29/133600Z-result-fixer-af3bda.md`.

Investigation findings:

- **Flakes are NOT intermittent**. Every recent test-xs run across PR
  #377, upstream #3291, and recent master commits failed the same way.
  phoddie's note on endojs/endo#3289 ("GitHub website has been less
  reliable recently") corroborates a persistent-issue shape.
- **Fast retry CAN make things worse** under soft rate-limit /
  lock-step concurrent-runner scenarios.
- **Back-off should be exponential with jitter** to break lock-step.
- **Workflow had no cache for `~/.esvu`** — only a downstream
  `bin/xst` cache that ran AFTER `Install engines`, so the script's
  symlink shortcut never fired.

Two follow-up commits pushed to `fix-benchmark-install-engines-retry`:

- **`7309e26b`** `fix(ci): cache esvu engines across test-xs runs (#377)`
  — `actions/cache@27d5ce7f` for `~/.esvu` keyed on
  `runner.os + install-engines.sh` hash with restore-keys fallback,
  inserted BEFORE the install step so `are_engines_installed` can
  short-circuit fire on a hit.
- **`6c15b047`** `refactor(benchmark): exponential backoff with
  jitter in esvu retry (#377)` — 5s/10s exponential + 0-4s
  awk-based jitter (portable for `/bin/sh`; `$RANDOM` is a bashism
  dash leaves unset).

New head: `6c15b047`.

Comments posted on #377:

- **4575777172** — main four-question reply: (1) flakes are systemic
  not intermittent; (2) yes, fast retry can worsen; (3) implemented
  exponential+jitter; (4) implemented esvu cache.
- **4575808861** — CI follow-up surfacing the cache's chicken-and-egg
  (can't bootstrap from a never-succeeding install) and the
  V8-direct-download structural question for the maintainer's call.

Post-push CI: backoff visible in log (6s, 14s for xs; 6s, 11s for v8;
jitter spread confirmed). Underlying esvu install still extract-fails
(v8 canary moved from 233 to 238 since prior run); the cache cannot
self-bootstrap. The structural V8-direct-download question is deferred
to the maintainer's reply.

## Judge `8418fa` outcomes (PR #376)

Result entry: `entries/2026/05/29/132630Z-result-solicitor-d9bc09.md`.

The solicitor *skipped the formal 7-seat design panel* with explicit
rationale: maintainer kriskowal APPROVED at 13:21Z, and running a
speculative panel after maintainer approval would only produce findings
that contradict the authoritative verdict. Panel-hints output (audit
trail recorded in the result entry) confirmed all 7 design-panel seats
were applicable; the skip decision was a deliberate one based on the
maintainer-approval-trumps-internal-panel principle.

Un-draft confirmed: `gh pr ready 376` → "marked as ready for review".
Post-state: `isDraft: false`, `reviewDecision: APPROVED`,
`mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`.

The solicitor's self-improvement note: skip-panel-on-maintainer-approval
is a one-engagement observation; doesn't yet meet the ≥3-engagement
threshold for a new role-file operating norm. Future solicitor or
gardener can lift it if the pattern recurs.

## #375 ownership transition (no steward action)

At 13:25:46Z (https://github.com/endojs/endo-but-for-bots/pull/375#issuecomment-4575666825),
0xpatrickbot commented:

> Re-drafting and taking this forward on `llm`. This is a follow-up
> to #339 (EndoMount), which lives on `llm` — not `master` — so a
> `master`-based reconstruction…

This resolves the steward's master-vs-llm impasse posted to #375 at
05:15Z (entries/2026/05/29/051600Z-result-steward-c6d7e8.md). The
original author 0xpatrickbot is reclaiming ownership and rebasing onto
the correct base. PR #375 is now **out of the steward queue** — the
parked builder dispatch root `/home/kris/dispatches/builder--99363b/`
can also be cleaned up. The push on `pc-endomount-fs-fixes` at 13:34Z
is likely 0xpatrickbot's continuation work.

## Teardown

Tearing down:
- `/home/kris/dispatches/fixer--af3bda/`
- `/home/kris/dispatches/judge--8418fa/`
- (TODO next-cycle: `/home/kris/dispatches/builder--99363b/` for the
  parked #375 reconstruction that 0xpatrickbot is taking instead)

## What now sits in maintainer's queue

- **PR #376** — APPROVED + un-drafted, ready for conductor merge.
  Steward dispatching conductor next (this engagement).
- **PR #377** — awaiting kriskowal reply to fixer's four-question
  disposition + CI follow-up. The structural V8-direct-download
  question is the open thread.
- **PR #79** — unchanged, still awaiting maintainer disposition on the
  test-xs flake (#377 is its long-term mitigation).
- **PR #375** — 0xpatrickbot reclaimed; not in steward queue.

Self-improvement: nothing new. The parallel-dispatch pattern
(fixer + judge in one steward turn) worked cleanly — both completed
their work, neither blocked on the other.
