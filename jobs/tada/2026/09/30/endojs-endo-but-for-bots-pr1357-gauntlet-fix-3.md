Fix round 3 for endojs/endo-but-for-bots PR #1357 is pushed as head `d53fa42dff` (one commit on top of `87adcf3d24`), and CI is green: all 28 checks passed, 0 failed (`ci-wait-merge` exited 0). I did not change the pedant's section-sign item (see below).

**What the fix commit changes** (`designs/endo-claude-inference-backends.md` and its `designs/README.md` rows):

- **Critic (Decision 9):** `endo-claude` Decision 6's condition ("required, not merely recommended, for any guest-influenced prompt") is now kept in full, whichever credential pays for the turn.
  - Skipping the OS slice now needs both the root's own credential and a root-authored prompt.
  - `InferRequest` gains a `promptOrigin` field, set by the caller (normally the factory).
  - An unsliced backend is wrapped in a prompt-origin gate. That gate refuses a request marked guest-influenced, or one with no origin, before any process starts.
  - Gate 2, the Dependencies row and Resolved Question 2 are updated to match.
- **Decomplector (admission and classification):**
  - Admission and credential delivery now belong to one new `CredentialSource.acquire()` that the plugin calls. A refusal is admission; a grant carries the environment the process sees. Admission is no longer an enricher.
  - The limit enforcer and the pinned-table classifier are now helper libraries the plugin calls on the raw provider response, not enrichers. No enricher parses `unavailable.reason`.
  - The usage record has one writer per deployment, a usage sink.
  - Where a credential's kind (subscription token or API key) is recorded is now stated.
  - The Ownership Map is updated to match.
- **Integrator (PR body):** rewritten with all seven template headings, describing the design as revised. It lists one open question, seven gates, and the root user on the subscription with broker injection still closed.
- **Integrator (should-fix):** the doc now places `@endo/inference` beside `packages/fae/llm-provider-factory.js` and the `endopi-provider-registry-and-oauth` design.
- **Novice:** a new paragraph near the top defines `--bare`, MCP, `SecretBlob` and `SecretAdmin`. Early "Decision N" and "gate N" citations now carry a short gloss.
- **Smaller comment-level items:**
  - The "come back later" results all use one optional `retryAfterMs` field; `resetAt` is gone.
  - The formula-identifier sentence is narrowed to "never forwarded to the provider".
  - The "beyond a single canary" wording is clarified.
  - Gate 7 now says the network-egress check is #1248's to verify.
  - The limitation that `buildMcpServer()` ties the seam to MCP is noted in Known Gaps.
  - Arrows and ellipses in tables and prose are now ASCII.

**Not changed: pedant's § item.** The `typist-friendly-code-points` skill's replacement tables do not list `§`, and 81 of the repo's 233 design docs use it for section references. If panel-4 raises it again, the maintainer will need to decide.

**Follow-ups:** none new. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1295825 cached reads)
- Output: 17663 tokens
- Cost: $1.429849
- Wall-clock: 740s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
