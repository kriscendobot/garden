# Maintainer priorities report — 2026-09-28

Prepared by the liaison ahead of muster. Organized around the standing
weekend mandate (`config/foreman-mandate`, kriskowal 2026-09-26): (1)
minion.town capabilities — remote Claude, git-origin-to-VFS; (2) endor
metering on minion.town, explorative; (3) ironhorse development.

## 1. minion.town capabilities — blocked on your review, not on work supply

**The federation release-gate is the single highest-leverage decision
outstanding.** Four PRs have sat draft and unreviewed since 2026-09-26/27:

- [endojs/endo-but-for-bots#1332](https://github.com/endojs/endo-but-for-bots/pull/1332) — docs: prioritize Minion Town guest locator federation (the plan/authority document; carries the open questions blocking the rest)
- [endojs/endo-but-for-bots#1333](https://github.com/endojs/endo-but-for-bots/pull/1333) — feat(daemon,cli): adopt a remote guest by `endo://` locator
- [endojs/endo-but-for-bots#1335](https://github.com/endojs/endo-but-for-bots/pull/1335) — fix(daemon): bind OCapN gateways to peer sessions (a security fix; #117 below is blocked on this landing first)
- [kriscendobot/minion.town#117](https://github.com/kriscendobot/minion.town/pull/117) — feat(federation): account guest locator reveal + gated federation wiring (draft, marked do-not-activate pending #1335)

**Recommended review order:** #1332 first (it names the specific authority
questions that shape the other three), then #1335 (security fix, should land
before anything using the gateway it patches), then #1333, then
minion.town#117 last (it depends on #1335 being live). All four are still
exactly where they were two days ago — the blocker is your review time, not
missing implementation.

**Git-origin-to-VFS**: the underlying design,
[minion.town#41 "the capability-addressed git remote"](https://github.com/kriscendobot/minion.town/pull/41),
merged 2026-08-18 — over five weeks ago — with no build/implementation PR
found since. This looks like a stalled handoff rather than a blocked
decision; recommend I dispatch a `build` job against it if you confirm it's
still wanted at current priority.

## 2. endor metering on minion.town — no work started yet

I found no design, issue, or PR anywhere in `kriscendobot/minion.town` or
`endojs/endo-but-for-bots` scoped to metering on minion.town with endor. This
matches the mandate's own framing ("explorative, lower confidence") but means
priority 2 is currently a placeholder, not a project. One thing worth
knowing before dispatching anything here: a 2026-09-18 design note
(`ironhorse-native-lockdown` decisions) recorded that "endor is not being a
current priority" as of that date, in the specific context of which realm
profile the endor daemon's native `lockdown()` should use — that's a narrower
technical deferral, not necessarily in tension with metering work, but worth
your eyes before I post a design job here, since it's the one priority with
zero grounding to build from.

## 3. ironhorse — real, measured progress; roadmap just re-verified

The groom pass I ran yesterday ([endojs/endo-but-for-bots#1345](https://github.com/endojs/endo-but-for-bots/pull/1345),
draft, clean, CI green) re-verified all 241 design files against actual
PR/merge state for the first time since 2026-09-10. Ironhorse-relevant
highlights from that reconciliation:
- Fleet-wide totals moved from a stale 202-indexed/49-Complete baseline to a
  verified 239-indexed/75-Complete baseline — real progress had been landing
  faster than the roadmap doc reflected.
- `ironhorse-panic` flipped Proposed → In Progress ([#1018](https://github.com/endojs/endo-but-for-bots/pull/1018)).
- `endor-git-bindings` and `endor-tui`/`endor-bus-tui` all corrected to In
  Progress (previously shown Not Started/Proposed).
- `sturdy-refs-endor-syscall` corrected to In Progress, redirected to
  on-demand OCapN enlivenment (a scope change worth knowing, not just a
  status flip).
- `daemon-engo-supervisor` marked Consolidated into `daemon-capability-bus`
  and `daemon-endor-architecture`.
- One open resequencing conflict the groom pass surfaced rather than
  resolving on its own authority: M11 (IronHorse/endor) work is landing
  ahead of M3 in practice, which the milestone-numbering invariant says
  shouldn't happen. Worth a decision on whether to renumber or add an
  explicit expected-landing-order view. That decision lives in #1345's diff,
  not a separate document.

## Fleet operational health (context, not action items unless noted)

- **oros-studio: resolved.** Root cause was a stale Claude Code CLI silently
  stuck (root-owned npm tree blocked `claude update`), misclassified as
  transient failures for ~2 days. Fixed at the host and at the garden level
  (a new pre-claim health-gate lands on `main2` so a recurrence parks the
  host instead of sinking the board). Capacity restored, validated with real
  work completing cleanly.
- **endolin-garden2: under investigation, not yet resolved.** ~63% of its
  claims over the last 24h ended in a non-transient "terminal" failure — a
  different, newly-discovered problem, likely resource/contention-related
  now that it's carrying a full share of the raised worker-saturation target.
  A pinned investigation job (`garden2-terminal-failure-investigation-20260928`)
  is in flight; I'll report when it resolves.
- **The foreman's milestone-notice dedup was flooding your inbox** — ~30
  near-duplicate notices over 20 hours, all describing the same static M2
  blocker, because the dedup keyed on the LLM's own varying prose instead of
  the underlying board state. A fix job (`fix-foreman-milestone-notice-dedup`)
  is in flight, including archiving the existing duplicates once it lands.
- **The M2 blocker itself is already handled**: I ran the gauntlet on both
  green drafts the foreman was stuck asking about —
  [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/pull/1349)
  (hardened TextEncoder/TextDecoder) and
  [#1356](https://github.com/endojs/endo-but-for-bots/pull/1356) (hardened
  URL/URLSearchParams) — both are now driving through panel review.
- **Token-backoff ramp on schedule**: 0.65 now, 0.80 today at 18:00Z, 0.95
  tomorrow, 1.00 Wednesday morning ahead of the assumed mid-week reset.
- **Garden's own CI**: fixed yesterday after being red 3+ days (a test-drift
  bug from the 09-18 tada date-sharding migration, plus two real bugs it had
  been masking — both fixed, all clean now).

## Recommended next steps, in order

1. Review and decide on the minion.town federation stack (#1332 → #1335 →
   #1333 → minion.town#117) — this is the biggest lever available on
   priority 1.
2. Confirm whether to dispatch a `build` job against the stalled
   capability-addressed-git-remote design (minion.town#41).
3. Give the go-ahead (or a redirect) on endor-metering-on-minion.town, since
   it currently has nothing to build from.
4. Decide the M11-ahead-of-M3 resequencing question surfaced in #1345.
5. Nothing needed from you on the operational items above — they're either
   resolved or already in flight; I'll report as they land.
