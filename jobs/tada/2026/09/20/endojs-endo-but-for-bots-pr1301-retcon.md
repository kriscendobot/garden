Retcon complete. Summary comment posted successfully via REST fallback.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr1301-retcon` — retcon PR #1301 (`feat(platform): ReadableBlob range attenuation (step 1 — platform blobs)`), maintainer directive "Shepherd and retcon, please" from kriskowal.

**What I did**
- Set up an isolated project worktree on the head branch `kriscendobot:build/readableblob-range-attenuation`.
- Confirmed the base `llm-387ea66` is already an ancestor of the head (no weave needed) and captured the pre-retcon tip (`ecadf15b9`) as a reference tag.
- `git reset --mixed` to the base, then restaged the identical net diff as **one commit per affected package**, using explicit pathspecs so the stray untracked `compartment-mapper` fixture dirs (yarn/warm-cache artifacts, not part of the PR) were excluded.

**New history** (head `d74ec536a`):
- `feat(platform)` — shared range-attenuation helpers, LocalBlob, BlobRef, additive types, platform tests
- `feat(git)` — native git backend range attenuation + tests
- `feat(daemon)` — daemon mount/blob attenuation, tests, `@endo/sha256` runtime-dep move, serial ava config
- `feat(exo-git)` — git help-text data
- `chore(agent-tools)` — regenerated `code-mode-globals` declarations
- `chore(floot)` — stray package-description em-dash normalization carried on the branch (kept for net-diff invariance)
- `docs(design)` — ReadableBlob build-review naming design note

**Verification**
- Net diff invariant: `git diff pre-retcon-1301..HEAD` was **empty** (byte-identical tree).
- No `chore: Update yarn.lock` commit — the only `package.json` edits were `workspace:^` moves, which leave the lockfile untouched (no yarn.lock in the diff).
- Force-pushed with `--force-with-lease` against `ecadf15b9` (lease held; no concurrent shepherd push had landed).
- Posted the required top-level summary comment: https://github.com/endojs/endo-but-for-bots/pull/1301#issuecomment-5747648517 (via `gh api` REST after the GraphQL `gh pr comment` path hit the shared primary-quota rate limit).

**Follow-ups**
- The "shepherd" half of the maintainer's comment (drive CI to green; mergeable_state was `unstable`) is a separate verb/job and out of scope for this retcon. If a companion shepherd job was not posted, one should be, since the retcon deliberately preserves the net diff and does not touch CI outcomes.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1301-retcon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1201483 cached reads)
- Output: 13475 tokens
- Cost: $1.9508735000000001
- Wall-clock: 228s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
