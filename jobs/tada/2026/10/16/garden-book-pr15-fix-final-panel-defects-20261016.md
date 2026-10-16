## Completion report: garden-book PR #15, fix the final panel defects

**Result:** all three defects are fixed on PR #15's branch, which now ends at `ef62703`. The job said the head was `c24d8c9`, but the branch was already at `d92a4f0`. An earlier claimant had pushed three commits that fix most of what the job asked for. I checked those against the spec and added the one missing piece: a test that the publish command exits non-zero on failure.

### The earlier commits (`c24d8c9..d92a4f0`), checked against the spec
- **`26d3567` fix(publish), the security defect:** `build/publish-book.mjs` now sends both tool calls through a new `callTool` helper. If a result comes back with `isError: true`, the helper throws. A failed `writeText` (the call that blanks `garden-book-inert`) therefore stops before `publish` is ever sent, and a failed `publish` throws too. These are the only two MCP tool calls in `build/` and `tools/`; `initialize` is not a tool call. New unit tests check both failures and the order of calls. The same commit also escapes the DEL character (0x7f) the way the Python bridge does, with a test.
- **`d92a4f0` docs:**
  - `art/MANIFEST.md`: the chart table's separator now has 5 columns, matching its header.
  - `art/chapter-illustrations-brief.md:145`: the chapter 3 opener now reads "portrait 3:4".
  - It also reworded an aside in `build/README.md` about the last published edition's test count and hashes.
- **`b14381e`:** more browser-check tests.

### What I added
- **`ef62703` test(publish):** a new file, `test/publish-cli.test.mjs`, runs `build/publish.mjs` end to end against a fake bridge script, using `GARDEN_ROOT` set to a temporary directory. It checks three cases:
  - Everything succeeds: exit 0, and both calls go out.
  - The blanking `writeText` fails: non-zero exit, and `publish` is never sent.
  - `publish` fails: non-zero exit.
- Against the old `publish-book.mjs` from `c24d8c9`, the two failure tests fail; against the current code they pass. The non-zero exit comes from Node's handling of a rejected top-level `await`, so I didn't need to change `publish.mjs`.

### Aspect-ratio check
I read the pixel sizes of all 25 illumination images and compared them with `MANIFEST.md` and every ratio statement in the brief. They all match. The brief offers two ratios in a few places (chapter 1 "3:2 or 16:10", the container boundary "1:1 or 4:3", the three indexes "square or 4:3"); in each case the actual image fits one of the options.

### Checks run locally on `ef62703`
- `npm ci`: OK, 0 vulnerabilities.
- `npm test`: 86/86 passed, 0 skipped. `PLAYWRIGHT_CORE` was pointed at `/tmp/pwc/node_modules/playwright-core`; without it the Chromium test is skipped and the result is 85 passed, 1 skipped.
- `npm run test:browser` with `PLAYWRIGHT_CORE` set: 1/1 passed. Without it, it fails because `playwright-core` isn't a dependency; `build/README.md` documents that.
- `node build/build.mjs chapters /tmp/gbout`: 27 files, 10 chapters.

### Noticed but not changed
- `build/README.md` lines 128 and 162 give test counts of 62/62 and 61/61. Both describe earlier published builds and are labelled that way, so they are not wrong for this tree.

I did not restart the gauntlet, grant rounds, un-draft or merge. The PR is still a draft, waiting for the liaison to bring the merge-or-one-more-round decision to the maintainer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-pr15-fix-final-panel-defects-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1020905 cached reads)
- Output: 6858 tokens
- Cost: $0.8603729999999999
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
