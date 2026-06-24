---
ts: 2026-06-17T22:47:42Z
kind: result
role: appellate
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/17/224446Z-result-solicitor-cb4250.md
  - entries/2026/06/17/221538Z-result-solicitor-2c53c2.md
  - jobs/open/20260617T224219Z--350bef--pr-449-design-summary-fix.md
---

# Appellate review: PR #449 design panel rounds 1-3

Post-loop appellate review of the three solicitor rounds for PR #449
(freezable TypedArray emulation, design panel).

## Round walk: follow-up and acknowledge items

### Round 1

**Follow-up items (2):**

1. **[critic] Frozen-base refresh discipline.** A one-line note that
   `master-4a04d07` will eventually need a refresh per
   `skills/frozen-base-branch/SKILL.md`; deferred to the ferry PR.
   - Small? Yes.
   - In-context? Partially: the design references the frozen base, but
     the note concerns a future ferry PR's branch discipline, not the
     current design document itself.
   - Loss-tracking risk? Low: item is in the durable follow-up ledger;
     the ledger is revisited at merge. The work target is a future PR,
     not a file this PR touches.
   - **Decision: deferral stands.** Fails in-context test (work lands
     on a future PR, not this design document).

2. **[ergonomist] README caveat language for silent-swallow indexed
   assignment.** Needs a call-site walkthrough so users do not file
   phantom bug reports; deferred to the implementation PR.
   - Small? Yes.
   - In-context? No: the README being updated is the implementation
     PR's artifact, not a file this design PR touches. Round-2
     verdict confirmed the worked-example additions in round 2 provide
     ready-to-paste prose for the implementation PR, but the write
     target remains that future PR.
   - Loss-tracking risk? Low: in the durable follow-up ledger.
   - **Decision: deferral stands.** Fails in-context test.

**Acknowledge items (2):**

1. **[decomplector] Drop-the-pseudo-prototype shape correctly
   decomplects state and identity.** Design validation observation.
   Stays acknowledge; no promotion candidate.

2. **[pedant] Em-dash and curly-quote discipline honored.** Mechanical
   verification. Stays acknowledge.

### Round 2

**Follow-up items (0).** Zero new items; round-1 follow-ups remain
in the ledger.

**Acknowledge items (7).** All are confirmations that prior round-1
must-fix items landed correctly (internal-heir moot, pass-style
premise verified, BigInt per-flavor named, record-bundling note,
API-surface asymmetry callout, copyeditor trio, pedant em-dash/
non-ASCII). All correctly stay acknowledge; no promotion candidates.

### Round 3

**Follow-up items (0).** Zero new items; round-1 follow-ups remain.

**Acknowledge items (16).** All are confirmations of round-2 must-fix
items landing (permits.js delta, adapter withdrawal scope named) plus
further round-1 item confirmations (toStringTag decision, getter
decomplecting, API surface table, prose mechanics). All correctly stay
acknowledge; no promotion candidates.

## Promotion decisions

**No promotions.** The two follow-up items (round 1: frozen-base
refresh discipline; round 1: README caveat language) both fail the
in-context test: their work targets are future PRs (the ferry PR and
the implementation PR respectively), not files this design PR touches.
The follow-up ledger is durable and will be revisited at merge. The
acknowledge items across all three rounds are genuine confirmations and
design-validation observations; none carry loss-track risk.

No missed `must-fix-loop` items identified. The acknowledge items are
all correct-landing confirmations, not suppressed regressions.

## Job entry

No appellate additions to the job entry. The existing bundle at
`jobs/open/20260617T224219Z--350bef--pr-449-design-summary-fix.md`
(17 enumerated items across all three rounds) is complete as posted.

## PR comment

None. No findings warrant a top-level PR comment. No re-open-loop
recommendation.

## Recommended next stage

`next: fixer` - claim the summary-fix job from the board and apply
the 17-item bundle to the design document. After the fixer pushes,
`gh pr ready 449` can run to un-draft.

Self-improvement: nothing this time.
