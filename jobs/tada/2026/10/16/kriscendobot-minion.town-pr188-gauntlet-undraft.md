PR kriscendobot/minion.town#188 is now ready for review. I took it out of draft at the head the panel passed, `b4455441267ee5d5cd01a4e6176de744f5de7628`.

**Un-draft gate:**
- Before the change, GitHub showed the PR as `state=OPEN`, `isDraft=true`, with head `b4455441267e…`, an exact match. I then ran `gh pr ready`.
- Fetched again afterwards: `isDraft=false`, and the head is still `b4455441267e…`.

**Advisory appellate pass (Sonnet `claude -p`, read the diff only, ran nothing):** it found nothing that should block. Points the maintainer may want to look at during human review:
- **Stale how-to card:** `applyClipListing` treats a definitive `[]` (401/403/404, redirect, non-JSON) differently from `clearClipListing`'s `null` path. After a sign-out, a publish how-to card the user had open stays up. It's generic text, so the impact is low.
- **Truncated JSON reads as empty:** a cut-off JSON body on a 200 response is treated as "no clips" instead of a failure. Nothing leaks, but the user would see it as lost data rather than an outage.
- **No deadline before the read:** the view is hidden as soon as a refresh is requested, but the 10 s timeout only starts once the read itself begins. If the 150 ms debounce callback never reaches the read, the view stays hidden indefinitely.
- **Hiding isn't clearing:** hiding only sets `visibility:hidden`. The iframe's `srcdoc` and `openLink.href` keep the previous account's content and clip URL, so this isn't a confidentiality boundary.
- **Tests pin source text, not behaviour:** several tests match regexes against `shell.js`. `bootstrap`'s wiring (the `listed`/`userActed`/`setConcealed` flags and the `finally` blocks) has no behavioural test, so a refactor could keep the tests green and break the fail-closed path.
- **Deploy skew:** a new `index.html` served with a cached old `shell.js` shows a dead refresh button. That's harmless, but the cache headers on `shell.js` are worth checking.

**Follow-ups:** none required. The notes above are advisory and can go to the maintainer's review.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168711 cached reads)
- Output: 1509 tokens
- Cost: $0.39673020000000003
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
