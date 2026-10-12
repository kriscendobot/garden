---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume post-deploy validation (4): screening patch fingerprint context drift

Successor to `verify-screening-patch-fingerprint-context-drift-postdeploy-resume3`.
Commit `8da29934080b323a7319806aeec0d52bfb8b0b1d` is on `main2`. At 2026-10-12T18:12Z
the leader `endolin-garden-ece02cb4` was still at
`fad05c57898961deea273986ef299ad6b32eecbd` (journal `fleet/deployed/endolin-garden-ece02cb4`
and `.garden-state/deploy/deployed-sha`). The rolling deploy was progressing: target
`2e531a6e2dda` (a descendant), canary `oros-studio-garden-ce242c49` released at
17:56:07Z and awaiting its deploy (900s/1500s at 18:11Z); `endolin-garden2-5bcdff64` is
OFFLINE and skipped. This successor was scheduled one-shot (not posted to todo) so
a leader worker waiting in the foreground does not defer the leader's own deploy
(long-job threshold 300s). Do not bypass the canary gate and do not deploy by hand.

First check whether the leader is at `8da29934080b323a7319806aeec0d52bfb8b0b1d` or a
descendant (`git merge-base --is-ancestor` in your worktree). If NOT, do not wait in the
foreground longer than a few minutes: inspect `journalctl --user -u garden-rolling-deploy`
and `journalctl --user | grep deploy-garden` for the reason (canary failure, DEFERRED
long-job), drain your inbox, and if no maintainer decline/hold, hand off again via
`scripts/jobs/set-schedule-once.sh` timed after the expected deploy; if the canary has
FAILED, report it to the maintainer instead of looping.

Once deployed, confirm the proxy screens `kriscendobot/minion.town#93`. For head
`ea66af29724a5e54140c18aaae1be0b7fdc40c0f` (unchanged as of 18:12Z), require journal
attestation `screenings/kriscendobot-minion.town/93/ea66af29724a5e54140c18aaae1be0b7fdc40c0f.json`
(only `df2205636b...json` existed at 18:12Z) and posted job
`screen-minion-town-pr93-ea66af2-conduct`. If the PR head changed, analyze whether the
original requirement is overtaken. Do not merge the PR by hand. Report deployed SHA,
attestation path, and conductor path.
