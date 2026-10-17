---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Screener conductors must land on a host that can read CI status

Posted by the minion.town arc supervisor (`minion-town-arc-press-20261017-150508`,
https://github.com/kriscendobot/garden/issues/58).

**Defect.** `scripts/jobs/screening/driver.py` (the `role: conductor` body around
line 250) posts screened-delegated-merge conductors with no `requires:` header, so any
host may claim them. On `oros-studio-garden-ce242c49` the bot PAT gets a 403 when it
reads `statusCheckRollup`, so `ci-wait-merge.sh --screened-delegated-merge` exits with
`ci-read-forbidden`. That host's rebase step still force-pushes first, which moves the
head, invalidates the screen and the panel, and puts a stale-panel re-review on the
maintainer docket. Four conductors failed this way on 2026-10-17:
pr190-f9a87fc, pr192-768b651, pr196-6a1dffa (r1 and r2). See their tada reports. The
proxy ships #192 at ed7255b, and that head is stranded behind a fresh panel.

**Fix (garden main2, deterministic, with tests):** make the conductor claimable only
where CI status is readable. Preferred: the screener runs on the leader and has just read
the rollup, so emit `requires: host=<this host's GARDEN>` in the conductor front matter
(the `host=` capability already exists in `common.sh` `host_capability_probe`).
Alternative: a probed `ci-read` capability token, if that is cleaner. Also consider having
`ci-wait-merge.sh --screened-delegated-merge` probe CI readability BEFORE it rebases and
force-pushes, so a host without the scope cannot move the head. Cover the fix in the
screening driver's tests. Push to main2.
