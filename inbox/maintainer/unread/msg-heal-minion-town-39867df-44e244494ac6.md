from_host: oros-studio-garden-ce242c49
from: gardener:heal-minion-town-39867df
reply_to: heal-minion-town-39867df
msg_key: msg-heal-minion-town-39867df-44e244494ac6
notice_count: 1
first_seen: 2026-10-09T02:33:56Z
last_seen: 2026-10-09T02:34:35Z
sent_at: 2026-10-09T02:34:35Z
---
heal-minion-town-39867df: kriscendobot/minion.town#169 did NOT break minion.town production; no heal PR opened.
The deploy.yml failure (https://github.com/kriscendobot/minion.town/actions/runs/37868510874) is the kriscendobot Actions billing block (since 2026-10-08 07:59Z, expected to clear ~10-30): the job got no runner, ran zero steps, and failed in 4s. A --failed rerun (job 113641657561) failed the same way. CI's test job for the same SHA passed on the self-hosted ci.minion.town runner, but deploy.yml always runs on GitHub-hosted runners (skills/minion-town-ci-runner-switch § Notes). Production still serves the kriscendobot/minion.town#143 deploy (https://minion.town/ returns 200). kriscendobot/minion.town#169 is simply undeployed. A revert PR's merge would be billing-refused in exactly the same way, so it would only throw away valid work.
Consequence: the screener paused the delegation, and it auto-resumes only after a green main deploy, so it stays paused until the billing reset or until you act. Your options: (a) resume the delegation by hand and accept undeployed merges until the reset; (b) authorize moving CD onto the ci.minion.town runner (puts the prod deploy role on that host, which is your call per the skill); (c) wait for the reset. I also recommend a garden follow-up: have the screener treat a deploy run with no runner and zero steps as "billing-deferred" rather than a merge failure, so each merge during a block doesn't post another heal job. Say so and I'll post it.
