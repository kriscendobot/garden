Done. Final inbox check was clean; worktree torn down. Here is my completion report.

---

## Completion report — `continue-sturdyref-510-endor-syscall`

**Outcome:** Design continued and pushed; #511 deferred; #521 typo surfaced. One material deviation from the job spec (below).

### Deviation: #510 was already merged
#510 had **merged** into `llm-65b0abe` at `95ecf86` ~17 seconds *after* this job was claimed, and its head branch was deleted — so "push to #510" was impossible. I continued the design as a **successor draft PR off the same base** (`llm-65b0abe`), which is the faithful reading of "continue development on #510." Flagged to the maintainer via the bus.

### What I did
- **New PR #539** (draft) — `design(sturdy-refs/endor): continue #510 …`, head **`333249e869f46672e79c676921d2228655b61c2b`**, on branch `design/sturdy-refs-endor-syscall-followup`. Single commit; 287 insertions / 116 deletions to `designs/sturdy-refs-endor-syscall.md`.
- Folded the synthesis grafts + review into the doc:
  - **Proactive per-turn `deleteExport` promoted from a deferred open-question to a REQUIREMENT** — new *Determinism: proactive per-turn export drop* subsection. The implicit/ephemeral path is now GC-timing-independent, so **both** retention paths are deterministic. Reconciled the determinism narrative end-to-end (Rule 1/2, sequence diagram, Composition, comparison table, acceptance criteria, and the two open questions that assumed a GC-driven implicit path — now resolved). Swept the doc clean of stale "only the explicit path is deterministic" language.
  - **`FinalizationRegistry` demoted to an optional, off-by-default leak detector** (diagnostic, never retention) — new subsection; this is the only role #511's mechanism keeps.
  - **Local-only-at-the-boundary rule** — new subsection; every worker-held reference/edge is local to the daemon boundary, which bounds the proactive drop and keeps the boundary FinReg-free.
  - **Flexible optional `type` hint** on the SturdyRef (`makeSturdyRef(location, type?)`), advisory only, excluded from structural identity.
  - Reaffirmed OCapN-instance-specificity + inert-data-box framing (both had already been folded pre-merge at `a2ea6f0ba`; verified no stale `E(sturdyRef)`/HandledPromise-as-target language).
  - Added matching test-plan and acceptance-criteria entries; aligned with **#521**.
- **#511 marked deferred** — comment posted.
- **#510 (merged)** — pointer comment to #539.
- **#521 typo surfaced** — `getStudyRefLocator` → `getSturdyRefLocator` (the "Study" misspelling appears across source, exports, and tests, with a self-aware "Spelling note" comment). Flagged on #521 and to the maintainer; did not edit their PR.
- Messaged the maintainer (liaison) with the deviation, the #539 link, and two open calls.

### Follow-ups (left for the maintainer)
1. **#539** is a draft off the stacked base `llm-65b0abe` — awaiting go-ahead to run the gamut / un-draft.
2. **#521 rename** `getStudyRefLocator`→`getSturdyRefLocator` — offered a fixer dispatch on request (it's the maintainer's PR).
