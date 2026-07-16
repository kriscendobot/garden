Opened DRAFT PR [endojs/endo-but-for-bots#756](https://github.com/endojs/endo-but-for-bots/pull/756) against `llm`.

Reconciled the existing equivalent design rather than duplicating it: normalized it to ASCII and fully qualified references. PR body links original #84, merge `4cb1ed4d2`, open upstream #2635, and partial upstream #3322.

Verified `git diff --check` and ASCII scan. Prettier was not run because dependencies are not installed.
