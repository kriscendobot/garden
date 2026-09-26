All core CI jobs pass: **`test` (5m7s), `test-xs`, `cover` (22.x + 24.x), `test262`, `sandbox-drivers`, `lint`, `viable-release`, `test-hermes`** — the daemon suite and XS conformance are green. The remaining `test (matrix)` per-OS jobs are still queued (macOS runners are slow), but the comprehensive ubuntu `test` job already exercised my new tests.

The builder stage is complete. Here is my report.

---

## Completion report: `endojs-endo-but-for-bots-mount-glob-build` (PR B of #127)

**Draft PR:** [endojs/endo-but-for-bots#653](https://github.com/endojs/endo-but-for-bots/pull/653) — `feat/mount-glob`, stacked on `feat/mount-revocation` (PR A, #650). Left in **draft** per the builder norm (the panel stage un-drafts).

### What I built
Implemented `EndoMount.glob(pattern)` in `packages/daemon/src/mount.js` per the design's normative pattern semantics:
- Splits on `/`, drops empty segments (`src//x` == `src/x`, trailing slash ignored), throws on a zero-segment pattern.
- Only `*` and `**` are metacharacters. `*` = zero-or-more chars within one segment (never `/`, matches leading-dot names); `**` as a whole segment = zero-or-more directory levels (embedded degrades to `*`); every other char (`?`, `[`, `]`, `{`, `}`, `+`, …) is a literal.
- Deny-filtered (denied names never surface, even when named literally → `[]`, not a throw), confinement-excluded (escaping symlinks dropped), directories included, results sorted by UTF-16 code unit **as a final step**, capped at `GLOB_MAX_RESULTS` (10,000) with silent truncation **after** the sort (deterministic across platforms).
- A trailing-`**` fix: the globstar branch emits file descendants, not just directories (caught during authoring before first test run).

Wired `glob` into the `MountInterface` guard, the `EndoMount` type, the help text (`help.md` → regenerated `help-text-data.js`, minimal one-line insertion), and the `mount-platform-fs-conformance` extension allowlist.

### Shared cross-language test contract (landed here per the design)
- `test/mount-fixture-manifest.json` — declarative fixture tree (files, empty dir, denied credential names, binary probe, optional escaping symlink).
- `test/_mount-fixture.js` — Node-side materializer (skips the optional symlink where unsupported).
- `test/mount-glob-cases.json` — the glob variant coverage matrix (~38 cases), each with a hand-computed exact expected result; the contract a Rust/XS runner will consume.
- `test/mount-glob.test.js` — the Node runner plus targeted tests: empty-pattern throws, subView scoping, an **overridden-empty-deny-set** test proving the deny-filter results are load-bearing (not just absent names), and the truncation unit test over a generated 10,005-file tree.

### Verification (evidence)
- Local: `ava test/mount-glob.test.js` → **5 passed** (including the full case-table matrix); conformance + mount + revocation + snapshot + helpdown → **135 passed**.
- Gates: `eslint` **0 errors**; `tsc` **exit 0**; `prettier --check` clean on all touched files.
- CI on #653: **lint, test, test-xs, cover (22.x/24.x), test262 (22.x/24.x), sandbox-drivers, test-hermes, test-async-hooks, test-ocapn-python, viable-release, build-wasm, familiar-bundle — all pass.** The per-OS `test (macos-15 / ubuntu matrix)` jobs were still queued at report time; the comprehensive ubuntu `test` job (which runs the daemon suite) already passed.

### Follow-up filed
Parked plan job `endojs-endo-but-for-bots-mount-glob-rust-runner` (role: builder) — the design-named Rust/XS-side case-table runner over the shared JSON artifacts — and posted a tracking comment on #653.

### Notes
- No dependency changes, so no `chore: Update yarn.lock` commit was needed.
- The isolated project worktree (`project-wt-…-d4b466a9`) remains under `$GARDEN_SCRATCH` for GC; the branch is pushed.
- I did **not** run the juror panel/un-draft gauntlet — that is the next supervised stage, and un-drafting is premature while PR A (#650) is itself an unreviewed draft.
