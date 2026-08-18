---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree). Design-doc job (designer), no application code.

PR #41 (`designs/git-remote-capability.md`, the capability-addressed git remote) merged to `main` at b23b091 on 2026-08-18. Its § 8 explicitly defers one follow-up to a separate job, and #39 records the same dangling thread from the other side:

- `designs/git-remote-capability.md` § 8: "#40 `designs/vitals-weblet.md` (open) — needs a follow-up reconciliation; not rewritten here. ... #40's delivery substrate assumption will need reconciliation once this design lands ... This design does not rewrite #40 — that is a separate job."
- `designs/git-content-substrate.md` (#39, merged) § "Companions" names `designs/vitals-weblet.md` as "a consumer whose publishing assumption will need reconciliation", and its ~line 329 says "That assumption will need a separate reconciliation after the superseding Git [remote design lands]."

The superseding design has now landed, so do that reconciliation. `designs/vitals-weblet.md` (#40, merged) still builds its content sourcing directly on #39's poll-a-public-branch syncer: its "What this is" opening, § "The delivery substrate" bullets (source-named mutable record, poll-based on-box syncer), the `weblet-git-sync.timer` mermaid node and `git fetch (poll)` edge, the poll-interval latency budget, the source-registry registration, and the readiness table row citing git-content-substrate G1–G3.

Task: revise `designs/vitals-weblet.md` so its delivery substrate reflects the superseding design, per § 8's own framing — plainly, the vitals weblet becomes a **partition the garden's leader pushes to** (the fleet already writes `vitals/fleet.json` / `vitals/garden.json`; a `git push` of that subtree to a partition it holds a write-capability for replaces "commit to `journal2` and wait for a poll"), or the polled-mirror special case is deliberately retained as a bridge — state which, and why, rather than leaving both open. Update every dependent detail that changes with it: the latency budget (push-triggered, no poll interval), the mermaid diagram, the registration/deployment story, the readiness/dependency table, and the companions/status header. Keep what § 8 says is unaffected and still correct: #40's rendered view, its privacy carry-over, and its isolation-floor fit. Preserve the doc's mermaid validity (parse-only re-validation) and the repo's prose conventions (typist-friendly code points, pet-name spelling, no Latin shorthand).

Scope discipline: this is a design-document reconciliation only — no code, and do NOT act on § 12 of the git-remote-capability design ("Consequent work in `endojs/endo-but-for-bots` (named, NOT actioned)"), which explicitly opens, files, and proposes nothing pending the maintainer's call. Land as a PR against `main` in the usual way for this repo.
