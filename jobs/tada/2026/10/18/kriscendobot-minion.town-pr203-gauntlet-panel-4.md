Panel round 4 on kriscendobot/minion.town#203 finished with a **must-fix** verdict, and the review is posted on the PR.

- **Pinned pair:** base `945aaaace22b5f66f8189d6f3226d828b1c20c04`, head `0e41474e80d8ea63f3c1a523e6bf2b56645f2aad` (`kriscendobot/minion.town`, branch `design/git-remote-s7-bearer-identity-test`). I checked out the head detached in its own project checkout, and `git rev-parse HEAD` matched it.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0 with no output, so the jurors ran.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition `must-fix`. The latest `panel.sh` (main2 8c13456a5e7) posts the review itself. The bot authored this PR and GitHub doesn't let an author request changes on their own PR, so it went up as a comment review headed "Must-fix before merge": review 5564834460 on commit 0e41474e, at 2026-10-18T20:37:34Z. I did not post a second copy.
- **Main must-fix items** (§ 7 of `designs/git-remote-capability.md`):
  - **`/hello` proof:** the HMAC key is the stored SHA-256 hash, so anyone who can read the store can impersonate the listener. The proof is also not tied to the connection, so a squatter can relay it. (skeptic, critic)
  - **Facet keys:** the listener stores only a hash of the facet key, yet `/open` has to return the facet key itself. The design contradicts itself here. (skeptic)
  - **Mechanism keeps growing:** this is the third round of must-fix findings on the same control-plane mechanism. The design still doesn't say why it needs a loopback HTTP listener rather than the § 6 capability-URL or a CapTP reference. The pending/confirmed partition lifecycle also depends on a timer racing the daemon's persist latency. (decomplector)
  - **Too dense for a newcomer:** terms are undefined (allocator, facet, formula), and the bearer-secret test is never walked through for one secret. (novice)
- **Should-fix items:** the partition key handed to the guest as a raw bearer string, the orphan-reclaim window and quota, no pinned #180 commit or test checklist, inconsistent key/opener naming, undefined glossary terms, and a few prose fixes.

Follow-up: the gauntlet driver should route this to fix-4. The decomplector flagged the repeat, so fix-4 should justify or drop the loopback listener rather than add more hardening.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (676171 cached reads)
- Output: 3279 tokens
- Cost: $0.6914542
- Wall-clock: 138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
