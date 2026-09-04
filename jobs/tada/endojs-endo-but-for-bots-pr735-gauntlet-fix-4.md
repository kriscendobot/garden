CI is GREEN (rc 0). All must-fix items applied, pushed as a follow-up commit, and CI passed.

## Completion report

**Job:** Gauntlet FIX round 4 for endojs/endo-but-for-bots PR #735 (design: Chat HTTP controller UI).

**What I did:** Read the latest panel-4 verdict (posted as a comment review because GitHub blocks request-changes on an own-authored PR; disposition **must-fix**) and applied all six load-bearing must-fix themes to `designs/chat-http-controller-ui.md`, in an isolated project worktree off PR head `c34b4d279`:

1. **Standalone `HttpClientControl` detection (decomplector/skeptic).** Added a third detection shape `isHttpClientControlLike` (interface tag / `inspect`+`revoke`, no `client`/`fetch`) that renders a control-only surface (Policy, Bindings, Audit, Revoke; no composer), plus a fourth flowchart branch and a Boundary 1 note. Closes the gap where a bare `control()` facet fell through to a generic remotable, contradicting Design Decision 6.
2. **Phase 1 provisioning dependency (skeptic).** Stated explicitly that Phase 1 rests on a not-yet-deployed daemon/CLI change to mint/pin a `FetchService` and grant `client()` (the only current call site is a docstring), owned by `endo-fetch.md`.
3. **Revoked-read-only framing → Bindings panel (skeptic).** Extended proactive-disable to the Bindings panel's per-row Block/Reset/Re-allow, with rationale (`assertNotRevoked()` blocks all eight mutators) and a new integration test.
4. **"Re-allow" affordance home (ergonomist).** Made the data-source decision explicit: a blocked origin leaves the Policy panel's effective list, so the undo lives in the `listBindings()`-backed Bindings panel (added the "Re-allow" action there); updated the interactions table.
5. **Header control-tier badge (ergonomist).** Added an explicit tier badge ("HTTP Service (control)" / "HTTP Client (read-only)") so read-only-vs-control is legible at the header, not inferred from field omission.
6. **Citation-form drift (copyeditor/pedant).** Normalized all self-citations to `§ Design Decisions N`, `§ Open Questions N`, `§ Capability and Authority Boundaries N`, `§ Grounding in the Current Implementation`.

Also swept the added prose for typist-hostile code points, converting em-dashes (period/parens/colon), a middle-dot, and an ellipsis I had introduced back to the doc's ASCII-only convention (original had zero em-dashes).

**What changed:** one commit `13d4529bf` pushed to `origin/design/chat-http-controller-ui` (advanced `c34b4d279..13d4529bf`).

**CI:** GREEN — 5/5 checks, 0 failed, at ~430s.

**Follow-ups:** none from me; the gauntlet driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr735-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4493054 cached reads)
- Output: 28991 tokens
- Cost: $4.052934000000001
- Wall-clock: 896s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
