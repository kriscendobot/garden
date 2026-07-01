The investigation is complete. Here is my report.

---

## Completion report: `proposals-matrix-test / build` on kriscendobot/agoric-3-proposals PR #1

**What I did — read-only investigation of upstream Agoric/agoric-3-proposals#320, local reproduction, honest summary on the fork PR.**

### Key finding: the "still failing" red is TWO different failures conflated as one
1. **Earlier run** (sha `d0a41d6c`) — a **real code bug**: `./run_eval.sh 111:ymax-beta` → `ERR_MODULE_NOT_FOUND: @agoric/synthetic-chain` from the generated `eval_submission.js`. **This is genuinely fixed** and survived the retcon.
2. **Latest run** (sha `7984e0db`, current #320 head) — a **depot.dev infrastructure flake**, NOT a code defect: `http2 PROTOCOL_ERROR` → **38 `rpc … EOF` errors all stamped the same second (23:16:49)** = a connection-wide reset of the depot builder → terminal `inconsistent graph state` on the **pre-existing `use-upgrade-8`** stage (unrelated to 111–116). The build aborted ~2 min in, before `eval-ymax-beta` even ran — so the module-not-found did **not** recur.

### Verification integrity (the crux the job demanded)
- **Reproduced-then-greened locally** the real code defect: the fork tree is byte-identical to upstream #320; `corepack yarn install` in a copy of `proposals/111:ymax-beta` resolves `node_modules/@agoric/synthetic-chain`, and `binary=agd node -e "await import('@agoric/synthetic-chain')"` **loads 75 exports**. The `ERR_MODULE_NOT_FOUND` is gone; the fix is the standard `.yarnrc.yml: nodeLinker: node-modules`, present on all six new proposals (parity with every existing core-eval proposal).
- **Honestly could NOT reproduce** the full matrix build: it needs Docker + the depot.dev remote builder + Agoric's private base images + an OIDC `DEPOT_TOKEN` scoped to the Agoric org. None available here — which is also **why the fork runs zero CI** (confirmed: 0 workflow runs), so a green fork would be meaningless and I did not manufacture one.

### What changed / didn't
- **No code pushed.** The tree is already correct (retcon-preserved, identical to upstream #320, real bug verified fixed). Applying a spurious change would have been dishonest. Retconned structure + net diff (111–116, bundles, documented 113, changeset) preserved.
- **Posted a summary comment on fork PR #1** (comment 4860948079) with the two-failure diagnosis, the reproduced-then-green evidence, and the honest can't-reproduce-the-matrix statement.

### Follow-up (beyond bot authority)
The remaining red clears with a **CI re-run of #320** — the failing edge is unrelated infra, not this PR. Triggering that is upstream-only (off-limits per scope); the maintainers (dckc/kriskowal, already on the thread) get this via the PR comment. Recorded a reusable reference memory distinguishing a3p depot infra flakes from real proposal bugs.
