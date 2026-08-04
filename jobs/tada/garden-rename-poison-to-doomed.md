All work landed and verified. Cleanup done, inbox empty.

## Completion report

**Landed revisions**
- **main2 `dd30716f03`** — the holistic rename (rebased cleanly onto the moving tip, present on `origin/main2`).
- **journal2 `b4a813707c`** — the live-state migration of the 38 parked jobs.

**What changed (main2, 72 files: 4 renames + 68 edits)**
- Renamed the *poison* job-state vocabulary to *doomed* across `scripts/ roles/ skills/ designs/ context/ CLAUDE.md`: frontmatter fields (`poisoned:`→`doomed:`, `poison_signature:`→`doom_signature:`, `poison_count:`→`doom_count:`, `poisoned_at/on:`→`doomed_at/on:`), the notice-filename prefix (`doomed-<base>-<signature>.md`), and all prose/log text.
- **File renames** (via `git mv`): `poison-notice.sh`→`doom-notice.sh` (sole caller `reaper.sh` fixed; no shim — no external caller); tests `outage-poison-pause`→`outage-doom-pause`, `promote-plan-poison-reset`→`promote-plan-doom-reset`, `reaper-poison-park`→`reaper-doom-park`.
- **Env knobs** (operator-facing): `GARDEN_REAP_POISON_THRESHOLD`→`GARDEN_REAP_DOOM_THRESHOLD`, `GARDEN_POISON_SPOOL`→`GARDEN_DOOM_SPOOL`.

**Compatibility shims left in place (with retirement condition)** — retire all of these once every host's deployed sha includes this change (documented in `designs/job-board.md § the doom rename`):
1. **Dual-read fallbacks**: `orchestrate.sh` and `cnf-backlog-triple.py` accept both `doomed:`/`poisoned:`; `reaper.sh`'s re-doom accumulator reads `doom_count` then falls back to `poison_count`.
2. **Deprecated env aliases**: `common.sh` maps the old `GARDEN_*POISON*` knobs to the new ones when the new is unset, logging once per process.

**Deliberately NOT renamed** (a distinct word-sense — *contamination*, not job-state; would fail the grep but is correct): the journal-remote/partial-clone/`new_sha` "poison" in `common.sh`, `root-repo-guard.{sh,md}`, `triager.sh`, `repo-transfer.md`, and "registry-cache poisoning" in `node-lts-window-watch`. History (past `tada/` reports, notices, entries) left untouched.

**Live state**: 38 parked jobs in `jobs/plan/` migrated (all 5 fields each), bodies untouched, one batched journal commit. Verified promote-plan.sh strips the migrated frontmatter cleanly (no `doom`/`poison` tokens survive promotion).

**Notice-text defect** — fixed within wording scope: the deadline-overrun doom notice now prints the **actual handler budget in force** (captured at park time from the job's `handler-timeout:`, not the literal 2400s), and presents **both** failure shapes (genuine wall-clock overrun vs. a fast repeated failure flagged by elapsed-constancy) with how to tell them apart, instead of the false "hit its wall every cycle" boilerplate. *Follow-up left (larger than a wording fix, as permitted):* printing the **actual elapsed** and a hard genuine-vs-constancy discriminator needs new gardener→reaper plumbing (the deadline-overrun marker carries only a count, no elapsed); the notice now directs the maintainer to the handler log for elapsed rather than asserting it.

**Verification**: `bash -n` clean on all edited scripts; `py_compile` clean; shellcheck shows no new issues vs baseline; grep confirms no stray `poison` tokens remain outside the shims/contamination/rename-doc. Tests: `reaper-doom-park` 7/7, plus `orchestrate`, `outage-doom-pause`, `productive-cycle`, `proxy-park-body-hygiene`, `reaper-requeue-cap`, `completion-signal`, `reaper-live-handler-guard`, `gauntlet`, `handler-budget`, `run`, `elapsed-constancy-classifier` all green. Two tests have failures I confirmed **pre-existing on origin/main2** (identical baseline), unrelated to this rename: `timeout-classifier` subtest-4 (stale overrun-threshold expectation / cross-subtest state) and `promote-plan-doom-reset`'s three `---`-rule assertions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-rename-poison-to-doomed.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (12728126 cached reads)
- Output: 93377 tokens
- Cost: $10.847918000000004
- Wall-clock: 1844s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
