Panel round 1 on endojs/endo-but-for-bots PR #432 ("designs: daemon-move-transfer-negotiation") came back **must-fix**, and the aggregate is posted on the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs/design/daemon-move-transfer-negotiation` @ `12d6e00db2`). The diff against the PR's own base (`llm` @ `11a76ae604`) is two files: `designs/daemon-move-transfer-negotiation.md` (+703 lines) and `designs/README.md` (+2 lines).
- Ran `panel.sh` in single-round mode (detached, polled in the foreground). The ownership-map pre-pass flagged ATTENTION, so the decomplector seat was forced on. The design panel's terminal disposition was `must-fix`.
- Posted the whole round-1 aggregate as a PR review: https://github.com/endojs/endo-but-for-bots/pull/432#pullrequestreview-5328413640. It opens with a round-1 must-fix summary and a `<!-- garden-panel-verdict: must-fix round=1 … -->` marker. GitHub refuses request-changes on the bot's own PR (kriscendobot is the author), so it went up as a COMMENTED review, which is the usual shape for own-PR panel verdicts.

**Must-fix findings, for the fix loop**
1. **Tier 4 can't be reached.** The ladder only enters Tier 4 (the CAS refcount swap) when the endpoints are *not* on the same host, but a shared local CAS only exists on the same host (critic, decomplector).
2. **Tier order contradicts itself.** `selectTier` picks the strongest tier first, yet the text says Tier 6 is preferred over Tier 5 (critic, skeptic, decomplector).
3. **`move(from, to)` can't name its target.** Option (a) takes two paths, which cannot identify another mount, host or peer. Its code sample also gets the real `move` signature (`PathArgShape`) wrong (skeptic, decomplector).
4. **No owner for commit, cleanup or authority.** Nothing says which layer deletes the source, cleans up a partial target, or recovers after a crash. `TransferGrant` also carries no authority to read or remove the source (decomplector).
5. **Tier 4 is a copy, not a move.** Nothing unbinds the source name, so the source stays reachable and the sweep never collects it (decomplector).
6. **Dead links.** The design cites `../../journal/library/concepts/{brand-and-trademark,four-ways-to-acquire-references}.md`, which is outside this repo (skeptic).

Other seats also filed should-fix findings. Among them: the ladder mixes two separate axes (where the data lives and how it's represented) into one ranking, it's unclear whether a brand identifies a peer or a session, and there may be no fallback tier for two endpoints on the same host.

**Follow-ups:** the next stage is the fixer loop. I didn't fix anything or un-draft the PR. The inbox drain was skipped because the journal clone timed out (offline). The per-seat files are in `$TMPDIR/garden-panel-project-wt-endojs--57c794223b57-96dbb02c-432`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr432-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 26 tokens (645074 cached reads)
- Output: 4130 tokens
- Cost: $0.5981027999999999
- Wall-clock: 698s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
