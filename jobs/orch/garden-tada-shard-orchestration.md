---
order: serial
children: garden-tada-shard-01-design garden-tada-shard-02-read-tolerance garden-tada-shard-03-write-switch garden-tada-shard-04-migrate garden-tada-shard-05-cleanup
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-13T21:30:52Z
---

# Date-shard `jobs/tada/` by yyyy/mm/dd

Maintainer request (kriskowal, 2026-08-13): refactor the job dispatch machinery
and migrate the journal so `jobs/tada/` is indexed by `yyyy/mm/dd`, **so recently
completed work is easier to find**. That goal is the acceptance criterion; the
path shape is the means.

Scope at time of posting: `jobs/tada/` holds **4,521** flat entries, read by ~27
non-test scripts and touched by ~54 test files.

## Why serial, and why the order is not negotiable

The fleet is leader + followers that deploy independently, so there is always a
window where hosts run different code. That forces exactly one safe order:

1. **design** — settle basename lookup, the date source, the `common.sh`
   centralization, and the transition.
2. **read tolerance** — every consumer reads BOTH layouts. Behavioral no-op on
   today's flat tree. Must be deployed everywhere before stage 3.
3. **write switch** — new completions land sharded. Tree goes mixed, which is
   safe only because of stage 2.
4. **migrate** — move all 4,521 entries in one atomic CAS push.
5. **cleanup** — drop the fallback, add the find-recent affordance, fix the docs.

Running any stage before its predecessor has DEPLOYED (not merely landed) can
make completions invisible to a lagging host. Stages 3 and 4 each begin by
verifying deployed shas and stopping if a host is behind.

## Halt on child failure, deliberately

`--on-child-failure halt`. A partial migration or a half-converted reader set is
worse than a clean stop: `jobs/tada/` is the fleet's completion record, and
`post-job.sh` idempotency and `orchestrate.sh` child-detection both consult it.
A silent break there re-mints finished work or false-halts campaigns rather than
erroring visibly.

## The two failure modes to watch

- **`post-job.sh` idempotency** consults `tada/` by basename when no directive
  identity is given. A lookup that silently misses will either re-mint completed
  work or swallow a fresh directive. The design must state which way it fails and
  choose re-minting.
- **`orchestrate.sh` child-completion detection** reads a missing child as
  "vanished" and halts the campaign. That exact false-halt cost a 21-child
  campaign its launch on 2026-08-13 (fixed in `9393c3ce6d`); a bad tada lookup
  reintroduces it for every orchestration at once.
