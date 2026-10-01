---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-01T04:22:06Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build phase 1 of endo-claude-inference-backends: the `@endo/inference` seam

Repo: `endojs/endo-but-for-bots`, base `llm`. Design (merged 2026-10-01 03:22Z via
https://github.com/endojs/endo-but-for-bots/pull/1357):
`designs/endo-claude-inference-backends.md`, § Phased Implementation item 1, plus
§ The Inference Seam, § Ownership Map, § Design Decisions, § Verification Gates.

Build the provider-neutral `@endo/inference` package: the `InferenceBackend`
interface and its request/result/usage-record shapes as guards, the
`CredentialSource` shape, the mechanism libraries (limit enforcement,
pinned-table classification), and the two enrichers (prompt-origin gate, usage
recorder). No provider package may be a dependency. Port from the gap-revealing
prototype https://github.com/endojs/endo-but-for-bots/pull/1369 (draft, branch
`probe/endo-inference-1357`) and minion.town #105/#106 where the design says so;
do not merge or modify #1369 itself (it stays a draft gap report).

Open a DRAFT PR (via ensure-pr.sh) with unit tests for the guards, limit
enforcement, classification, and both enrichers. Phase 2 (Claude core + CLI/SDK
backends) is the next child of this orchestration and stacks on this PR.
Arc: https://github.com/kriscendobot/garden/issues/89 item 4.
