No peer reply pending. All deliverables complete.

## Completion report

**Job:** Revise the design on PR #853 (`endojs/endo-but-for-bots`) per maintainer directive on garden issue #64, reconciling its `llm` publication mechanics with the capability-attenuated `npm.minion.town` staging boundary from PR #890.

**What I did**
- Read both current design PRs (#853 `designs/llm-dev-publish.md`, #890 `designs/npm-dev-publisher-attenuation.md`) and their full review histories, plus the issue #64 thread including the maintainer's sitrep (comment 5463679721) that defines the reconciliation direction.
- Coordinated on the message bus with the live parallel job revising #890 (`endojs-endo-but-for-bots-pr890-revise-chronological-publishing-20260829`) to keep the ownership split and the shared `dev-*` tag spelling mutually consistent.
- Revised `designs/llm-dev-publish.md` in place on the existing PR head branch `design/llm-dev-publish` (commit `59e24622e`), keeping the PR draft.

**What changed in the design**
- **Removed the direct agent-to-npmjs.com credential path.** The `llm` workflow now authenticates only to `npm.minion.town` with an attenuated `PublishGrant` token, holds no npmjs.com credential / `id-token: write` / trusted-publishing binding, and cannot publish an ordinary or `latest` version anywhere.
- **Delegated to #890 (not duplicated):** the `PublishGrant` capability, proxy validation pipeline (P1–P8), `dev-*` tag shape + monotonicity, and the deterministic promoter that is the sole npmjs.com credential holder and independently revalidates policy, grant state, integrity, and byte identity. Added *Relationship to the attenuation design*, *Dependencies*, and updated *Resolved decisions*.
- **Preserved and sharpened:** FIFO `llm` ordering (now framed as the origin of end-to-end chronological upstream order via the promoter's seq-ordered event log), commit-derived `X.Y.Z-dev.<ts>.<sha>` versions, staged manifests, and manifest-backed idempotent retry/recovery.
- **Reconciled development-tag semantics:** immutable per-commit `dev-<ts>-<sha>` staging tags plus one shared moving `dev-latest` pointer; bare `dev` dropped because it cannot pass the registry's `^dev-` rule (prefix stays `dev`, never `llm-dev`). Recorded the shared-pointer spelling as a cross-design open question.

**Verification:** `prettier --check` passes; `git diff --check` clean; no mermaid fences; no em-dashes or Latin shorthand (matching the file's voice). `yarn docs` still cannot run in the warmed worktree (`typedoc` not executable) — unchanged from the original submission, unrelated to this markdown-only change.

**Posted (per directive authorization):** top-level summary on PR #853 (`#issuecomment-5463930430`); outcome reply on garden issue #64 (`#issuecomment-5463931447`), left open.

**PR:** `endojs/endo-but-for-bots#853`, slug `llm-dev-publish`, left draft — its design-panel gauntlet is staged automatically by the completion machinery.

**Follow-ups:** The peer #890 revision should adopt the identical reserved shared-moving `dev-*` tag name (`dev-latest` proposed); coordinated on the bus, no reply yet — non-blocking.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr853-revise-npm-minion-town-20260829.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3252744 cached reads)
- Output: 34325 tokens
- Cost: $3.596842
- Wall-clock: 499s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
