In `scripts/jobs/handlers/triager-claude.sh` (~line 27), the triage handler crashes on the first triage of any repo. When the journal cursor is empty (`old=""`), the expansion `${old:+$old..$new}` passes an empty-string revision to `git log --no-merges --stat ""`, which fails with `fatal: ambiguous argument ''` (exit 128). Because the handler runs under `set -euo pipefail` and the git call is in a pipe (`| head -400`), pipefail propagates the 128 and the `changes="$(…)"` assignment aborts the whole handler with no error output — so `triager.sh` reports only the bare `FATAL: triage handler failed for <slug>; leaving cursor at <none> to retry`, and it recurs every restart because the cursor is never advanced.

Fix: select the git-log range without ever passing an empty argument. When `old` is non-empty use `"$old..$new"`; when empty, describe just the new tip, e.g. `git log --no-merges --stat -1 "$new"` (or `--root "$new"`). Suggested shape:

```sh
if [ -n "$old" ]; then
  changes="$(git --git-dir="$bare" log --no-merges --stat "$old..$new" 2>/dev/null | head -400)"
else
  changes="$(git --git-dir="$bare" log --no-merges --stat -1 "$new" 2>/dev/null | head -400)"
fi
```

Also harden diagnosability: this failed with zero captured stderr, so the FATAL was undiagnosable from logs alone. Consider guarding the assignment (e.g. append `|| true` so an empty/failed log yields empty `changes` rather than killing the handler) so a bad ref degrades to "empty change summary" instead of a silent crash. Reproduced deterministically against `repos/kriscendobot-minion.town.git`: empty-old expansion → `fatal: ambiguous argument ''`, assign-exit=128.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  claimed_at: 2026-07-10T01:10:36Z
