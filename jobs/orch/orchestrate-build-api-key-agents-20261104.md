---
child-build-api-key-agents-p0-freeze-onboarding-host: oros-studio-garden-ce242c49
child-build-api-key-agents-p0-freeze-onboarding-reap-count: 0
order: serial
children: build-api-key-agents-p0-freeze-onboarding build-api-key-agents-p1-provider-registry build-api-key-agents-p2-provider-adapters build-api-key-agents-p3-provider-ui build-api-key-agents-p4-agent-factory build-api-key-agents-p5-pinned-responder
on-child-failure: halt
state: running
created_by: endojs-endo-but-for-bots-pr1543-review-ed16aaac
created_at: 2026-11-04T01:48:04Z
---

Serial build of the API-key inference providers + pinned Lal/Fae agents (endojs/endo-but-for-bots #1543 designs), authorized by kriskowal's approval https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590 ("conduct the design and build the implementation"). Children: course-correction step 1, then companion phases 1-5, all behind the disabled `apiKeyGuestAgents` flag. Phases 6-7 (production canary, legacy migration) and parent retirement steps 5-9 are parked separately as `api-key-agents-canary-and-retirement` awaiting maintainer answers to the parent's open questions.
