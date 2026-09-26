Completed `daemon-commit-formula` design in commit `df8569c46b`.

Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/988

Changed:

- Defined daemon-native Git tree, commit, and tag formulas.
- Specified formula-rooted refs through name-hub paths, CAS updates, deterministic orphan commits, and byte-stable SHA-1/SHA-256 projection.
- Updated the design roadmap, dependency graph, milestone, estimate, and totals.
- Added a formula-graph library keyword shortcut and notified the scholar.

Checks run:

- Prettier passed.
- `git diff --check` passed.
- Both README Mermaid diagrams parsed successfully.
- TypeDoc completed with three pre-existing `@endo/agent-tools` warnings.
- Root `yarn lint` was not verified because the pnpm-linked checkout did not expose Prettier/ESLint on script PATH.

Follow-ups: the design leaves object-format rollout and generic NameAdmin CAS as review questions. Minion Town implementation remains with the existing chained follow-up.

Self-improvement: reported that `inbox-send.sh --help` creates a dead letter instead of showing help.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-daemon-commit-formula-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 812s

<!-- garden-usage-end -->
