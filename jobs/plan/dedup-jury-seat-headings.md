---
gate: blocked
blocked_on: collapse-jury-and-fixer-report-verbosity
priority: normal
role: fixer
posted_by: producer
posted_at: 2026-09-17T19:42:34Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Drop redundant seat-heading duplication in aggregated jury reports

Blocked on `collapse-jury-and-fixer-report-verbosity` landing first (same
`scripts/jobs/gardening/panel.sh` aggregate-assembly code region — read that
job's tada report and build on its result rather than reverting it).

Maintainer observation: many seat sections in the aggregate panel report
carry a REDUNDANT heading — the seat's own generated block repeats its name
as a heading a second time (sometimes with throwaway meta-narration before
it), on top of panel.sh's own `### $seat` heading the aggregate loop already
prints. Concrete example from this session (endojs/endo-but-for-bots#1281
round 6):

```
### assessor
Now I have the block shape. I'll produce the assessor's per-juror block.

### assessor

**Verdict:** request-changes
...
```

The first `### assessor` is panel.sh's own wrapper heading; the seat's LLM
output then narrates itself and repeats `### assessor` again before the
actual verdict. This is pure waste — doubled heading, plus a throwaway
sentence that says nothing.

## Fix

Two independent things to check and fix:

1. **The seat/juror prompt** (`roles/jurors/<seat>/AGENT.md` and/or whatever
   shared prompt scaffolding `run_seat` in `panel.sh` hands each seat) should
   not ask for or tolerate the seat re-heading its own output — the seat's
   job is to emit its verdict block content, not a document with its own
   title, since the aggregator already supplies that. If the prompt
   currently shows the seat an example block that includes a self-heading
   (a template artifact the seat is copying literally, including "Now I have
   the block shape..." style meta-narration), fix the template/example, not
   just tell the seat "don't do this" — a demonstrated bad example is a
   stronger prior than an instruction.
2. **Defense in depth in the aggregator**: since prompt compliance is
   probabilistic, have `panel.sh`'s aggregate loop (the same `### $seat`
   loop you're already touching for the `<details>` work) strip a
   seat-authored leading heading that exactly duplicates its own `### $seat`
   (case-insensitive, allowing for `###`/`**seat**`-style variants) before
   wrapping the block — so even if a seat's prompt drifts again later, the
   aggregate never shows the doubled heading. Keep this narrowly matched (an
   exact/near-exact duplicate of the seat's own name) so it never eats a
   legitimate seat finding that happens to start with a similarly-worded
   line.

Check across a sample of recent panel runs (not just this one PR) whether
this duplication is universal or seat-specific — that tells you whether the
root cause is a shared prompt fragment or something particular to how a
subset of seats respond.

Same going-forward-only scope as the sibling job: no retroactive editing of
already-posted comments.
