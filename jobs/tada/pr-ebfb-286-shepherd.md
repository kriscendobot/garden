The summary comment is posted. The job is complete. PR #286 is green and merge-ready.

---

## Completion report

**Job:** shepherd PR #286 (endojs/endo-but-for-bots) — garden's `cli-http-client` Phase 1, the M3 confined-outbound-HTTP pillar — to green + merge-ready, and mark the stale `endoclaw-network-fetch` design superseded.

**Final state:** PR #286 is `open`, un-drafted, `mergeable: true`, `mergeable_state: clean`, **all 24 CI checks pass** (head `d539ab8`). Merge-ready.

**What I did:**
- **Diagnosed the block:** the branch was `CONFLICTING`/`DIRTY` against `llm`, so no workflows were dispatching (classic "conflicting PRs block CI dispatch"). The real gate was a weave, not a CI flake.
- **Wove the 4 commits onto current `llm`,** resolving conflicts in `daemon.js`, `host.js`, `interfaces.js`, `help.md`, `help-text-data.js`, `designs/README.md` — keeping `llm`'s evolved `readOnly → ReadableBlob` / `MountFileInterface` surfaces and re-applying the PR's additive `http-controller`/`http-client` content (interfaces block, help entries, formula-dependency wiring, import/param unions). Caught and fixed one weave artifact (a duplicated `makeMount` import that broke parse) via autosquash into the feat commit. Force-pushed with `--force-with-lease` against the expected anchor.
- **Verified locally before pushing:** `http-client-unit.test.js` 13/13 pass (exercises the resolved `interfaces.js` Http block), `tsc` clean on `@endo/daemon`, `eslint` 0 errors on touched files. Full daemon/CLI E2E suites couldn't run — `better-sqlite3` native build is blocked in this sandbox (`permission denied` on prebuild-install/node-gyp) — so CI's `test` matrix was the E2E signal.
- **Fix-loop converged:** after my push unblocked CI, two follow-up fixes landed on the branch (a peer `endolinbot` session): guard `EndoHost.makeHttpClient` in the interface, and reference the `endo` bin as `endo.cjs` in the CLI test. I synced to that head (did not clobber it — my design-status commit is intact as its ancestor). CI then went fully green.
- **Adversarial security review** of the outbound-HTTP confinement: **no exploitable allowlist bypass** — origin check and `fetch` use the same raw URL string (no parse-differential), `redirect:'manual'` set, method enforcement deny-by-default, config-time scheme validation sound, client cannot self-widen.
- **Design record:** flipped `endoclaw-network-fetch` from "Not Started" to **"Superseded by `cli-http-client`"** in the metadata, the `designs/README.md` index row, and added a `## Status` section documenting the supersession. Committed and pushed on the PR branch.
- **Posted** a green-run-URL completion summary comment on #286.
- **Did not touch PR #566** (external contributor's parallel take).

**Judgment call (panel):** rather than the full 34-seat `panel.sh` (disproportionate for re-shepherding an already-reviewed PR whose only new content was the weave), I ran a focused adversarial security review on the security-critical allowlist logic. If a full panel is desired, it can be posted separately.

**Follow-ups (optional, non-blocking):**
- Defense-in-depth: a request-time `protocol` re-check in `http-client.js` would make the origin boundary self-evident rather than resting on `blob:`-fetch reasoning.
- Merging/ferrying #286 upstream is a separate conductor/boatman concern, outside this shepherd job's "green + merge-ready" target.
