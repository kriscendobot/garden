Panel round 4 on kriscendobot/minion.town#85 is done: the panel ran cleanly (exit 0) and the verdict is **must-fix**. I posted the review to the PR.

- **Setup:** I made an isolated checkout of the PR head (`kriscendobot/minion.town` `feat/clip-upgrade-in-place`, head `93d20dc900`). I compared against the PR's frozen base `ec8db3fc87` (`main-ec8db3f`), and the local file list matches GitHub's: 18 files.
- **Run:** `panel.sh` ran with `GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_YARN=npm`. It ran the 32-seat code panel and ended with `code-panel single-round — must-fix`. The run is recorded at `panel-runs/kriscendobot-minion.town-85/40a7f717f0d9.md`.
- **Votes:** 12 approve, 11 comment-only, 9 request changes (breaker, engine-realist, locksmith, migrator, prover, pruner, purist, saboteur, wire-watcher).
- **Review:** it went up as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR. The body starts with the `disposition: must-fix` header, which is what the next-stage check reads. It includes a summary of the findings plus each request-changes seat's full review; the full 93KB aggregate was too large to post.

The main must-fix and should-fix findings for the fix stage:
1. **Revocation can be undone (5 seats).** A grant is tied only to `{clipId, owner}`. If `deleteClip` doesn't finish, the old capabilities work again when the same owner re-registers the clip. That happens if:
   - the process crashes or throws between unregistering and deleting the grants;
   - a grant file can't be read and gets skipped;
   - the operator unregisters through the `sites` exo, which never calls `deleteClip`.

   Fix: tie each grant to a per-registration nonce. The existing test only covers a different owner, so a same-owner test is needed.
2. **Revoke doesn't stop an upgrade already in flight.** `upgrade` checks the capability outside the per-clip queue (`serializeClip`), and revoke/attenuate aren't queued at all. An upgrade waiting in the queue still writes after revoke has reported success.
3. **Tool description overpromises.** It says a content-only delegate "cannot rebind its powers", but known gap R3 lets anyone who knows the URL rebind them.
4. **Breaking input change.** The `upgrade` tool's `hash` field became `capability` with no transition. Clips published before this PR also have no way to get a capability.
5. **Untested check.** The `clipId`/`owner` match in the ancestor-chain check can be weakened with all 47 tests still passing.
6. **Torn writes.** The vhost record and grant files are overwritten in place with a plain `writeFile` while the gateway reads them; they should use temp file plus rename.
7. **Smaller items:**
   - the unheld-power check is skipped when `guest.has` is absent, so the caller is charged and the clip is left half-upgraded;
   - the secret field sits on a type the list path shares;
   - the "opaque" power reference can be forged;
   - write access to scaffold directories is now module-wide instead of per-authority;
   - the PR body's test list should be trimmed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (663348 cached reads)
- Output: 6145 tokens
- Cost: $0.7826496000000001
- Wall-clock: 554s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
