---
handed-off: conduct-endojs-endo-but-for-bots-pr1573-after-pr1646
deliverable-complete: false
---
**Phase 1 is already built as #1573, so I built nothing new and opened no PR.** #1573 isn't merged, so I handed the merge to a parked conduct job.

**Why I didn't build:**
- **Existing PR:** #1573 is open, non-draft and based on `llm`, at head `50a020ea4b7`. kriskowal approved it with "Please conduct".
- **Prior attempt:** no rival PR or branch from it survives.
- **Coverage:** I compared the design's phase 1 list with the PR's test titles and read the daemon restart test and parts of the registry code. I did not run the tests or read the rest of the code.

| Phase 1 item | Where it's covered |
| --- | --- |
| Anthropic-only providers, model ids validated by shape | unit test |
| Supersession, unchanged descriptors, audit rows, no admin derived from use | unit test |
| Crash injection at each creation and retirement boundary, including a lost response | unit tests |
| Grants rebind after restart | real daemon restart test and unit test |
| Grant revoked before restart stays fenced | real daemon restart test and unit test |
| Provider retired before restart stays fenced, in-flight request cancelled on retirement | unit test only |
| Issuer serves in-process with no listener | unit test |
| Cross-principal denial (`provider-not-found`, `provider-owner-mismatch`) | unit tests, at lookup, admin and grant level |

**Gaps to know about:**
- **Foreign id at agent creation:** this is only tested at the grant step, because agent creation arrives in phase 4.
- **`apiKeyGuestAgents` flag:** it isn't in #1573. The PR adds no UI, CLI or daemon bootstrap wiring, so the registry stays dormant until something exposes it. The flag is left for the first phase that does, and I told the maintainer in case they want it earlier.

**Why it isn't merged:**
- **The red check:** the first conduct attempt stopped because `test-xs` is red. `llm` fails the same way, because `.node-version` is `lts/*`, which now resolves to Node 26.
- **The fix:** #1646 pins Node to 24 and passes `test-xs`, but it is an unreviewed draft. Its gauntlet halted on one bwrap failure in `packages/sandbox`, which also shows up on other PRs and is outside its one-line diff.
- **No owner:** no job on the board was working on this.

**What I did:**
- **Follow-up job:** I parked `conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`, pinned to endolin and blocked on #1646, and confirmed it's on `origin/journal2`. If #1646 closes without a fix, the job stops and messages the maintainer rather than merging on red.
- **Maintainer message:** it explains the blocker and how to clear it: rerun the failed job on #1646 or land #1591, then approve and merge #1646.

**Follow-ups:**
- **Maintainer action needed:** nothing merges until #1646 is resolved, and the #1575 weave and conduct jobs wait behind #1573.
- **Next in the orchestration:** the p2 job (`build-api-key-agents-p2-provider-adapters`) is next in line. It already carries a note not to rebuild #1575, and p3–p5 should stack on these PRs or wait for them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-api-key-agents-p1-provider-registry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 106 tokens (7739245 cached reads)
- Output: 121050 tokens
- Cost: $6.625737
- Wall-clock: 2841s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
