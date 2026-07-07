Both tasks complete. PR #2 is CLOSED (not merged), the branch `cognito-mcp-metadata-bridge` is retained, and `DEPLOYMENT.md` is on `origin/main`.

---

## Completion report

**Task 1 — `DEPLOYMENT.md` committed to `origin/main`.** Verified the draft against repo reality before committing:
- `src/` (config seam, verifier, scopes) confirmed present; `grep` confirmed **no AWS SDK imports in `src/`** (draft's portability rule holds).
- Current code uses `mcp:*` (colon) scopes and `aud == resourceUrl` verification — consistent with the draft marking the `mcp/` scope fix + client_id verifier as **Phase 2 (pending)**.
- `infra/` CDK tree confirmed as App Runner + Cognito + API-Gateway-bridge (matches the "superseded, retained as reference" statement); `deploy/` and `config/` correctly absent (future phases).
- No pre-existing `DEPLOYMENT.md`.

The draft was accurate, so I committed it verbatim (no corrections needed; architecture directives left intact). Pushed cleanly to `main`.

**Commit SHA: `448de88e5e0c925684422a45db9e3713a0cd6597`**

**Task 2 — PR #2 closed without merging.** Posted a comment pointing at `DEPLOYMENT.md` explaining it's superseded by the EC2/Caddy target, that its pre-token-generation-Lambda idea survives in Phase 4, and that its aud-stamping goal is dead (verifier now validates `client_id` against an allowlist instead of RFC 8707 `aud`). Then closed PR #2 (state now `CLOSED`, not merged). Branch `cognito-mcp-metadata-bridge` retained (confirmed via API). Comment: `#issuecomment-4900525404`.

**Follow-ups:** none blocking. The phase-plan table's `pending` rows (Phase 2–6) reference jobs to be posted on the garden board per the doc's orchestration note — that's the next stage of this orchestration, not part of this job.
