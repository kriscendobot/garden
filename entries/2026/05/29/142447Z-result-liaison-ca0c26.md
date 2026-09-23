---
ts: 2026-05-29T14:24:47Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/29/141848Z-dispatch-liaison-b2e87a.md
---

Boatman Shape-2 re-ferry of endojs/endo-but-for-bots#351 -> endojs/endo#2422 complete and correct (dispatch `b2e87a`).

**Upstream PR:** endojs/endo#2422 (OPEN, non-draft) — https://github.com/endojs/endo/pull/2422. Branch `kriskowal-ponyfill-host-module`, force-push `+ 1bf012f0b...773f151d4 (forced update)`, lease against prior tip `1bf012f0b` held. Post-push head `773f151d454916de6daf65f8b06af457f6d9f16c`, `mergeable: MERGEABLE`.

**Approvals persisted:** `reviewDecision: APPROVED`; both dckc and boneskull approvals remain on the record (endo master has no `dismiss_stale_reviews`). No unexpected dismissal. This was the principal risk of the re-ferry and it resolved favorably, as predicted from the unprotected-branch check before dispatch.

13 commits rebuilt on `origin/master`, author+committer normalized to `Kris Kowal <kriskowal@kriskowal.com>` (source mixed `kris@agoric.com` + `endolinbot`). Per-commit `interpret-trailers --parse` empty; `(#351)` suffixes and garden-bookkeeping body fragments stripped. Net diff (646 lines) byte-identical to `gh pr diff 351 -R endojs/endo-but-for-bots` (only `@@` hunk line numbers differ, expected from the older mirror base). Title/body left unchanged (same feature). CI: 18 checks pending at re-ferry time; shepherd owns follow-up.

Garden-side mirror cross-link created on endo-but-for-bots#351 (comment 4576217955). Upstream-side handed to steward via `message: boatman → steward` (no steward this session; recorded). Boatman journal entries at journal tip `6ae17bc6`.

Second ferry of the session; the `endojs/endo` bare clone and host preconditions from the earlier #3291 ferry were reused. The stale `kmkmbp2021` host name in `journal/projects/endo/README.md` (flagged in the prior result `60bd10`) remains unaddressed; still worth a gardener refresh.
