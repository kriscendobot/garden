PR #804 is open against `llm`, authored by the bot, single grooming PR. Work is complete.

## Completion report

**Job:** Weekly Sunday grooming of `designs/` on `endojs/endo-but-for-bots` `llm` branch (2026-07-20).

**Setup:** Worked from a fresh isolated worktree off `origin/llm` (HEAD `00a04f5b4`). Read repo instructions (`AGENTS.md`, `designs/AGENTS.md` design-doc conventions) before editing.

**Audited:** All 170 files in `designs/` (+ `channel threads/`). Ran deterministic scans for unfiled documents (14 found) and broken internal links (63 relative-link defects found), then live-verified PR/issue state with `gh` for every drift candidate rather than guessing.

**Changes made (1 commit, PR #804, 6 files, documentation-only):**
- **Status drift — `chat-pending-commands` In Progress → Complete.** Live-verified PR #133 merged to `llm` 2026-07-13 (commit `82c81afa1`); feature landed as `packages/spaces-util/src/pending-commands.js` + `#pending-commands-region` mount + tests. Updated the design doc (metadata + Status/roadmap prose) and synced all five README surfaces: summary row, dependency-graph node (`IN PROGRESS`→`COMPLETE`), M9 milestone table, per-design estimate, and totals (Complete 42→43, In Progress 23→22). Added a 2026-07-20 grooming layer to the README changelog.
- **17 dangling in-repo links repaired:** `cbors.md` `ocapn-tcp-syrup-framing.md`→`ocapn-tcp-syrups-framing.md` (4); the removed `endo-gateway.md`→`gateway-package.md` in `endo-gateway-mcp.md` (8) + `registry-capability.md` (1), verified via gateway-package's `Supersedes: endo-gateway` header and its `Registration`/`Open Questions` sections; `d256.md`→`daemon-256-bit-identifiers.md` shorthand in `chat-inventory-create-menu.md` (4). Broken-link count dropped 63→46.

**Checks:** Determined no repository check gates `designs/*.md` — `*.md` is in `.prettierignore`; `format`/`lint`/`lint:prettier` target only `.github`+`packages`; `yarn docs` (TypeDoc) reads package source. The load-bearing verification (internal-link integrity) was run directly: all 17 repaired links resolve, no new breaks introduced.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/804 — bot-authored, base `llm`, branch `groom/2026-07-20`, not draft, not merged, no comments on unrelated work. No prior open grooming PR existed to reuse.

**Deliberately left for the maintainer (flagged in PR body, not silently decided):**
- 14 unfiled design docs — full filing needs milestone/estimate judgment, not mechanical grooming.
- `daemon-message-streaming` still "In Progress (PR #287)" but #287 is closed-unmerged and `streamReply` isn't on `llm`; status is accurate, the PR pointer is stale, successor unknown.
- ~46 remaining broken links are cross-repo provenance pointers (`../../journal/`, `../roles/`, `../packages/`) and forward-refs to designs still open in PRs (#432, #450, #356 stack) that resolve on merge.
