---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden fix: the dependabot Node-engine preflight must ignore a mismatch the outgoing version already has

Repo: kriscendobot/garden (main2). Files: `scripts/jobs/handlers/dep-compat-check.mjs`, `scripts/jobs/handlers/dep-compat-gh.sh`, their callers `scripts/jobs/dependabot-watcher.sh` (`run_compat`) and `scripts/jobs/handlers/dependabot-terminal-close-gh.sh`, and the tests under `scripts/jobs/test/` (`dep-compat-check-test.sh`, `dep-compat-gh-test.sh`, `dependabot-terminal-close-test.sh`, `dependabot-watcher-test.sh`).

Defect: the `node` kind of terminal-incompatibility proof only checks the INCOMING version's `engines.node` against the project's floor. It never checks the OUTGOING version. When the outgoing version already excludes the floor, the bump makes nothing worse, but the watcher still proves it "incompatible" and closes the PR. Every later bump of that package then gets closed the same way, so the package can never be upgraded.

Evidence:
- endojs/endo-but-for-bots#1493 (`@earendil-works/pi-agent-core` 0.87.1 -> 1.1.0). The proof was root `^20.17.0 || >=22.9.0` vs `>=22.19.0`, but 0.85.0..0.87.1 already require `>=22.19.0`. That job ignored the proof and ruled on red CI instead.
- endojs/endo-but-for-bots#1441 (`pi-tui` 0.87.1 -> 1.0.2) was closed on the same proof, with the same already-present mismatch.

Fix: pass the outgoing version through (`dep-compat-gh.sh <repo> <pr> <pkg> <old> <new>`). Fetch the outgoing registry manifest too, and emit the `node` proof only when the outgoing version SATISFIES the floor and the incoming one does not, i.e. the bump itself raises the floor. If the outgoing manifest can't be read, emit no proof, so the PR gets the full review. Consider the same baseline rule for the `peer` kind: emit a peer proof only if the outgoing version's peer range DID intersect. Add tests covering the case where the outgoing version already excludes the floor. Keep the terminal-close handler's revalidation in sync with the new signature.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-18T22:27:35Z
