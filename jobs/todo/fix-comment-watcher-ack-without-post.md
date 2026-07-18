# Fix: comment-watcher acked a directive five times without a job reaching the board

On 2026-07-18 ~04:30Z the PR-comment watcher acknowledged (reactji-acked) the same
`rebase`-verb directive on `endojs/endo-but-for-bots` PR #600 **five times** without any
`pr600-rebase` job landing on the board (observed and reported by the press tada
`xs2rust-endor-press-20260718-080504`, which then had to cover the rebase's intent itself).

That is a broken invariant in `scripts/jobs/comment-watcher.sh`: an ack must imply a posted
job (ack AFTER the post succeeds), and a failed post must not ack — otherwise the directive
looks handled while the work is silently dropped, and the dedup state lets it re-fire without
ever landing.

The work: reproduce/trace the 04:30Z path in the watcher's logs (host endolin-garden or
endolin-garden2, unit `garden-repo-watcher`/comment-watcher logs around 2026-07-18T04:30Z),
find why the post failed or was skipped while the ack succeeded (ordering, dedup, CAS-race
retry giving up, error swallowed), fix the ordering/retry so ack-implies-posted, and add the
failure mode to the watcher's self-checks. Garden repo work on `main2` (normal worktree, push
CAS). Report the root cause in your tada.
