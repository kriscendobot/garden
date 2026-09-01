---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Execute the probe specified in designs/opencode-alternate-harness.md
§ "The smallest probe": one opencode-anthropic kind (registry row +
count_key + eligibility branch), one worker enabled, one reversible
canary job pinned to an opencode-routed anthropic model. Verify:
sessionID parses and resume works via sidecar; usage/<base>.jsonl gets
real non-censored USD cost from summed step_finish events; the
reputation event lands on a DISTINCT arm from gardener/anthropic/<model>;
a killed run and a refused key classify as transient/environmental, not
a job defect. Report the gap if any of these don't hold.

This is the hand-off's own top-ranked probe ("zero new research needed;
design and probe recipe are both already written") — see `hand-off.md`
(bare-host research session, this session) for the full harness x provider
survey this probe sits inside of.
