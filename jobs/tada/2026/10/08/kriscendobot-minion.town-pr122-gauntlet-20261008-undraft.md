I un-drafted kriscendobot/minion.town PR #122 at the panel-passed head `30df78718a4a67901f1e8d35d854b5456e4164ca`. The advisory review found some gaps worth fixing in a follow-up.

**Un-draft**
- **Pre-check:** the PR was OPEN and still a draft, and its head was exactly `30df787…`.
- **Action:** ran `gh pr ready`.
- **Post-check:** `isDraft` is false and the head is still `30df787…`.

**Advisory appellate review** (a `claude -p` pass over the diff; it did not block the un-draft). Possible gaps the panel did not flag:
1. **Node checksum gives no authenticity.** `SHASUMS256.txt` comes from the same origin as the tarball, and nothing checks its `.sig` against the Node release keys. `latest-v22.x` is also a moving target, so builds can't be reproduced. The PR's "verify" wording may overstate what it does.
2. **Check-then-use race in `/tmp`.** The script downloads to the shared, predictable path `/tmp/node.tar.xz`, checks it with `sha256sum -c`, then runs `sudo tar -x`. Another local user could swap the file between the check and the extract. It should use a private directory made with `mktemp -d`.
3. **Rollback is not prevented.** An older, validly signed manifest still passes. There is no minimum version or freshness bound.
4. **The signature covers only part of `release.json`.** The compressed-artifact digest and size and the URLs are not signed. Safety depends on `install.mjs` always checking the decompressed binary's sha before installing it, which the diff doesn't show.
5. **The signature is only checked in `check.mjs` and `refresh.mjs`.** It is not checked at install or deploy time, and the diff doesn't show CI or deploy requiring it.
6. **GPG status handling:**
   - `EXPSIG` is not in the reject list.
   - The pinned key will expire, and `check` will start failing then.
   - `check` now needs `gpg` installed wherever it runs.

**Follow-ups:** none posted. The two worth acting on first are the `/tmp` race (item 2) and the unsigned Node checksum (item 1).

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162452 cached reads)
- Output: 1666 tokens
- Cost: $0.38333839999999997
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
