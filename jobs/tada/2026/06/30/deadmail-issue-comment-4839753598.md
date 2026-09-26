Done. The downloader is live and progressing (57% and climbing), inbox is empty, and the issue is answered.

---

## Completion report

**Job:** `deadmail-issue-comment-4839753598` — a dead-lettered issue-inbox message intended for the already-completed `issue-kriskowal-garden-9`. Maintainer comment on kriskowal/garden#9 asked: *verify the snapshot is still downloading; if not making progress, resume with ranged reads so we don't lose progress.*

**What I found:** The Polkachu Agoric mainnet snapshot pull (`agoric_26146641.tar.lz4`, height 26146641) was **stalled** — the partial archive in the per-host cache (`$GARDEN_STATE/cache/agoric-snapshots/agoric-26146641/`) sat at ~10.59 GB, last written 00:19 UTC, with **no live downloader process**. It was not progressing, and nothing was extracted yet.

**What I did:**
1. Confirmed the remote was still the same artifact before touching the partial (no snapshot-rotation/corruption risk): `last-modified: Mon, 29 Jun 2026 11:40:15 GMT`, `content-length: 20,627,561,482` (~19.2 GiB), `accept-ranges: bytes`, and a 1-byte range probe at our exact offset → **HTTP 206**.
2. Resumed with **ranged reads** (`wget -c`, HTTP Range continuation) from the preserved offset — no progress lost.
3. Handed ownership to the canonical `scripts/agoric/fetch-polkachu-snapshot.sh --url … --download --keep-archive --vacuum`, run **detached** (`setsid`) in the cache directory (outside this job's worktree, so it survives teardown). Its own `wget -c` resumed from the identical partial; on completion it will extract only `data/agoric`, run `PRAGMA integrity_check`, write `provenance.json`, and `VACUUM INTO` a WAL-free `swingstore.sqlite`.
4. Replied on the issue thread (https://github.com/kriskowal/garden/issues/9#issuecomment-4839806548) per the ISSUE NOTE — did not close it.

**Current state:** Download live and steady at ~57% of 19.2 GiB (tens of MB/s); will finish and self-extract autonomously.

**Changes:** No repo/source changes — operational recovery only (no commit to main2 needed). Cache artifacts live under `$GARDEN_STATE` (gitignored), not tracked history.

**Follow-ups:** Once the transfer completes, the swing-store at `…/agoric-26146641/swingstore.sqlite` is ready to feed to inquisitor for the `hex.js` `flatMap`→loop XS value-stack reproduction (the next step of issue #9's in-flight work). The raw direct-`wget` log left a `wget-resume.log`; the active run logs to `finish-capture.log` in the same cache dir. If the transfer stalls again, the same `wget -c` ranged-resume is repeatable from whatever offset is on disk.
