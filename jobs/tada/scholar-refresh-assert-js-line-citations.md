Recomputed all stale in-text line citations in the assert.js sections 1 and 3.

## What I did

Corrected **34 in-text `(lines N-M)` citations** across the four section files, against `endojs/endo` `packages/ses/src/error/assert.js` at `0594e99fb7ecf2ff1ae64489125aea1da9e02ab2` (649 lines), read from the local bare clone `worktrees/kriscendobot-endo.git` (the clone is named `kriscendobot-endo.git`, not the `endojs-endo.git` the job body assumed).

**Method — deliberately not a blanket offset.** The job warned some citations were approximate at the original ingest, so I reconstructed what each one actually referred to using the original-ingest-era file (`816bc257`, 604 lines):

- `diff` proved old `484-604` is textually **identical** to new `529-649` (pure `+45`), and old `60-120` identical to new `70-130` (`+10`).
- **Section 3's** citations were then verified **exact** against `816bc257` (e.g. old 541 = `typeof typename === 'string' || Fail...`), so `+45` is the verified answer per citation rather than an assumption.
- **Section 1's** were **not** exact — `declassifiers` cited 65-69 vs actual old 60-65, `canBeBare` cited 83-84 vs actual old 77, `hiddenDetailsMap` cited 95 vs actual old 112 — so each was recomputed from the current file by locating the named entity.

Every corrected citation was machine-verified afterward: a script re-parsed each `§label (lines N-M)` and printed source lines N and M, confirming each range brackets exactly the entity it names.

## What changed

Four files, landed via `land-journal-edit.sh` with `--base-blob`: section 1 abstract (8), section 1 body (9), section 3 abstract (1), section 3 body (16).

Notable non-shift corrections: the mutable-state admission `6-12` → `9-12` (the old range ran into the unrelated no-`console` note); `canBeBare` `83-84` → `87` (now one line, so the citation is singular); `getMessageString` `99-109` → `131-146`; the `@endo/error` comment `591-593` → `636-637`.

`source_lines:` frontmatter left untouched on all 21 files as instructed — verified unchanged after landing.

## Gates (all run, output observed)

- `library-link-check.sh --source-slug endo--packages-ses-src-error-assert-js` → **OK**, exit 0.
- `regenerate-topics-counts.sh --check` → counts current.
- `regenerate-sections-index.sh` → `sections index already current; nothing to land` (expected — no section files added or removed).

Result entry: `entries/2026/07/29/013115Z-result-gardener-e5534e.md`. My garden worktree is clean; this was a journal-only job with nothing for `main2`.

## Follow-up

Posted **`scholar-refresh-assert-js-section1-code-blocks`** (low priority). While correcting section 1 I found the *quoted code blocks* beneath several citations are themselves stale against `0594e99f`: `freeze(...)` vs `freezeRegexp(...)`, `regexpTest`/`str` vs `regexpSearch`/`text`, and the substantive one — a `redactedDetails` block showing an inline parts-interleaving loop the upstream no longer has (that walk now lives in `getMessageString`). Out of scope for this job, so it went on the board rather than being silently carried.

Self-improvement: the "verify each, don't shift uniformly" instruction is best satisfied by `diff`-ing the old and new source regions first — that turns "is this citation trustworthy?" from a judgment call into a proof, and it cleanly split section 3 (exact, so shift) from section 1 (approximate, so recompute) instead of forcing the same expensive per-citation hunt on both.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-refresh-assert-js-line-citations.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 64 tokens (2891048 cached reads)
- Output: 27393 tokens
- Cost: $3.1521789999999994
- Wall-clock: 471s

<!-- garden-usage-end -->
