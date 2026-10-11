## Completion report: kriscendobot/minion.town PR #179, gauntlet fix round 1

I applied all eight must-fix items from the panel-1 review, pushed them as three follow-up commits on top of `9550ed3` (head is now `91aa6b5`), and CI finished green on all 3 checks (`ci-wait-merge` rc 0). The PR is still a draft; un-drafting is left to the driver.

**What changed, by panel item:**
1. **Name lookup bounded and cancelled.** `makeClipTitleReader` now:
   - runs at most 4 lookups at once;
   - on timeout, aborts the lookup with an `AbortController`, which releases its slot even when a daemon read hangs and destroys the blob stream;
   - caches titles by manifest id. Manifests are content-addressed, so a cached title can't go stale. The cache holds at most 512 entries and drops the oldest.
2. **One name rule, shared.** Both copies are now called `UNSAFE_NAME_CHARACTERS`, in `clip-title.ts` and `shell.js`. A new test checks that the two regexes have the same source and flags and the same `CLIP_NAME_MAX`. It also runs 27 hostile inputs through both `sanitizeClipName` and `clipName` and requires the same output.
3. **Strip set gaps closed.** The rule now removes every control, format, surrogate and line/paragraph separator character, plus the invisible filler characters outside those groups. That covers U+061C, the soft hyphen and the Hangul and Mongolian fillers. The zero-width joiner and tag characters are kept because emoji sequences need them.
4. **`clipIcon` tightened.** A name's first character only becomes the icon if it is a real emoji (shown as emoji by default, or followed by VS16), a flag pair, or a ZWJ sequence, and it is capped at 16 code points. "© 2026 Acme", ®, ™, ‼, ↔, and an emoji followed by 60 combining marks all get the fallback icon.
5. **MCP `sites.list`** now documents the optional `name` field. The title is sanitized when it is read, so the MCP path does not miss the endpoint's clean-up.
6. **Regression evidence:**
   - a DOM-level gutter test, using a minimal fake document, that checks `data-serving`, `aria-label` and `title`;
   - a new `test/clip-names-http.test.ts` that goes through `createApp` and sees `name` in `/account/clips`;
   - tests for timeout cancellation, the 4-at-once limit (including that a hung read gives its slot back), and the cache.

   I confirmed the tests catch real breakage: deleting the `dataset.serving` line, removing the stream-destroy-on-abort, or dropping the `nameFor` wiring in `http.ts` each makes a test fail.
7. **Narrower authority.** The reader takes only `readManifest` and `openBlob` from the content store. The publisher passes it only `{contentRoot, directoryId}`, not the whole record. Named HTML entities are now looked up in a `Map` rather than a plain object indexed by page text.
8. **PR body** shortened from 368 to 226 words, with a one-line statement of the visible effect. The "Notes" section is gone and the "What changes" section is shorter.

**Checks:** `npm run typecheck` is clean. Locally, `npm test` passed 1031 tests and failed one: `test/git-remote/capability.test.ts > propagates a git failure…`. That test was already flagged in the PR body as a local checkout-environment failure, and this diff doesn't touch it. All three CI checks are green.

**Follow-ups:** none. The driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3441070 cached reads)
- Output: 29931 tokens
- Cost: $2.2027780000000003
- Wall-clock: 1153s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
