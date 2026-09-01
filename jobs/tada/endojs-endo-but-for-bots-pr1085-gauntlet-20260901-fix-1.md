FIX stage round 1 complete for endojs/endo-but-for-bots PR #1085.

**Panel round-1 must-fix items applied** (project head `e72f672f30`, branch `feat/mount-stream-glob-grep`):

1. **`designs/mount-stream-glob-grep.md`** — corrected the "Surface" section's early-close claim (lines 52-53 prose + line 67 comment) to the accurate per-method split: `streamGrep` early close elides remaining *content* reads; `streamGlob`'s walk is already eager (engine's global UTF-16 sort forces the whole match set), so early close saves only marshalling. This removes the intra-document self-contradiction with the sections farther down.
2. **`.changeset/daemon-mount-stream-glob-grep.md`** — trimmed from 332 words to release-note register: one line each for the two methods, the pull-bound/no-cap property, the eager-walk caveat, and the revocation-latency fact; dropped the threat-model exposition and implementation-location detail. Bump levels (minor on both packages) unchanged.
3. **`packages/daemon/test/mount-stream-search.test.js`** — added an invariant test proving a `streamGrep` record's `{ line, text }` identifies the matched source line for generated, regex-matched content (`text === sourceLines[line-1]`, no embedded newline, one record per matched line). All 27 tests pass.

**Should-fix items also applied:**
- Replaced U+2192 `→` with `->` in the PR's new help entries (edited `help.md` source, regenerated `help-text-data.js`).
- Dropped the dangling `done` reference in the `streamGrep` help example (→ `{ ... }`).
- Added the streaming revocation-latency caveat to `makeRevocableMount`'s class-level revoke doc comment in `mount.js`.

**Push & CI:** Committed as one review-feedback fix commit and pushed to the PR head. A first push exposed a prettier formatting nit in the new test (CI lint red); fixed with `prettier --write`, amended, and re-pushed as `e72f672f30`. Fresh CI run reached terminal **GREEN — all 27 checks passed, 0 failures** (bounded `ci-wait-merge.sh`, rc 0).

Per the stage contract I applied the fixes once, pushed, watched CI to terminal, and stopped — did not re-run the panel (the driver re-posts panel-2).

**Follow-ups (recorded by the panel, not this stage's work):** per-grant `buffer` ceiling on `makeMount`/`makeRevocableMount`; fast-check property coverage for `clampStreamBuffer` and the stream-vs-eager equivalence pair; and the scribe's escalation that maintainer comment `#issuecomment-5462863853` needs human closure — all out of scope for the fix stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 150 tokens (7117688 cached reads)
- Output: 29681 tokens
- Cost: $5.386388999999999
- Wall-clock: 1523s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
