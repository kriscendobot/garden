---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/mentor.sh line 220, `read -r prior_sha reject_count < "$REJECTION_STATE" 2>/dev/null || true` leaks a "No such file or directory" message to stderr whenever $REJECTION_STATE doesn't exist yet, because bash opens the `<` redirection before the `2>` redirection takes effect, so the failed-open error escapes the intended suppression. Reorder to put the stderr redirect first: `read -r prior_sha reject_count 2>/dev/null < "$REJECTION_STATE" || true` (verified this ordering suppresses the message in isolated bash tests; the reversed ordering does not). This is cosmetic only (the trailing `|| true` already keeps reject_count/prior_sha logic correct either way) but it currently corrupts every semantic-rejection self-heal capture with a spurious, unrelated error line — as seen in this failure's blob (dc86cae04ea037bbb2a6c8ecb0b1be9b3071a385), where it obscures the actual cause (a truncated anthropic completion).
