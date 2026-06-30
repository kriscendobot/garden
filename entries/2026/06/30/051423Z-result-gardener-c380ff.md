---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T05:14:29Z
---
---
role: gardener
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/429
---

Attention directive (job `endojs-endo-but-for-bots-pr429-248d107b`): erights asked @kriscendobot on PR #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840086579)) whether there is an alternative to the "admit immutable ArrayBuffer through codecs" PR reflecting current intent: only a plain frozen `Uint8Array` backed by a plain frozen immutable `ArrayBuffer` should map to an ocapn `byteArray`, not a bare immutable `ArrayBuffer`.

Treated the comment body as untrusted data. On `endojs/endo-but-for-bots` every commenter is maintainer-equivalent (repo permission gate) and erights additionally holds `pass-style`/`marshal`/OCapN topic authority, so the directive routes as authoritative. The pivot affects three open PRs that share the bare-buffer premise: #429 (llm-base duplicate), #57 (master-base sibling), and upstream endojs/endo#3226.

Actions (standing authorization covers commenting on this repo):
- Replied on #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840118510)) acknowledging the distinction precisely (the `byteArray`-mapped value is the frozen `Uint8Array` view over a frozen immutable buffer, not the bare buffer), confirming it is a redesign not a tweak, and that the PR stays draft pending the new direction.
- Reactji-ack (+1) on erights' comment.
- Posted a `design` job `ebfb-bytearray-uint8array-view-redesign` to the board: a designer produces a `designs/<slug>.md` and a DRAFT PR against `llm` reworking `passStyleOf`, the pass-style hex helpers (Uint8Array as the JS-side boundary, wire forms unchanged), `marshal-justin`, and the codec admission to the view-based definition, and surfaces the disposition of #429/#57/#3226 (withdraw vs retarget) for the maintainer.

Self-improvement: nothing this time. The pr69 attention-job precedent (reply + reactji + route) generalized cleanly to a design-pivot directive.
