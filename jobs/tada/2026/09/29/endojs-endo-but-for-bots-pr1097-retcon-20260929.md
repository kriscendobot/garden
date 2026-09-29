## Retcon of endojs/endo-but-for-bots#1097: done, with the same net diff

The PR's history needed regrouping, so I regrouped it and pushed. The PR's code is unchanged: the new head has the same tree as the old head (`c7134444…`), and the PR still reads `MERGEABLE`. The base stays `llm-1706e63`. Nothing was merged.

**Why it wasn't already in shape:** the old head (`99b69ceed7`) split `packages/platform` across two commits (`273765a08e` and `49c3731fd7`), and both touched `test/cached-fs.test.js`. The exo-stream commit also carried the agent-tools generated files.

**New history on `fix/readableblob-byte-array-cleanup`** (head `9d778de299`):
1. `8751b66b22 docs(changeset): align readable blob method names` — `.changeset/readable-blob-declarations.md` only.
2. `8162280c2a feat(exo-stream): offer a byte-array stream() on bytes readers` — `packages/exo-stream/**` plus its changeset.
3. `9070188207 chore(agent-tools): regenerate code-mode declarations for bytes-reader stream()` — the three regenerated `code-mode-globals` files, which only pick up the new optional `stream?`. I gave them their own commit so each commit covers one package.
4. `1a6ee1d316 refactor(platform): populate the read cache through stream()` — all `packages/platform/**`, with implementation and tests together. Its message combines the two old platform messages, including the stream/events race fix.
5. `9d778de299 chore: Update yarn.lock` — the lockfile only, in its own commit.

**Incident during the push:** my first force-push went out incomplete. A message file wasn't where the script expected it, and the script kept going after the error. For about a minute the remote head was `9070188207`, which has only commits 1–3. I pushed the corrected history right after, and confirmed the new head's tree matches the old one before finishing. If CI started on `9070188207` it will show failures; ignore them, since only the run on `9d778de299` counts.

**Follow-ups:**
- The approving review was on an older head (`bf54c8f16c`), so it's now stale in any case. The base pin and the stream migration also landed after it, so this is expected.
- The remaining ask in that review, "conduct" (merge), is not part of this job and is still open.
- CI on `9d778de299` needs to come back green before merging. Earlier notes say the ubuntu Node 24.x red on this PR was a runner problem, not the code.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1097 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `bf54c8f16c70151be62d28461fca83012bc077bf`; this job presented `9d778de299938ffcf149949a7234b59ef44290be`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-retcon-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (526826 cached reads)
- Output: 6368 tokens
- Cost: $0.6567651999999998
- Wall-clock: 93s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
