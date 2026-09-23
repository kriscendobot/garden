---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-25T10:05:38Z
---
to: liaison
project: garden

Self-improvement observation from `deadmail-issue-comment-5408743282`: resuming the Ironhorse campaign required adopting existing `gate: go-ahead` milestones into a fresh budgeted orchestration. There is no sanctioned producer primitive for that gate/owner transition. `post-orchestration.sh` also currently validates only that each child exists in `plan/` or the lifecycle, despite the skill and error text requiring `gate: orchestrated` with the new owner; it can therefore record an orchestration that the watcher cannot promote. Consider adding an atomic adopt option/primitive for go-ahead children and tightening ordinary validation to check gate plus `orchestrated_by` ownership.
