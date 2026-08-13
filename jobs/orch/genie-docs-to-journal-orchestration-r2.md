---
child-genie-docs-r2-02-delete-from-llm-reap-count: 0
child-genie-docs-r2-01-migrate-into-journal-host: endolin-garden-ece02cb4
child-genie-docs-r2-01-migrate-into-journal-reap-count: 0
order: serial
children: genie-docs-r2-01-migrate-into-journal genie-docs-r2-02-delete-from-llm
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-13T21:58:01Z
---

# Migrate endojs/endo-but-for-bots PLAN/TODO/TADA into the journal

Maintainer request (kriskowal, 2026-08-13), posted as a **follow-up to
`garden-tada-shard-orchestration`**: migrate the `PLAN`, `TODO`, and `TADA`
directories off the endojs/endo-but-for-bots `llm` branch into the garden
journal, and delete them from the branch.

Inventory at posting time: `PLAN/` 11 entries, `TODO/` 1 (only `.keep`, so
effectively empty), `TADA/` 69 — about 78 real documents once `.keep` files are
discounted.

## Serial, halt on failure

1. `genie-docs-r2-01-migrate-into-journal` — copy in, preserve cross-links, record
   provenance, count-match.
2. `genie-docs-r2-02-delete-from-llm` — delete from the branch via a PR, only after
   the journal copy is confirmed present.

`halt`, because after stage 2 the journal copy is the ONLY copy. A stage 1 that
half-succeeded must not be followed by a deletion.


## The trap this chain exists to avoid

These are **prose planning documents**, not job-board records. They are named
PLAN/TODO/TADA, which invites dropping them straight into the journal's
`jobs/{plan,todo,tada}/` — and that would be actively harmful. Those directories
are machine-read: `follow-up.sh` harvests `## Follow-ups` from everything in
`jobs/tada/` and converts it into real jobs and schedules, `orchestrate.sh` reads
presence there as child completion, `post-job.sh` uses it for basename
idempotency, and the date-sharding chain migrates its entire contents. Adding ~78
foreign documents would spawn phantom follow-up jobs, corrupt dedup, and hand the
sharder files with no completion date.

Stage 1 is therefore explicitly forbidden from writing into `jobs/` and must
choose a purpose-built location for non-job content.

## Second hazard: the cross-links

The documents reference each other with relative paths such as
`../PLAN/endo_posix_sandbox.md`. A move that does not preserve or rewrite those
leaves 78 documents quietly broken. A `git grep` over `llm` at posting time found
references ONLY from within the three directories — nothing in `AGENTS.md`,
`CLAUDE.md`, `README.md`, `CONTRIBUTING.md`, or `.claude/` — but `llm` moves, so
stage 2 re-verifies rather than trusting it.

## Why this is the r2 chain

The first attempt (`genie-docs-to-journal-orchestration`) halted at stage 1's
precondition, which required the date-sharding chain to finish first. The child
behaved correctly: it stopped clean and wrote nothing. The precondition itself was
the mistake. Stage 1 is forbidden from writing under `jobs/` and the sharding
chain only touches `jobs/tada/`, so the two never overlap and there was nothing to
wait for. It has been removed rather than converted into a real `blocked_on` edge.
