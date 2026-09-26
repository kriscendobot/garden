Done. Completion report follows.

---

**Job: cybernetics-rec7-frontmatter-validation** — Implemented recommendation 7 of `designs/cybernetics-audit.md` § 7 [wrong sensor]: write-side job frontmatter validation.

**What changed** (landed bare on `main2` as `8d5139f4be`):
- **`scripts/jobs/common.sh`** — new `validate_job_frontmatter <file>`, mirroring `set-schedule.sh`'s `validate_handler_timeout` write-side shape. It WARNs by default and additionally refuses (rc 1) under `GARDEN_JOB_FRONTMATTER_STRICT=1` on (a) a `tier:` outside `job_tier`'s closed vocabulary `mentat|mentor|minion|myrmidon`, and (b) a non-integer `handler-timeout:` (the field gardener.sh silently ignores unless `^[1-9][0-9]*$`). It reads the same fields the readers read (`plan_field`, first-occurrence-wins), so it validates exactly what is honored downstream. An absent field stays valid.
- **`scripts/jobs/post-job.sh` / `post-plan.sh`** — call the validator on the supplied body before posting/parking (temp file, since the readers take a file path).
- **`scripts/jobs/common.sh` `job_tier`** — logs ONE WARN on the previously-silent non-empty-out-of-vocabulary rc-1 path; an empty tier stays silent (it is not a mis-spec, it falls through to the model-migration vocabulary).
- **`scripts/jobs/test/job-frontmatter-validation-test.sh`** — new hermetic test (15 assertions) covering warn-first vs strict-refuse for both scripts, backward compat (tier-less/timeout-less bodies post clean), and the `job_tier` WARN/silence split.

**Verification:** new test 15/15; existing `directive-identity-dedup-test` (24/0), `model-routing-test` (32/0), `handler-budget-test` (12/0), and the full `run-test.sh` board suite (379/0, exit 0) all pass. Read-side semantics and budgets unchanged; existing producers with no `tier:` are unaffected.

**Note / follow-up:** early in the session I mistakenly applied the edits to the *deployed* garden root (`/home/kris/garden2`) via absolute paths instead of my worktree; I fully reverted those (confirmed byte-identical to HEAD, `grep -c` = 0) before redoing the work correctly in the worktree and committing. No git was run in the deployed root; the root advances only via `deploy-garden.sh`. The strict-refuse mode is opt-in (`GARDEN_JOB_FRONTMATTER_STRICT=1`) and off by default, so no existing producer breaks — a future hardening step could flip on strict for specific automated producers if desired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec7-frontmatter-validation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 112 tokens (4860099 cached reads)
- Output: 36124 tokens
- Cost: $4.0040595
- Wall-clock: 670s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
