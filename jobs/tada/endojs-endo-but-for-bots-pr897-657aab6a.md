Empty inbox; PR is MERGEABLE at my rebased head `dc6834e47` (UNSTABLE = the one flaky check, not a conflict). The weave and shepherd are complete.

---

## Completion report

**Directive** (`endojs/endo-but-for-bots#897`, kriskowal comment): "Weave, shepherd". Preflight returned exit 2 (HINT); I corroborated — the PR was genuinely `CONFLICTING`/`DIRTY` against base `llm`, so no peer had resolved it. Proceeded.

**Weave (done).** Rebased the 4-commit branch `fix/mount-glorp-713-followup` onto current `upstream/llm` (was 274 commits behind → `CONFLICTING`; now `MERGEABLE`). New head `dc6834e47`, force-pushed with `--force-with-lease`.
- One real conflict: `packages/platform/src/fs/search-types.ts` header (upstream renamed it from `search.types.d.ts`). The branch commit `fbf5583dc`'s "drop dangling design citations" premise is now **obsolete** — `designs/platform-search-pushdown.md` has since landed on `llm`, making the citations valid. Resolved by keeping the citation, and additionally **restored** the same citations in `search.js`, `interfaces.js`, and `search.test.js` that the rebase's auto-merge had silently deleted.
- Reworded that commit's message (dropping the now-inaccurate "drop dangling design citations" claim, with a note explaining why).
- Verified locally: platform tests 319/319 pass; daemon mount glob/grep/glorp tests 28/28 pass (the PR's actual deliverable). Prettier clean on touched files. Net diff preserves the PR's real intent (maxResults, ReDoS bounds, revocation, symlink-deny, help, trailing-newline, glorp seam) and adds nothing spurious.

**Shepherd (25/26 green; 1 known-infra red).** The sole failing check is `test (24.x, ubuntu-latest)`: `@endo/cli` demo tests (`counter-example`, `doubler-agent`) fail with `endo restart` → "Daemon failed to spawn … manager-node.js … exited null". This is **not this PR's diff** — the *identical* demo tests **pass** on `test (22.x, ubuntu)` and `test (24.x, macos)`; only the Node-24.x-linux cell crashes. That asymmetry, plus the varying failure count across runs (1, then 2, then 2 tests), is the signature of the documented Node-24.x/better-sqlite3 native crash (the same bug blocking `endojs/endo-but-for-bots#340`/`#877`/`#475`; pin job `endo-but-for-bots-pin-node-24x-ci`). Re-ran the failed job **3×** — fails consistently; `gh run rerun --failed` does not clear it, and it can't be fixed from a feature branch.

**Follow-ups / notifications.**
- Notified the maintainer via the liaison (msg `20260822T152358Z-a7f0fa`) with the full weave summary and the flake diagnosis.
- Updated memory `ocapn-over-noise-goal.md` with the daemon-spawn shepherd-recognition signature for this flake.
- The green-CI gate is owned by the repo-wide Node-24.x pin, not this PR; the weave itself is complete and the PR is mergeable.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr897-657aab6a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 44 tokens (2509175 cached reads)
- Output: 17670 tokens
- Cost: $2.8278075 (1 engagement(s) unpriced)
- Wall-clock: 3815s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
