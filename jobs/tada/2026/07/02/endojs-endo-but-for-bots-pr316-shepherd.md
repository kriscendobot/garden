Final state: **24 checks green, only `lint` red** (the zip projectService ceiling). Inbox empty. This is the shepherd's definition of done — a hard escalation point surfaced with a clear hand-off. Writing my report.

---

## Shepherd report — endojs/endo-but-for-bots PR #316 (chore: bump bundled Node pin to v22.22.3)

**Starting state:** 3 red checks — `cover (20.x)`, `cover (24.x)`, `lint`.

**Root-cause diagnosis:**
- All three reds traced to `packages/ocapn`, *not* the PR's familiar-only diff. The PR head (930cf2f1) was 1 commit behind base `llm`; that missing commit contained the `makeClient`→`makeOcapn` rename in `ocapn/src/client/index.js`. The stale `test/netlayer-tcp-syrup.test.js` still imported `makeClient`, breaking both the `import/named` lint error and the `cover` test runs (`SyntaxError: ... does not provide an export named 'makeClient'`).

**Action taken:**
- Isolated project worktree; merged `origin/llm` into the head branch (clean, no conflicts), preserving the PR's familiar Node-pin changes intact. Pushed `930cf2f1c..e08e3bc71` to `chore/familiar-lts-node-pin`.
- Result: `cover (22.x)`, `cover (24.x)`, and the original `makeClient` lint error all went green. **24/25 checks now pass.**

**Remaining red — escalated (impasse):**
- `lint` now fails with a *different* error than at start: typescript-eslint `useProjectService` "none of those TSConfigs include this file" for every file in `packages/zip` (the alphabetically-last package). This is the known, documented lint-infra **projectService scaling ceiling**: passes in isolation, fails only on the large whole-repo `eslint .` run, deterministically dropping the last package. Confirmed deterministic — a targeted job re-run reproduced the identical `zip` errors.
- It is **trunk-wide**: `ci.yml` never runs lint on `llm` pushes, so trunk lint drift is uncaught; merging the base's large `#58` commit grew the tree past the ceiling and surfaced it. It affects any current PR that runs the full lint check, not this PR's diff.
- **Out of shepherd scope / hard impasse:** the fix is a dedicated trunk lint-infra change (raise projectService match ceiling or split the lint run). It must **not** be bundled into this Node-pin chore PR.

**Classification: `next: liaison`** — structural/lint-infra impasse needing a maintainer decision + a dedicated trunk lint-infra fix. The shepherd has done all in-scope work (2 of 3 reds cleared; PR advanced from behind-base to up-to-date-and-24-green).

**Follow-up:** A separate lint-infra fix on `llm` (typescript-eslint `useProjectService` ceiling for `packages/zip`) is warranted; once landed, this PR needs only a re-run to go fully green. Merge is already pushed and correct; no further shepherd action is possible without inappropriately bundling infra into this PR.
