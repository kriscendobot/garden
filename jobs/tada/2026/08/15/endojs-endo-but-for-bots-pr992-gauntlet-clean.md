This is a docs-only PR — three markdown files under `designs/`, no source packages touched. A coverage pass is inapplicable (no code, no dead code possible), and CI is already GREEN at the current head. This stage is a NO-OP.

## Completion report

PR #992 (`design(http): HTTP client/controller as a metered pass-style adapter pipeline`) is a **docs-only** change: it adds `designs/http-adapter-pipeline.md` (750 lines) and touches `designs/README.md` and `designs/cli-http-client.md` — no source packages, no code, so the coverage-driven-testing pass has nothing to cover and there is no orphaned/dead code to remove.

- **Idempotence check**: all 6 CI checks report `SUCCESS` at the current head (browser-tests, lint, build, zizmor, test — via the "CI (docs-only)" workflow). PR is already the right shape.
- **No changes made**: no isolated checkout, no follow-up commits, no push needed.
- **CI state**: terminal GREEN; no wait needed.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 6 tokens (102516 cached reads)
- Output: 970 tokens
- Cost: $0.36288899999999996 (1 engagement(s) unpriced)
- Wall-clock: 22s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
