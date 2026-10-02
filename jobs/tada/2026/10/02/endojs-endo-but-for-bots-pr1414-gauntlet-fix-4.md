## Fix round 4 for endojs/endo-but-for-bots#1414: done, CI is green

I fixed the three must-fix items from the round-4 panel review (5390463794). The fix is one commit, `38ad01d0a6`, pushed to `design/guest-delegated-host-channel-confinement` with `safe-push-pr-head.sh` (`0688159b3c` → `38ad01d0a6`). It only changes `designs/daemon-guest-delegated-host-channel-confinement.md`.

**Must-fix items:**
1. **Method Partition (critic).** The exposes/withholds lists now cover every `HostInterface` method on base `llm-afc72ca`, including the methods it pulls in from shared guard groups. I checked this with a script against `interfaces.js`: no method is missing, and the lists contain no names that aren't methods.
   - Now withheld:
     - `makeArchive`, `makeFromTree`, `stageTree` and `makeUnconfinedFromTree`. They carry the same power as `makeUnconfined`, and none of the five factories calls them.
     - The shell, git, HTTP and credential providers, now listed by name. floot calls the git providers only on its controller's own host, which no guest holds.
     - `handle`, `listIdentifiers`, `listLocators` and the content-locator methods.
   - Now exposed: `listValues`, `reverseLookup`, `readText`, `maybeReadText` and `writeText`.
   - Removed two names that are not `HostInterface` methods: `allowHistoryRewrite` (an option) and `identity`.
2. **Phasing wording (copyeditor).** The made-up "`mountPath` change" now reads as the mount-bridge signature change (`capId` → `cap`) plus floot's registrar-private pins.
3. **Section symbol (pedant).** All five `§` cross-references now use plain words.

**Should-fix items also addressed:**
- **Partition test:** it now also fails when a name is in both lists or is not a `HostInterface` method.
- **Open Question 1:** it now covers the four archive/tree makers alongside `makeUnconfined` and `evaluate`.
- **Open Question 4:** phase 3 now adopts its recommended rename from `host-agent` to `provisioner`, and the Phasing text says so.
- **Ownership Map:** it gains a row for floot's registrar and its `pinDirectory` (decomplector).

**Not addressed** (all should-fix or comment-only):
- skeptic: the provisioner can see every name in the host's namespace, not just a factory's own; nothing narrows grants already stored in running daemons; whether `sameCapability` reveals anything that comparing two looked-up references doesn't.
- ergonomist: `has` reports `@` names that `lookup` refuses, and the three "pin" names overlap.
- novice: the `llm` branch is used before it is defined, plus small wording points.
- pruner: trimming the PR body and the survey.

The next panel round can pick these up.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 28 checks passed and none failed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1579779 cached reads)
- Output: 11575 tokens
- Cost: $1.2087758
- Wall-clock: 684s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
