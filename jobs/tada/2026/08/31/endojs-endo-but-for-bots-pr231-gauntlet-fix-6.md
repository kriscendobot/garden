CI is GREEN (rc 0). The fix is pushed and verified.

## Completion report

**Job:** endojs/endo-but-for-bots PR #231 — gauntlet FIX round 6 (design PR `design(familiar): MVR release plan`).

**Panel round-6 must-fix (critic + skeptic, both request-changes):** The Tier-1 "mock LLM gateway" plan in `designs/familiar-release.md` claimed it could drive a registry-provider model (Anthropic/OpenAI) off the public network by injecting the mock's address as the form's `host` field. Tracing the actual code (`resolveModelString`/`resolveModel` in `@endo/agentry/harness`, re-exported by `packages/lal/model-resolution.js`) confirmed the panel: `LAL_HOST` is only substring-matched to *pick a provider name* and is then discarded; `resolveModel` resolves registry providers through pi-ai's registry (`getModel`) whose `baseUrl` is hardcoded (`api.anthropic.com`/`api.openai.com`). Only the `ollama/` branch honors a custom endpoint, via the `OLLAMA_HOST` credential. So the registry-provider Tier-1 cell as described would either silently exercise Ollama (false pass) or hit the real public API.

**Applied (design-doc-only change, 1 file):**
- Rewrote **The mock LLM gateway** section: corrected the over-broad "form host redirects every shape" claim; split the two G12 shapes — the Ollama shape already redirects via `OLLAMA_HOST`, the registry-provider shape has **no** endpoint-redirect seam today. Named the concrete seam Tier 1 must add (a harness-level `baseUrl` override, e.g. `LAL_BASE_URL`, threaded into `resolveModel`'s registry branch, *not* `LAL_HOST` sniffing) as a Tier-1 prerequisite, and stated that until it lands Tier 1 gates G16 on the Ollama shape alone.
- Added a budgeted MVR line item (G16, "day") for the `baseUrl` override seam.
- Reconciled the Tier-1 assertion table cell so it points at the per-shape redirect mechanism rather than implying the form host alone suffices.

**Push:** commit `8e1e951e5` advanced `endojs/design/familiar-release` (`09fb85c78..8e1e951e5`) via `safe-push-pr-head.sh`.

**CI:** GREEN — 5/5 checks, 0 failed (rc 0).

Per stage contract: fix applied once, pushed, CI watched to terminal green — did **not** re-run the panel (driver re-posts panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1278617 cached reads)
- Output: 13851 tokens
- Cost: $1.6428654999999996
- Wall-clock: 650s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
