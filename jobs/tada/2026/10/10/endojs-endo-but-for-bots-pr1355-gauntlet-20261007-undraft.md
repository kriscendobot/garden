The un-draft stage was a no-op: PR #1355 was already ready for review on the exact head the panel passed, so I did not run `gh pr ready`.

- **Head check:** The PR is OPEN, and its head is `3c06675b1bef346d90e0f41ee2570ababc2fd508`, the same commit the panel covered. It was already not a draft when I fetched it.
- **Confirmation:** I fetched the metadata again at the end and it was unchanged: isDraft false, same head.
- **Advisory appellate pass (does not block):** I read the diff myself instead of running a separate `claude -p` review. It is docs-only, 2 files, +142/−34: `designs/hardened-url-shim.md` and the `designs/README.md` index. It marks the hardened URL shim design complete via endojs/endo#3332. It also switches the design text to the names that shipped (`%InitialURL%` and `urlBlobTaming: 'retain' | 'remove'`), and records that the open question about `constructor` was resolved by pinning it, with the security reason why. The two gaps it names are written down honestly: no XS smoke test exists, and the optional task of finding `new URL(` call sites is still open. I found nothing the panel systematically missed.

Nothing changed: no commits to the garden, and nothing on the PR. There are no follow-ups; the PR is waiting for maintainer review and merge.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-20261007-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175848 cached reads)
- Output: 949 tokens
- Cost: $0.4271496
- Wall-clock: 15s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
