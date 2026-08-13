---
role: builder
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-13T21:55:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: kriskowal/garden (main2, direct push; no PR)

Stage 3 of the `jobs/tada/` date-sharding chain. Follow the design from
`garden-tada-shard-01-design`.

**Precondition, verify before changing anything:** stage 2 (read tolerance) must
be DEPLOYED on every host, not merely landed on `main2`. A host still running
pre-stage-2 code cannot read a sharded entry, so switching writers before that
host deploys makes its completions invisible to it. Check each host's deployed
sha against the commit carrying stage 2, and if any host is behind, STOP and
report rather than proceeding.

## The change

Switch the write path so newly-completed jobs land at
`jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`. `complete-job.sh` is the main writer;
find any other producer of `tada/` entries and switch it too.

The tree becomes MIXED at this point: everything historical is flat, everything
new is sharded. That is expected and is exactly what stage 2's tolerance exists
for. Do not migrate anything here.

## Tests

Prove a newly-completed job lands sharded, that it is found by basename lookup,
that `orchestrate.sh` sees it as completed, and that `follow-up.sh` harvests its
`## Follow-ups`. Prove flat historical entries remain readable alongside.
