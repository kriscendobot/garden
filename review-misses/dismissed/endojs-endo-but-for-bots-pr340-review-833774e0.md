---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr340-review-833774e0
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T12:03:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/340#discussion_r3796153710
identity: endojs/endo-but-for-bots#340:review:4951338822:retro
producing_role: none (contributor-authored)
missed_by: none
severity: minor
---

Inline review on `packages/daemon/src/networks/ocapn.js`: the maintainer applies
OCapN-spec expertise, doubting that the specification assigns a swissnum to the
bootstrap object (recalling the bootstrap as the implicit first export), and asks
the author to verify against the spec, cite, and correct. The primary review job
confirmed the point and renamed the mislabeled object from
`EndoOcapnBootstrap`/`BOOTSTRAP_SWISSNUM='endo-bootstrap'` to
`EndoPeerEntry`/`PEER_ENTRY_SWISSNUM='endo-peer-entry'` with cited docs (verified
present at PR head `claude/endo-daemon-ocapn-FkmHO`, lines 25–65/245–367).

Grounds: not an indictment of the garden's review process. Three independent
reasons converge on a dismissal. (1) **The critiqued code is not the garden's and
never passed a garden panel.** The mislabeled-bootstrap terminology was authored
by the contributor ph0ngb0t on 2026-05-22 ("feat(daemon): layered agent-binding
attestation on OCapN bootstrap"); #340 is a contributor PR (author kumavis, base
`llm`), and `journal/jobs/tada/` holds only weave/shepherd/conduct/review jobs for
it — no gauntlet or panel ever ran, because the garden assisted this PR, it did not
build it. The garden's auto-gauntlet invariant binds garden-produced feature
builds, not contributor PRs, so there is no `process`/avoidance shape here: the
evaluator was never obligated to run. (2) **No garden seat, skill, or standing
instruction encodes OCapN bootstrap protocol semantics.** The wire-watcher brief
covers in-band trust markers, parser divergence, and `alg:none`-style bypasses —
not "the OCapN bootstrap is the implicit position-0 export reached via
`getBootstrap()` with no swissnum." A grep of roles/skills/designs finds no seat
that demonstrably knows this, so even had a panel run, no seat's letter or purpose
was violated. (3) **The comment is first-stated domain expertise.** "Verify, cite,
and correct" is a maintainer bringing specialized spec knowledge nobody in the
review apparatus held in written form — the canonical new-direction shape, not a
violated convention the panel could have anticipated. The primary's deliverable
genuinely exists in the world (the rename and cited docs are at the current PR
head), so there is no false-resolution discrepancy to report.
