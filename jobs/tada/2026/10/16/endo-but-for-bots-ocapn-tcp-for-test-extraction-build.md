I didn't build this one. The design it points at is out of date, so I stopped without writing code or opening a PR. This is the second build of this design to stop for the same reason (`build-ocapn-tcp-for-test-extraction` stopped on 2026-10-07). No gauntlet should be staged.

**Why I stopped:** the design on `llm` (`61cd656cb8`) is still the 2026-02-24 draft, which says to make `op:start-session` private to the tcp-for-test transport. Current `llm` code has moved past that:
- OCapN-Noise runs its own encrypted `op:start-session` exchange (`exchangeIdentity`). It is needed because it carries the location signature that three-party handoffs rely on.
- `@endo/ocapn-iroh`, the `ws` netlayer and thixotrope all depend on the core handshake, and Iroh also uses the `verifyPeerLocation` hook. Following the design as written would break them.
- Draft design PR https://github.com/endojs/endo-but-for-bots/pull/1430 revises the design. It replaces the old approach with a shared `@endo/ocapn/start-session` wrapper (`makeStartSessionNetwork`), delivered in four phases with Iroh migrated before the core fallback is removed, and it rejects the draft's approach outright. Its gauntlet halted at the clean stage, and no maintainer has reviewed it. The 2026-10-07 viability check confirmed it is still current and that nothing competes with it.

The builder rules say to stop at an impasse when a design has drifted from the code, rather than build against either version. Building phase 1 of the revision would mean building on a design the maintainer hasn't accepted.

**What I did:** I checked both design versions, the code, the open PRs and the journal record of the earlier attempt. I sent the maintainer one message (`msg-endo-but-for-bots-ocapn-tcp-for-test-extraction-build-a468a54ad4ea`) asking them to rule on https://github.com/endojs/endo-but-for-bots/pull/1430. Nothing was committed to any repository.

**Next steps:**
- Once the maintainer accepts #1430, post a build of its phase 1: add the wrapper with behavior unchanged, and unit-test it on mocked connections for version mismatch, a bad signature, a `verifyPeerLocation` rejection, and crossed hellos.
- Until then, whatever posts these jobs should stop posting builds against the stale `llm` design. The design file's header still says "Not Started", though the README marks it "In Progress"; the stale header may be why the job keeps getting re-posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-tcp-for-test-extraction-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (970933 cached reads)
- Output: 7009 tokens
- Cost: $0.9215426
- Wall-clock: 99s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
