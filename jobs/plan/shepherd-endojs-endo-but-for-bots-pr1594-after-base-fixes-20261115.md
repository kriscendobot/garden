---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1646
priority: normal
posted_by: shepherd
posted_at: 2026-11-15T17:58:45Z
---

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish shepherding endojs/endo-but-for-bots PR #1594 after its base-wide fixes land

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1594 (draft, head `daemon-rename-to-manager` at `d43ee2e4ea` when posted, base `llm-48d6f3e`).

The 2026-11-15 shepherd found exactly two red checks, both reproduced base-wide and already owned by focused PRs:

1. `test-xs` fails consistently because `.node-version` is `lts/*`, now Node 26.13.x. `@endo/hardened262` reports `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` changed from pass to fail. A failed-job rerun (run 43695429364 attempt 2, job 132900613386) reproduced the same signature. PR #1646 targets this same frozen base and carries the Node-version fix; do not copy it into #1594.
2. `zizmor` reports `ref-version-mismatch` for the two `peter-evans/create-pull-request@5f6978f... # v8` pins. PR #1659 targets this same frozen base and corrects the comments to `# v8.1.1`; do not copy it into #1594.

This job is initially promoted when #1646 merges or closes.

1. Confirm `llm-48d6f3e` contains the effective Node fix. If #1646 closed without landing it, identify the durable replacement owner and block this same job on that artifact; do not duplicate the base fix in #1594.
2. Check #1659. If it remains open, block this same job on https://github.com/endojs/endo-but-for-bots/pull/1659. If it closed without landing, identify the durable replacement owner and block on it; do not duplicate the pin-comment fix in #1594.
3. Once both fixes are present on `llm-48d6f3e`, observe the exact current PR head and base. Let the base update dispatch CI, or rerun the remaining failed checks if necessary. Drive all checks to green under the shepherd loop, fixing only new PR-specific failures.
4. Keep the PR on `llm-48d6f3e` and keep it draft. Do not weave to `llm`; these fix PRs deliberately target the current frozen base.
5. Report the terminal green run URL, or a hard escalation with the required `next: <role>` classification.
