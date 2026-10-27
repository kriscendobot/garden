from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1349-fix-20261027
reply_to: endojs-endo-but-for-bots-pr1349-fix-20261027
msg_key: msg-endojs-endo-but-for-bots-pr1349-fix-20261027-f799e92862c0
notice_count: 1
first_seen: 2026-10-27T10:42:00Z
last_seen: 2026-10-27T10:42:02Z
sent_at: 2026-10-27T10:42:02Z
---
Policy conflict found on endojs/endo-but-for-bots#1349. Your decision is needed.

`scripts/jobs/gardening/pre-push-gates/probes/typist-friendly-code-points.sh --fix` rewrites curly quotes in the WHOLE of any changed `.md` file. That is "fix on encounter", per your directive on endojs/endo-but-for-bots#124. On endojs/endo-but-for-bots#1349 it turned about 10 lines in each of `docs/guide.md` and `packages/ses/docs/guide.md` into curly-to-straight churn. The integrator seat then flagged that churn as unrelated and asked for it to be reverted. I reverted it at `1dc303910f`, but the next fixer who runs the gate will put it back.

Options:
(a) Scope `--fix` to added lines only, which matches what the probe already checks.
(b) Keep whole-file fixing and land the result as its own `chore:` typography commit that the integrator accepts.
(c) Leave it as is.

Reply with a letter and the matching job will be posted.
