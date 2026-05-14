# Keywords

A grep-friendly index from domain terms and phrases to concept-ids in
[`concepts/`](concepts/). Multiple keywords may resolve to the same
concept; this is how synonyms cluster. Use the
[`library-lookup`](../../../skills/library-lookup/SKILL.md) skill rather
than reading this file by eye — the skill knows how to fall back
gracefully when a term is not yet indexed, and is responsible for
*indexing on the fly* (adding the shortcut that would have made your
current search succeed, so the next reader's search succeeds where
yours did not).

Format: one entry per line, `<keyword or phrase> | <concept-id>`.
Code-symbol keywords are written in backticks; prose keywords are
plain. Letter case in keywords is preserved when meaningful (e.g.
`LOCAL_NODE` as a symbol vs. `local node` as prose).

## Index

`@keypair` | per-agent-keypair
`'0'.repeat(64)` | local-node-sentinel
`0.0.0.0 of Ed25519` | local-node-sentinel
6/7 aspects | six-aspects-of-sharing
acyclic formula graph | formula-graph
agent Ed25519 keypair | per-agent-keypair
agent identity formula | per-agent-keypair
all-zeros sentinel | local-node-sentinel
asymmetry of authority | crdt-in-formula-persistence
bidirectional CRDT | crdt-in-formula-persistence
Bob Alice Carol garage scenario | six-aspects-of-sharing
cohort | cohort-destruction
cohort-aware programming model | cohort-destruction
coalesce-then-deliver | retention-accumulator
coordinated retention | four-tables-coordinated-retention
CRDT | crdt-in-formula-persistence
CRDT abandoned | crdt-in-formula-persistence
CRDT in formula persistence | crdt-in-formula-persistence
daemon persistence strategy | formula-persistence-thesis
dehydrate | dehydrate-hydrate
dehydrate at ingestion hydrate at presentation | dehydrate-hydrate
dehydration and hydration | dehydrate-hydrate
deliberately-unreachable value | sentinel-with-rationale
destruction by cohort | cohort-destruction
disincarnation by cohort | cohort-destruction
do not transcribe upstream rows | shape-not-content
dynamic chained cross-domain composable attenuated accountable revocable | six-aspects-of-sharing
Formula Persistence | formula-persistence-thesis
formula graph | formula-graph
formula key vs locator | dehydrate-hydrate
formula persistence | formula-persistence-thesis
formulas as recipes | formula-graph
formulas as constructors | formula-graph
`formulaGraph` | formula-graph
formatting at the edges | producer-typed-shape-consumer-rendering
fourth revocation mechanism | revocation-by-withdrawal
four tables | four-tables-coordinated-retention
hidden-intrinsic sampling | throwaway-instance-prototype-walk
`%IteratorPrototype%` | throwaway-instance-prototype-walk
IteratorPrototype sampling | throwaway-instance-prototype-walk
immediate local revocation | revocation-by-withdrawal
inviter and accepter tables | four-tables-coordinated-retention
Karp | six-aspects-of-sharing
Karp Stiegler Close | six-aspects-of-sharing
`KeypairFormula` | per-agent-keypair
keypair formula | per-agent-keypair
library captures shape | shape-not-content
local agency CRDT | four-tables-coordinated-retention
`LOCAL_NODE` | local-node-sentinel
microtask-coalesced retention deltas | retention-accumulator
mirrored retention roots | four-tables-coordinated-retention
no daemon-side string formatter | producer-typed-shape-consumer-rendering
no shared truth to converge on | crdt-in-formula-persistence
not one click for security | six-aspects-of-sharing
out-of-band sentinel | sentinel-with-rationale
pass by construction | cohort-destruction
per-agent keypair | per-agent-keypair
persist construction not content | formula-persistence-thesis
petname CRDT | crdt-in-formula-persistence
petname graph as persistence root | formula-persistence-thesis
pet store holds formula keys not locators | dehydrate-hydrate
producers own typed shape | producer-typed-shape-consumer-rendering
consumers own rendering | producer-typed-shape-consumer-rendering
rationale for sentinel choice | sentinel-with-rationale
reconstruction on demand | cohort-destruction
remote-view table | four-tables-coordinated-retention
`RetentionDelta` | retention-accumulator
retention-accumulator | retention-accumulator
`retention-accumulator.js` | retention-accumulator
retention churn collapse | retention-accumulator
return-value prototype walk | throwaway-instance-prototype-walk
revocation by withdrawal | revocation-by-withdrawal
revocation by withdrawal of the constructor | revocation-by-withdrawal
sentinel local node | local-node-sentinel
sentinel-with-rationale | sentinel-with-rationale
SES permit graph seed | throwaway-instance-prototype-walk
seven aspects of sharing | six-aspects-of-sharing
shape-not-content principle | shape-not-content
shape not content | shape-not-content
six aspects of sharing | six-aspects-of-sharing
stable formula key vs ephemeral hints | dehydrate-hydrate
Stiegler | six-aspects-of-sharing
taxonomy capture without rows | shape-not-content
throwaway-instance-prototype-walk | throwaway-instance-prototype-walk
timely revocation through local reachability | revocation-by-withdrawal
Tyler Close | six-aspects-of-sharing
typed-shape-in typed-shape-out | producer-typed-shape-consumer-rendering
`%URLSearchParamsIteratorPrototype%` | throwaway-instance-prototype-walk
upstream meta-tables | shape-not-content
why it cannot collide | sentinel-with-rationale
