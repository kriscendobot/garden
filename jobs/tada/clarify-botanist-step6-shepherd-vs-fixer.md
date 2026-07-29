Work is committed and pushed as `4f7525c214`; all 7 check suites pass.

## Completion report

**Job:** clarify botanist step 6 (shepherd vs fixer) + the missing verdict. Garden-library change, `roles/botanist/AGENT.md` only.

### Prior state
A peer job had already landed `fb951897d3` ("make step 6 fixer escalation conditional") ten minutes before I claimed this. It removed the flat contradiction but re-anchored the boundary on **ability** ("escalate when you cannot land the repair yourself"), which fails *unsafe*: an agent that can type a change reads that as authorization to make a decision that was not its to make. None of the edge cases, the major-bump framing, or the verdict question were addressed. I rewrote from there.

### What changed

**Step 6, the boundary.** Re-anchored on the *kind of judgement the repair needs*, not size and not ability. A remedy that is a mechanical consequence of the upgrade (renamed export, changed specifier form, moved subpath, tightened lint/type rule) is the botanist's to push; design judgement about the project's own code is `next: fixer`, a conflict `next: weaver`, deeper `next: liaison`. Stated the major-bump case round the way the reporter observed: Dependabot edits only the manifest and lockfile, so a major is red by construction and the push is the ordinary path, not the exception. Kept the PR 867 evidence inline (fully-qualified URL, the two v2 breaks, 534 tests / 0 lint / 23 green).

**The three edges**, as instructed:
- *Size is not the test.* A 200-site rename is still shepherd-scope, citing the shepherd's 2026-06-14 retirement of file count. This keeps the two roles agreeing rather than introducing a threshold only the botanist has.
- *A change to an observable contract is not mechanical, however mechanical the edit looks* (wire format, published export, an error callers match on, a default that silently flips — happy-dom 20.x is the file's own worked example). Routed to `next: liaison`, since it is the shepherd's *design decision needed* impasse, not a contextual one.
- *Mechanical here but forces a choice elsewhere* → `next: fixer`.

**Fail-safe tie-break.** Added an explicit asymmetry argument: a needless fixer job costs one re-derivation; a migration pushed on someone else's judgement lands a design decision under a dependency bump's commit message with green CI arguing for it. "I can type this change" is not the test.

**The missing verdict — I chose the smaller change.** No fifth verdict. MERGE-NOW's definition now says the green may be one the botanist created, with a **disclosure duty** (breaking changes, substitutions, commits, green run URL), echoed in step 10 and the definition of done. Reason: a migration is a *route to* MERGE-NOW, not a disposition — it disposes of the PR identically. I verified the cost of the alternative: the three-verdict vocabulary is echoed in `roles/COMMON.md:83` and `scripts/jobs/dependabot-watcher.sh:393`, so a fifth verdict would force a synonym on both plus the ledger and the conductor gate, to name how the green was obtained rather than what happens next.

**What the formulation deliberately excludes:** it does not make file count, commit size, or number of touched packages an escalation trigger; it does not give the botanist a way to decline a migration it merely finds tedious (declining is not REJECT — see below); and it does not let "mechanical" cover anything that changes an observable contract, even when the diff is one line.

**Two gaps I closed to keep it coherent** (small, in-file):
- An escalation is *not* a terminal verdict, and leaving the PR on one hits the existing anti-pattern (an open Dependabot PR suppresses its successor). It now takes the ledger row and the daily backstop leg an embargo takes; no precise one-shot, since there is no floor to place it at.
- REJECT's "downstream API break the project cannot yet absorb" now excludes a break a migration would close or an in-flight escalation will close, so a migratable break cannot be routed to a close.

Plus two anti-pattern bullets (don't hand a fixer a diagnosis you hold; don't push a migration that decides something for the project).

**`roles/shepherd/AGENT.md`: no change needed.** I checked the reciprocal claim. The shepherd already says scope alone is not an escalation criterion and that `next: fixer` means a *contextual* impasse with the default being self-repair. The tension was one-sided, in the botanist only; my formulation is written to cite and inherit the shepherd's rules rather than restate or contradict them.

### Verification
`tests/checks/run.sh`: 7 suites, 0 failures (includes the CLAUDE.md inventory-drift and double-space-separator checks). House style checked mechanically: no new em-dashes, no Latin shorthand, GitHub URL fully qualified.

### Follow-up (out of scope, flagged to the maintainer)
The shared root repo's object store is unmaintainable: `/home/kris/garden2/.git/gc.log` (dated 2026-07-28 23:52) reads `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, with identical copies in seven per-worktree git dirs, the oldest from 2026-07-23. That is precisely the condition `garden-root-repo-guard` is described as catching, so either it is not running on this host or it does not repair this shape, and the missing object may be real corruption rather than just a stale log. I did not touch it (repair means running git in the deployed root). Sent to the maintainer inbox as `20260729T015413Z-2a8d23`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/clarify-botanist-step6-shepherd-vs-fixer.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1360850 cached reads)
- Output: 18326 tokens
- Cost: $1.8618190000000001
- Wall-clock: 274s

<!-- garden-usage-end -->
