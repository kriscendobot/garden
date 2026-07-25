model: claude-opus-4-8
role: gardener
Audit and tune the garden model-assignment policy using the existing Kimi K3/Fable research and the now-successful live K3 Mystic canary.

Maintainer direction: walk back every IMPLICIT/default use of Fable to Claude Opus 4.8 going forward. Fable must remain available only when a job explicitly requests it. Designers currently default to Fable and should default to Opus 4.8 instead. Where a task is safe and suitable for reputation-building, consider assigning explicit Kimi K3 rather than Fable, but do not make K3 a blanket default or route design/build/high-stakes work to it without evidence.

First audit all live assignment surfaces, not just the canonical tier table: roles, skills/model-selection, model-routing defaults, worker-kind eligibility, foreman/provider order, schedules/templates, docs/designs, tests, and any scripts that spell fable or map designer/builder defaults. Ground the decision in the existing journal research reports for K3/Fable interaction and routing, including research-harness-kimi-k3, scholar-fireworks-kimik3-fable, and the live accepted reputation event for kimi-k3-canary-20260725-f.

Then implement a coherent policy: (1) no implicit Fable assignments anywhere; explicit model: fable remains honored, (2) designer and every other former Fable default resolve to claude-opus-4-8, (3) define a conservative explicit K3 trial/reputation lane for low-risk, reversible, tool-verifiable gardener/research-style work if the routing/reputation machinery can express it safely, with K3 still zero-default and never an implicit builder/designer choice, (4) update documentation and tests so drift is caught, and (5) preserve explicit-request precedence for both Fable and K3.

Run the focused model-selection, routing, worker-spine, provider-order, and scaler/eligibility tests plus repository checks appropriate to touched files. Push main2 directly per garden convention and report the full before/after assignment map, any K3 trial classes selected, tests, commit, and deployment readiness. Do not enable or scale any hosted worker pool and do not consume live credentials as part of this policy change.

<!-- garden-reaped: 1 -->
