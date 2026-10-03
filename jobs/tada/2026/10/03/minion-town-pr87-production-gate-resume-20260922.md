---
handed-off: minion-town-claude-cli-production-20261003
deliverable-complete: false
---
I didn't produce production evidence for minion.town#87 in this job. I handed the remaining work to a new three-step orchestration, `minion-town-claude-cli-production-20261003`, which runs one step after another and stops if a step fails.

**Why I handed it off:** minion.town `main` (ec8db3f) still has every Claude setting in `src/endo/claude/wiring.ts` defaulting to "off and refusing". That covers the inference provider, credential store, confinement check, model list, credential expiry and child-guest creation. So the setup-token page `/account/claude/:nonce` can never finish connecting, and `infer` always reports "unavailable" in production. Getting evidence from the deployed AWS host, as the maintainer asked, needs that wiring built, merged and deployed first, and that is several PRs of work.

**What I checked:**
- endojs/endo-but-for-bots#1015 (`@endo/claude`, the confined `claude -p` core) is merged and is itself the CLI backend: its `make()` returns a provider whose per-guest `infer` runs the CLI.
- `@endo/claude` is not yet on npm.minion.town (the registry returns 404 for it).
- The child-guest naming support (`introducedSpecialNames`) is not in Endo yet.
- kriscendobot/minion.town#105 predates #1015 and plugs in at a different point, so it should be marked superseded.
- No other job on the board is doing this wiring.
- The old #87 conduct job is gone; #87 itself is already merged.

**What I posted (all on the journal, all three steps parked in `plan/` and controlled by the orchestration):**
1. `build-minion-town-claude-cli-provider-20261003` (builder): wire `@endo/claude` into each of those settings and choose how minion.town gets the package. It must also fix two gaps found by the endojs/endo-but-for-bots#1369 probe: the token leaking into the MCP child process's environment, and the 10-retry storm on a 401. It opens a draft PR that marks #105 as superseded, then goes through the gauntlet.
2. `minion-town-claude-cli-provider-conduct-20261003` (conductor): after the gauntlet, merge with maintainer approval, land kriscendobot/minion.town#137 first, and confirm the deployed service is healthy with `ENDO_CLAUDE_ENABLED=1`.
3. `minion-town-claude-cli-production-canary-20261003` (fixer): run four live checks on the deployed host using a real subscription:
   - connecting and passing the confinement check
   - a child `infer` returning a real result
   - the child being unable to reach anything beyond its guest's tools, with no token leak
   - disconnecting, after which the next `infer` returns "needs-auth"

   It then posts the evidence reply on #87 for review 5273131188 and closes #105.

**Maintainer message:** I sent the plan to the maintainer inbox with a heads-up. Step 3 needs a person with a real Claude subscription to run `claude setup-token` and paste the result at the deployed link. The canary job will send them the exact link when it's ready. I asked them to reply if a different subscription or person should do it.

**Unchanged:** no garden code changed. #87 is merged and I didn't touch it. The inline test-fixture ask stays resolved by `8a0bf2b` and reply 4067792020.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr87-production-gate-resume-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1549446 cached reads)
- Output: 13865 tokens
- Cost: $1.1669412000000001
- Wall-clock: 225s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
