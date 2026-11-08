Fix round 3 for kriscendobot/minion.town#230 is pushed and CI is green. I didn't re-run the panel; that's left to the driver.

**What I did.** No pre-pass block came with the job, so I worked from the latest panel review (5815681444, "Must-fix before merge"). I applied the four must-fix items and most of the should-fix items in one commit, `742cfb7` on `design/clip-governor-column`, which only changes `designs/clip-governor-column.md`. I pushed it with `safe-push-pr-head.sh`, moving the head from `bf1dfb1` to `742cfb7`.

The usual isolated checkout failed with a read-only file system error under the monk sandbox (the known problem). I used the documented workaround: a fresh clone in `$TMPDIR`.

**Must-fix items:**
- **Skeptic 1 (clones):** a clone now drops entries the clip holds through its governor's wrapper, and lists them in the confirmation. Rung 3's Replace can substitute the owner's own reference. § 2 now says plainly that governing is not containment. Open question (f) is narrowed to a wrapper the child hands out of its subtree some other way.
- **Skeptic 2 (rung 0a exit):** the rung now lists named test cases that differ by browser: `Origin: null` from sandboxed clips, whether the `SameSite=Lax` cookie is sent on the WebSocket upgrade, WebKit's tracking prevention, and the unload revoke. The exit criterion now requires a real-browser run on all three engines.
- **Copyeditor 1:** "A governor endows its child with capabilities the governor itself holds."
- **Copyeditor 2:** § 15 now lists the REST that actually remains: the session bootstrap, plus `GET /account/clips` until open question (k) is answered.

**Should-fix items applied:**
- **Locator not checked against the logged-in user (critic 1, skeptic 4):** I added a leak threat model instead of restoring the check. That check was dropped deliberately after review of the rung 0a build (#231).
- **Destroy cascade (critic 2, skeptic 3):**
  - The window where a destroyed clip still serves is now stated.
  - `list()` and `powers()` no longer wait on a cascade.
  - A failing unpublish retries with backoff, gives up after ten attempts, and makes `destroy` reject with `destroy-incomplete`.
  - The three states a crash can leave are listed, and the tests now include a failing step.
- **Other design points:**
  - A clone and its source are not isolated: shared references are a channel between them.
  - The real boundary is no script injection on any minion.town page.
  - Rung 0a is marked as the large rung, with #231's size as the reference.
  - When the governor and the owner both select a child, the last one wins.
  - A page restored from the back-forward cache re-mints its locator.
  - The ownership map now matches the bearer-locator model.
- **Wording (copyeditor and pedant):**
  - "chrome", "colonnade", "no chain" and "Mail view" are glossed.
  - The square-viewport rule now uses one test.
  - The § 4 cross-references are qualified, and the entry-name contradiction is fixed.
  - The Pause/Resume/Resize/Revoke mapping is spelled out.
  - The agent's starting power is clarified.
  - The gear emoji and the `·` separators are gone (now `"Settings" (7f3k)`).
  - `clip-ocap-synthesis.md` is linked.
  - OQ, C3 and "Phase 4" are written out.
  - "Windows" is no longer capitalized.
- **Cuts (pruner):** two restated mermaid diagrams, the sequence diagram, the duplicated "only REST left" claims, the repeated chrome and reparenting statements, the revision history, the answered open questions, the repeated invariants and attach points, the old § 4.3 (the later sections were renumbered), and the sentences describing the document's structure. I rewrote the PR body from 419 to 171 words, keeping both markers.

**Declined or left alone:**
- **Pruner 4:** I kept both the § 1 and § 15 tables. They serve different readers: the build ladder versus the transport scoring.
- **Pruner 9:** I kept § 17's reconciliation with #228; the reviewer marked it as acknowledge-only.
- **Critic 3's default of copying only attenuated references:** the maintainer settled clone-by-reference as the default, so the design now states the channel instead.
- **Comment-only items:** I left skeptic 7 (the four-character suffix is weak) and the unnumbered "Open questions" heading unchanged.

**CI:** `ci-wait-merge` returned 0 (green, 3 checks, none failed). The `changes` job sat queued for about 50 minutes before it ran, which looks like the known ci.minion.town runner stall. I polled it directly until then, then ran the official 540-second wait for the final result.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr230-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2313818 cached reads)
- Output: 23048 tokens
- Cost: $1.7629236000000001
- Wall-clock: 3588s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
