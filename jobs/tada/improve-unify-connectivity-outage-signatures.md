Pushed and cleaned up. Completion report:

---

**Job: improve-unify-connectivity-outage-signatures — done.**

**What changed** (committed `5fc801e85`, pushed to `origin/main2`):

- `scripts/jobs/common.sh`: Introduced a single canonical `GARDEN_OFFLINE_SIGNATURES` regex constant (overridable via env, default `Could not resolve hostname|Temporary failure in name resolution|Could not read from remote repository|Connection timed out`). Rewrote `_fetch_stderr_is_offline()` to consume it (`printf | grep -qE "$GARDEN_OFFLINE_SIGNATURES"`) instead of its own inlined `case` arms.
- `scripts/jobs/self-heal-run.sh`: Replaced the belt-and-suspenders fallback grep's hardcoded three-signature alternation (which was missing `Connection timed out`) with the shared `GARDEN_OFFLINE_SIGNATURES`. self-heal-run.sh already sources common.sh, so the constant is in scope.

**Effect:** The drift is closed by construction — both the function and the fallback grep now read one definition, so a raw-git path that dies on a `Connection timed out` outage is correctly normalized to a clean exit instead of being misdiagnosed as a real failure and burning a responder. Future signature additions go in one place and both paths inherit them.

**Verification:** `bash -n` clean on both files; behavioral test confirms all four signatures (including `Connection timed out`) classify as OFFLINE while a real `not a git repository` error classifies as REAL; shellcheck surfaced only pre-existing warnings unrelated to this change.

**Follow-ups:** None. The change preserves the existing env-override convention (`: "${VAR:=...}"`), so any caller can extend or override the signature set without code edits.
