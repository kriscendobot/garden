Inbox empty. Work complete.

## Completion report

**Job:** `improve-block-nul-pr-diffs` — add a deterministic pre-push gate that rejects NUL bytes in candidate files, so a test file made binary by literal NULs can no longer hide its substantive diff from GitHub review.

**What I did**

- **New probe** `scripts/jobs/gardening/pre-push-gates/probes/no-nul-bytes.sh` (executable, mode `100755`). It walks the changed files across all three diff modes the driver supports — staged, unstaged fallback, and `<base>...HEAD` when `--base-ref` is supplied — and fails any changed text file that carries a literal NUL (U+0000). Because a NUL makes the whole file binary (git produces no added-line ranges), the check is whole-file. Content is streamed straight into a `perl -0777` detector, never captured into a shell variable (which would silently strip NULs). The failure line names the file, NUL count, first byte offset, and suggests a textual escape (`\0`, `\x00`, `String.fromCharCode(0)`).
- **Scope / escape hatches** (narrow-by-design so no real asset is flagged): a curated known-binary extension denylist (images, archives, fonts, media, compiled objects, …); `references/` and `node_modules/`; and any file the repo declares binary via a gitattributes `-diff`/`binary` attribute (the principled per-file opt-out for an intentionally-binary fixture with a text-shaped name).
- **Regression coverage** appended to `scripts/jobs/test/pre-push-gates-test.sh`: a staged NUL is rejected (asserting both `probe no-nul-bytes` and the offending filename in the report), a committed `--base-ref` NUL is rejected, and a genuinely-binary `.png` asset passes untouched.
- **Docs**: added the probe row to the *Garden-specific deterministic probes* table and a dated changelog entry in `skills/pre-push-gates/SKILL.md`.

**Verification**

- shellcheck clean on the probe and the test file.
- Full `pre-push-gates-test.sh` suite passes (9/9 `ok`), including the three new NUL cases.
- Manual smoke test confirmed all paths (clean pass, staged/base-ref NUL fail, binary-ext skip, gitattributes `-diff` skip). The driver auto-discovers the probe by glob, so no driver edit was needed.

**Changed files:** `scripts/jobs/gardening/pre-push-gates/probes/no-nul-bytes.sh` (new), `scripts/jobs/test/pre-push-gates-test.sh`, `skills/pre-push-gates/SKILL.md`. Committed and pushed to `main2` (`d24f8862e8..343af39b28`).

**Follow-ups:** none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-block-nul-pr-diffs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1505530 cached reads)
- Output: 16474 tokens
- Cost: $1.8822529999999997
- Wall-clock: 226s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
