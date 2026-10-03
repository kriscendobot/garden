Round-4 fixes for PR #147 (kriscendobot/minion.town) are pushed and CI is green: all 3 checks passed (`ci-wait-merge` rc 0).

**The one must-fix (critic, T1 → T4):** each task runs as its own `claude -p` process with no saved session, so the old T4 prompt ("change the page you published in T1") only worked if the agent remembered T1. § 6.2 now pairs the runs: T4 rep *k* runs right after T1 rep *k*. The harness, not the agent, takes the URL that the T1 verifier recorded and puts it into the T4 prompt as `<t1-url>`. If a T1 rep produced no working URL, the harness publishes a clip itself and marks the T4 run "harness-seeded", so T4 still tests recovery and doesn't inherit T1's failure. I rewrote the T4 row in Table 3 to match.

**Should-fix and comment-only items I also addressed**, all in `designs/mcp-resources-getting-started.md`:
- **§ 2 access control (critic):** it now says resources are protected only by the `/mcp` bearer check, not by the per-call `mcp/guest` admission that tools get, and explains why that is acceptable here.
- **§ 3.2 mounts (skeptic):** it now says mounts are fixed per process, not per session. I confirmed this in the code: `src/http.ts` sets `clipsEnabled` and `claudeEnabled` once at startup.
- **§ 4 rollback (skeptic):** the ancestry check blocks swapping back to an older copy, so rollback is now done by reverting the change on `main` and redeploying that new commit. The five retained copies are kept for comparison only.
- **§ 6.1 tool names (skeptic):** build slice 2 must now check the resource-reader tool names (`ListMcpResourcesTool`, `ReadMcpResourceTool`) and the effect of `--tools` against the pinned Claude Code before running any baseline.
- **`instructions` (decomplector):** the string is now written as `resources/instructions.md` and read from the same deployed resources copy as the guides, so a guide fix updates it too and the lint covers it. § 4 also now says the server resolves the symlink first and then reads the files, not the other way round.
- **Captions (pedant):** the tables are labeled Table 1–3.
- **Glosses (novice):** one-clause explanations of `publish`, `evaluate` and `upgrade` in § 1, and of the "step-1 gate" in § 6.1. § 9 Q1 now says where the parked principal question is tracked.

The new commit is `c4f890e`, pushed through `safe-push-pr-head.sh` on top of `4e03a39`.

**Not addressed:** the ergonomist's suggestions to rename the URIs to a single grammatical form and to add a link from `guide/clips` to the worked example, and the copyeditor's wording suggestions. The next panel (round 5) may raise them again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (855534 cached reads)
- Output: 6668 tokens
- Cost: $0.8364748000000001
- Wall-clock: 330s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
