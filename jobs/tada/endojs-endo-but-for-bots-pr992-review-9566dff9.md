All asks resolved and pushed. Completion report:

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots` PR #992 (kriskowal, `CHANGES_REQUESTED`, review `4945559559`).

**Enumeration.** The review body was empty; it carried exactly one inline comment (`3791104230`) at `designs/http-adapter-pipeline.md:264`, on the `estimateCost` method of the uniform `HttpStageInterface`. Preflight returned PROCEED (no peer resolution). The comment (treated as untrusted data) made two asks:
1. **Design smell** — `estimateCost` on the general stage interface is a cross-cutting concern (every adapter forwards a probe it has no stake in); provide an alternative where a stage calls forward to the *next* adapter's specialized `estimateCost` as a contract between two adapter *constructors*, not the interface in general. Noted it "won't be the last time."
2. **Terminology** — don't repeat "middleware"; call them "adapters".

**What I did** (all in an isolated fork worktree, committed `53dfdd72b`, pushed to `kriscendobot/endo-but-for-bots@design-http-adapter-pipeline`):
- **Removed `estimateCost` from `HttpStageInterface`** (now `request` + `help` only) and added **`CostQuoteInterface`**, a bilateral facet the composer wires at construction between the meter (provider) and the client's thin forwarder (consumer) — the same capture-at-construction shape `next` uses. Non-participant adapters (retry/breaker/rate) never see it; a meterless chain answers `0` via a named null quote rather than an interface-wide fallthrough.
- **Added a new `### Specialized adapter-pair contracts` section** articulating the general pattern (provide/consume declarations, composer wires each consumer to the nearest downstream provider, fails composition on an unmatched contract, preserves composition opacity, and threads transitively for future multi-party chains) — the general answer to the recurrence concern.
- Updated the client-interface comment, the guard-rule reasoning, the Exo/CLI surface (note that the meter provides the internal `CostQuote` facet), and added a **test-plan bullet** asserting the structural property.
- **Terminology sweep:** reserved "middleware" for the in-process prior art (Koa/Express), renamed self-referential uses to "adapter"/"stage", added a vocabulary sentence. Left the verbatim maintainer-prompt quote and the external prior-art attributions intact.
- Synced metadata: bumped the doc's **Updated** to 2026-08-16 and updated the matching `designs/README.md` summary row (per the design-doc convention that metadata changes sync to the README).

**Follow-through:** posted an inline reply on the review thread (`discussion_r3791137910`) summarizing the resolution and citing `53dfdd72b`.

**Follow-ups:** none required. (Latent, out-of-scope and untouched: `estimateCost`/`costMax` is spelled `FiniteNonNegative` at the boundary while §1 treats `costMax` as `bigint` — a pre-existing tension the reviewer did not raise, left as-is to avoid unreviewed semantic drift.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-review-9566dff9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 64 tokens (3137649 cached reads)
- Output: 32694 tokens
- Cost: $3.4663854999999995 (1 engagement(s) unpriced)
- Wall-clock: 488s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
