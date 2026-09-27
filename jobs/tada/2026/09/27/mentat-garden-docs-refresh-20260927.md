Updated 26 documentation files and pushed five commits to `main2`, ending at `c942c685af2`. Working tree is clean.

Surfaces reconciled:

- `CLAUDE.md`, `README.md`: current vocabulary, manual mentat dispatch, monk/cleric slots, foreman target/brake, and missing inventory entries.
- `roles/COMMON.md`, gardener and liaison briefs: replaced obsolete dispatch-triple instructions, removed deployed-root git guidance, documented headless completion recovery and `.md` archive filenames.
- All four `context/first-run/` pages: corrected identity resolution, subscription/auth guidance, worker provisioning, and date-sharded completion reports.
- Operations index, `starting`, `scaling`, `leader-follower`, `deploy`, `health`, and `harden-container`: corrected retired worker commands, baked linger, leadership activation semantics, deploy/drain behavior, candidate testing, advisory probes, contention thresholds, and pending recreation.
- New `context/operations/cybernetics.md`: subscription accounting, shared checkpoints/supersession, fleet allocation, reset slack, dwell, and decision-on-change recording.
- Both cybernetics designs: dated implementation-status notes preserving historical analysis.
- Job-board, model-selection, orchestration, panel, pre-push-gates, local-verify, and TypeSafe skills: reconciled completion paths, final-disposition recovery, re-export review, verification boundaries, and advisory pilot scope.

Validation: all five documentation gates pass; 42 new relative links resolve; frontmatter and whitespace checks pass. GitHub Pages passed. [CI](https://github.com/kriscendobot/garden/actions/runs/36302438130) passed shellcheck and shell syntax checks but retains two pre-existing gauntlet-suite failures, also present in the baseline.

Recommendations: exclude drained/offline hosts from budget allocation; address inherited quiesce drains on no-op deploys; update gauntlet fixtures still expecting flat `tada` paths. Until archive suffix normalization exists, pass the exact `.md` filename. Recreate older containers to apply hardening.

Self-improvement: corrected shared workflow instructions and documented operational pitfalls at their owning surfaces.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-garden-docs-refresh-20260927.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 853s

<!-- garden-usage-end -->
