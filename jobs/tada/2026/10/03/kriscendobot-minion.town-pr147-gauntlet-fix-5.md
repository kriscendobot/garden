I pushed the fix for the round-5 panel's must-fix item to kriscendobot/minion.town PR #147, and CI is green (3 of 3 checks, `ci-wait-merge` returned 0).

**What I did:** I added one review-feedback commit, `8bed1aa`, on top of `c4f890e` and pushed it to `design/mcp-resources-getting-started` with `safe-push-pr-head.sh` (a fast-forward, nothing rewritten). Only `designs/mcp-resources-getting-started.md` changed (+79/−59).

**The must-fix (decomplector):** two places in § 4 each claimed to read the guide from disk. A deploy landing between those two reads could give one session its `instructions` from one commit and its resources from another.
- A new pure function, `loadGuide(dir) -> { commit, instructions, resources[] }`, is now the only thing that reads the guide. It looks up the deploy pointer once per session.
- `createMcpServer` calls it, builds `new McpServer(info, { instructions: guide.instructions })`, and then calls `registerGuideResources(server, guide, mounts)`, which never sees a file path.
- In Table 2, row 2 now names `loadGuide` as the sole owner and lists `instructions` among the values that cross. Figure 1 shows `loadGuide` too.

**Should-fixes, also done:**
- **Novice:** I reordered § 4 so "resources commit" and "ships in seconds" are defined before they are used, and added a short definition of "the daemon".
- **Decomplector:** T4 now always starts from a clip the harness publishes before the run, instead of taking T1's output. The pairing paragraph is gone and the T4 prompt uses `<seed-url>`.
- **Critic:** § 8 slice 2 now runs the § 6.1 preflight check, and records it, before the baseline.
- **Skeptic and ergonomist:**
  - § 3.3 gains item 3: before writing the four `guide/troubleshooting` error strings that no test task triggers, the build reproduces each one against production. Any string it cannot reproduce is left out.
  - Table 1 now says no `mail` error has been observed yet.
  - § 6.4 says the stand-in's result does not carry over to the confined guest until § 9 Q3 is settled.
- **Copyeditor:** I reworded the `evaluate` "reads as literal binding" phrase and split the two long sentences in § 4.
- **Pedant:** "1–255" now uses an ASCII hyphen.

**Not done (comment-only):** the ergonomist's suggestions to rename `instructions.md` and to add a content-density lint, and the critic's emphasis on § 9 Q3. I did not re-run the panel; the driver posts panel round 6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (799773 cached reads)
- Output: 7451 tokens
- Cost: $0.8450226000000002
- Wall-clock: 410s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
