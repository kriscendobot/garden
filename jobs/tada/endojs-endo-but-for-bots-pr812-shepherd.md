The field note landed on main2 (a stray parent-SHA `e488cea748` glued to "Record" in the body from a shell substitution slip — cosmetic only, and I won't force-push a shared branch for it). Everything is done.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #812

**Diagnosis.** Re-fetched live check state: 23 checks, exactly one red — `zizmor` ("Workflow security audit"). The finding was zizmor's `stale-action-refs` audit (repo runs it at `persona: pedantic` + `min-severity: low`) flagging three `actions/checkout@34e114876b0b # v4` pins: `ci.yml:123`, `ci-docs.yml:42`, `ci-docs.yml:71`. This is a **time-bomb** failure — the `v4` tag moved upstream so the audit fires with no change in the PR's own diff (which touches only `rust/` and `designs/`). Confirmed it is not repo-wide: sibling PRs #811/#809/#807/#806 pass because the default branch `llm` already migrated every checkout to `de0fac2e4500dabe # v6.0.2`; #812's endor stack (#812 → #805 → …) still carried three stragglers.

**Fix.** In an isolated project worktree on the head branch, repinned the three stragglers to `de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2` (matching every sibling usage and the default branch, mirroring precedent commit `1ff3e0d3d` on `llm`). One atomic commit `c0482e3fc` `fix(ci): repin stale actions/checkout hashes flagged by zizmor`, pushed to `feat/endor-npm-relative-resolution`.

**Result — CI green.** New head `c0482e3fc`: zizmor now passes (17s), all **23 checks pass**, `mergeStateStatus` went `UNSTABLE` → **CLEAN**. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/29780881807

**No PR comment posted** — the auto-shepherd job (minted by the CI watcher, no maintainer comment) carries no green-run-URL comment authorization, and the shepherd never originates one.

**Garden self-improvement.** Added a shepherd field note (`roles/shepherd/AGENT.md`, commit `803733cc0` on main2) documenting the zizmor `stale-action-refs` time-bomb: fires with no diff change, the finding hash is the tag's resolved commit (not the pinned SHA, so grep finds nothing), fix is an in-scope inline repin, and `check-action-pins` can pass while zizmor fails.

**Follow-ups.** The same three stale pins still live on the downstream base branches (#805 `feat/endor-run-top-level-await` and lower `reland/endor-npm-offline-npmrc`); those PRs will go red on zizmor until repinned or until they rebase to pick up #812's fix. Not in this job's scope. Also: unrelated PR #808 (`fix/floot-…`, based on `llm`) is independently red on zizmor — separate shepherd job if desired.
