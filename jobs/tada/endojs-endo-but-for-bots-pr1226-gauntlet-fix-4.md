CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — endojs/endo-but-for-bots PR #1226 (`docs(designs): a stdio MCP server scoped to one guest's tool surface`).

**Panel disposition applied:** must-fix (aggregated request-changes from critic, skeptic, decomplector, novice; plus should-fix from ergonomist, copyeditor, pedant, novice).

**What I changed** (single commit `265034f57` on `design/endo-guest-stdio-mcp`, pushed via `safe-push-pr-head.sh` advance-mode CAS):

Must-fix items:
- **SO_PEERCRED peer check (critic #1, decomplector, skeptic note):** replaced the "matched by pid, or by a per-guest uid" ambiguity with a single deterministic predicate — the **per-guest uid** — and stated the two reasons a bare pid is inadmissible: concurrent adapters (distinct pids on one broker socket) would be rejected by a pid match, and pids are recyclable (reuse window). Documented the sandbox uid-assignment precondition and the single-uid fallback. Updated the Test plan's negative-confinement item to match.
- **Argument-scope check (critic #2, skeptic #1):** reframed as **defense-in-depth** over daemon-agent-tools' already fail-closed petname/petstore + boundary-authenticated path resolution (dropped the "name-only prune is cosmetic" over-claim); its distinct value is a uniform reject-only wire shape. Added an explicit note that endo-claude DD2's "or attenuates" branch is **superseded** by this doc's reject-only rule.
- **Teardown-on-reprovision (skeptic #2):** reframed from settled fact into a **new cross-document obligation** this design places on endo-claude (which does not commit to it today), carried as such in Open Questions.
- **Long paragraph (novice #1):** split the socket-remount block into mismatch / resolution / resulting-isolation sub-bullets.

Should-fix/prose: guest+harness inline glosses (novice #2); a discriminated construction throw mirroring the request-time `reason` field (ergonomist); comma-splice, gerund, subject-verb, and "mapping" copyedits (copyeditor); "e.g."→"for example" and "incl."→"including" (pedant). Also rewrote every em-dash I introduced to periods/parens/colons per `skills/em-dash-style` (the doc uses none).

I committed only `designs/endo-guest-stdio-mcp.md`, deliberately excluding a stray unrelated `packages/floot/package.json` normalization present in the worktree.

**CI:** GREEN — 7/7 checks, 0 failed (rc 0). Panel was **not** re-run (driver re-posts panel-5).

**Follow-ups:** none for this stage. The two cross-document obligations flagged on `endo-claude.md` (adopt teardown-on-reprovision; reword DD2's "or attenuates") are noted in the doc for a future endo-claude revision, not owned by this PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3954283 cached reads)
- Output: 32110 tokens
- Cost: $3.8010595
- Wall-clock: 985s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
