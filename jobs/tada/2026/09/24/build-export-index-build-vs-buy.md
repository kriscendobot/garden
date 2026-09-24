The prior attempt had already built the whole job and pushed it to `main2` before the requeue, as commit `268455dca86`. I checked it against the design's Rollout and Test plan and found nothing missing, so this run added no new commits.

**Tests:** all four named suites pass when re-run in a fresh worktree:
- `export-index-test.sh`: 13 passing, 0 failing
- `build-vs-buy-probe-test.sh`: 9 passing, 0 failing. This includes the PR #1336 replay: the copied `makePromiseKit` fails at pre-push when checked against the real base index.
- `seat-gate-procurer-test.sh`: 11 passing, 0 failing
- `review-convention-probes-test.sh`: 30 passing, 0 failing

The new scripts also pass `bash -n`.

**What is on `main2`:**
- **Export index:** `scripts/jobs/export-index/{build,ensure,publish}-export-index.sh` build the index with no LLM, using the vendored Babel parser. Each (repo, commit) index is cached under `$GARDEN_STATE/export-index` and filled atomically; garbage collection keeps the newest 20.
- **Detector:** `skills/build-vs-buy/` holds `SKILL.md`, `detect.cjs` (the name and idiom passes, with strong/weak/blocked strength), `idioms.tsv`, `lib.cjs`, `export-index.cjs`, `procure.cjs` (the fixed disposition map) and `exports-README.md`.
- **Pre-push:** a new `build-vs-buy.sh` probe. `prefer-endo-primitives.sh` is now an idiom-only shim, and its `makePromiseKit` regex is gone because the name pass covers it.
- **`procurer` juror seat:** its brief, the `C-procurer.sh` panel-hints probe, `seat-gate-procurer.sh` (at most 8 hits sent to the model, with a verdict cache), a haiku row in `seat-model-tiers.tsv`, and the `panel.sh` wiring.
- **Daily timer:** `garden-export-index` runs at 04:23 and only on the leader (it is gated by `is-main-host.sh`). It publishes `journal/library/exports/<owner>-<repo>.tsv`. `install-units.sh` picks it up automatically because it installs every `garden-*.timer`.
- **Docs:** the builder brief gains the "grep the export library before writing a helper" rule. The `pre-push-gates` and `panel-hints` skills and the CLAUDE.md skill and juror lists are updated.

**Follow-ups:** none required. The export-name files in `journal/library/exports/` will first appear after the leader's timer runs, the next 04:23 after units are reconciled on the next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-export-index-build-vs-buy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 152 tokens (9395806 cached reads)
- Output: 84863 tokens
- Cost: $5.374861199999999
- Wall-clock: 867s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
