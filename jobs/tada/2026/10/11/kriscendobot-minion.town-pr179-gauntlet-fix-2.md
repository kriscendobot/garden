# PR #179 (minion.town) gauntlet fix round 2: all panel items fixed, CI green

I fixed all 8 must-fix items from the panel's round-2 verdict and pushed the fixes to `gutter-clip-labels`. The head moved from `91aa6b5` to `9ebace1` in three new commits: `a4bbdac`, `c12a63a` and `9ebace1`. `ci-wait-merge.sh --no-merge` returned rc 0, with all 3 checks passing.

1. **Sanitizer (both copies).** `UNSAFE_NAME_CHARACTERS` is replaced by `NAME_FILTER`, which removes every invisible or reordering character. It keeps only three invisible sequences that shape a visible emoji:
   - a subdivision flag: U+1F3F4, then 2 to 7 lowercase-letter or digit tags, then U+E007F;
   - a zero-width joiner between two pictographs;
   - an emoji presentation selector right after an emoji.

   A name with no visible character left falls back to "Clip N". The shared adversarial test inputs now include tags-only, joiner-only, tags after text, a long tag run after a flag, U+E0100 and U+2065.
2. **Daemon reads.** A lookup now keeps its slot until its reads finish, even after its caller has given up. Concurrent lookups of the same clip share one read. Together these cap daemon reads at 4 at once.
3. **Reconnect.** `makeDaemonSiteDirectorySource` now forgets its saved connection when a connect or lookup fails, or when the connection closes, so the next read reconnects. The connect function can be injected, and a new test (`test/gateway/daemon-site-directory-source.test.ts`) covers both reconnect cases.
4. **Fairness.** Owners take turns for slots. The 1.5 s timer starts once a lookup holds a slot. Waiting for a slot has its own 3 s cap, so a hung daemon still can't stall the listing.
5. **MCP boundary.** `publish.list` now sanitizes the name itself, so the endpoint and `listSites` apply the same rule. The `listSites` description is built from `CLIP_NAME_MAX` and says the cap is in code points.
6. **Truncation** now cuts at a grapheme boundary in both copies, so it never splits a flag or a joined emoji.
7. **Cache.** A missing manifest or blob is no longer cached, so a brief miss can't become a permanent "Clip N".
8. **Docs and PR thread.**
   - `designs/clip-shell-framework.md` now says the name is untrusted `<title>` text.
   - The duplicate rule paragraph in `shell.js` is gone; it points to `clip-title.ts`.
   - The PR body is down to 216 words, says `listSites`, and no longer lists the constants or the tests.
   - I posted a [summary comment](https://github.com/kriscendobot/minion.town/pull/179#issuecomment-6110100424) with a short rationale for the 16 KiB / 4 / 1.5 s constants. I corrected that comment once after posting, because its first version overstated what gets cached.

I also did three of the should-fix items:
- The title reader now gets only a `frontOf(directoryId)` function instead of the whole directory source.
- There is a test that a blob opening after the timeout is destroyed.
- New and changed comments have no en dashes.

Not done: a test that pins the live `directories` wiring in `http.ts`.

**Local checks:** typecheck is clean. `npm test` passes except `test/git-remote/capability.test.ts > propagates a git failure…`, the same failure noted in the PR body; it is outside this diff and fails only in the checkout environment.

**Follow-ups:** none. The driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3977425 cached reads)
- Output: 39885 tokens
- Cost: $2.5909050000000007
- Wall-clock: 1853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
