Pre-push gate stages that run the project's own scripts now have a time limit and a memory limit. Hitting either stops the whole gate at once with a new exit code, 3. The change is pushed to `main2` as `9b83c6e34e0`, and `scripts/jobs/test/pre-push-gates-test.sh` passes after the change, including the new cases.

**What changed**
- **`scripts/jobs/gardening/pre-push-gates.sh`:** the format, lint-fix/`lint:fix`/`lint --fix` and typecheck stages each run in their own session (`setsid`). The gate sums memory use across the stage's whole process tree about once a second and kills the session when it goes over the memory limit. At the time limit it sends TERM, waits briefly, then KILL.
- **What counts as resource exhaustion:** going over either limit, a Node heap-exhaustion abort (found in the stage output), or a SIGKILL death (exit 137, usually the kernel's out-of-memory killer). The gate prints `resource-exhausted (<reason>)` with the last 40 lines of output and tells the agent not to retry with a larger heap. It then exits 3 without running later stages or probes. The existing codes are unchanged: 1 for probe findings, 2 for typecheck.
- **Settings:**
  - `GARDEN_PRE_PUSH_RESOURCE_LIMITS=0` turns both limits off and restores the old unbounded run.
  - `GARDEN_PRE_PUSH_STAGE_WALL` is the per-stage time limit (default 1200 s; 0 turns it off).
  - `GARDEN_PRE_PUSH_STAGE_MEMORY_MB` is the per-stage memory limit (default 25% of total RAM; 0 turns it off).
  - `GARDEN_PRE_PUSH_DEADLINE_MARGIN` keeps time free before the job's deadline (default 300 s).
- **Deadline safety:** `scripts/jobs/gardener.sh` now passes the job's absolute deadline to the handler as `GARDEN_HANDLER_DEADLINE_EPOCH`. Each stage's time limit is cut so the stage ends at least the margin before that deadline. If there isn't enough time left to start a stage, it is not started and is reported as resource-exhausted. This leaves the agent time to write its report instead of being killed mid-stage.
- **Tests:** the new cases cover the memory limit (a 300 MiB process against a 64 MiB limit), the time limit (including a leftover background child, with no stray processes afterwards), a Node heap abort, the deadline margin, and limits turned off. Each limit test also checks that typecheck and the probes never ran. Two related tests, `codex-completion-nudge-test.sh` and `panel-seat-timeout-test.sh`, still pass.
- **`skills/pre-push-gates/SKILL.md`:** new section on the limits and settings, exit 3 added to the exit-code docs, and a dated changelog entry.

**Follow-ups**
- Memory is checked about once a second, so a very fast allocation spike can get past it. In that case the out-of-memory-kill and heap-abort checks report it instead.
- The 25%-of-RAM default applies to each stage separately, so several gardeners running lint at the same time can still add up to more than that. If that becomes a problem, the next step is a host-wide limit, for example one based on free memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-bound-pre-push-lint-resource-use.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1767002 cached reads)
- Output: 18319 tokens
- Cost: $1.4475163999999998
- Wall-clock: 275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
