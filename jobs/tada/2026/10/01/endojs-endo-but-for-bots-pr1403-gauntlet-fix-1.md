Fix round 1 for endojs/endo-but-for-bots#1403 is complete: all panel must-fix items are applied, and CI is green on head `ef660bd65e` (33 checks, 0 failed; `ci-wait-merge` exited 0).

**Work already done before this run.** An earlier claimant of this job had pushed three commits (`ec25b8b11c`, `32e06a91df`, `c35fcc4f59`) and posted a "Fix round 1" comment. Those covered:
- **Classifier (assessor, saboteur, breaker):** `classify` now catches anything that throws on a malformed response, including `harden` and a throwing refill reader.
- **Usage recorder (breaker must-fix):** it now runs `mustMatch` on the wrapped backend's result before reading any field.
- **`stop` guard (prover):** the dead guard is removed.
- **`countOutputBytes` (breaker):** it now rejects a count that is not a non-negative safe integer.
- **PR body:** the pruner's wording changes are made, and it now explains why `test:xs` is a no-op.

That comment did not address the changeset-auditor's request-changes items.

**What I added (commit `ef660bd65e`, pushed with `safe-push-pr-head.sh`):**
- **Version (item 1):** `packages/inference/package.json` now starts at `0.1.0` instead of `0.0.0`, as `skills/changeset-discipline` § New-package initial release requires.
- **CHANGELOG (item 3):** added the stub `packages/inference/CHANGELOG.md`.
- **Changeset format (item 4):** `.changeset/add-endo-inference.md` now has one sentence per line.
- **`private: true` (item 2):** I left this in place. The neighboring `@endo/claude` package is also private, and `.changeset/config.json` sets `privatePackages.version: true`, so the changeset still versions the package.

I posted a PR comment explaining these four items, including why item 2 was kept.

**Follow-ups:** none from this stage; the driver re-posts the panel for round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 128 tokens (4842410 cached reads)
- Output: 22842 tokens
- Cost: $2.6809700000000003
- Wall-clock: 8298s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
