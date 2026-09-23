Job complete. PR #27 is MERGED with a merge commit.

## Completion report

**Landed kriscendobot/minion.town#27 (Increment 4 — the weblet publish capability + stubbed charge seam) on `main`.**

**What I did:**
- Confirmed the preconditions: #31 (B4 guest facet tools) was already MERGED into `main` (`14dae5c`); #27 was still unrebased at `8b514e5` (CONFLICTING). The peer rebase/gauntlet job (`kriscendobot-minion.town-pr27-review-615e16eb`) had returned to `plan/` (not active), so I performed the rebase myself, incorporating the Fable proxy review's guidance.
- Rebased #27's single commit onto current `main` in an isolated project worktree. Resolved the three conflicts (all compositional unions, exactly as the review predicted):
  - `src/server.ts` — unioned imports + both `GuestMount` fields (`grants`, `weblets`); B4's `grants` now flows through the shared `guestDeps` to both `registerGuestTools` and `registerWebletTools`.
  - `src/http.ts` — unioned imports; kept both `guestFacetGrants` and `webletsEnabled`; `makeSocketGuestService(sock, guestFacetGrants, undefined, publisherFor)`; the mount literal passes both `grants` and `weblets`.
  - `src/endo/guest-tools.ts` — took the shared `guardedRun`/`requirePublish` spine.
  - `test/endo-weblet-tools.test.ts` — the one real reconciliation: B4 made `GuestToolDeps.grants` required, so the test mount passes a benign `grants: { evaluator: false }` (weblet tools never read it).
- **Net diff preserved** — identical file set to the original PR; only +7 lines, the union reconciliations.
- **Gauntlet:** typecheck clean · build clean · **214 passed / 3 skipped** (combined B4+publish tree) · CI `test` SUCCESS · mergeState CLEAN.
- Verified the mandate behaviors are covered by passing tests: publish capability + gateway-serves-content; owner isolation (owner-gated list/unpublish); charge-before-intern (unfunded → interns nothing); reserved-prefix clean errors; fail-closed (no-publish facet + denied guard).
- Addressed review feedback: answered kriskowal's inline reserved-segments question at `publish.ts:117` (grounded same-origin shadow-protection rationale for `/gateway/*` + `/.well-known/*`), and posted a rebase+gauntlet status comment resolving the CHANGES_REQUESTED "rebase and run a gauntlet."
- Force-pushed with a lease CAS, then **merged with a merge commit** (never squash/rebase). GitHub reports **MERGED** — merge commit `65e655fc`, now the `main` tip.
- Posted issue-scoped progress to garden#58; PR-scoped work stayed on the PR; issue left open.

**What changed:** minion.town `main` advanced to `65e655fc` (Merge PR #27). No garden `main2` changes (project-repo job; worktree clean).

**Follow-up (handed to the deploy-verify stage, not a blocker):** the Fable review's one flagged gap — production write-access to the shared store. `deploy/aws/systemd/minion-mcp.service` sets no `GATEWAY_STORE_DIR`/`MINION_TOWN_DOMAIN` and lacks a `SupplementaryGroups=endo-gateway` / `ReadWritePaths=` grant for `/var/lib/endo-gateway/store` (owned `endo-gateway:endo-gateway` under `ProtectSystem=strict`). Fail-safe (the weblet tools simply don't mount without the store env), so it doesn't block the merge, but Increment-4 **edge verification** needs the unit env + a setgid group-writable store. I documented it in both the PR and issue #58 for the downstream `minion-town-weblet-publish-deploy-verify-20260809` orchestration child, where a real host is available. I deliberately did **not** fold this unverifiable infra change into the reviewed net diff. Excluded scope (bean deflation / toy-tool retirement / PRs #20, #30) was not touched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-publish-land-pr27-20260809.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 113 tokens (4483810 cached reads)
- Output: 36767 tokens
- Cost: $4.111980000000001
- Wall-clock: 586s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
