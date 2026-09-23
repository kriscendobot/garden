---
kind: result
role: jurors/scribe
host: endolin-garden2-5bcdff64
at: 2026-09-12T00:00:00Z
---
Scribe seat, code panel on kriscendobot/minion.town#100 (dispatch:
`minion-town-pr69-followup-hardening`; head `eaff0585`, base `13ef072`, diff
`HEAD~1...HEAD`). Verdict: request-changes.

Note-this / directive asks and their closure state:

- `#discussion_r3939501084` (kriskowal, PR #69: "retire `storeIdentifier` and
  `identify` on Guest agent facets ... Please fix. Above and below. Search this
  change for similar opportunities") -> CLOSED on-thread. Reply
  `#discussion_r3995015734` (2026-09-12) posts the sweep disposition
  ("declined for now") and names PR #100. The same disposition appears in the
  PR body. Good closure shape.
- `#discussion_r3938944656` ("How is this not a pet name?") -> CLOSED in #69 by
  reply `#discussion_r3939467722` and the `powerName` rename. Not #100's work.
- Job item 6, "post the sweep result / decline note" -> CLOSED, same reply.
- Job "Maintainer question (do not act without an answer)" on renaming the public
  MCP parameter `confirmPublicBuiltIn` -> CLOSED. Surfaced to the maintainer
  inbox as `inbox/maintainer/unread/msg-minion-town-pr69-followup-hardening-6a04ef086ece.md`
  (2026-09-12T03:44Z) and restated in the PR body; not renamed unilaterally.
- PR #100 has zero review comments, zero top-level comments, zero reviews of its
  own, and a single commit, so the completion-summary surface is clean this
  round: the PR body carries the SHA-level account, the declines, and the
  verification status (370 passed / 5 skipped; typecheck clean).

Open (findings raised):

1. Two live-daemon residuals the job asked for (item 2's operator-cap
   `E(sites).directory(id)` -> `lookup('front')` anchor; item 4's B1 ordinary
   pet-name publish) are deferred, and the PR body asserts they are "flagged for
   a follow-up done on a host with `ENDO_CHECKOUT`" -- but no carrier exists:
   no parked `jobs/plan/` entry, no `jobs/todo/` entry, no issue.
   `grep -rli 'ENDO_CHECKOUT|live-daemon|operator-cap' jobs/plan jobs/todo` is
   empty. The claim of flagging is currently false.
2. The residuals and the new register-anchoring invariant are not written into
   `designs/clip-ocap-synthesis.md` Sec 9, which is this repo's living record of
   the landed units and their "Deferred / open residuals" list. Every prior
   commit touching this surface (`4e5b982`, `ddb13cb`, `754c552`, all of #69)
   updated that doc in the same PR; #100 touches no design file.
3. `test/gateway/property-hardening.test.ts` embeds two literal NUL bytes
   (lines 64-65), so git classifies the file as binary. GitHub's own
   `pulls/100/files` reports `patch: ABSENT` for it: 8397 bytes of new test
   code -- the centerpiece of the PR's finding 3 -- cannot be read in the PR
   diff, by this panel, by the maintainer, or by a later `git log -p` /
   `git blame`. Writing `"a\0b"` / `"\0"` keeps the file textual and the record
   reviewable.

Self-improvement: the seat's brief frames the primary surface as maintainer
"note this" comments on the PR under review. PR #100 had none -- it is a
follow-up PR whose asks all live in its originating job body and in the PARENT
PR (#69). Reading the dispatching job record (`jobs/doin/<base>.md`) and the
parent PR's threads was what surfaced every real closure item here. Worth adding
to `roles/jurors/scribe/AGENT.md` as an explicit third primary surface: when the
PR under review is a deferred-findings follow-up, the enumerable asks are the
job body's numbered items and the parent PR's unresolved threads, not this PR's
(often empty) comment history.
