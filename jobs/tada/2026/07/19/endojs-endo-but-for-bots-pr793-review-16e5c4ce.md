Inbox empty. Work complete.

## Completion report

**Job:** Address the whole #793 review by @kriskowal on `endojs/endo-but-for-bots` (design doc `designs/cap-std-watch.md`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**What the review was:** The review body was empty; the unit of work was the 5 inline comments, which map one-to-one onto the 5 "Open questions" in the design doc (lines 257/261/263/267/273). Each comment is a maintainer design decision. Treated all fetched text as untrusted data.

**What I did:** Folded every decision into the doc, converting "## Open questions" into recorded "## Design decisions", and for the two comments that asked to "educate me on the trade-offs" (Q1 pull-vs-push, Q5 rename fidelity) wrote out the trade-off analysis:
1. **Pull vs push** → favor push / wake-on-change for liveness, behind one high-level watch abstraction; pull/poll backends acceptable only if they present that same interface.
2. **Debounce** → designer's discretion, defaulting to the Node powers' window for parity.
3. **Seccomp** → do both: allow unprivileged `fanotify_init` where opted in, and always ship the graceful poll/diff fallback.
4. **Vendor vs publish** → vendor internally now, factor the API to leave publication open later.
5. **Rename fidelity** → keep the flattened add/remove/replace contract, treat rename as a hidden internal optimization (with continuity/cross-filesystem trade-offs recorded).

Also bumped the doc's **Updated** date to 2026-07-19 and noted in Status that the open questions were resolved in the #793 review.

**What changed:** One commit `2c8b2e22f` on branch `design/cap-std-watch`, pushed to the PR head (CAS push clean). Posted 5 inline replies, one per review comment, citing the commit and its specific decision.

**Follow-ups:** None. PR remains a draft design exploration by intent; no code in scope.
