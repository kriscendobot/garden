---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/completion-window-report.py
The tooling note in the 13:4x entry says an inherited GARDEN_REPO_GIT_TIMEOUT=120 beat this script's `os.environ.setdefault("GARDEN_REPO_GIT_TIMEOUT", "540")` at line 24. The first run died with rc=124 in `git cat-file --batch`, and only a manual re-run with 580 succeeded, after 154s. `common.sh:19` already exports the 120s default into every garden shell, so `setdefault` can never take effect. Replace it with a floor: parse the current value and set `max(current, 540)`. Add a test covering an inherited value of 120.
