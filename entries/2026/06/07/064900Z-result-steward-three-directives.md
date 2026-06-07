---
ts: 2026-06-07T06:49:00Z
kind: result
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 428
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 429
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - entries/2026/06/07/055400Z-dispatch-builder-f2fd55.md
  - entries/2026/06/07/060500Z-result-builder-f2fd55.md
  - entries/2026/06/07/060700Z-dispatch-researcher-df145e.md
  - entries/2026/06/07/060236Z-result-researcher-df145e.md
  - entries/2026/06/07/060900Z-dispatch-builder-316c4c.md
  - entries/2026/06/07/061454Z-result-builder-316c4c.md
  - entries/2026/06/07/061800Z-dispatch-researcher-a14165.md
  - entries/2026/06/07/062046Z-result-researcher-a14165.md
  - entries/2026/06/07/062500Z-dispatch-builder-490c42.md
  - entries/2026/06/07/064708Z-result-builder-490c42.md
---

# result: steward — three user directives addressed; PRs #428, #429, #430 opened

User issued three directives in quick succession during a prior
fixer dispatch on PR #403. All three are now addressed:

## Directive 1: validate endo#3295's lint-on-master claim

**PR #428** — `ci: validate lint on master (probe for endo#3295)`,
DRAFT, base `master`, head `ci-validate-lint-probe-3295` at
`f1e5235b`. Single empty commit.

**Verdict: claim NOT validated.** CI on PR #428 ran:
- `lint`: **SUCCESS**
- 13 other named checks: SUCCESS
- `browser-tests`: CANCELLED (the recurring 30-min-timeout
  pattern; not failure)

The upstream PR `endojs/endo#3295`
(`fix(eslint-plugin): drop conflicting project parser option`)
claimed lint on master is currently broken. Bot master at
`4a04d078` IS in sync with upstream master, and the no-changes
probe shows lint passes. Possible explanations: (a) upstream
master has moved past the broken state since the claim was made;
(b) bot fork's lint configuration differs from upstream's in a
way that masks the issue; (c) the claim was about a different
state than the current tip. Surfacing to the user for the call;
the experimental data is in #428's CI.

Builder dispatch: `f2fd55` (no researcher precedence per skip
rule — mechanical git-and-PR-open with no design substance to
ground).

## Directive 2: duplicate endo#3226 onto llm

**PR #429** —
`feat(marshal,pass-style): admit immutable ArrayBuffer through
codecs (llm-base mirror of #57)`, DRAFT, base `llm-2bd9e0c`
(frozen base), head `kriskowal-marshal-binary-llm` at
`7e2c6348`. 5 commits.

The duplicate carries upstream's `0b55322 + abc1010` plus the
`b0b5cafe` positive-hex example fix plus a composite-tsconfig
chase commit. One add/add conflict on
`packages/pass-style/test/byte-array.test.js` resolved by taking
upstream's strict superset with llm-side tests preserved.

**Critical context surfaced in PR body**: the prior llm-side
sibling PR #56 was withdrawn 2026-05-06 with no recorded reason.
The body asks the maintainer to speak to keep-or-withdraw on
this new duplicate.

CI at this entry's time: 23 SUCCESS, 0 FAILURE. Clean.

Researcher+builder dispatch: `df145e`+`316c4c`.

## Directive 3: RSVP #417 — no-spackle experiment per erights's premises

**PR #430** —
`feat(immutable-arraybuffer): no-spackle experiment (from #417's
freezable-virtual-typedarrays)`, DRAFT, base `master-4a04d07`
(frozen base), head
`experiment/no-spackle-immutable-arraybuffer-417`. 8 commits.

The experiment opens with erights's three Mark-Miller-authored
commits from PR #417 (`96e4fd4a`, `24ac8faa`, `59dfbc6d`) plus
the cleaner typo sweep (`984b5d4d`) and two compatible
panel-round-1 fixups (`08b6bcd4`, `f6d919e3`); drops the spackle
commits (`d334dcc0` onwards); drops the spackle-adjacent permits
annotation (`0bf3dc8e`); drops the @endo/bytes-spackle README
ramifications fixup (`2071b71e`).

**Two new commits** implement erights's premises 3 and 5:
- Shim install via pseudo-constructors built from the freezable
  TypedArray pony's exports (`amplifyTypedArray` renames
  `getHiddenTypedArray` for drop-in global replacement).
- Race-to-install in the simpler *detect-then-skip* form (no
  symbol, no pin) — distinct from the harden three-tier pattern.
- 8 new shim-level tests mirroring pony tests.

**Premise 2 partially deferred**: "package exports only the shim"
would require modifying `@endo/bytes/src/to-immutable.js` which
the dispatch brief placed out of scope. The builder surfaced the
gap via review comment
[`issuecomment-4641694062`](https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4641694062)
asking erights to choose between (a) migrating @endo/bytes to
the shim'd method or (b) adding a private subpath.

CI at this entry's time: 3 SUCCESS, 12 FAILURE. Expected — the
restructure has substance that needs erights's response to
premise 2 before further work. Not the steward's CI to drive.

Researcher+builder dispatch: `a14165`+`490c42`.

## Adjacent observations

- **Researcher precedence rule worked as written** for directives
  2 and 3 (the substantive ones); skipped with documented reason
  for directive 1 (mechanical). Each researcher walk surfaced
  load-bearing context: #56-withdrawn history for #429,
  original-commits boundary + race-to-install precedent for
  #430.
- **Inbox-drain Monitor** caught the builders' result entries as
  they landed; no addressed-to-steward messages from the
  dispatched builders.
- **All three dispatch roots torn down** via
  `dispatch-teardown.sh`.

## Self-improvement

Two lessons from this triple-dispatch chain:

1. **Stacked directives benefit from sequential dispatch + clear
   substate cite-back.** The three directives arrived in
   sequence during a prior dispatch; rather than queueing, the
   steward addressed them in order with clean dispatch roots per
   directive. The chain's per-directive scope kept each builder
   focused.
2. **The probe-style "no-changes PR" is a useful low-effort
   diagnostic.** PR #428's empty commit surfaces ground truth
   on a claim (CI passes or fails on master) without any local
   substance interfering. The result negated the upstream claim,
   which is a useful signal to surface to the user.

The two self-improvement messages from the prior PR #426 chain
(pre-count errors before composing briefs; verify --fix runs by
content not stat) are routed to liaison/gardener for landing on
`skills/pre-push-gates/SKILL.md` or shepherd/fixer role files
separately.

Self-improvement: see above. The chain played cleanly across six
sequential dispatches (1 builder + 2×(researcher+builder)) with
each dispatch's brief grounded in fresh state.
