---
role: builder
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=awaiting-maintainer priority=normal maintainer=true at=2026-10-16T17:18:25Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: implement approved clip embedding headers after design approval

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Governing design decision: https://github.com/kriscendobot/minion.town/pull/189. Predecessor job: `minion-town-ui-iframe-embed-headers`.

After a maintainer approves or merges design PR #189, implement its approved clip-embedding relaxation in `src/endo/gateway/isolation-headers.ts`. Add tests proving that only the approved ancestor may frame a clip and that the framing floor remains intact for every other embedder and route. Re-check the live design review/merge state before building and implement the final approved wording, not the current draft by assumption. Open the required draft PR through `ensure-pr.sh` and complete the builder verification and reporting requirements.

<!-- garden-annotation: key=2dc12df6532c by=producer at=2026-10-16T17:18:18Z -->

Maintainer approved design PR #189 on 2026-10-16 (liaison session): approval comment posted on the PR; final wording is the branch head with the ocap.site shell-frame and same-clip-id revisions; static-only first frame confirmed.

<!-- garden-transient-elapsed: kind=signature through=0 values=1712 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T17:34:33Z
