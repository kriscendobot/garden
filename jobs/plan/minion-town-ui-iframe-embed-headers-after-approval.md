---
gate: awaiting-maintainer
maintainer_question: 'Approve or merge design PR #189 before implementation begins.'
asked_at: https://github.com/kriscendobot/minion.town/pull/189
priority: normal
role: builder
arc: minion-town-ui
posted_by: gardener
posted_at: 2026-10-15T06:43:17Z
---

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
