Builder stage complete. PR #669 is open as draft against the frozen `llm-08f5acc` base, all gates green, inbox empty.

---

## Completion report — `build-endopi-jsonl-transcript-format`

**What I built**

Implemented the design `endopi-jsonl-transcript-format` (endopi raft, M3) as a new self-contained package **`@endo/jsonl-transcript`** (`packages/jsonl-transcript/`, private) in `endojs/endo-but-for-bots` — the append-only on-disk JSONL projection of a Lal reply-chain transcript graph under `<ENDO_STATE>/sessions/<guest-id>/<timestamp>_<session-id>.jsonl`.

- `types.d.ts` + `src/entries.js` — the `header`/`message`/`compaction`/`branchSummary`/`custom` entry format (`version: 3` = Pi v3), `formatEntry`, and torn-line-tolerant `parseEntries`/`parseLine`.
- `src/writer.js` — `makeSessionWriter`: lazy `0600` create, `O_APPEND` writes, idempotent `writeHeader` across reopen, torn-final-line recovery by truncating to the last newline.
- `src/reader.js` — `loadFromJsonl` (graph reconstruction), `assemblePath` (root→leaf branch walk), `readSessionFile`.
- `src/project.js` — `projectGraph`/`projectNode` (Lal node map → entries) and the inverse `loadTranscriptNodes`, so an agent can resume from its own file; handles branching and Lal's alias-node duplication.
- `src/session-path.js` — path helpers with a traversal-guarding segment slug.
- `docs/session-format.md`, `README.md`, plus a `minor` changeset and copied `LICENSE`/`SECURITY.md`.

**PR**: [endojs/endo-but-for-bots#669](https://github.com/endojs/endo-but-for-bots/pull/669) — **draft**, base `llm-08f5acc` (frozen `llm`, matching the repo's endopi-feature convention seen on #668/#661), head `endopi-jsonl-transcript-format`. Affected package: `packages/jsonl-transcript` (new); `yarn.lock` in a separate `chore:` commit.

**Verified (real execution, in the project worktree)**
- `ava` — **21 tests pass** (serialize/parse incl. torn line; path composition + traversal guard; writer against a real temp FS: 0600, lazy create, reopen-no-double-header, torn-line recovery; projection round-trip w/ branches, custom entries, alias dedupe, `assemblePath`).
- `tsc` (package `lint:types`) — clean, exit 0.
- `eslint '**/*.js'` — clean, exit 0 (fixed `no-continue`, `no-bitwise`, numeric-separator, safe-await-separator, inline-`import()` JSDoc).
- `prettier --check packages/jsonl-transcript` (repo-scoped, honoring `.prettierignore`) — clean. SECURITY.md hash matches all siblings (uniformity gate).

**Scoping decisions (surfaced for review)**
1. **Doc path.** The design/job names `packages/coding-agent/docs/session-format.md`; that is Pi-mono's *reference* file (`coding-agent` does not exist in this repo — it's the Pi CLI package). I placed the Endo-side doc at `packages/jsonl-transcript/docs/session-format.md`, tracking Pi's.
2. **Scope = substrate.** Delivered the format + writer + reader + projection + docs + tests (design Phase 1–2 shape). **Not** included, as later design phases: wiring the writer into the live Lal/Fae agent loop (capturing each message's daemon `messageId` on send) and the operator `endo session list/show` CLI verb.
3. **Base branch.** Frozen `llm` (`llm-08f5acc`), not `master` — the endopi raft lives only on `llm` and recent endopi-feature PRs base off frozen `llm`.

**Follow-ups**: live-agent writer wiring; `endo session` CLI verb; `compaction` integration once `endopi-iterative-compaction` lands. Builder stage ends with the draft PR open; hand off to the panel/gauntlet.
