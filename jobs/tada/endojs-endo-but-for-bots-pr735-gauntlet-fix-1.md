The PR head is my commit `db3c426885` on base `llm`, CI green. The fix stage is complete.

## Completion report

**Stage:** FIX round 1 for endojs/endo-but-for-bots PR #735 (design PR: "Chat HTTP controller UI").

**Panel verdict applied (request-changes).** The dominant must-fix (critic/skeptic/decomplector) was that the design was grounded on daemon infrastructure absent from the branch and documented as superseded: `host.provideHttpClient` / `getHttpClientControl` and the `http-client` daemon formula (#661). I re-grounded the whole design on the actual current mechanism:

- **Re-grounding:** control is now recovered through `ConfinedFetchService.control()` over the landed #566 `HttpClient`/`HttpClientControl` pair, per the `@endo/confined-fetch` model (endo-fetch.md, PR #609), not a WeakMap `getHttpClientControl` on a daemon formula. Detection probes both the bare `HttpClient` and the `ConfinedFetchService` shapes.
- **Persistence corrected:** policy is now durable on the confined service's VFS state directory (revoked revives revoked), not session-scoped; removed the false live-vs-baked front/back divergence. Former Open Question 1 becomes the provisioning-path gate; control phases (2+) now explicitly gate on the confined-fetch path landing (critic).
- **Added a Test Plan** section (skeptic).
- **Read-only revocation gap** fixed (decomplector): a bare `HttpClient` has no `isRevoked()`, so it detects revocation reactively via a `fetch` rejection; header/status and audit claims corrected to control-only.
- **Kill-switch copy** now carries the durability + irreversibility caveat; bindings panel gets explicit Reset/Block labels shown per row state (ergonomist). Added a Design Decision on bespoke-vs-schema-driven panels (decomplector).
- **House style** (pedant/copyeditor): removed all em-dashes, converted typist-hostile code points (`→ ✕ ⌘ …`) to ASCII, joined the broken `E(value).__getMethodNames__()` inline code span.
- **README** updated to match (regrounded recently-added entry, design table row, mermaid node, M9 detail row + count 13→14, dated totals-delta line).

**CI blocker resolved.** The PR head was 1500 commits behind `llm` (7-week-stale branch), and GitHub Actions would not schedule checks for pushes to it — confirmed across two pushed SHAs while an identical fresh design PR (#1102) passed all checks green. I replanted the content as one commit directly on the live `llm` tip (`db3c426885`, resolving the `designs/README.md` divergence against the current index) and force-pushed. Actions then scheduled and all checks passed.

**Result:** `ci-wait-merge.sh ... --no-merge` → **rc 0 (CI GREEN)**, total=6 checks, 0 failed. PR head `db3c426885`, base `llm`, still draft (the driver re-posts panel-2 next).

**Follow-up:** none required for this stage; the driver owns re-review.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 162 tokens (9832193 cached reads)
- Output: 72454 tokens
- Cost: $11.050418999999998
- Wall-clock: 1927s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
