Fix round 5 is done for endojs/endo-but-for-bots#1403: I shortened the PR description, and CI is green (33 checks, 0 failed).

**What the panel asked for.** The round-5 review (5479564636, head `378e1345a3`) had two must-fix items:
1. **PR description too long** (pruner, plus the concision probe): 372 words against a 300-word ceiling. I cut the "Release metadata (maintainer to confirm)" paragraph from about 140 words to two sentences, as the panel asked:
   - **What ships:** `0.1.0` with a `major` changeset, so the first release is `1.0.0`. This follows `@endo/cbor`, `@endo/crc32`, `@endo/hardened262` and `@endo/pubsub`.
   - **Open question for the maintainer:** should the first release instead be `0.1.0`, via `0.0.0` + `minor`?

   The release metadata itself is unchanged, per the panel. The description is now 295 words, including the HTML markers.
2. **"acknowledgement" in `packages/inference/SECURITY.md:21`** (orthographer): left alone, as the panel instructed. A lint script (`scripts/check-security-md.sh`) requires that file to match `packages/skel/SECURITY.md` byte for byte. Changing the spelling would need a separate repo-wide change to skel and every copy.

**What changed.** Only the PR description, edited through the GitHub API. I made no commits and no push, so I didn't need `safe-push-pr-head.sh`, and the head is still `378e1345a3`.

**Follow-ups:**
- The maintainer still needs to answer the release-version question in the description, and decide whether to rename the `cancelled` identifiers.
- Early in the run, the `gh` wrapper reported it "could not resolve token for identity=kriscendobot". Several API calls stalled for minutes and two runs hit their time limits. The problem cleared up by itself, and I didn't investigate it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (886012 cached reads)
- Output: 3504 tokens
- Cost: $0.6645384000000001
- Wall-clock: 1263s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
