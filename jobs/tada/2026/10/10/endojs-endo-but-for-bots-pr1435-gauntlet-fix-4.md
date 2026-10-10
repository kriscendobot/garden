# Gauntlet fix round 4: endojs/endo-but-for-bots#1435 (Moddable 10.0.0 port plan design)

I pushed the panel-4 fixes as one review-feedback commit, `c05ddcc0ac`, on top of `9867b28114` on `design/moddable-10-0-0-ironhorse-port-plan`. `ci-wait-merge.sh --no-merge` returned **rc 0: CI green**, with 28 checks and none failed.

## Must-fix items (all applied)
- **skeptic #1: R14 and R15 had no concrete probe.** Each row now names a probe taken from its XS 10.0.0 change:
  - **R14:** `next` returns or resolves to a primitive, the `Array.fromAsync` promise rejects with a TypeError, and `return` is never called.
  - **R15:** for all seven Set methods, `size` is set to `2**31` and to `2**32+1`, and the probe checks which of `has` or `keys` gets called.
  - Both rows now also say that the existing test262 passes happen on 8.3.1 too, so they can't show the 10.0.0 change.
- **pedant #1: em dash in the `designs/README.md` index row.** The Updated cell now holds `2026-10-10` instead of the dash.
- **pedant #2: «» characters in the expectation example.** I left them in and added a note that they are verbatim test262 `assert.sameValue` output.

## Should-fix and comment items (applied)
- **Revoked-proxy probes:** the R08 and R13 revoked-proxy probes moved to child 1. Child 3 now probes only live proxies, so it can't hit its probe-failure limit because of R01's bug (critic #2).
- **Child 6 gate:** reduced to one self-check that passes only when all five port PRs are merged, and fails closed if `gh` or the journal can't be reached.
  - I dropped the advisory `--require-tada` and `grep` steps (decomplector #1, ergonomist #2 and #3, critic #6).
  - I checked against the garden scripts: `--adopt-go-ahead` exists, and `--require-tada` only checks that a completion record exists.
  - Re-runs of a failed child now use a dated `<child>-rerun-YYYYMMDD` basename, because the board treats a reposted, already-completed basename as a no-op (skeptic #3).
- **Child 6 stop rule:** it stops and splits the rest into follow-up jobs if an overlay won't build against 10.0.0 or the unexplained drift goes over 25 entries (critic #3, skeptic #6).
- **R22 go/no-go:** the decision on whether to support immutable ArrayBuffer at all is now child 5's first deliverable. On no-go, R22 becomes `not-applicable` (critic #4).
- **Ordering rationale:** restated without the reason the critic showed was already covered by another gate. "Considered and rejected" now has an entry for an early drift report that promotes nothing (critic #1).
- **Other edits:**
  - A note to re-probe R17–R21 and R24 when resizable buffers land (skeptic #4).
  - The R16 oracle check is now labeled output-only, not evidence of memory safety (skeptic #5, decomplector #2).
  - Child 2 now says what happens if the IronHorse scoper counts slots differently: R03 still lands, R02 stops and is reported (skeptic #2).
  - Each parked job body states its child number and stage (ergonomist #1).
- **Prose for new readers:** a one-sentence problem statement up front, the expectation-line format explained before the command, a clearer column header, a pointer to where the garden terms are defined, and the README wording (novice #1, #2, #4, #7; copyeditor #1; ergonomist #4).

## Not applied
These were comment-only or taste calls, so I left them:
- **decomplector #3:** the mutable "(provisional)" marker in the table.
- **decomplector #4:** the fixed probe-failure count.
- **novice #3:** a second worked example.
- **copyeditor #2 and #4:** two small wording changes.

## Follow-ups
None. The gauntlet driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1778676 cached reads)
- Output: 15216 tokens
- Cost: $1.4144632000000004
- Wall-clock: 889s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
