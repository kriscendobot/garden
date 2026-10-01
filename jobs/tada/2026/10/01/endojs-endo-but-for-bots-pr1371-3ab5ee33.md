I posted the endo job kriskowal asked for in PR #1371: a builder job, `ebfb-guest-no-identifiers-locators`. I confirmed it is in `jobs/todo/` on `origin/journal2`.

- **The directive:** `gh` was rate-limited, so I read the comment through the unauthenticated GitHub API (kriskowal, 2026-10-01T04:57Z). It asks for a job on endo that removes guests' ability to produce or consume identifiers or locators, consistent with distributed confinement. The usage patterns this breaks are to be recovered with sturdy refs or other means.
- **Preflight:** `pr-feedback-preflight.sh` couldn't gather evidence because of the same rate limit and exited 0. I searched the board for an existing equivalent job and found none.
- **What the job asks for:** the target is `endojs/endo-but-for-bots` on a frozen `llm-<sha>` base, as a draft PR.
  - Audit the guest powers in `packages/daemon` and remove every method that returns or accepts a formula ID or locator. The host keeps them. Named candidates are `identify`, `locate`, `reverseLocate`, `followLocatorNameChanges`, `storeIdentifier`, `adoptFromLocator` and any `lookup`/`provide` paths that take a locator.
  - Update the guards, types and docs, plus the guest tool lists in `@endo/agent-mcp-stdio`, `@endo/mcp` and `@endo/claude`.
  - Add tests that close the hole found on #1371: a guest calling `storeIdentifier` with a host ID copied from its prompt ends up holding host authority.
  - Put a list of everything this breaks in the PR body, with a recovery path for each: sturdy refs, pet-name paths (#1390), going through the host, or a named follow-up.
  - Add changesets.
- **Dedup:** my first post was refused because this routing job already owns the comment's directive identity. I reposted under the distinct identity `endojs/endo-but-for-bots#1371:comment:5925033783:build-guest-no-identifiers`.

**Follow-up — likely conflict:** the Minion Town guest-locator federation campaign (orchestration `endo-minion-town-guest-locator-federation`, design PR #1332, with deploy and acceptance children parked in `plan/`) relies on guests using locators. The builder will flag this in the PR body, but someone needs to decide how the two fit together.

I didn't post an acknowledgment reply on #1371.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1371-3ab5ee33.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (744201 cached reads)
- Output: 4481 tokens
- Cost: $0.6394842
- Wall-clock: 68s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
