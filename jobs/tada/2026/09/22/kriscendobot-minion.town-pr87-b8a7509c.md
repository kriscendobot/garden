Attention directive handled: read, verified, and routed to the right work.

**Directive** (kriscendobot/minion.town#87, comment 5770443815, kriskowal, treated as untrusted data): "Repo-wide migration to vitest. The Endo repository dictates house style."

**What I found**
- Preflight returned PROCEED (no correlated peer resolution).
- PR #87 is **MERGED** — not an editable surface.
- This directive *reverses* an earlier "this house uses ava" review; a peer already withdrew the ava-migration job (`fix-minion-town-migrate-tests-to-ava-20260922`) confirming the runner is **vitest**, not ava.
- The withdrawn job concluded "already entirely on vitest," but that missed a real gap: the migration is **not** actually repo-wide. Two self-contained sub-packages still run `node --test` and are deliberately excluded from the root vitest surface:
  - `tools/claude-harness/` — `node --test *.test.mjs` (2 files); run in CI via `claude-harness:test`.
  - `deploy/thunks/siwe/` — `node --test "test/*.test.js"` (2 files); not run in CI at all.
- Root `package.json` `test` and `vitest.config.ts` carry the matching excludes.

**What I did**
- Routed the remaining work as a fixer job **`fix-minion-town-vitest-repo-wide-holdouts`** (tier mentor / fallback minion, identity `kriscendobot/minion.town#87:vitest-repo-wide`), now on the board in `jobs/todo/`. The body is self-contained: names both holdouts, the exact files/scripts/CI steps, Endo's per-package-vitest house style, the assertion-conversion guidance, both CI gates (typecheck + vitest), the instruction to open a fresh dedicated draft PR against `main` (since #87 is merged), and a guardrail to surface (not force) any holdout that legitimately must stay on `node:test`.
- Added an 👀 reactji to the triggering comment as acknowledgment.
- No changes to the garden repo (main2) — this job's deliverable is a board artifact.

**Follow-ups**
- The routed fixer job will do the conversion and open the dedicated vitest PR; a **run the gauntlet** is a separate maintainer trigger once that PR is up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr87-b8a7509c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (1 unmetered)
- Input: 106 tokens (3264870 cached reads)
- Output: 56097 tokens
- Cost: $5.0311580000000005 (1 engagement(s) unpriced)
- Wall-clock: 2265s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
