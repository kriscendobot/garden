---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:09:07Z
---
refs: endojs/endo-but-for-bots#475:comment:5333434953:retro

# Result: review retrospective on endojs/endo-but-for-bots #475

Prosecutor loop over erights's attention comment
(https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5333434953),
which flagged an obsolete "no engine ships native immutable ArrayBuffer, so all
tests exercise the shimmed path" assumption (current XS ships native).

**Verdict: miss** (category `test-gap`, `missed_by: engine-realist`, severity
minor). Recorded as `review-misses/misses/endojs-endo-but-for-bots-pr475-54294cd3.md`,
joined cluster `cross-platform-test-coverage` → count=2, prs=[836,475], status=open.

Grounds: the engine-realist seat brief already charters the exact check that
would have caught this ("test covers both engines or documents why one is out of
scope"; "assertion passes on V8 but is engine-defined"). Emulated-only assertions
(`isView===false`, `view[i]===undefined`, the ImmutableArrayBuffer tag) are
engine-specific by construction and were latent false-greens under Node's
`exit 0` `test:xs`. Standing rule existed, did not bind → a miss, not new
direction.

**Threshold: HOLD (no dispatch).** Floor is K≥3 across ≥2 PRs; the cluster is at
K=2 (PRs 836, 475). Severity is minor (test-only, latent, runtime source is
native-safe, caught pre-merge), so no severity bypass. One more XS-divergence
test-coverage miss on a distinct PR trips the floor; left open.

**World-grounding / discrepancy note:** the primary attention job
`endojs-endo-but-for-bots-pr475-54294cd3` is **doomed** (`requeue-exhausted`,
5 requeue cycles) in `jobs/plan/` — it never completed. The directive's
deliverable nonetheless **exists**, delivered by a peer job
`endojs-endo-but-for-bots-pr475-verify-shimmed-claim-20260819`: commit
`0984dd89b` gated the emulated-only assertions behind a native-detection
predicate, follow-up plan job
`endojs-endo-but-for-bots-pr475-guard-passstyle-emulated-tests` (in `jobs/todo/`)
owns the pass-style tail, and reply comment 5349170331 was posted to erights.
The retro's judgment rests on this verified peer resolution, not the doomed
primary's (nonexistent) report.

Self-improvement: none this engagement — the discriminator, cluster fit, and
floor call were all well-served by existing tooling.
