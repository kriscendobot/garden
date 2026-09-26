CI is terminal GREEN (rc 0).

## Completion report

**Stage: CLEAN — endojs/endo-but-for-bots PR #539**

PR #539 is a **docs-only design PR**: it modifies only markdown under `designs/` (deletes `sturdy-refs-endor-syscall.md` −1202, adds `sturdy-refs-ocapn-enlivenment.md` +877, trims `designs/README.md`). No packages are touched.

- **Coverage pass:** N/A — no source packages in the diff, so there is nothing to run `coverage-driven-testing` against and no orphaned source code to remove.
- **Follow-up pushes:** none needed; nothing changed.
- **CI:** confirmed terminal via `ci-wait-merge.sh --no-merge` → **GREEN** (rc 0; the sole check, `copilot-setup-steps`, is SUCCESS at the current head).

The clean stage is a no-op for this PR — it is already the right shape. No commits, no PR mutations, no garden-repo changes.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr539-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (132069 cached reads)
- Output: 1732 tokens
- Cost: $0.4322895
- Wall-clock: 30s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
