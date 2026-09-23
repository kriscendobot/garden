Done. Work landed on `origin/main2` at commit `3a76ea5b` and the scratch worktree is cleaned up.

---

## Completion report: build-local-prepr-verification

**What I built.** A deterministic, no-LLM pre-PR verification harness that runs the project's real verification steps in the project worktree before a PR push, so format/lint/build/test/docgen failures are discovered locally rather than on the CI server — shortening (or eliminating) the shepherd loop and keeping raw failure logs out of agent context.

**Commit / SHA.** `3a76ea5b` on `origin/main2` (fast-forward from `a6ff8afb`). Bot identity (`endolinbot`). Built in an isolated worktree off `origin/main2` per garden-infra discipline; committed explicit pathspecs; scratch torn down.

**Entry point + per-step discovery.** `scripts/jobs/gardening/local-verify.sh [<worktree>]` (defaults to cwd). Steps run in order `format → lint → build → test → docs`. Each step's command is discovered, first match wins:
1. `LOCAL_VERIFY_<STEP>` env override (a command string, or `-`/empty to skip);
2. a `package.json` script from a small candidate table (check-variant first, e.g. `format:check` before `format`; `lint:check`/`lint`; `build`/`compile`; `test`/`test:unit`; `docs`/`build:types`/`generate-docs`), run as `<yarn> run <script>` (`yarn`, else `npx corepack yarn`, overridable via `GARDEN_YARN`);
3. otherwise skipped. No project's commands are hardcoded; a repo with no `package.json` verifies nothing and exits 0.

**Capture / inspect contract.** Silent on full success (exit 0, no output). On a step failure, the combined stdout+stderr is hashed into the *worktree's* object store via `capture_blob` (the `common.sh` `git hash-object -w` helper from the audit-self-healing-wrappers work), and stdout carries only `STEP <name> FAILED: output blob <sha> (<n> lines) inspect: git -C <wt> cat-file -p <sha>` plus a one-line tail — never the raw log. All steps run (failures aggregate), then exit non-zero. A debugging agent reads only the slices it needs: `git -C <wt> cat-file -p <sha> | grep/sed/tail`. I chose to hash only on failure (success needs no blob), documented as a deliberate read of the "hash then discard on success" contract.

**How it plugs into the flow.** Wired as the default `GARDEN_EVAL` in `scripts/jobs/gardening/garden-pr.sh`, replacing the `true` no-op — so the gardening state machine's always-run evaluation gate now pre-verifies before the CI push. The supervising gardener runs the capture → SHA → debugging-agent → fix → re-verify loop locally until the gate is silent; the shepherd's job shrinks to confirming CI.

**Tests & verification.** `scripts/jobs/test/local-verify-test.sh` — 12 assertions, all passing: full-pass silence + exit 0; failing step emits only step+SHA+tail (no raw body); `git cat-file -p <sha>` returns the captured output; check-variant discovery; override skip/replace; empty-repo exit 0; determinism (identical failure → identical SHA). `bash -n` and `shellcheck` clean on the harness, the test, and the edited `garden-pr.sh`.

**Docs.** New skill `skills/local-verify/SKILL.md` (full contract incl. the debugging-agent inspection recipes and cross-host anchoring note); cross-references added to `skills/pre-push-gates/SKILL.md` (complementary push-path halves), `designs/gardening-state-machine.md` (stage 3 now names the default runner), and the `CLAUDE.md` skills inventory.

**Follow-ups (none blocking).** (1) `pre-push-gates.sh` is still skill-only (no executable yet); when it lands, the push path should run it (mutating style/probe gate) then `local-verify` (read-only full suite). (2) The candidate tables are intentionally small and extensible — extend per project as new script names appear rather than branching.

Self-improvement: nothing this time.
