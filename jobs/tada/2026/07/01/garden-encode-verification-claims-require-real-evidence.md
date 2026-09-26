The work is complete and landed on main2. Here is my completion report.

---

**Job: encode "a verified claim requires real-run evidence"** — landed on `main2` at `7655539bb` (pushed cleanly, one-shot rebase CAS).

**What I did**

Encoded the maintainer-surfaced discipline from `endojs/endo-but-for-bots` #58 (garden reported three UI acceptance criteria "verified" from code inspection; Chrome showed only one rendered) in four always-read/juror surfaces plus a self-healing gate:

1. **`roles/COMMON.md` § Reporting** (fleet-wide, read first by every dispatched agent) — a new norm: a "verified" claim requires real-execution evidence and must cite it (command+output, passing test, or observation); code inspection is a design argument, not verification; **UI/browser criteria require an actual browser run** with rendered-DOM observation (a unit test does not satisfy them); an honest **"not verified"** when a run was not possible. Cites the #58 provenance.
2. **`roles/gardener/AGENT.md`** operating norms — the same rule pointed at the gardener completion report, the exact surface that burned the trust.
3. **`roles/jurors/saboteur/AGENT.md`** (code panel) — a **verified-claim evidence discipline** that **rejects as must-fix** any "verified" claim citing no evidence, or evidence of the wrong type for the criterion (a unit test for a UI criterion). Remedy: back it with a real run or downgrade to "not verified" before the panel clears the PR.
4. **`roles/jurors/skeptic/AGENT.md`** (design panel) — the design-side analog.
5. **`scripts/checks/verified-claim-requires-evidence/`** (`check.sh` + `prompt.md` + `README.md`) — a doc-invariant grep-gate (the `claude-md-inventory-drift` shape) that fires when the discipline drifts out of any of those four files (whitespace-normalized so a markdown line-wrap inside an anchor still matches), and dispatches a focused re-encode prompt. Added to the checks README table.
6. **`tests/checks/test_verified_claim_requires_evidence.sh`** — 9 cases (real tree clean, no-`roles/` self-pass, line-wrapped-anchor happy path, missing-file, and each missing-anchor path). All pass.

**Verification** (real runs, cited): the new gate exits 0 on the rebased tree; the new test suite is 9/9; style checks confirm no em-dashes or Latin shorthand in the added prose; `run-all.sh --list` shows the gate registered.

**Follow-ups (pre-existing, not caused by this job)** — two check suites fail identically on `origin/main2` with my changes stashed: `test_run_all` (10/12) and `test_maintainer_inbox_information_hiding` (9/10). The latter's real-tree failure is a legitimate `roles/COMMON.md` reference to "maintainer inbox" at line 96 (the erights maintainer-authority prose) that is not on that gate's `INBOX_ALLOWLIST`; `COMMON.md` is read by free-standing roles, so adding it to the allowlist is likely the correct fix, but that touches a security-adjacent gate and is a separate reviewed act. Worth a dedicated job.
