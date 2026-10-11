I closed endojs/endo-but-for-bots PR #1441 as REJECT (incompatible), but the problem it rejects is already on the base branch. The version being replaced has the same Node requirement, so this bump didn't create it.

**What I checked:** the live PR head (`8a2c976`, still open and from dependabot, touching only `packages/agentry/package.json` and `yarn.lock`), compared against the job's proof:
- **Project floor:** the root `package.json` declares Node `^20.17.0 || >=22.9.0`, so the lowest supported Node is 20.17.0. This matches the proof.
- **New version:** the npm registry shows `@earendil-works/pi-tui@1.0.2` requires Node `>=22.19.0`. This also matches.

Both ranges were as stated, so I skipped the full lockfile, source, advisory and test review, as the job directs.

**Pre-existing mismatch:** the outgoing `@earendil-works/pi-tui@0.87.1` also requires Node `>=22.19.0`. That means `packages/agentry` already depends on a package that excludes the project's Node floor. The verdict comment says this plainly and invites a reopen once the floor is settled.

**What changed:**
- **PR #1441:** closed, with a verdict comment giving the finding, the evidence, the pre-existing-mismatch note and when to reopen.
- **Ledger:** I added a Dependabotany entry to the journal at `entries/2026/10/11/201720Z-message-botanist-f5bca8.md`, tagged `project: endo-but-for-bots`. The job's slug `endojs-endo-but-for-bots` was rejected by the journal, so I used the existing `endo-but-for-bots` project.

**Decision for you:** either give `packages/agentry` its own Node floor, or raise the root floor to ≥22.19. Until one of those happens, every later pi-tui bump will be rejected the same way.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1441-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (532389 cached reads)
- Output: 3493 tokens
- Cost: $0.6383218
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
