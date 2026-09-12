# Diagnosis: panel runs recorded as simultaneous seat errors

| | |
| --- | --- |
| Created | 2026-09-12 |
| Author | builder (job `diagnose-panel-seat-error-rate`) |
| Status | Report; recorder observability fix landed with this report |
| Scope | `scripts/jobs/gardening/panel.sh`, `scripts/jobs/panel-run-record.sh`, journal `panel-runs/` and matching job lifecycle records |

## Result

The reported 19.6% simultaneous-seat failure rate does not exist. At the exact
444-record journal snapshot, 87 records have terminal `disposition: error`, but
only 14 have every recorded seat classified as `error`. The query that produced
19.6% treated the record disposition as if it were the seat verdict vector.

The actual all-seat records have two established causes:

1. Twelve seven-seat records on 2026-08-31 are interruption artifacts. The
   supervising gardener session ended while `panel.sh` was still running. Process
   teardown interrupted all in-flight seats, then the panel's EXIT recorder
   labeled the unfinished panel `error` and mapped every empty `pending` seat file
   to `error`. These are not seven independent provider responses. The panel
   record is an effect of the stage interruption, not its cause.
2. The 2026-07-30 PR #893 incident was a real shared account quota failure. The
   surviving stage report says 27 of 28 seats returned the same weekly-limit
   message. It is one bounded provider incident, not a persistent background rate.

The remaining all-seat record, PR #867 on 2026-07-29, has no surviving seat
stderr or session transcript. Its empty blocks establish that no seat verdict was
returned, but do not distinguish interruption from a shared provider failure.

## The corrected count

The snapshot is journal commit
`454d3e0edaf7267c5bc82ba95aeb92d83f619040`, which contains exactly 444 Markdown
files under `panel-runs/`. Grouping their frontmatter gives:

| disposition | records |
| --- | ---: |
| `must-fix` | 282 |
| `error` | 87 |
| `seat-error` | 43 |
| `passed` | 18 |
| `max-rounds-exceeded` | 9 |
| `passed-no-review-surface` | 3 |
| `decider-error` | 2 |

For each of the 87 `error` records, splitting every `seat verdicts` line and
requiring every token to end in `=error` leaves 14 records, or 3.2% of the
snapshot. The other 73 records contain at least one real verdict class. The 14
break down as follows:

| period | shape | records | host |
| --- | --- | ---: | --- |
| 2026-07-29 | code, 8 seats | 1 | `endolin-garden-ece02cb4` |
| 2026-07-30 | code, 16 seats | 1 | `endolin-garden2-5bcdff64` |
| 2026-08-31 | design, 7 seats | 12 | `endolin-garden-ece02cb4` |

The twelve 2026-08-31 run IDs are `fe4630bc00e2`, `f9d9ef6274bd`,
`1622712678ca`, `8c2a91dfe59c`, `3ad3df1bb63a`, `f9358540eaa8`,
`4a6750febf04`, `6a5721076e24`, `65d6e632811a`, `aacebcef4ed5`,
`dc91abfb690e`, and `ccfe12e5c256`. They cover eight PRs and several base-ref
forms. Their apparent design-panel correlation comes from the historical design
panel having seven seats, all launched in one concurrency wave. It is not a
specific prompt or diff correlation.

The all-seat failures are therefore not spread thinly through the month. Twelve
of fourteen occur in a twelve-hour burst on 2026-08-31. The persistent 19.6%
pattern belongs to the broader default-disposition bucket, not this verdict
shape.

## Evidence for interruption

### Lifecycle timestamps

Every one of the twelve 2026-08-31 records lands within 22 seconds of a matching
panel-stage `outcome: requeue` usage event. All matching durable progress reports
classify the handler as `exit-0-unsatisfying`: the gardener process returned
without the completion signal. Examples:

| stage | panel record | record time | usage event |
| --- | --- | --- | --- |
| PR #1018 panel 1 | `fe4630bc00e2` | 02:24:29 | requeue at 02:24:37 |
| PR #1013 panel 1 | `f9d9ef6274bd` | 03:28:25 | requeue at 03:28:21 |
| PR #241 panel 2 | `3ad3df1bb63a` | 08:30:07 | requeue at 08:30:00 |
| PR #1016 panel 6 | `65d6e632811a` | 12:36:07 | requeue at 12:36:11 |
| PR #1098 panel 3 | `ccfe12e5c256` | 14:18:06 | requeue at 14:18:01 |

The supporting ledgers are the matching files under `usage/`, such as
`usage/endojs-endo-but-for-bots-pr1018-gauntlet-panel-1.jsonl`, and progress
entries such as
`entries/2026/08/31/022448Z-progress-gardener-8b8b23.md`. Across all 87 generic
`error` records, 47 are within 30 seconds of a matching usage requeue and none is
within that window of a successful completion. Fifty are within 60 seconds. This
also explains much of the broader background bucket without asserting a cause for
the records that lack a nearby retained usage event.

These agent sessions lasted 41 to 261 seconds. They did not approach the panel
role's 7,200-second handler budget, so the 2026-08-31 cluster is not evidence for
a handler-budget overrun.

### Surviving stage and seat transcripts

The completed report
`jobs/tada/endojs-endo-but-for-bots-pr1018-gauntlet-panel-1.md` says two earlier
agent sessions were torn down mid-panel and left zero-byte seat outputs. A third
attempt launched the same panel under `setsid`; it survived the agent session,
returned `must-fix`, and posted the review. This is an observed recovery from the
same PR, diff, base, panel kind, host, and provider.

The host-local transcript directory for PR #241 panel 2 contains seven seat
sessions ending at 08:29:56 through 08:29:58, immediately before record
`3ad3df1bb63a`. The transcripts stop at tool results or internal latch events and
contain no terminal verdict. The corresponding durable record at 08:30:07 has
seven `error` classes. That is the shape of group teardown, not seven completed
refusals or provider errors.

### Reproduction and code path

A hermetic reproduction launched a two-seat panel in a new process group, waited
until both `.status` files said `pending`, then sent SIGTERM to the group:

```sh
setsid env GARDEN_CODE_SEATS="assessor typist" \
  GARDEN_PANEL_CONCURRENCY=2 FAN_SLEEP=30 \
  GARDEN_PANEL_SEAT=panel-parallel-fanout-stub.sh \
  bash scripts/jobs/gardening/panel.sh worktree 606 HEAD~1 &
kill -TERM -- "-$panel_process"
wait "$panel_process"
```

The observed panel exit was 143. Before the recorder fix, the metadata disposition
was `error`, both seat blocks were empty, and both statuses remained `pending`.
The old `classify_seat` ignored status and converted an empty block to `error`.
This is the exact durable shape of record `fe4630bc00e2` and the other interrupted
all-seat records.

The shared mechanism is precise:

1. `run_seat` writes `pending` and truncates its output before invoking the seat.
2. A supervisor teardown signal reaches the panel process group during fan-out.
3. The EXIT trap still calls `emit_panel_record`.
4. `PANEL_DISPOSITION` is still its unexpected-exit default, `error`.
5. The recorder sees empty blocks and previously labeled each one `error`.

No common PR input, base ref, malformed prompt, or fan-out guard is needed to
produce the vector.

## The proposed failure chain is reversed

For the interruption cluster, the chain is not:

```text
seven seat errors -> no verdict -> handler failure -> requeue exhaustion
```

It is:

```text
agent session ends without completion -> process-group teardown interrupts panel
-> EXIT trap records unfinished files as errors -> stage is requeued
```

PR #1018 demonstrates recovery. Its next durable attempt completed the panel and
the gauntlet continued. That gauntlet eventually halted because the panel/fix loop
did not converge, not because the all-seat record made the panel stage impossible.

Repeated agent-session termination can still exhaust the reaper and halt a
gauntlet. The missing stage marker and the all-seat record then have the same
upstream cause; the record does not cause the missing marker.

PR #893 is the separate exception. Its stage report
`jobs/tada/ebfb-doc-package-json-cross-tool-semantics-gauntlet-panel-1.md` preserves
the actual seat error: `You've hit your weekly limit`. A shared provider account
quota can make all seats fail together, but this incident is bounded to the quota
window and cannot explain a month-long 19.6% rate.

## Other default `error` records

The 73 `error` records with one or more real seat verdicts do not prove a decider
failure. A signal after some or all seats finish produces that shape too, and the
lifecycle correlation supports that explanation for many records.

One independent control-flow bug was nevertheless present: the decider's retry
loop used a bare command-substitution assignment under `set -e`. A nonzero
foreperson exit aborted the panel before its promised retry and left the default
disposition. Commit `6e393da9e7` now captures the status and stderr, retries, and
records exhausted attempts as `decider-error`. Its regression test proves the bug
and fix, but the historical records discarded decider stderr, so they cannot prove
how many times that path occurred. Source comments no longer claim it was the
dominant historical cause.

## Fix and remaining work

The established recorder defect is fixed with this report:

- `panel.sh` traps HUP, INT, and TERM explicitly and records `interrupted` while
  preserving the signal-derived exit code.
- `panel-run-record.sh` records the exit code and maps a seat whose status is still
  `pending` to `interrupted`, not `error`.
- The EXIT writer is confined to the main panel process, so a background seat
  subshell cannot own the terminal record.
- `panel-run-record-test.sh` reproduces group SIGTERM and asserts exit 143, panel
  disposition `interrupted`, and two `interrupted` seat classes.

This makes future records distinguish provider failure, exhausted decider,
ordinary unexpected exit, and supervisor interruption. It does not claim to stop
the supervising agent from ending early.

The operational follow-up should target lifetime ownership, not increase the
panel budget without measurement. Run the deterministic panel process outside the
ephemeral agent tool session, or require the stage agent to poll the running panel
through completion. Persisting completed per-seat blocks would also make a requeue
resume only unfinished seats. The newly recorded exit code and interruption class
will show whether that change removes the cluster. Genuine `seat-error` and
`decider-error` outcomes should use the gauntlet's bounded stage-retry path rather
than be interpreted as review verdicts.

The exact reason each historical agent session returned normally without its
completion signal is not recoverable from the durable journal after its live tool
session was pruned. That boundary is now explicit: the evidence establishes
process interruption and recorder misclassification, but not the upstream agent
runtime decision that initiated every teardown.
