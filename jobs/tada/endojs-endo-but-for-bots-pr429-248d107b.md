Completion report — `endojs-endo-but-for-bots-pr429-248d107b`

**Directive (attention):** erights asked @kriscendobot on PR #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840086579)) whether there's an alternative to the "admit immutable ArrayBuffer through codecs" PR reflecting current intent: only a plain frozen `Uint8Array` backed by a plain frozen immutable `ArrayBuffer` should map to an ocapn `byteArray` — not a bare immutable `ArrayBuffer`.

**Assessment.** A genuine design pivot, not a code fix. The current PRs (#429 llm-base, #57 master-base sibling, upstream endojs/endo#3226) all share the now-outdated premise that the *bare* immutable `ArrayBuffer` carries passStyle `byteArray`. The new intent makes the passable the frozen `Uint8Array` *view* over a frozen immutable buffer. On `endojs/endo-but-for-bots` every commenter is maintainer-equivalent (permission gate), and erights additionally holds topic authority over `pass-style`/`marshal`/OCapN, so the directive routes as authoritative. Treated the comment body strictly as untrusted data.

**What I did** (standing authorization covers commenting on this repo; same shape as the prior `pr69` attention-job precedent):
- Replied on #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840118510)) acknowledging the distinction precisely, confirming it's a redesign rather than a tweak, naming the affected siblings (#57, upstream #3226), and stating the PR stays draft pending the new direction.
- Reactji-ack (+1) on erights' comment.
- Posted board job `ebfb-bytearray-uint8array-view-redesign` (map: design): a designer produces a `designs/<slug>.md` + DRAFT PR against `llm` reworking `passStyleOf`, the pass-style hex helpers (Uint8Array as the JS-side boundary, wire forms unchanged), `marshal-justin`, and codec admission to the view-based definition, and surfaces the disposition of #429/#57/#3226 (withdraw vs retarget) for the maintainer.
- Journaled a `result` entry (`051423Z-result-gardener-c380ff.md`).

**Changed:** one PR comment + one reactji on endojs/endo-but-for-bots; one new design job on the board; one journal entry. No code, branch, or worktree changes.

**Follow-ups:** The design job is in `todo/` for the fleet. The PR reply promises a design follow-up on #429; the designer who claims the job posts the design-PR link there. The maintainer ultimately decides whether #429/#57/#3226 are withdrawn or retargeted once the design lands.
