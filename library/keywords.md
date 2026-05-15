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
Aifred | delegates-and-epithets
AI assistant disclosure | delegates-and-epithets
anti-impersonation | delegates-and-epithets
anti-impersonation invariant | delegates-and-epithets
assistant to Alice | delegates-and-epithets
caretaker | caretaker-pattern
caretaker pattern | caretaker-pattern
connector identity guarantee | pass-invariant-handle-equality
chat invariants | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat principles | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat components | (see source: endo-but-for-bots--llm-designs-chat-components)
chat package layout | (see section: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map)
counter-proposal endowments | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
CSS theme tokens | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
eval proposal | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
inventory panel | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
Monaco sandboxed iframe | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
profile breadcrumb | (see section: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling)
SPECIAL toggle | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
speech-pointer error | (see section: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling)
wrapped powers | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
Familiar Chat | (see source: endo-but-for-bots--llm-designs-chat-invariants)
keyboard-manual parity | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
modeline completeness | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
progressive disclosure | (see section: endo-but-for-bots--llm-designs-chat-invariants--principles)
escape consistency | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
autocomplete list navigation | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
platform-appropriate modifier keys | (see section: endo-but-for-bots--llm-designs-chat-invariants--principles)
token chip | token-chip
token chips | token-chip
`@`-prefix chip | token-chip
pet-name chip | token-chip
named-value chip | token-chip
path chip | token-chip
removable chip | token-chip
token autocomplete | token-chip
slash command | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat spaces gutter | space
space (chat) | space
spaces gutter | space
`SpaceConfig` | space
spaces | space
home space | space
Space 0 | space
indelible space | space
user space | space
Cmd+0 | space
configurable home space | space
chat-spaces-home | (see source: endo-but-for-bots--llm-designs-chat-spaces-home)
`data-menu-scope` | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
`HOME_SPACE_DEFAULTS` | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
`showName` parameter | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
icon-selector extraction | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
merge-on-load normalize-on-save | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
belt-and-suspenders discipline | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
`createSpacesGutter` | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future)
client-side convention over a complete daemon API | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture)
typed namespace over untyped pet-store | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
Cmd+1..9 | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future)
multi-agent context switching | (see source: endo-but-for-bots--llm-designs-chat-spaces-gutter)
profilePath | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
control facet vs action facet | caretaker-pattern
delegate | delegates-and-epithets
delegates | delegates-and-epithets
delegates and epithets | delegates-and-epithets
delegate/epithet model | delegates-and-epithets
Delegates and Epithets | delegates-and-epithets
epithet | delegates-and-epithets
epithets | delegates-and-epithets
epithet chain | delegates-and-epithets
epithet stripping | delegates-and-epithets
facet split | caretaker-pattern
`handleFor` | pass-invariant-handle-equality
Handle equality | pass-invariant-handle-equality
Handle vs HandleControl | caretaker-pattern
`HandleControl` | caretaker-pattern
`HandleInterface` | delegates-and-epithets
identity / action facet split | caretaker-pattern
Jarvis | delegates-and-epithets
majordomo of Aifred | delegates-and-epithets
obligatory verifiable deniable | delegates-and-epithets
pass-invariant equality of Handles | pass-invariant-handle-equality
pass-invariant Handle equality | pass-invariant-handle-equality
permits buckets | permits-buckets
permits.js buckets | permits-buckets
powered vs powerless intrinsics | permits-buckets
prefer Uint8Array over Buffer | permits-buckets
principal | delegates-and-epithets
SES permits buckets | permits-buckets
`sharedGlobalPropertyNames` | permits-buckets
start compartment vs shared compartment | permits-buckets
`TextDecoder` | permits-buckets
`TextEncoder` | permits-buckets
text codecs shim | permits-buckets
universal vs shared vs initial | permits-buckets
`universalPropertyNames` | permits-buckets
`initialGlobalPropertyNames` | permits-buckets
vetted shim | permits-buckets
service connector | delegates-and-epithets
verification protocol | delegates-and-epithets
verifiable deniable claims | delegates-and-epithets
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
formula store JSON vs SQLite | formula-graph
retention table SQLite | formula-graph
`makeNetstringReader` | (see section: endo--pkg-netstring-readme--overview)
`makeNetstringWriter` | (see section: endo--pkg-netstring-readme--overview)
`makeOcapnRecordCodecFromDefinition` | syrup-record-positionality
ocapn-peer record | syrup-record-positionality
OcapnLocation field rename | syrup-record-positionality
positional bindings not on the wire | syrup-record-positionality
record field rename wire-compat | syrup-record-positionality
Syrup field names on the wire | syrup-record-positionality
Syrup record positionality | syrup-record-positionality
transport vs network field rename | syrup-record-positionality
base64 native fallthrough | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`encodeBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`decodeBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`ENDO_BASE64_FORCE` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`Uint8Array.fromBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`Uint8Array.prototype.toBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
ponyfill-shim pattern | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
TC39 Uint8Array to/from base64 | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`%URLSearchParamsIteratorPrototype%` | throwaway-instance-prototype-walk
upstream meta-tables | shape-not-content
why it cannot collide | sentinel-with-rationale
