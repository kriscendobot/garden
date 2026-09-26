Done. Both suites green and the change is pushed to `main2` as `d4a3fa9eac`.

**Report**

**What I did** — hardened `scripts/jobs/annotate-plan.sh` so the producer-supplied note it appends to a parked plan job is stripped of the reaper/gardener cycle-marker family before it lands.

**The gap** — `post-plan.sh` strips the family on the way *into* `plan/` and `promote-plan.sh` on the way *out*, so a stale `<!-- garden-deadline-overrun: N -->` can't re-poison a job on its first evaluation after promotion. `annotate-plan.sh` was a **third** writer into a parked body, appending note text verbatim, so a producer piping a live job body as a note ("here is what the last cycle reported") re-introduced the whole family behind both strips. The promotion strip would still clear it at the exit, but in the meantime the parked body carries counters the job never earned — it's what every reader of `plan/` sees, it makes the promoter's `cleared=` provenance report a reset that never happened, and any other path that copies a parked body into a live cycle carries the counter to a reaper that trusts it. (Timely: the peer commit `df33583e94`, landed minutes earlier, routes watcher follow-ups — external comment bodies — through `annotate-plan.sh`.)

**Changed**
- `scripts/jobs/annotate-plan.sh` — the note goes through the same `strip_cycle_markers` / `cycle_marker_summary` helpers as the other two writers (one spelling of the family). The strip runs **before** the default dedup key is computed, so the key content-addresses what actually lands and two notes differing only in stale markers collapse to one annotation. What was cleared is recorded as a `cleared=` token on the `<!-- garden-annotation: … -->` marker, emitted only when something actually was — an ordinary annotation's marker is byte-for-byte what it always was. A note that is *entirely* cycle markers is refused (exit 1, naming the sanitization) rather than appending an empty annotation.
- `scripts/jobs/test/promote-plan-poison-reset-test.sh` — SUBTEST 5 (the annotation half): the strip, the preserved prose / non-cycle comments / `---` rules / parked body, the recorded and the absent `cleared=` token, the marker-only refusal leaving the parked body byte-identical, and end-to-end annotate → promote landing a `cleared=none` todo job rather than a laundered reset.
- `scripts/jobs/common.sh`, `skills/job-board/SKILL.md`, `designs/job-board.md` — the family comment and both docs now name all three writers into `plan/`.

**Verification** — `promote-plan-poison-reset-test.sh` 32/32 (was 20; +12 new), `annotate-plan-test.sh` 45/45 unchanged, `bash -n` clean, `shellcheck -S warning` shows only the pre-existing `GARDEN_TAG` SC2034. The new negative assertion ("no spurious `cleared=` token") was itself checked against a poisoned fixture to confirm it isn't vacuous.

**Follow-up (unrelated to this change, worth a look)** — pushing surfaced a failed gc on the shared root repo: `/home/kris/garden2/.git/worktrees/gardener-wt-fu-fu-improve-promote-plan-poison-reset-3-2/gc.log` holds `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6 / failed to run repack`. That's the exact "object store no longer maintainable" condition `garden-root-repo-guard` exists to catch, and a lingering `gc.log` disables git's automatic cleanup permanently. I did not touch the root repo (per the standing prohibition); someone should confirm the guard is alerting on it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-fu-improve-promote-plan-poison-reset-3-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2815487 cached reads)
- Output: 22898 tokens
- Cost: $2.869861499999999
- Wall-clock: 331s

<!-- garden-usage-end -->
