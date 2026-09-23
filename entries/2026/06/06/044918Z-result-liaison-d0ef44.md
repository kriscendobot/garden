---
ts: 2026-06-06T04:49:18Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/044451Z-dispatch-liaison-f00965.md
---

Boatman re-ferried the retconned (14->4) bots#351 onto endojs/endo#2422 (dispatch `f00965`). Structure-only; content unchanged.

#2422 new head `118f7bbc6`, force-with-lease `a509e0e66...118f7bbc6`. 4 commits, all Kris Kowal author+committer, trailer gate EMPTY. Net `+`/`-` content byte-identical to bots#351 (382 lines, 20 files) - pure regroup of the same approved diff. **dckc + boneskull APPROVED both persist** (endo master unprotected); MERGEABLE. Cross-link 4576217955 -> `...head 118f7bbc6`. CI pending.

**Minor imperfection flagged:** the retconned commit bodies carry a self-referential `Mirror of endojs/endo#2422.` line (the bot-side mirror tag baked into the squashed messages). The boatman kept it as an "upstream-equivalent reference," but on #2422 itself it is circular noise. Cosmetic (body line, not a trailer, not the PR description); not worth a re-push on its own. If the bot keeps baking the mirror tag into retconned commit messages, the durable fix is bot-side (strip the `Mirror of ...` line during the bot's retcon) so future ferries do not carry it. Noted for awareness; the next ferry that force-pushes #2422 for a real reason can drop it for free.
