---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-15T20:25:40Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1662 - EMBARGO-2026-11-16

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1662: `peter-evans/create-pull-request` 8.1.1 -> 8.1.2 (github-actions, 2 sites: update-action-pins{,-major}.yml).
- Verdict: **EMBARGO-2026-11-16**. Maturity floor 2026-11-16T08:46:04Z = v8.1.2 release publish instant 2026-11-09T08:46:04Z + 7d (the only moved version; tag commit 15733dbd dated 2026-11-06).
- Base census: llm pins v8.1.1 (5f6978fa) at both sites, so the bump is not superseded. No sibling PR moves this action. v8.1.3 (2026-11-10) also exists.
- Advisories: none for the action (GHSA global + repo). Source read: uuid replaced by crypto.randomUUID, a submodule-deletion fix under sign-commits, and dev-dep/dist churn. Benign.
- CI: zizmor failed on the Dependabot head because the floating v8 tag now points at v8.1.3, so the `# v8` comment mismatched. A garden-bot commit f5dfab4e set the comment to `# v8.1.2`, after which CI was green (9 success, 24 skipped).
- Recheck: one-shot `dependabotany-recheck-endo-but-for-bots-pr1662` at 2026-11-16T09:15:00Z. The daily backstop `dependabotany-recheck-endo-but-for-bots` is in place. Expected terminal verdict: MERGE-NOW.
