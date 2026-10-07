I rewrote the `ocapn-tcp-for-test-extraction` design against `llm` at `f1e3065` and opened it as draft PR **endojs/endo-but-for-bots#1430**. It is on branch `design/ocapn-tcp-for-test-extraction-revision` (commit `75e7151b70`), against the frozen base `llm-f1e3065`. The diagram passes the mermaid parse check; nothing else was run, since this is design only.

**What the revised design says** (`designs/ocapn-tcp-for-test-extraction.md`):
- **Each network owns its identity exchange.** The OCapN core accepts only an authenticated `NetworkSession`, through the `provideSession`/`inboundSessions` path Noise already uses.
- **Noise keeps its encrypted `op:start-session`** (`exchangeIdentity`). The old draft called it redundant, but it carries the location signature that three-party handoffs need, tied to the Noise handshake.
- **New shared wrapper for the other networks.** `makeStartSessionNetwork`, exported as `@endo/ocapn/start-session`, runs `op:start-session`, checks the signature, resolves crossed hellos and calls Iroh's existing `verifyPeerLocation`. Nothing changes on the wire.
- **Four phases, with Iroh before the core removal:**
  1. Extract the wrapper.
  2. Migrate Iroh.
  3. Migrate tcp-testing, the `ws` netlayer and thixotrope's durable netlayer. The last two also use the core fallback; the build report didn't list them.
  4. Remove the core fallback and its three optional handshake hooks.
- It includes an ownership map and notes that the #1071 hints are not identity.
- **Two open questions for the maintainer:** whether thixotrope's `resumeSession` stays in the core for now (recommended), and when Noise should switch to the shared helpers.

**Plan record updates:**
- `ocapn-tcp-syrup-framing.md` is now **Complete**, citing `bdb9ddc50d`. It shipped as a `framing` option on the existing TCP-testing netlayer, not the separate `tcp-syrups` netlayer the design proposed.
- The `designs/README.md` rows are refreshed: index dates, milestone notes and estimates, including removing the stale "impl PR #109 open".
- The dependency note in `ocapn-noise-network.md` is corrected.

**Follow-ups:**
- The PR is left draft so its design-panel review is staged automatically.
- I could not file the token estimate for the four-phase build. The budget-request skill names `scripts/jobs/request-budget.sh`, which doesn't exist in the deployed root or on `main2`. Either the skill or the script needs fixing; the estimate I meant to file was about 12M tokens for effort `ocapn-tcp-for-test-extraction`.
- Moving `resumeSession` out of the core is marked "to be filed".
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ocapn-tcp-for-test-extraction-revision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3341903 cached reads)
- Output: 25467 tokens
- Cost: $2.1168966000000005
- Wall-clock: 327s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
