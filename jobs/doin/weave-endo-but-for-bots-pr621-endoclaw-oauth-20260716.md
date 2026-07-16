# weave #621 — rebase endoclaw-oauth refinement onto fresh `llm`

**Repo:** endojs/endo-but-for-bots. **PR:** #621
(https://github.com/endojs/endo-but-for-bots/pull/621) — "design: refine
endoclaw-oauth as the connector credential foundation (settle first-mint flow)",
OPEN, un-drafted, base `llm`, head `design/endoclaw-oauth-foundation`.

**Task:** The PR has drifted behind `llm` and is now `CONFLICTING / DIRTY` (the
conflict is in the design docs — `designs/README.md` milestone/dependency graph
and/or the design body — not substance). All 5 CI checks are green and the
maintainer's requested design round (recursive partition/delegation with
narrowing; the named composite "caretaker-attenuation" pattern) already landed on
the head (commits 2026-07-13). **Rebase the head onto current `origin/llm` and
resolve the doc conflict without altering the design substance** (net-diff
invariant: the resolved tree must preserve every intentional design change on the
head; only the mechanical merge markers get reconciled). Push the rebased head to
`design/endoclaw-oauth-foundation`, confirm CI re-greens, and leave the PR
un-drafted and mergeable so the maintainer can one-click merge on re-review.

**Why:** #621 is the deepest unmet node of the `@endo/exo-google-sheets` tree —
the entire downstream (OAuth exo → `@endo/google-sheets` → `@endo/exo-google-sheets`)
is dammed behind it. Keeping it green + mergeable removes all friction from the
maintainer's pending re-review + merge.

**Authorization:** This job authorizes push to the PR head branch
`design/endoclaw-oauth-foundation` on the endojs/endo-but-for-bots fork only.
Read-only otherwise on `endojs/*`; never push to `llm` or any upstream branch.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-16T16:23:38Z
