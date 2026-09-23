Applied the design panel's round-1 must-fix items to PR #832 (`endojs/endo-but-for-bots`, `docs: Design ReadableBlob lines stream`) and drove CI to green.

**What I did**

Read the latest request-changes panel verdict and applied its must-fix items in `designs/readableblob-lines.md` and `designs/README.md`:

- **Reconciled the line-addressing convention** (critic, skeptic, ergonomist — the dominant must-fix): changed `lines({start,end})` from the invented *inclusive, negative-capable* convention to the established `rangeReadText`/`textRange` convention on the same interface — **zero-based, end-exclusive, non-negative, `EINVAL` on negative/fractional/non-safe bounds**. This simultaneously resolved the skeptic's streaming-premise break (negative/"tail" bounds had forced a full-source scan before first yield); every range now streams forward with a bounded skip and closes at `end`.
- **Clarified the return-shape family** (ergonomist): added a paragraph on how `rangeReadText` (string) / `textRange` (sub-blob) / `lines` (stream) share one addressing convention and compose.
- **Glossed `readableBlobMethodGuards`** at first use (novice).
- **Named the range-attenuation companion `Status: Proposed`**, not "accepted" (critic, skeptic).
- **Fixed the ambiguous "It" pronoun** to name the scanner (copyeditor, novice).
- **README**: replaced the out-of-order `2026-07-22 / 149-designs` totals paragraph with a running-log entry (`193 → 194`, Proposed `38 → 39`) (pedant, critic), and reverted the unrelated arrow edit on the 2026-08-27 genie line.

**Base-conflict resolution**: while watching CI, the PR went `CONFLICTING`/`DIRTY` because its base `llm` had advanced (`65eb8869d` → `38ca1d189`, #896 cbor split) and the hot `designs/README.md` collided — GitHub therefore scheduled **no** `pull_request` workflows. I rebased the head onto current `llm`, collapsing the 4-commit stack into one clean commit and resolving the README milestone conflict (kept `llm`'s M4=9 with `cbor-encode-decode`, took my M3=20 with `readableblob-lines`). Force-pushed via `safe-push-pr-head.sh --mode rewrite`.

**What changed**: PR head is now `f53b347d4` on base `38ca1d189`, `MERGEABLE`. All 5 CI checks green (zizmor, lint, test, build, browser-tests); `ci-wait-merge.sh` returned rc 0 (CI GREEN).

**Follow-ups (non-blocking, for the driver/next panel)**: I preserved the PR author's choice not to bump README "Total remaining" for the M3 addition (left at `llm`'s 64), to avoid expanding scope beyond the panel's asks; a later pass may reconcile that. Per the stage contract I did not re-run the panel — the driver re-posts panel-2 against this green head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr832-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 138 tokens (7501460 cached reads)
- Output: 48310 tokens
- Cost: $6.286441
- Wall-clock: 1391s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
