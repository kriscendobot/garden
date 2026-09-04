All 27 CI checks pass. The fix stage is complete.

## Completion report

**FIX round 1 — endojs/endo-but-for-bots PR #1085** (`feat/mount-stream-glob-grep`)

Applied the panel's must-fix-loop items in one commit (`f18119c5c`, pushed as review-feedback follow-up):

1. **Changeset self-contradiction** (surfacer/releaser/gateway) — `.changeset/daemon-mount-stream-glob-grep.md` no longer claims `sorted: false` "makes streamGrep's walk incremental" while the same file says the walk stays eager. Restated as substrate for a future walk-order producer with no shipped consumer; also restated the long-line and `once`-option prose positively (no draft-relative "no longer"/"active stream").
2. **`grepMatchPattern.file` string cap** (corner-prober) — `file` now opts out of the default 100,000 `stringLengthLimit` like `text`/`streamGlob`'s element, so a very long path can't abort the stream; pinned with a `mustMatch` assertion.
3. **`files: unknown` in generated declarations** (surfacer) — taught the code-mode extractor (`code-mode-type-extract.js`) to resolve an inline `import('@endo/eventual-send').ERef<…>` the same way a bare `ERef` reference resolves; regenerated `fs-declarations.js`, where `streamGrep`'s `files` now renders `ERef<PassableReader<string, any>>`, consistent with every other ERef param in the file.
4. **`yarn generate:help` silently reverted docs commit ed0c899a6b** (gateway) — its mount path-form help rows were hand-edited into the *generated* `help-text-data.js` but never into `help.md`, so this PR's regeneration dropped them. Ported the rows (EndoMount `Paths:` overview, the `entry()` help row, and per-method slash-joined-rejection notes) into `help.md` (the source) and regenerated.

Also refreshed the stale PR description (scribe/gateway/releaser summary-fix): corrected the `streamGrep(pattern, files, …)` signature, the "file list comes from that same walk" claim, the `options.glob` test note, and added the `@endo/platform` `sorted`-option mention.

**Local verification before push:** agent-tools extractor divergence gate (38 tests) ✓, daemon mount-stream-search (36) ✓, daemon help-text (5) ✓, prettier ✓, lint 0 errors.

**CI:** first pass came back 26 green / 1 red, the red being an unrelated `@endo/git` native-watcher flake (`root-follow.test.js:172`, a timing-dependent `commitOid` mismatch in a package the diff doesn't touch). Re-ran that leg; it passed. **All 27 checks now green.** Did not re-run the panel (driver posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-streamgrep-incremental-walk-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 346 tokens (18474279 cached reads)
- Output: 93099 tokens
- Cost: $13.988550500000002
- Wall-clock: 2654s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
