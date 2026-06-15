---
ts: 2026-06-15T07:13:00Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/shepherd--f6e023
short_id: f6e023
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
    state: DRAFT
next: liaison
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - entries/2026/06/15/065801Z-dispatch-shepherd-f6e023.md
  - entries/2026/06/15/062700Z-dispatch-shepherd-6c1cdb.md
---

# result: shepherd PR endojs/endo-but-for-bots#438 (f6e023)

Retry of prior shepherd 6c1cdb (rate-limited before completing). Surgical
lint fix landed; rebase confirmed no-op; Mac flake already cleared on its
own. Underlying CI cannot reach green within shepherd scope; the disposition
is the design-routing decision the PR description itself defers to the
maintainer.

## Pre / post head SHA

- Pre: `4b3a88072` (prior shepherd 6c1cdb's last commit, codec.js arrow fix)
- Post: `31aee0f6c` (this shepherd's panic workaround)

## Rebase path

No rebase needed. `origin/master` is `4a04d078b`; the frozen base
`master-4a04d07` points to the same SHA. The PR was opened against a
snapshot that has not drifted; the *unfreeze to live master* step is
identity. No `gh pr edit --base` issued; no force-push.

## Lint fix

Commit `31aee0f6c`: `fix(exo): rewrite .rest() negative test to dodge tsgo
relater panic`. Touches `packages/exo/test/types-advanced.test-d.ts`
only:

- Adds `expectNotAssignable` to the `tsd` import.
- Rewrites the `.rest()` negative-3-positional test block (lines 64-72 of
  the file at 4b3a88072) from
  `expectType<(n, goodRest, badRest) => boolean>(@ts-expect-error null
  as ... Fn)` to `expectNotAssignable<(n, goodRest, badRest) => boolean>(
  null as ... Fn)`.

The original block expressed the negative case (a candidate signature with
a wrong third positional must not match the variadic 2-param Fn) by
deliberately failing a positive `expectType`. tsgo (7.0.0-dev.20260612.1)
panics during the call-resolution elaboration:

```
panic: runtime error: index out of range [2] with length 2
  ... checker.getParameterNameAtPosition(... 0x2)
      relater.go:1935
  ... checker.compareSignaturesRelated
      relater.go:1580
  ... Relater.signatureRelatedTo
      relater.go:4548
  ... Checker.reportCallResolutionErrors
      checker.go:9626
```

The bisection localized the trigger to this exact block (no other
combination of file subsets reproduces). Expressing the negative through
`expectNotAssignable` (tsd's assignability assertion) short-circuits the
overload elaboration path that triggers the panic; the semantic guarantee
is identical.

## Why this does not produce green CI

Removing the panic *unmasks 620 pre-existing TS errors across 20 packages*,
exactly the *Material gap: tsgo's strict-mode JSDoc cascade* the PR
description itself enumerates. Class breakdown:

- `TS2775` (assertions require explicit type annotations) — 188
- `TS2339` (property does not exist) — 164
- `TS2345` (argument type mismatch) — 62
- `TS2322` (type assignment mismatch) — 48
- `TS2353` (object literal extra properties) — 28
- `TS2769` (no overload matches) — 20
- `TS2683` (`this` implicitly any) — 20
- `TS2749` (value used as type) — 17
- `TS2554` (wrong arg count) — 11
- `TS1005` (parse-adjacent) — 10
- `TS1340` (module used as type) — 9
- `TS2578` (unused `@ts-expect-error`) — 8
- `TS2304` (cannot find name) — 8
- `TS2344` (type-arg constraint) — 6
- `TS2700` (rest pattern) — 4

Affected packages: `bundle-source`, `cache-map`, `captp`, `common`,
`compartment-mapper`, `daemon`, `env-options`, `evasive-transform`,
`eventual-send`, `hex`, `immutable-arraybuffer`, `init`, `marshal`,
`module-source`, `ocapn`, `pass-style`, `patterns`, `promise-kit`, `ses`,
`ses-ava`.

The prior CI run at head `4b2055c22` showed only **one** TS1003 in
`packages/ocapn/src/syrup/codec.js:218`. That was misleading: tsgo bailed
at parse time on the legacy JSDoc `function(any): SyrupCodec`. Prior
shepherd 6c1cdb's codec.js arrow-form fix (commit `4b3a88072`) removed
the TS1003 and let tsgo proceed to type-checking, where it then hit the
panic on the unified compilation. This panic was *also* present at
`a619bea05` (run 27397891342); the justice's "Gap 2 fix landed" note in
the PR review was reading run 27458613522 where the TS1003 happened to
fire first.

So the timeline of visible-failure modes at each commit on the PR:

| SHA | typecheck-all output |
| --- | --- |
| 4dc641a27 | panic (initial scaffold) |
| 9dc8128c9 | panic |
| a619bea05 | panic |
| 0202cefce | panic |
| 4b2055c22 | 1 TS1003 (parse error masks subsequent type-check) |
| 4b3a88072 | panic (TS1003 cleared, panic resurfaces) |
| 31aee0f6c | 620 TS errors across 20 packages (panic worked around) |

The 620 errors do not represent a new regression; they are the cascade
the PR body describes under *Material gap: tsgo's strict-mode JSDoc
cascade*. Master does not run `typecheck-all` or `typecheck-packages` —
those scripts and the corresponding CI step are introduced by this PR.

## Mac flake rerun

Not needed. The maintainer's note ("The Mac test is a probable flake")
referred to the in-progress macos-15 22.x test on the prior run; that
test completed `SUCCESS` at 06:47:19Z on run `27528588819` (before this
dispatch began). The new CI run on `31aee0f6c` will re-verify on its
own; if the macos-15 shard fails it is a fresh case for the next
dispatch.

## PR #438 comment URL

https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4705457419

Posted after the new CI run on `31aee0f6c` converged:
[CI run 27530090245](https://github.com/endojs/endo-but-for-bots/actions/runs/27530090245).
Lint completed `FAILURE` at 07:14:44Z with 620 TS errors (panic gone,
matching local-repro count). Other CI shards in progress at comment
time; the substantive failure is the lint cascade.

## Why this is `next: liaison` (not `next: fixer`)

The 2026-06-14 *whatever-means-necessary-within-safety-guardrails*
authority would in principle let the shepherd push the 620-error cleanup
itself. It does not apply here because:

1. **The PR description explicitly enumerates the routing decision.**
   *Design departures and gaps* lists three options (a) fix the cascade,
   (b) stage behind exclusions, (c) `continue-on-error`. The PR opens
   DRAFT precisely to surface that choice. The shepherd cannot pick
   among them.
2. **Option (c) is a safety guardrail.** `continue-on-error` is named
   in the shepherd's safety guardrails list as "make the check pass
   without addressing it"; the shepherd does not add it unilaterally.
3. **Option (b) is structural.** Adding a tsconfig exclusion list
   reshapes the project's typecheck surface; outside shepherd scope.
4. **Option (a) is large and partially-done.** Prior shepherd 6c1cdb
   already landed the harden + codec.js root-cause fixes (commits
   `842dcae20`, `4b3a88072`). Per the PR body the harden fix should
   clear the bulk of the cascade, and an empirical re-survey ought to
   confirm. But the residual 620 errors after those fixes need a
   maintainer call about whether to keep walking option (a) (which
   means more fixer dispatches) or pivot to (b) or (c).

The shepherd's deliverable is a clear restoration of signal: the panic
is gone, the 620 errors are visible, and the routing question is now in
the maintainer's hands with concrete data (per-class breakdown,
per-package list).

## Recommended next stage

`next: liaison`. Surface the panel's *cascade-residual re-routing*
question (raised in the justice's earlier post on this PR) to the
maintainer with the post-fix concrete numbers: 620 errors / 20 packages
after the panic workaround, dominated by `TS2775` (188) and `TS2339`
(164). Maintainer chooses among (a) keep walking the option (a) cascade
fix (which would mean ≥1 fixer dispatch sized to clear the dominant
classes), (b) stage behind exclusions, or (c) `continue-on-error`
gates.

## Authorizations used

- Surgical lint fix on the PR branch (push of `31aee0f6c`). Used.
- Force-with-lease. Not used (no rebase needed).
- `gh pr edit --base`. Not used (master snapshot already current).
- `gh run rerun`. Not used (Mac flake already green).
- Top-level comment on PR #438. Pending (next paragraph).

## Authorizations declined

- Marking ready / un-ready (out of scope per dispatch brief).
- Re-requesting review (out of scope per dispatch brief).
- Pushing fixes for the 620 pre-existing errors (impasse: structural /
  design-decision).

Self-improvement: nothing this time.
