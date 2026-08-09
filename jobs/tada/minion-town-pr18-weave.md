Rebased PR #18 onto current `main` and force-pushed head `ee4e70d` with lease protection.

Resolved `.github/workflows/deploy.yml` by preserving both deploy lanes in dependency order: Endo daemon → app → Endo gateway → oauth2-proxy → Caddy → www. Updated `DEPLOYMENT.md` accordingly.

Verification passed after refreshing dependencies with `npm ci`:

- `npm run typecheck`
- `npm run build`
- `npm test`: 191 passed, 3 environment-gated integration tests skipped

GitHub reports the approved PR as MERGEABLE. It remains draft. Posted a SHA-anchored completion summary on PR #18.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr18-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 188s

<!-- garden-usage-end -->
