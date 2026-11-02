# Undraft complete: endojs/endo-but-for-bots#1636

PR #1636 ("feat(ocapn-noise): add the <transport>+<codec> connection hint grammar") is now ready for review.

**What I did**
1. **Pre-mutation check.** Fresh metadata showed the PR was OPEN, still a draft, and at head `8859ec1c4c732deae700442d8b0595f98a6bb770`. That is exactly the head the panel passed.
2. **Undraft.** I ran `gh pr ready`, and it succeeded.
3. **Post-check.** `isDraft` is now false and the head is still `8859ec1c4c73…`.

**Advisory appellate pass** (a light `claude -p` review, recorded here only; it did not gate the undraft):
- **IPv6 validator is too loose.** `ipv6Pattern` accepts any string of hex digits, `:` and `.` that has a colon, so `::::` and `[:]:80` pass. Zone IDs are not supported.
- **Host-name validator is too loose.** It accepts `a..b` and `999.999.999.999`, has no length limits, and doesn't lowercase hosts. As a result, formatting a parsed hint keeps the text the same but doesn't produce one canonical form.
- **Paths allow `%`, `\`, `//`, non-ASCII characters and `..` segments.** A path like `/a%40b` could be decoded or encoded twice. The encoder for these paths exists only in the tests.
- **Nothing maps a transport to its parser.** Unknown transports are accepted without complaint. There are no default ports, so `wss` always needs `:443`.
- **Edge cases with no tests:** `[]:80`, port `65535` or `00`, `+80`, uppercase hex, and how `parseHint` splits `tcp+cbor+x`.
- **Packaging:** the `./hints` export has no `types` entry. Check that `files` includes `src/hints.js`.

**Follow-ups:** the notes above could become a later fixer pass if the maintainer wants one. I posted no jobs.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1636-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177889 cached reads)
- Output: 1490 tokens
- Cost: $0.41940980000000005
- Wall-clock: 71s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
