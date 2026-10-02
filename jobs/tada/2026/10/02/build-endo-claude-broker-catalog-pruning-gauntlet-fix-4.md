Fix round 4 for endojs/endo-but-for-bots#1409 is pushed as `f417d53307` (a follow-up commit, pushed with `safe-push-pr-head.sh`). CI is green: all 31 checks passed with no failures.

**Must-fix items from the panel-4 review:**
- **locksmith:** `loadContent` is no longer in `confinedToolNames`. A caller can put any HTTP(S) address in a magnet `ws=` hint, and the daemon will fetch it with no destination allowlist, so serving it would let the confined side make the daemon fetch from any address. The reason is now written down in `confined.js`, both READMEs, `designs/endo-guest-stdio-mcp.md` and the existing changeset. The classification test now lists `loadContent` as withheld.
- **corner-prober:**
  - A new broker test checks that `allowedToolNames: ['help', 'evaluate']` replaces the default list and can widen it: `evaluate` is listed and the call reaches the guest.
  - The `tools/call` refusal test now covers all 14 withheld names instead of 3.
- **scribe:** posted the top-level summary comment covering fix rounds 1–4: https://github.com/endojs/endo-but-for-bots/pull/1409#issuecomment-5944826853

**Comment-only items, also done:**
- `selectConfinedTools` now hardens the list it returns (purist).
- The README tool-catalog bullets now mark every withheld name (surfacer).
- New `.changeset/endo-claude-confined-catalog.md` (`@endo/claude` minor) describes the narrower tool surface a confined turn now gets (migrator).

**Checks:**
- **Tests:** `@endo/agent-mcp-stdio` passed 65/65 three runs in a row; `@endo/claude` passed 78/78.
- **Lint:** package lint has no errors. The 17 warnings include `safe-await-separator` at broker test lines 55 and 60, outside my edits; I didn't check the other 15 one by one.
- **Root type check:** `tsc -p tsconfig.json` (the repo-root check CI runs) exited non-zero, but none of its errors are in the touched packages; I didn't confirm whether those errors already existed on the base branch.

**Follow-ups:**
- Two comment-only notes are still open: pruner (one-sentence "does not apply" sections) and fast-checker (property tests for `selectConfinedTools`).
- `loadContent` could come back once the HTTP content plane enforces a destination allowlist.
- Panel round 5 is next and is posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1301012 cached reads)
- Output: 10708 tokens
- Cost: $1.0887784
- Wall-clock: 885s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
