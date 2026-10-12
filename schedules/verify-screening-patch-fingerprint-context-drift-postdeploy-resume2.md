once: 2026-10-12T17:45:00Z
job_basename_prefix: verify-screening-patch-fingerprint-context-drift-postdeploy-resume2
---
---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume post-deploy validation (2): screening patch fingerprint context drift

Successor to `verify-screening-patch-fingerprint-context-drift-postdeploy-resume`.
Commit `8da29934080b323a7319806aeec0d52bfb8b0b1d` (the fix) is on `main2`, but the
rolling deploy of it is HALTED (sticky `failed` status at canary
`oros-studio-garden-ce242c49`; `rolling-deploy.sh` logs "roll already HALTED ...
leader holds"). Oros nonetheless reached 8da2993 later (fleet/health
2026-10-12T11:43:58Z), so the halt reason looks like a slow deploy. The maintainer
was notified twice (predecessor + msg ...-ba07225ff93b). Do not bypass the
canary gate and do not deploy by hand.

First check whether leader `endolin-garden-ece02cb4` (journal
`fleet/deployed/endolin-garden-ece02cb4`, host `.garden-state/deploy/deployed-sha`)
is at `8da29934080b323a7319806aeec0d52bfb8b0b1d` or a descendant. If not, wait a
bounded time in the foreground; if still halted, hand off again only if the
maintainer has not declined/held the tip (drain your inbox first).

Once deployed, confirm the proxy screens `kriscendobot/minion.town#93`. For head
`ea66af29724a5e54140c18aaae1be0b7fdc40c0f`, require journal attestation
`screenings/kriscendobot-minion.town/93/ea66af29724a5e54140c18aaae1be0b7fdc40c0f.json`
and posted job `screen-minion-town-pr93-ea66af2-conduct`. If the PR head changed,
analyze whether the original requirement is overtaken. Do not merge the PR by
hand. Report deployed SHA, attestation path, and conductor path.
