CI is green on the new head. The job is complete.

---

**Completion report**

**Job:** `finbot-pr4-harness-doc-drift` — fixer, doc-only correction of `packages/harness/README.md` drift from the merged PR #4 range.

**What I did**
- Isolated project worktree off `origin/main` (`kriscendobot/finbot` @ b06cdac), fresh branch `docs/harness-readme-worker-drift`.
- Read the authoritative wording in `designs/cap-attenuation.md` (updated in the same range) and the actual modules (`sandbox/role-worker.js`, `sandbox/boundary.js`) to stay consistent with existing terms rather than invent new ones.

**What changed** (`packages/harness/README.md`, +21/−4, one commit `e52e9ba`):
- **Quickstart prose:** now states each role-program turn runs in a **dedicated preemptible worker thread** (spawn-fresh per turn, JSON-only transport both ways), which is what makes the `timeoutMs` deadline enforceable against a non-yielding program — the host terminates the worker. Added that `timeoutMs` omitted means no deadline, that the attenuator is the **sole** narrowing point for ambient globals *and* the tool slice (f5d1f91), and that tool grants are denied when omitted (b70fb80).
- **Module map:** added `sandbox/role-worker.js` (per-turn worker evaluating the program in a hardened Compartment) and `sandbox/boundary.js` (shared boundary primitives `ensureLockdown`, `buildGlobalsFromTokens`, `copyJsonData`, extracted so the two sides cannot drift).
- No harness behavior touched.

**Verification (real execution):**
- `local-verify`'s default is yarn, but this repo uses **npm** with no committed lockfile (CI = `npm install` → `npm test`), so the yarn path's failures were an environment divergence, and its codegen-dirty flag was just my uncommitted README edit — neither a real defect. I ran CI's exact steps: `npm install` → exit 0; `npm test` (iterates `packages/*/test/*.test.js`, harness included) → exit 0, all suites pass.
- Committed **only** `packages/harness/README.md` by explicit pathspec (left the npm-generated untracked `package-lock.json` out, since the repo ships no lockfile).
- Opened **PR #7** (https://github.com/kriscendobot/finbot/pull/7) against `main`; **CI `test` check passed** (45s, observed green via `gh pr checks 7`).

**Follow-ups:** none. Inbox was empty; no cross-PR coordination surfaced.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/finbot-pr4-harness-doc-drift.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 37 tokens (1454865 cached reads)
- Output: 10867 tokens
- Cost: $1.7080684999999995
- Wall-clock: 259s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
