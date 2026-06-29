All deliverables are in place. Inbox is empty; PR #16 is DRAFT, `design/gardener-bid-accept-market → main2`, OPEN.

---

## Completion report

**Job:** `design-gardener-bid-accept-market` — design-only proposal for a bid/accept job market with differentiated, reputation-bearing gardeners (issue kriskowal/garden#15).

**What I did**
- Grounded in the live machinery: `designs/job-board.md`, `designs/gardening-state-machine.md`, `designs/judicial-workflow.md`, `skills/job-board/SKILL.md`, `scripts/jobs/claim-job.sh`, and the full issue #15 thread (re-fetched and treated as data). (`skills/model-selection` is referenced by the directive but not present in this checkout; I grounded the model axis on the issue's own framing.)
- Wrote `designs/gardener-bid-accept-market.md` (Status: Proposed) covering all six required areas: bid/accept lifecycle over the journal CAS; differentiation by role and model; a per-kind append-only reputation ledger; the AMiX objective/subjective acceptance oracle with no-loss rejection unwind; future directions (subcontracting, the meta-machine, todo/tada-replay bootstrapping) with open questions; and a shadow-first, race-by-default, permanently dual-mode migration. The framing makes the "garden is a degenerate Gimix" reflexion load-bearing — every new mechanism reduces to today's behavior when the bid window is empty.
- Added the index row in `designs/README.md`.

**What changed / state**
- DRAFT PR **kriskowal/garden#16** (`design/gardener-bid-accept-market` → `main2`), no source/behavior change, build chain not run.
- Top-level summary comment posted on **issue #15** (left OPEN for the submitter to close).

**One process note (transparency):** the gardener wrapper instructs pushing to `main2`, which I did first — but garden convention (`designs/README.md` § PR-against-garden exception) is that *designs* go through a DRAFT PR, not a direct land. I corrected by pushing a review branch, backing the design out of `main2` with a forward-only revert (commit `cb8066c8f`, deletes only the two design files), then rebuilding the branch as a fresh divergent commit so the PR shows a clean diff. `main2` currently does **not** contain the design — it lands when the maintainer merges #16.

**Follow-ups**
- On acceptance, implementation splits naturally along the phased rollout (Phase 0 `market` field + opt-in kind → Phase 1 shadow `reputation/` ledger → Phase 2 scoring selector → Phase 3 widen-by-evidence).
- The meta-machine future direction is explicitly gated on a separate Gimix-on-Endo design pass.
- Any follow-on job must carry the ISSUE NOTE block verbatim (`issue_spine: issue-kriskowal-garden-15`, `issue_url: https://github.com/kriskowal/garden/issues/15`, `submitter: kriskowal`).
