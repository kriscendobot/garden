The job is genuinely complete — a prior claimant of this exact job base delivered it, and the commit is already on `origin/main2` (`343af39b28`). I verified everything rather than assuming; nothing remains to build. Working tree is clean, so no new commit or push is needed.

---

## Completion report

**Job:** `improve-reject-nul-in-source-diffs` — add a deterministic changed-source probe to `scripts/jobs/gardening/pre-push-gates.sh` that rejects literal NUL bytes in text source/test files before push, with an escape-based remediation message.

**Status:** Already delivered and landed on `origin/main2` at commit `343af39b28` ("feat(pre-push-gates): reject literal NUL bytes in changed text files") by a prior claimant of this same job base. A cross-host reaper requeue started me clean, so I re-discovered and verified the existing work rather than duplicating it. My worktree needed no new commits (clean status).

**What the delivered change contains (verified, not assumed):**
- `scripts/jobs/gardening/pre-push-gates/probes/no-nul-bytes.sh` — a new probe, present and executable, auto-discovered by the driver's `probes/*.sh` loop. It walks the changed files (staged → unstaged → `<base>...HEAD` under `--base-ref`), reads each file's post-change content **streamed straight into a perl detector** (never a shell variable, which would strip NULs), and fails whole-file on any NUL (U+0000). The remediation message directs the author to spell the byte with a textual escape (`\0`, `\x00`, `String.fromCharCode(0)`, `Buffer.from([0])`). Non-auto-fixable by design. Skips genuinely-binary paths: a curated known-binary extension denylist, `references/`/`node_modules/`, and any gitattributes `-diff`/`binary`-declared file.
- `scripts/jobs/test/pre-push-gates-test.sh` — three regression cases added.
- `skills/pre-push-gates/SKILL.md` — probe table row + dated changelog entry.

**Verification I ran:**
- Full `pre-push-gates-test.sh` suite → all green, including the three NUL cases: staged NUL rejected with the escape suggestion, committed `--base-ref` NUL rejected, and a `.png` binary asset left untouched.
- `shellcheck scripts/jobs/gardening/pre-push-gates/probes/no-nul-bytes.sh` → clean.
- Probe file is executable; `origin/main2` HEAD is the landing commit; working tree clean.

**Changes made this attempt:** none — the deliverable was already complete, correct, tested, and pushed.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reject-nul-in-source-diffs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (307986 cached reads)
- Output: 3139 tokens
- Cost: $0.674157
- Wall-clock: 52s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
