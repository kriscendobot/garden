The directive is routed. No code changes were needed — this was a deferral note on a closed PR, so there is nothing to commit or push. The job is complete as a clean no-op with the intent preserved on the message bus.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #112.

**What I did:**
1. Ran the recheck preflight (`pr-feedback-preflight.sh … 112 4921379850 kriskowal`) → exit 0 (PROCEED; no peer had resolved it).
2. Re-fetched the comment (treated as untrusted data). Body: *"We will reconstruct these changes when implementation settles on the llm branch."*
3. Established context: PR #112 ("feat(ocapn-noise): Noise IK netlayer, #59 stack 2/3") is **CLOSED, not merged** — kriskowal closed it at the exact timestamp of the comment (2026-07-09T03:46:03Z). It was already marked "Superseded by #137 (consolidated PR against llm)" back on 2026-05-07.
4. Classified the directive: a **deferral / closure note**, future-tense and conditional ("*will* reconstruct … *when* implementation settles"). Not a request for immediate work.

**What changed:** Nothing in any repo. No edit or push — the PR is closed and superseded, so editing it would be wrong. Clean no-op on the code.

**Routing:** Sent a message to the maintainer (via the liaison) summarizing the finding and recommending a plan-queue park — *"reconstruct the OCapN-Noise layer-2 (Noise IK netlayer) changes on the llm branch once implementation settles"* — to be promoted when the `llm` implementation is ready. This preserves the intent without acting prematurely.

**Follow-ups:** None actionable now. When the `llm` branch implementation settles, a fresh designer/builder job can reconstruct the layer-2 netlayer work against `llm` (consistent with the standing preference to target `endojs/endo-but-for-bots` @ `llm`).
