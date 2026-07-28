Everything is done and pushed. Here's my completion report.

---

## Completion report: staged-gauntlet-build

Implemented the staged gauntlet per `designs/staged-gauntlet.md` and pushed directly to `main2` (commit `5bdb5e444b`, rebased over a concurrent `kimi-k3` commit; no PR, per garden convention). 11 files, +1166/−51.

### What I built

1. **`common.sh`** — added `JOBS_GAUNTLET="jobs/gauntlet"` beside `JOBS_ORCH`, plus `gauntlet_*` record-field readers (kind/stage/iteration/max_iterations/current_child/state/repo/pr_number/pr), all built on the existing `plan_field` reader.

2. **`post-gauntlet.sh`** — idempotent producer of `jobs/gauntlet/<g>.md` with the design frontmatter; no-ops if a record or `tada/<g>` exists (mirrors `post-orchestration.sh`). Parses the PR via the shared `parse_pr_ref`. Flags: `--build-job`, `--probe`/`--kind`, `--max-iterations`, `--by`.

3. **`gauntlet.sh`** — the deterministic, leader-only, no-`claude -p` driver modeled on `orchestrate.sh`. Reuses the `child_state`/CAS-record-update/`finish_orch`/`orch_notify` substrate. Per tick: reads `current_child` board state (active→wait, failed→halt+surface, done→transition), parses the `<!-- gauntlet-stage-result: <stage>=<result> -->` marker, and applies the full transition table (clean→panel-1; panel pass→undraft/done(probe); panel must-fix→fix-k; fix→panel-(k+1) or halt at max_iterations; undraft→done). `still-pending` atomically re-posts the same stage on a fresh budget (stable base → session resume); a `done` child with no parseable marker halts **fail-closed**. The four stage bodies (clean/panel/fix/undraft) are composed inline as thin `role: gardener` jobs that call the existing `panel.sh`/`ci-wait-merge.sh`/`safe-push-pr-head.sh`/coverage scripts and emit their marker; clean/fix carry the CI-sized handler budget with a CI deadline kept under it so `still-pending` fires before a handler kill.

4. **`garden-gauntlet.{service,timer}`** — leader-only via `ExecCondition=is-main-host.sh`, run through `self-heal-run.sh`, absolute `OnCalendar=*:02/3`. Auto-discovered by `install-units.sh`'s glob (verified: timer enabled, service treated as timer-paired); not in `EXCLUDED_UNITS`.

5. **Producers switched to records** — `auto-gauntlet-handoff.sh` records a gauntlet instead of the monolith (probes still skip, matching CLAUDE.md's "auto-gauntlet is for mergeable-feature builds, not probes"; the `--probe` capability exists on `post-gauntlet.sh` for deliberate/explicit paths). `comment-watcher.sh` and `mention-watcher.sh` `run the gauntlet` paths create a record via a focused intercept branch (new `gauntlet_recorded` post-confirm guard, `GARDEN_*_GAUNTLET_POST` overrides), guarded against a missing PR number.

### Acceptance criteria — ran and observed

- **`gauntlet-test.sh`** (new, hermetic, 8 subtests / 22 assertions): clean→panel→undraft happy path, panel→fix→panel convergence, non-convergence halt at max_iterations, vanished-stage halt+surface, probe-never-un-drafts, still-pending re-post, no-marker fail-closed halt, idempotent in-flight re-tick — **all 22 pass**.
- **`auto-gauntlet-handoff-test.sh`** (rewritten to the record shape) — **pass**.
- **`panel-single-round-test.sh`** and **`panel-parallel-fanout-test.sh`** — still **green**.
- **`mention-watcher-test.sh`** — **pass**. **`comment-watcher-test.sh`** — my MP2b rewrite (now asserts a record + ack) passes; the only remaining failures are **3 pre-existing, environmental jq-masking assertions** that fail identically on a clean HEAD checkout (unrelated to this work).
- Every new/changed script is `bash -n` clean and `shellcheck -x -S warning` clean; I added zero new shellcheck warnings to the two edited test files (verified against HEAD).

Fixed one real bug during testing: an empty marker made `read` hit EOF and `set -e` aborted the whole tick — now `|| true` with the empty case handled explicitly.

### Post-deploy follow-ups (for the liaison to schedule)

These are **not** part of this build and require the `garden-gauntlet` unit deployed to the garden root via a drained `deploy-garden.sh`:
- **Live demonstration** on one real PR (each stage inside budget, chain reaches un-draft).
- **Migration of the gauntlet-shaped poisoned jobs** as gauntlet records: `endo-sturdyref-…` (#871), `finbot-pr5-panel`, and the #755 case (pick up as a narrow `<g>-undraft` if the in-flight monolith finishes, else a stage-pinned record). The non-gauntlet-shaped poisoned jobs stay flagged for their own decomposition.

### One decision to flag
Probe handling: I kept `auto-gauntlet-handoff.sh` **skipping** probes (no auto-record), honoring CLAUDE.md's "auto-gauntlet invariant is for mergeable-feature builds, not probes" and the existing tested behavior, while the driver + `--probe` fully support a `kind: probe` record (clean→panel→done, never un-drafts) for deliberate/explicit or migration use. The design's "a probe creates a kind: probe record" is satisfied for explicit records; if the maintainer instead wants the **auto** handoff to record probes too, that's a one-line change to `auto-gauntlet-handoff.sh` plus a test flip.

Note: my dedicated worktree contained several stray files that were **not mine** (`bin/pnpm`, `bin286/`, `pr661-bin/`, `tmp/`, `skills/consolidate-maintainer-inbox/`, a modified `roles/liaison/AGENT.md`) — I committed only my 11 explicit pathspecs and left those untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/staged-gauntlet-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 200 tokens (17100110 cached reads)
- Output: 116743 tokens
- Cost: $13.859065
- Wall-clock: 2019s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
