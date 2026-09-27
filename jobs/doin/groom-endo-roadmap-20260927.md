---
role: groom
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 21600
token-budget: 1500000
---
# Full grooming pass: designs/README.md on endojs/endo-but-for-bots@llm

Repository: `endojs/endo-but-for-bots`, directory `designs/` (+ `packages/*/designs/`),
roadmap branch `llm`. Read `roles/groom/AGENT.md` in full before starting — this
job's Skills, Operating norms, and Definition of done are ALL there and are not
repeated below. Run the **Full grooming pass** flavor, not a targeted pass.

Read `designs/AGENTS.md` on the fork first (metadata table, Status Values, the
Progress-Tracking contract) — you will be amending this file, so read it as both
instructions and the edit target.

## Why now, and the specific gap to close

A liaison-session spot-check (2026-09-27) found the ledger's own totals stale:

- `designs/README.md`'s last real bucket tally is dated **2026-09-10**: 202
  designs (49 Complete/Implemented, 37 In Progress, 49 Not Started, 39 Proposed,
  2 Active, 15 Reference, 3 Deprecated, 1 Draft, 4 Superseded, 1 Approved), plus
  cbor-codec and genie-integration each carrying their own non-bucketed status.
- The doc's own trailing prose logs roughly 15 individual status flips through
  2026-09-18, but repeatedly notes **"it does not re-tally the buckets; the
  recount remains owed."** No re-tally has landed since.
- A live tree walk today counts **241 design files** on `llm`
  (`designs/*.md` + `packages/*/designs/*.md`) — **39 more than the 202 the
  ledger has ever bucketed.** Some fraction of those 39 may already be covered
  by landed work; none of them have been checked.

So this pass has two jobs, not one: re-verify the ~202 previously-tallied rows
AND fold in the ~39 untallied files the ledger has never counted at all.

## Case-by-case depth (the maintainer's explicit ask)

Do not batch-guess. For every row that does not cleanly verify against real
PR/merge state, determine — individually, with evidence — which of these it is:

- **Redirected**: the design's scope moved into a different design or PR under a
  new name/framing; name the successor.
- **Superseded**: a later design or landed change makes this one moot; name what
  superseded it.
- **Consolidated**: this design merged into a broader one rather than shipping
  standalone; name the consolidating design.
- **Abandoned**: no successor, no landed work, and no open PR — genuinely
  stalled or dropped; say so plainly rather than leaving it ambiguously "Not
  Started" if the evidence points to abandonment.
- Or simply **confirm the existing status is still correct** — most rows will
  land here, and that is fine; the corrective work is what needs care.

## Tractability at this scale (do this, not a serial pass)

~241 rows is too much for one linear read-and-check. Split the design corpus
into roughly 6 batches (by milestone or by filename range — your call, but keep
batches disjoint and record which files landed in which batch) and dispatch one
subagent per batch via the Agent tool to do the real per-design investigation:
current file content + Status field, `gh pr list --search <slug> --state all`,
and where relevant the branch git log — each subagent reports its batch's
findings (claimed status → verified status, redirected/superseded/consolidated/
abandoned/confirmed, PR citations) back to you. You then consolidate every
batch's findings into the single edit and the single draft PR — do not let a
subagent open its own PR or edit the fork directly; only you do that, after all
batches report in. This mirrors the `groom-endo-designs-readme` (2026-08-17)
precedent, scaled to the corpus's current size.

## Everything else

Recount totals, re-fit velocity against measured merge cadence, reproject
milestones/timeline, re-derive the `### Dependency Graph`, validate it
(mermaid-validation skill), and archive any milestone gone fully complete —
all per `roles/groom/AGENT.md`. Append the pass note to `ARCHIVE.md` (do not
layer a new note at the head of `README.md`). Preserve the milestone-numbering
invariant and the Strategic Early Items carve-out; surface any resequencing
conflict in the draft PR rather than resolving it yourself. Build the drift
table (claimed → verified, with PR citations) so every correction is auditable.
Land as a draft PR against a frozen `llm-<sha>` snapshot per
[frozen-base-branch](../../skills/frozen-base-branch/SKILL.md) — never bare
floating `llm`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T07:16:53Z
