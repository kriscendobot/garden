PR #68 can go into the gauntlet: it is open, nothing on `main` has replaced it, and the reason it was opened still applies.

**PR state:** kriscendobot/minion.town#68, "feat(clip): publishNamedContent tool — publish a clip from a guest-stored content value", is OPEN, not draft and not merged. Head is `550f4f0`. Its base is `main-d750b09`, a frozen copy of the current `main` tip (`d750b09`, merged 2026-10-07). The head is 18 commits ahead of `main` and 0 behind, so it was rebased today.

Deciding question: Does current `main` still lack any way to publish a clip from content already stored in the caller's Endo guest, so that large files still have to be pasted inline as base64 to `publish`/`upgrade`?

Evidence:
- **No replacement on `main`.** `src/endo/guest-tools.ts` on `main` still only accepts clip files as base64 in the request (`bytes: decodeBase64(f.bytes)` at lines 732 and 780). That inline-base64 path is the problem this PR fixes.
- **The name isn't taken or reserved.** The `sites` group in `src/endo/mcp-tool-names.ts` on `main` has `publish`, `listSites` and `unpublish`, and no `publishNamedContent`. The PR adds the name through that manifest.
- **The PR's helper isn't on `main`.** A code search for `resolveGuestMainWorker` finds nothing there.
- **No competing PR.** A search for related PRs found no newer or merged implementation. The nearby open PRs (#85 in-place upgrade, #88 immutable-content design, #100 `@sites` hardening, #83/#93 content garbage collection, #142 lifecycle design) are separate work and none has merged. The issue it cites, #65, is still open.
- **The maintainer still wants it.** kriskowal approved it on 2026-09-02 and again on 2026-09-05, with the instruction "Please conduct, deploy, and validate in production." Nothing since then withdraws that. The previous gauntlet (20260929) ended with a panel round-5 result of `pass` on head `80fb1ee`. Since then the head has been rebased onto `main-d750b09`, so the panel needs to review it again.

I did not run any clean, panel, fix, CI-wait or un-draft work, and I changed no code.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (427754 cached reads)
- Output: 2839 tokens
- Cost: $0.5726028
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
