CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 5 — endojs/endo-but-for-bots PR #1058 (`design: optimize hardener indexed cardinality`, a design-doc PR).

**What I did:** Read the panel round-5 request-changes verdict and applied its must-fix items to `designs/hardener-indexed-cardinality.md` (plus a supporting `designs/README.md` refresh), pushed as a review-feedback follow-up commit to the PR head (`origin design/hardener-indexed-cardinality`, `3284785fd0..568da89ad9`), and watched CI to terminal GREEN.

**Must-fix items resolved:**
- **critic** — the sole open question posed a false dichotomy between the count-only and last-key forms. Resolved by *conjoining* both tests (`keys.length === len && (len === 0 || isCanonicalIntegerIndexString(keys[last]))`) rather than escalating the choice: each conjunct is the other's engine-independent backstop, so the fast-path classification no longer fails open under either lemma's failure. Reworked the Design code, Correctness Argument (the now-two reads' skew proved conservative by reading intrinsic length before `ownKeys`), Alternatives Considered, and Open Questions (now resolved, none load-bearing).
- **novice** — defined *purely indexed* (dense **and** no expando) at first reach, distinguished from *dense*.
- **copyeditor** — rewrote the tautological/ambiguous prototype-hoist sentence.
- **pedant / novice** — repointed the nonexistent `§ Implementation details`/`§ Implementation` cross-references at `§ Implementation and Test Plan`.

**Cheap should-fix folded in:** cite internals by symbol (removed stale line-number anchors flagged as drifted against the pinned SHA); stated a falsifiable 2x acceptance threshold; corrected the SES-copy `traversePrototypes` misdescription (the option does not exist in that copy); dropped the superseded-draft refutation (voice slip); normalized section cross-reference style to `§ Title`; refreshed the README row and past-tense totals.

**CI:** GREEN — 5/5 checks passed (`rollup-terminal … failed=0`).

**Follow-ups:** none required for this stage. Per the gauntlet protocol I stopped after one fix + CI watch; the driver re-posts panel-6. The design still names a `freezeTypedArray` cross-file parity check as an implementation-PR candidate follow-up (unchanged from prior rounds).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1058-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 95 tokens (4909189 cached reads)
- Output: 35002 tokens
- Cost: $4.451653499999999
- Wall-clock: 942s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
