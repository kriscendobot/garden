Inbox empty. The job is complete. All deliverables are landed on `main2` and verified.

## Completion report

**Job:** Create a cost-gated `coverage-auditor` reviewing juror that enforces test coverage of newly-introduced code, driven by a deterministic c8 report, and wire it into every builder/fixer panel. Landed on `main2` (commit `48c658da71`, pushed cleanly on the first CAS attempt).

**What I built**

1. **Deterministic coverage-diff script** — `scripts/jobs/gardening/coverage-auditor-coverage-diff.sh` (no LLM). It intersects the change's added `+` lines (`git diff <base>...HEAD`, new-file line numbers) with c8's `coverage/coverage-final.json` using **Istanbul's own `getLineCoverage` semantics** (statement-start line, max hit count). Per added line it decides uncovered (statement-start, 0 hits) / covered (>0) / N-A (not a statement-start → blank, comment, type-only, inside a multi-line statement). Files absent from the report are N/A, which inherits c8's config-based exclusions (vendored/generated) for free. Subcommands: `check` (exit **0** uncovered⇒dispatch, **1** clean/no-base⇒skip, **2** no-report/no-jq⇒**LOUD, never silent "covered"**), `lines` (the `file:line` digest), `report` (digest + summary count). The `--all` caveat for wholly-untested new files is documented loudly in the header.

2. **The cost gate** — `scripts/jobs/gardening/seat-gate-coverage-auditor.sh`, mirroring the proxy's deterministic-pre-pass-then-cost-gated-handler pattern. Runs the pre-pass first; emits an **approve** block on clean and a **comment-only** (surfaced) block on no-report **without spending `claude -p`**, and only dispatches the LLM (over the seat brief + uncovered-line digest, treated as DATA, run from the worktree) when a real gap exists — with a deterministic request-changes fallback if `claude` is unavailable so the gap always reaches the fix-loop.

3. **Panel integration (mandatory on every builder/fixer run)** — `panel.sh`'s `seat_review` now honors a co-located `seat-gate-<seat>.sh`, and `coverage-auditor` is in `GARDEN_CODE_SEATS` (runs on every code panel).

4. **The seat brief** — `roles/jurors/coverage-auditor/AGENT.md` (reviewing seat: recommends the specific missing test or accept-with-rationale via the coverage-driven-testing four-way; never writes tests; injection hygiene).

5. **Unit test** — `scripts/jobs/test/coverage-auditor-coverage-diff-test.sh`, 13 hermetic cases (uncovered/covered/N-A, clean-skip, added-only, file-absent, report summary, no-report exit-2-loud, no-base exit-1, non-code). **13/13 pass.**

6. **Roster/inventory sync** — CLAUDE.md juror inventory; panel-hints.sh + SKILL (always-fire, cost-gated note); panel-review, panel, pr-creation-flow, and barrister/justice/judge counts (also corrected the pre-existing `transplanter` drift so the docs now match panel.sh's authoritative 28-seat set).

**Verification:** CI-equivalent `bash -n` sweep clean; `shellcheck -S warning` clean on all three new scripts; inventory-drift check passes; gate smoke-tested in all branches (approve / comment-only / LLM / fallback); panel-hints emits the seat.

**Follow-ups:** For the whole-untested-new-file case to be caught deterministically, projects should run c8 with `--all` (documented in the script and skill; the seat's semantic read is the backstop otherwise). The seat surfaces a comment-only "coverage unavailable" block on panels where the eval doesn't yet produce a c8 report — a maintainer wiring c8 into `GARDEN_EVAL`/local-verify would make it fully active.
