Fix round 9 for kriscendobot/minion.town PR #186 is pushed as `d6f4e64` and CI is green (`ci-wait-merge` ended with "CI GREEN", 3/3 checks passed). I applied most of the panel-9 must-fix items, declined one and left one should-fix for later.

**What I fixed:**
- **Token visible to other processes (breaker, purist, wire-watcher):** `root_canary_signed_by` in `deploy/aws/scripts/root-canary-common.sh` used to pass the live root token to `jq` as a command-line argument. It now sends the token on stdin through bash's built-in `printf`, so no child process carries it in its arguments.
- **Overridable stream cancel (spec-keeper):** `deploy/probe/root-canary.mjs` now cancels response bodies with `Reflect.apply` and `ReadableStream.prototype.cancel`, captured once at load, not the instance's own `cancel()` method.
- **Untested negative check (prover):** `runRootCanary` now accepts an injected fetch. A new test has the unallowed client's request answer 200 and checks that the canary throws after that single request, before the root token helper runs or any root operation happens.
- **Token admission property test (fast-checker):** a new fast-check property checks that a token is accepted only when the subject, the client and both MCP scopes all match.
- **Docs (archivist):** `DEPLOYMENT.md` now says the caller must set `MINION_ROOT_CANARY_UNALLOWED_BEARER_CMD`, since the wrapper only passes it through, and gives a full example command.
- **Unmeasured "cheap" claim (benchmarker):** the design no longer calls refresh grants cheap. It now records not caching tokens as a security choice, with the reasoning: about two grants per run, and a cached root token would outlive the run. There is no measurement, and I didn't plan one.

Locally, typecheck is clean and the two canary test files pass (83 tests). I posted a PR comment listing each item and how it was handled.

**Declined (locksmith):** the request for a separate, narrower canary surface goes against a maintainer decision in `designs/root-canary-principal.md` (decisions, item 1). That decision accepts full root access over MCP because the deployment is disposable, and lists the narrower design as deferred. The next panel may raise this again; if the maintainer wants it reopened, that needs their call.

**Left for later (breaker should-fix):** the canary command can forge the sibling `status` file and make the wrapper exit 75 instead of with its own status. It gains no extra authority from this.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1645301 cached reads)
- Output: 10963 tokens
- Cost: $1.1287682
- Wall-clock: 925s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
