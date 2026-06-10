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
`@endo/compartment-mapper` | (see source: endo--pkg-compartment-mapper-readme)
compartment mapper | (see source: endo--pkg-compartment-mapper-readme)
compartment-mapper architecture | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
`mapNodeModules` | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
`languageForExtension` | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
`moduleLanguageForExtension` | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
`parsers` (package.json) | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
auxiliary package.json | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
language-for-extension overrides | (see section: endo--pkg-compartment-mapper-readme--language-extensions)
connector identity guarantee | pass-invariant-handle-equality
chat invariants | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat principles | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat components | (see source: endo-but-for-bots--llm-designs-chat-components)
chat package layout | (see section: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map)
channel bridge | (see project design: endojs/endo-but-for-bots@llm:designs/endoclaw-channel-bridges.md; NOT YET INGESTED)
endoclaw-channel-bridges | (see project design: endojs/endo-but-for-bots@llm:designs/endoclaw-channel-bridges.md; NOT YET INGESTED)
Vercel chat SDK | (see project design: endojs/endo-but-for-bots@llm:designs/endoclaw-channel-bridges.md; NOT YET INGESTED)
npm `chat` package | (see project design: endojs/endo-but-for-bots@llm:designs/endoclaw-channel-bridges.md; NOT YET INGESTED)
`@chat-adapter/slack` | (see project design: endojs/endo-but-for-bots@llm:designs/endoclaw-channel-bridges.md; NOT YET INGESTED)
platform connector bridge | (see source: endo-but-for-bots--llm-designs-daemon-capability-persona)
service connector | (see source: endo-but-for-bots--llm-designs-daemon-capability-persona)
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
pending commands region | (see source: endo-but-for-bots--llm-designs-chat-pending-commands)
chat pending commands | (see source: endo-but-for-bots--llm-designs-chat-pending-commands)
indeterminate spinner | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
blocked command bar | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
asymmetric command record | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
asymmetric record | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
no command history | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
`executeWithSpinner` | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
`setCommandSubmitting` | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
dispatch-then-release | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
concurrent commands | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
rename-after-adopt | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
pending card | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
show result affordance | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
commands as messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
daemon-commands-as-messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
self-addressed messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
near-term UI vs invasive daemon change | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
dual-positioning | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
errors deserve attention | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
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
`ColorScheme` (typedef) | space
high-contrast mode | space
high-contrast-light | space
high-contrast-dark | space
`prefers-color-scheme` | space
`prefers-contrast: more` | space
`data-scheme` (attribute) | space
`SCHEME_COLORS` | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
`validateSpaceConfig` | space
`applyScheme` | space
`HOME_SPACE_DEFAULTS` | space
scheme picker | space
`scheme-picker.js` | space
endojs.org brand palette | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
dual-selector CSS pattern | space
brand-derived palette | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
shadows-to-borders substitution | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
substitution of channel | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
combined media query | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
mechanical-refactor-then-feature | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
scheme-aware tokens with intentional exceptions | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
factor-out-the-orthogonal-axis | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
ship-with-acknowledged-gaps | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
Monaco iframe theme bridge | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
`set-theme` postMessage | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
SpaceConfig fragmentation | space
`channelPetName` | space
`viewMode` | space
`channelOrder` | space
`bookmarks` (SpaceConfig field) | space
`whylipSystemPrompt` | space
`proposedName` | space
`ownedPersona` | space
`lastChannelPetName` | space

## Capability theory (Miller-Yee-Shapiro 2003)

object capability | object-capability
object-capability | object-capability
object-capability model | object-capability
ocap | object-capability
OCAP | object-capability
pure capability | object-capability
true capability model | object-capability
Model 4 | object-capability
Model 3 | object-capability
Model 2 | object-capability
Model 1 | object-capability
capabilities as keys | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
capabilities as rows | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
capabilities-as-keys | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
capabilities-as-rows | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
ACLs as columns | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
ACL system | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
access control list | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
access matrix | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Lampson access matrix | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Equivalence Myth | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Confinement Myth | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Irrevocability Myth | (see section: papers--miller-capability-myths-demolished-2003--irrevocability-myth)
Delegation Myth | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
No Designation Without Authority | object-capability
Property A | object-capability
Dynamic Subject Creation | object-capability
Property B | object-capability
Subject-Aggregated Authority Management | object-capability
Property C | object-capability
No Ambient Authority | object-capability
Property D | object-capability
Composability of Authorities | object-capability
Property E | object-capability
Access-Controlled Delegation Channels | object-capability
Property F | object-capability
Dynamic Resource Creation | object-capability
Property G | object-capability
ambient authority | object-capability
no ambient authority | object-capability
principle of least privilege | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
principle of least authority | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
POLA | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
least privilege | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
confused deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
confused deputy problem | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
unconfusable deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
chain of designation | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
forwarder revoker | caretaker-pattern
forwarder/revoker | caretaker-pattern
forwarding facet | caretaker-pattern
revoking facet | caretaker-pattern
facet | caretaker-pattern
Redell 1974 | caretaker-pattern
KeyKOS | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
EROS | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
KeyKOS factories | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Boebert | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
*-Property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
star property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Simple Security Property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
POSIX capabilities | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
SPKI | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
password capability | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Amoeba | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Saltzer Schroeder | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Saltzer & Schroeder | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Hardy confused deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Capability Myths Demolished | (see source: papers--miller-capability-myths-demolished-2003)
Miller Yee Shapiro | (see source: papers--miller-capability-myths-demolished-2003)
Mark Miller | (see source: papers--miller-capability-myths-demolished-2003)
Ka-Ping Yee | (see source: papers--miller-capability-myths-demolished-2003)
Jonathan Shapiro | (see source: papers--miller-capability-myths-demolished-2003)
SRL2003-02 | (see source: papers--miller-capability-myths-demolished-2003)

## Chat Markdown rendering (chat-markdown-render, cycle 64)

`@endo/markmdown` | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markmdown | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markdown rendering | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markdown parser | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
CommonMark | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
CommonMark alignment | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
GFM | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
GitHub-Flavored Markdown | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
flanking delimiter run | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
left-flanking | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
right-flanking | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
intraword underscore | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
delimiter stack | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
state-machine scanner | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
`parseInline` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
`parseBlocks` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`renderBlocks` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`renderInlineTokens` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
multi-backtick code span | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
N-character code fence | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
backslash escape | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
backslash escapes | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
inline nesting | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
escape sequences (Markdown) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
GFM tables | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
table block (Markdown) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
chip slot placeholder | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
Private Use Area character | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`md-chip-slot` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`md-table` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
`md-link` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
HighlightCode callback | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
code highlighter injection | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
DI for code highlighting | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
happy-dom | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
md/html fixture pair | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
fixture-driven testing | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
render mode toggle | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
per-message render mode | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
Markdown / Literal / Preformatted | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
timestamp tooltip toggle | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
soft break | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
hard break | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
visually-invisible phase | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
phased rollout | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
gap analysis (design shape) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
`HandledPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`makeHandledPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
handled promise | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`shorten` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`forwardedPromiseToPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`promiseToPendingHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`promiseToPresence` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`presenceToHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`presenceToPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
union-find | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
union-find forest | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
path splitting | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
disjoint-set data structure | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarding graph | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarding forest | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
promise forwarding | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarded promise | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
pending handler | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`isSafePromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
safe promise | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
passable promise | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
reentrancy attack | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
promise reentrancy | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
`HandledPromise.resolve` | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
promise safety check | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
`dispatchToHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
operation reduction | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
handler protocol | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
handler operation | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
minimum handler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
minimum viable handler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyMethod` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyFunction` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyMethodSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyFunctionSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`getSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
SendOnly | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
SendOnly variant | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`SEND_ONLY_RE` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
forwardingHandler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
nanoq | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
infix-bang | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
wavy-dot | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
promise pipelining | promise-pipelining
pipelined eventual-send | promise-pipelining
`E(E(x).foo()).bar()` | promise-pipelining
round-trip elimination | promise-pipelining
answer slot | promise-pipelining
`<desc:answer>` | promise-pipelining
pipelined message send | promise-pipelining

## Chat edit-message UI (chat-edit-message-ui, cycle 68)

`editMessage` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
`messageHistory` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit message | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit affordance | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
chat edit | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
/edit | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
`/edit` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit slash command | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
e shortcut | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
hover pencil | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
pencil button | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
sender-only edit authority | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
revision panel | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
revision history | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edited caption | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edited timestamp | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edit in flight | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
racing edits | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
last edit wins | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
saving affordance | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
chip carries locator | token-chip
locator-bearing chip | token-chip
chat parity gap | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
proposed name | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
indefinite edit window | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
pre-populate from model | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)

## Smallcaps encoding (encodeToSmallcaps.js, cycle 69)

smallcaps | smallcaps-encoding
Smallcaps | smallcaps-encoding
smallcaps encoding | smallcaps-encoding
Smallcaps Encoding | smallcaps-encoding
smallcaps wire format | smallcaps-encoding
smallcaps prefix scheme | smallcaps-encoding
smallcaps special characters | smallcaps-encoding
smallcaps cheatsheet | smallcaps-encoding
`encodeToSmallcaps` | smallcaps-encoding
`decodeFromSmallcaps` | smallcaps-encoding
`makeEncodeToSmallcaps` | smallcaps-encoding
`makeDecodeFromSmallcaps` | smallcaps-encoding
`startsSpecial` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
BANG to DASH range | smallcaps-encoding
reserved characters | smallcaps-encoding
sigil character | smallcaps-encoding
capdata | smallcaps-encoding
`@qclass` | smallcaps-encoding
qclass | smallcaps-encoding
manifest constant | smallcaps-encoding
`#undefined` | smallcaps-encoding
`#NaN` | smallcaps-encoding
`#Infinity` | smallcaps-encoding
`#-Infinity` | smallcaps-encoding
`#tag` | smallcaps-encoding
`#error` | smallcaps-encoding
Hilbert hotel | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
Hilbert hotel string escape | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
canonical encoding | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
canonical smallcaps encoding | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
copyRecord key sort | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
canonical-JSON | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
JCS canonical JSON | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
error-encoding root special case | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
`isErrorLike` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
`encodeErrorToSmallcaps` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
diagnostic-information priority | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
pass-by-copy | (see source: endo--pkg-marshal-readme)
pass-by-presence | (see source: endo--pkg-marshal-readme)
jsonable | (see section: endo--pkg-marshal-readme--alternative-to-json)
JSON-representable | smallcaps-encoding
SmallcapsEncoding | smallcaps-encoding
tagged record | (see section: endo--pkg-pass-style-readme--maketagged)

# Concept-page additions, 2026-05-21 (Miller-cluster concept-page batch)
POLA | principle-of-least-authority
principle of least authority | principle-of-least-authority
principle of least privilege | principle-of-least-authority
least privilege | principle-of-least-authority
least authority | principle-of-least-authority
least-authority | principle-of-least-authority
Saltzer-Schroeder least privilege | principle-of-least-authority
need to do | principle-of-least-authority
need-to-do basis | principle-of-least-authority
authority-driven design | principle-of-least-authority
permission-vs-authority | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
de facto access | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
de jure access | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
arrangement-only bound | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
partially behavioral bound | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
cp foo.txt bar.txt | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
cat < foo.txt > bar.txt | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
designation determines authority | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
four ways to acquire references | four-ways-to-acquire-references
Introduction (capability mechanism) | four-ways-to-acquire-references
Parenthood (capability mechanism) | four-ways-to-acquire-references
Endowment (capability mechanism) | four-ways-to-acquire-references
Initial Conditions (capability mechanism) | four-ways-to-acquire-references
only connectivity begets connectivity | four-ways-to-acquire-references
ways B can come to know about C | four-ways-to-acquire-references
reference graph is the access graph | four-ways-to-acquire-references
security as extreme modularity | security-as-extreme-modularity
Table 1 (Structure of Authority) | security-as-extreme-modularity
abstraction as protection | security-as-extreme-modularity
modularity gives access control for free | security-as-extreme-modularity
the lost paradigm | security-as-extreme-modularity
nested POLA | security-as-extreme-modularity
multiplicative attack-surface reduction | security-as-extreme-modularity
spawning tree (nested TCBs) | security-as-extreme-modularity
forbid mutable static state | security-as-extreme-modularity
no global name spaces | security-as-extreme-modularity
say what you mean / mean only what you say | security-as-extreme-modularity
patterns of safe cooperation | security-as-extreme-modularity
Redell's Caretaker | caretaker-pattern
caretakerMaker | caretaker-pattern
carol2Rvkr | caretaker-pattern
filtering facet | caretaker-pattern
factory + factoryMaker | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
FactoryStamp | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
Cassie + Max | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
trademark guard | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
controlled subject | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
uncontrolled subject | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
non-discretionary capabilities | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
Boebert 1984 | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
*-property | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
star-property | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
data diode | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
diodeWriter | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
diodeReader | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
arena | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
terms of entry | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
meta-linguistic abstraction | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
virtual machine within a virtual machine | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
mutually suspicious composition | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
diverse policies over the same graph | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
failures of conservatism | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
the lost paradigm restored | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
more cooperation with less vulnerability | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
pointMaker | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
loader.load | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Dennis and van Horn 1966 | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
DVH | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Karger-Herbert 1984 | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Chander-Dean-Mitchell | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
pinchtab | pinchtab
PinchTab | pinchtab
PINCHTAB_TOKEN | pinchtab
pinchtab server | pinchtab
pinchtab bridge | pinchtab
accessibility tree with stable refs | pinchtab
`e0`, `e1` (PinchTab refs) | pinchtab
Browser capability backend | pinchtab

## Chat /view and /edit commands (chat-view-edit-commands, cycle 70)

/view | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
`/view` | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
view command | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
view slash command | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
blob viewer | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
blob editor | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
edit blob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
edit blob content | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
blob-leaf gap | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
inventory blob gap | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
`endo cat` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
v focus shortcut | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`v` focus shortcut | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
focus mode v | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
content type from extension | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
content-type from extension | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-based content type | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-as-content-type | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-based language mode | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
immutable blob save as new | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
save as new blob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
save-as-new immutability | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
content-addressed immutability | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
new readable-blob formula | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`readable-blob` formula | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
Monaco read-only viewer | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
Monaco JSON mode | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
markdown synchronized preview | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
synchronized scroll preview | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
markdown split view | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
side-by-side markdown editor | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
line-to-element mapping | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
modal overlay vs embedded panel | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
Monaco reuse | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
`text()` blob read | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`write()` parent directory save | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`lookup()` tree path walk | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
pet name path walk | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`petNamePath` field type | (see section: endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics)
ReadableBlob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`ReadableBlob` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
SnapshotBlob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`SnapshotBlob` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
ReadableTree | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`ReadableTree` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)

## passStyleOf classifier internals (passStyleOf.js, cycle 71)

`passStyleOf` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
passStyleOf | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass style classification | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`passStyleMemo` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass-style memo | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`makePassStyleOf` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass-style cache | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
static communications channel | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
proxy observability | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
mutable static state | security-as-extreme-modularity
forbid mutable static state | security-as-extreme-modularity
cycle detection during passable walk | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`inProgress` Set | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
WeakSet vs Set | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`PassStyleOfEndowmentSymbol` | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
PassStyleOfEndowmentSymbol | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
`Symbol.for('@endo passStyleOf')` | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
liveslots passStyleOf | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
liveslot delegation | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
classifier delegation | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
GC detection oracle | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
garbage-collection detector | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
detect GC | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
passStyleOf determinism | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
deterministic classifier | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
authority by substrate | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
install-on-global gate | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
virtualization-aware classifier | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
`toPassableError` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
toPassableError | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`toThrowable` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
toThrowable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
throwables-only | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
passable error | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
diagnostic preservation | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
diagnostic-information preservation | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
copy-with-cause | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
exo boundary throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
exo-boundary throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
PassableCap | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
PassableCaps | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`isErrorLike` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
isErrorLike | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
error-like value | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`confirmRecursivelyPassableError` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`isPassable` | (see source: endo--packages-pass-style-src-passstyleof-js)
isPassable | (see source: endo--packages-pass-style-src-passstyleof-js)
`assertPassable` | (see source: endo--packages-pass-style-src-passstyleof-js)
assertPassable | (see source: endo--packages-pass-style-src-passstyleof-js)

# Focus message mode (chat-focus-message, cycle 73)

focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus message mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
chat focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
deliberate-mode focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focused message | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`.focused` class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`.focus-active` class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
Cmd+ArrowUp enter focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`⌘↑` focus entry | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
Ctrl+ArrowUp focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus mode entry gesture | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
exit focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
edge-exit symmetry | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
MOI layout | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
message of interest | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
auto-MOI selection | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
reply chain visualization | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chat-reply-chain-visualization | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus modeline | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
focus shortcut keys | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
shortcut key dispatch | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`r` reply shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`d` dismiss shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`a` adopt shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`g` grant shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`s` submit shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
PageUp PageDown accumulating heights | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
viewport-height-accumulating navigation | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
flush edge scroll | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
global keydown focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
primary chain walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
backward `replyTo` walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
last-reply forward walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chronologically last reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-start class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-through class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-end class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-tee class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-start class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-end class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-through class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-indicator class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
secondary connections pass | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
gutter-connected reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
predecessor-connected reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
reply indicator stub | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
indented message classification | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
.message-envelope wrapper | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`.message-envelope` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-number` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-message-id` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-reply-to` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
no-margin envelope | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
background-image chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
gradient chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
2ex primary gutter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
6ex secondary gutter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`--msg-sent-bg` line color | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
focus ring highlight | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`box-shadow` focus highlight | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`prefill?` setCommand parameter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`setCommand` prefill | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`skipFilled` focus advance | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`focus(skipFilled)` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
generic pre-fill primitive | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`enterCommandMode` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`inline-command-form.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`chat-bar-component.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`inbox-component.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
arrowheads on chain lines (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
multi-message selection (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
automatic MOI (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)

# makeMarshal constructor rationale (marshal.js, cycle 74)
`makeMarshal` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`MakeMarshalOptions` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat: 'smallcaps'` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat: 'capdata'` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
ontogeny recapitulates phylogeny | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
capdata-as-default | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`#`-prefix body sentinel | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
JSON-illegal first byte | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
body.charAt(0) === '#' | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
dual-format wire | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
dual-format coexistence | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`fromCapData` dual decode | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
smallcaps body prefix | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`makeFullRevive` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
backward-compat default flip | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`encodeErrorCommon` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`encodeErrorToCapData` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`encodeErrorToSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`decodeErrorCommon` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
"rather send it anyway" | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
deliberate no-stack-sharing | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
no stack on the wire | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
stack as privileged information | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
privileged correlator | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorId` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorIdNum` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`nextErrorId` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
"Sent as ${errorId}" annotation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
errorId allocation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
local-to-remote error correlation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
Remote<Name>(errorId) | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`marshalSaveError` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`marshalName` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorTagging: 'on'` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorTagging: 'off'` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
decoder-first encoder-second ratchet | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
forward-compatibility ratchet | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`cause` late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errors` late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
diagnostic priority over validation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
diagnostic salvage | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`annotateError` (marshal-side) | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
descriptor-properties no decodeRecur | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
agoric-sdk#2780 errorIdNum | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
endojs/endo#2052 capData string transform | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`decodeSlotCommon` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`decodeRemotableOrPromiseFromCapData` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
TODO SECURITY HAZARD (marshal) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
slot-typing security hazard | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
remotable-vs-promise wire ambiguity | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
under-typed slot encoding | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
implementation restriction (marshal) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
identical decode handlers | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
agoric-sdk#4334 | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
agoric-sdk#4337 | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`encodeSlotCommon` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
slot-table | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`convertValToSlot` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`convertSlotToVal` (kind dispatch) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`Nat(index)` non-security-check | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
wire-level type-tagged slots | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeSlotFromSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeFromCapData` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeFromSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)

# Cycle-76 decomposition batch (2026-05-29) — four new concept pages
Granovetter Operator | granovetter-operator
Granovetter Diagram | granovetter-operator
Granovetter step | granovetter-operator
Mark Granovetter | granovetter-operator
three-object reference-passing | granovetter-operator
bob.foo(carol) | granovetter-operator
b.foo(c) | granovetter-operator
introduction by message passing | granovetter-operator
six perspectives (Granovetter) | granovetter-operator
the strength of weak ties | granovetter-operator
agoric system | agoric-system
agoric open system | agoric-system
agoric approach | agoric-system
agoric systems | agoric-system
agora (computational) | agoric-system
agora-style computation | agoric-system
market-based computation | agoric-system
computational market | agoric-system
Agoric (the company) | agoric-system
Agoric mission | agoric-system
Miller-Drexler 1988 | agoric-system
The Ecology of Computation | agoric-system
Huberman 1988 | agoric-system
encapsulation as property right | agoric-system
encapsulation of resources | agoric-system
charge-per-use | agoric-system
opaque box | agoric-system
marketplace of mind | agoric-system
the scandal of idle time | agoric-system
business agent | agoric-system
spontaneous order | agoric-system
competence vs performance modularity | agoric-system
post-facto simulation | agoric-system
Pareto-preferred compiler | agoric-system
subjective aggregation | subjective-aggregation
only trust makes distinctions | subjective-aggregation
mistrust is ignorance | subjective-aggregation
mistrust = ignorance of internal structure | subjective-aggregation
vat as TCB | subjective-aggregation
vat as Trusted Computing Base | subjective-aggregation
per-bundle trust model | subjective-aggregation
inter-vat mutual suspicion | subjective-aggregation
inter-object mutual suspicion | subjective-aggregation
reason as if only suspicious of objects | subjective-aggregation
economy of suspicion | subjective-aggregation
fully paranoid actor | subjective-aggregation
monolithic conspiracy assumption | subjective-aggregation
vat | vat-and-compartment
vat model | vat-and-compartment
compartment | vat-and-compartment
HardenedJS compartment | vat-and-compartment
SES compartment | vat-and-compartment
Endo compartment | vat-and-compartment
vat-compartment translation | vat-and-compartment
vat as unit of persistence | vat-and-compartment
vat as unit of migration | vat-and-compartment
vat as unit of partial failure | vat-and-compartment
vat as unit of resource control | vat-and-compartment
vat as unit of DoS-defense | vat-and-compartment
vat incarnation | vat-and-compartment
Joule tank | vat-and-compartment
heap + thread + pending-delivery queue | vat-and-compartment
unit of sequentiality | vat-and-compartment
turn boundary | vat-and-compartment
computational firm | vat-and-compartment

# Cycle-77 decomposition batch two (2026-05-29) — three more concept pages
MintMaker | mint-purse-money
mint | mint-purse-money
purse | mint-purse-money
sealed decr | mint-purse-money
capability-based money | mint-purse-money
six security properties | mint-purse-money
six security properties (mint-purse) | mint-purse-money
Alice pays Bob $10 | mint-purse-money
Agoric ERTP ancestor | mint-purse-money
ERTP issuer-kit ancestor | mint-purse-money
makeIssuerKit | mint-purse-money
issuer-kit | mint-purse-money
mint-purse-money | mint-purse-money
brand | brand-and-trademark
brands | brand-and-trademark
trademark | brand-and-trademark
trademarks | brand-and-trademark
sealer/unsealer | brand-and-trademark
sealer-unsealer pair | brand-and-trademark
sealer | brand-and-trademark
unsealer | brand-and-trademark
BrandMaker | brand-and-trademark
BrandMaker pair | brand-and-trademark
FactoryStamp | brand-and-trademark
factoryStamp | brand-and-trademark
interface guards | brand-and-trademark
rights amplification primitive | brand-and-trademark
rights amplification | brand-and-trademark
envelope and can-opener | brand-and-trademark
can and can-opener | brand-and-trademark
can-opener analogy | brand-and-trademark
@endo/marshal brand | brand-and-trademark
Endo brand | brand-and-trademark
makeBrand | brand-and-trademark
types-by-fiat | brand-and-trademark
smart contract | smart-contract
smart contracts | smart-contract
Szabo smart contract | smart-contract
Nick Szabo | smart-contract
Szabo 1996 | smart-contract
computational contract | smart-contract
self-enforcing computational contract | smart-contract
self-enforcing computational embodiment of a contract | smart-contract
CoveredCallOption | smart-contract
covered call option | smart-contract
CoveredCallOptionMaker | smart-contract
Zoe contract | smart-contract
Agoric Zoe | smart-contract
Agoric contract | smart-contract
TitleCompanyMaker | smart-contract
escrowedStock | smart-contract
escrowedMoney | smart-contract

# Cycle-78 decomposition batch three (2026-05-30) — agoric-machinery cluster (3 concept pages)
competence vs performance modularity | competence-vs-performance-modularity
competence-vs-performance modularity | competence-vs-performance-modularity
competence modularity | competence-vs-performance-modularity
performance modularity | competence-vs-performance-modularity
safety and liveness | competence-vs-performance-modularity
what programs can do vs how efficiently they do it | competence-vs-performance-modularity
object-orientation modularizes competence | competence-vs-performance-modularity
markets modularize performance | competence-vs-performance-modularity
business agent | business-agent
business agents | business-agent
data-type agent | business-agent
lookup-table agent | business-agent
manager agent | business-agent
agent-selection agent | business-agent
performance-domain delegate | business-agent
subcontractor vs agent | business-agent
specialized resource-allocation agent | business-agent
compilation speculator | business-agent
Pareto-preferred compiler | business-agent
positive vs negative reputation | positive-vs-negative-reputation
positive reputation | positive-vs-negative-reputation
positive reputation system | positive-vs-negative-reputation
negative reputation | positive-vs-negative-reputation
negative reputation system | positive-vs-negative-reputation
reputation system | positive-vs-negative-reputation
reputation service | positive-vs-negative-reputation
pseudonyms and reputation | positive-vs-negative-reputation
cheap pseudonyms vulnerability | positive-vs-negative-reputation
cash bond performance guarantee | positive-vs-negative-reputation
cash bond pattern | positive-vs-negative-reputation
performance guarantee bond | positive-vs-negative-reputation
crypto staking (1988 ancestor) | positive-vs-negative-reputation
Better Business Bureau (computational) | positive-vs-negative-reputation
Underwriters Laboratories analogy | positive-vs-negative-reputation
Axelrod iterated prisoner's dilemma | positive-vs-negative-reputation
iterated relationship | positive-vs-negative-reputation

# Cycle-79 decomposition batch four (2026-05-30) — visionary cluster (2 concept pages; decomposition campaign closure)
marketplace of mind | marketplace-of-mind
marketplace-of-mind | marketplace-of-mind
intelligence as emergent property | marketplace-of-mind
intelligence separated from individuality | marketplace-of-mind
multi-agent societal AI | marketplace-of-mind
agoric AI | marketplace-of-mind
Stefik knowledge medium | marketplace-of-mind
knowledge medium | marketplace-of-mind
knowledge-as-service vs knowledge-as-representation | marketplace-of-mind
knowledge-engineering bottleneck | marketplace-of-mind
opaque box | opaque-box
opaque-box | opaque-box
hardware encapsulation | opaque-box
tamper-responding box | opaque-box
tamper-evident hardware | opaque-box
secure enclave | opaque-box
Intel SGX | opaque-box
AMD SEV | opaque-box
ARM TrustZone | opaque-box
Apple Secure Enclave | opaque-box
AWS Nitro Enclave | opaque-box
Microsoft Pluton | opaque-box
trusted execution environment | opaque-box
TEE | opaque-box
hardware-attested companion channel | opaque-box
Confidential Computing Consortium | opaque-box
TPM 2.0 | opaque-box
confidential computing | opaque-box

## encodePassable.js rank-order-preserving encoder (cycle 81)

`encodePassable` | rank-order-preserving-encoding
encodePassable | rank-order-preserving-encoding
`makePassableKit` | rank-order-preserving-encoding
makePassableKit | rank-order-preserving-encoding
rank-order encoding | rank-order-preserving-encoding
rank order encoding | rank-order-preserving-encoding
rank-order preserving encoding | rank-order-preserving-encoding
sort-preserving encoding | rank-order-preserving-encoding
lexicographic order matches numeric order | rank-order-preserving-encoding
lexicographic byte order matches sort order | rank-order-preserving-encoding
compactOrdered | rank-order-preserving-encoding
legacyOrdered | rank-order-preserving-encoding
compactOrdered format | rank-order-preserving-encoding
legacyOrdered format | rank-order-preserving-encoding
`rankOrder` | rank-order-preserving-encoding
rankOrder | rank-order-preserving-encoding
rank-order | rank-order-preserving-encoding
`passStylePrefixes` | rank-order-preserving-encoding
passStylePrefixes | rank-order-preserving-encoding
ordinal-mapping prefix | rank-order-preserving-encoding
remotable-to-ordinal mapping | rank-order-preserving-encoding
bit-complement for sort order | rank-order-preserving-encoding
Elias delta encoding | rank-order-preserving-encoding
Elias-delta encoding | rank-order-preserving-encoding
sign-aware alphabets | rank-order-preserving-encoding
ten's complement digit encoding | rank-order-preserving-encoding
sign-aware unary alphabet | rank-order-preserving-encoding
`encodeBinary64` | rank-order-preserving-encoding
encodeBinary64 | rank-order-preserving-encoding
`encodeBigInt` | rank-order-preserving-encoding
encodeBigInt | rank-order-preserving-encoding
`stringEscapes` | rank-order-preserving-encoding
stringEscapes | rank-order-preserving-encoding
`encodeCompactArray` | rank-order-preserving-encoding
encodeCompactArray | rank-order-preserving-encoding
`encodeLegacyArray` | rank-order-preserving-encoding
encodeLegacyArray | rank-order-preserving-encoding
`decodeCompactArray` | rank-order-preserving-encoding
`decodeLegacyArray` | rank-order-preserving-encoding
`verifyEncoding` | rank-order-preserving-encoding
verifyEncoding | rank-order-preserving-encoding
double-decode embeddability check | rank-order-preserving-encoding
embeddability verify | rank-order-preserving-encoding
embeddable encoding | rank-order-preserving-encoding
liberal decode | rank-order-preserving-encoding
`liberalDecode` | rank-order-preserving-encoding
liberalDecoders | rank-order-preserving-encoding
`canonicalNaN` | rank-order-preserving-encoding
canonical NaN constant | rank-order-preserving-encoding
WebIDL canonical NaN | rank-order-preserving-encoding
lockdown-independent NaN canonicalization | rank-order-preserving-encoding
BigUint64Array DataView aliasing | rank-order-preserving-encoding
C union trick | rank-order-preserving-encoding
JavaScript C union | rank-order-preserving-encoding
`isEncodedRemotable` | rank-order-preserving-encoding
isEncodedRemotable | rank-order-preserving-encoding
`getSuffix` | rank-order-preserving-encoding
`zeroPad` | rank-order-preserving-encoding
`recordNames` | rank-order-preserving-encoding
`recordValues` | rank-order-preserving-encoding
BANG escape prefix encodePassable | rank-order-preserving-encoding
C0 control character escape | rank-order-preserving-encoding
`rC0` | rank-order-preserving-encoding
~ format discriminator | rank-order-preserving-encoding
v2 encoding marshal | rank-order-preserving-encoding
encodePassable v2 | rank-order-preserving-encoding
keyed-store key encoding | rank-order-preserving-encoding
CopyMap key encoding | rank-order-preserving-encoding
CopySet key encoding | rank-order-preserving-encoding
CopyBag key encoding | rank-order-preserving-encoding
slow substring XS | rank-order-preserving-encoding
XS substring performance | rank-order-preserving-encoding
PR #1260 marshal | rank-order-preserving-encoding
endojs/endo#1260 | rank-order-preserving-encoding
endojs/endo#1984 | rank-order-preserving-encoding
sign-aware bit complement | rank-order-preserving-encoding
two's-complement-by-sign | rank-order-preserving-encoding
ten's complement | rank-order-preserving-encoding
unary length-of-length prefix | rank-order-preserving-encoding
Elias delta variant | rank-order-preserving-encoding
slot slash command | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slot input slash mode | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slash mode | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slashCompose | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
chipRetained | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/js` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/json` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/locator` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/ref` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
inline capability provisioning | captp-bounded-transient-pin
throwaway capability | captp-bounded-transient-pin
slot filler without pet name | captp-bounded-transient-pin
transient pin | captp-bounded-transient-pin
transient-pin | captp-bounded-transient-pin
`pinTransient` | captp-bounded-transient-pin
pinTransient | captp-bounded-transient-pin
`unpinTransient` | captp-bounded-transient-pin
unpinTransient | captp-bounded-transient-pin
`transientRoots` | captp-bounded-transient-pin
transientRoots | captp-bounded-transient-pin
`makeRetainedValue` | captp-bounded-transient-pin
makeRetainedValue | captp-bounded-transient-pin
RetainedValueSpec | captp-bounded-transient-pin
retained value | captp-bounded-transient-pin
release exo | captp-bounded-transient-pin
release capability | captp-bounded-transient-pin
release Exo | captp-bounded-transient-pin
captp-bounded transient pin | captp-bounded-transient-pin
captp partition handler | captp-bounded-transient-pin
captp partition signal | captp-bounded-transient-pin
partition-triggered release | captp-bounded-transient-pin
disk before graph | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin)
disk-before-graph | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin)
real locator over opaque ephemeral identifier | captp-bounded-transient-pin
ephemeral identifier | captp-bounded-transient-pin
slot input component | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`slot-input.js` | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`createSlotInput` | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
SlotInputAPI | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
petname drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
command drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
two-stage drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
slot picker | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formula ID submission | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formula identifier as endow binding | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
`endowmentFormulaIdsOrPaths` | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
`formulateMarshalValue` | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formulateMarshalValue | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
slot as the unit of transient retention | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps)
transient pin over deferred formulation | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps)

## rankOrder.js in-memory rank-order regime (cycle 84)

`rankOrder.js` | rank-order-preserving-encoding
rankOrder.js | rank-order-preserving-encoding
`sameValueZero` | rank-order-preserving-encoding
sameValueZero | rank-order-preserving-encoding
SameValueZero | rank-order-preserving-encoding
`compareNumerics` | rank-order-preserving-encoding
compareNumerics | rank-order-preserving-encoding
`compareByCodePoints` | rank-order-preserving-encoding
compareByCodePoints | rank-order-preserving-encoding
`trivialComparator` | rank-order-preserving-encoding
trivialComparator | rank-order-preserving-encoding
`ENDO_RANK_STRINGS` | rank-order-preserving-encoding
ENDO_RANK_STRINGS | rank-order-preserving-encoding
`utf16-code-unit-order` | rank-order-preserving-encoding
`unicode-code-point-order` | rank-order-preserving-encoding
`error-if-order-choice-matters` | rank-order-preserving-encoding
utf16-code-unit-order | rank-order-preserving-encoding
unicode-code-point-order | rank-order-preserving-encoding
`passStyleRanks` | rank-order-preserving-encoding
passStyleRanks | rank-order-preserving-encoding
`getPassStyleCover` | rank-order-preserving-encoding
getPassStyleCover | rank-order-preserving-encoding
`RankCover` | rank-order-preserving-encoding
RankCover | rank-order-preserving-encoding
rank cover overestimate | rank-order-preserving-encoding
cover may be an overestimate | rank-order-preserving-encoding
`getIndexCover` | rank-order-preserving-encoding
getIndexCover | rank-order-preserving-encoding
`FullRankCover` | rank-order-preserving-encoding
`coveredEntries` | rank-order-preserving-encoding
`unionRankCovers` | rank-order-preserving-encoding
`intersectRankCovers` | rank-order-preserving-encoding
`makeComparatorKit` | rank-order-preserving-encoding
makeComparatorKit | rank-order-preserving-encoding
`compareRank` | rank-order-preserving-encoding
compareRank | rank-order-preserving-encoding
`compareAntiRank` | rank-order-preserving-encoding
compareAntiRank | rank-order-preserving-encoding
`antiComparator` | rank-order-preserving-encoding
antiComparator | rank-order-preserving-encoding
`comparatorMirrorImage` | rank-order-preserving-encoding
comparatorMirrorImage | rank-order-preserving-encoding
`RankComparatorKit` | rank-order-preserving-encoding
RankComparatorKit | rank-order-preserving-encoding
`FullComparatorKit` | rank-order-preserving-encoding
FullComparatorKit | rank-order-preserving-encoding
`makeFullOrderComparatorKit` | rank-order-preserving-encoding
makeFullOrderComparatorKit | rank-order-preserving-encoding
full order comparator | rank-order-preserving-encoding
full-order comparator | rank-order-preserving-encoding
observable mutable state comparator | rank-order-preserving-encoding
covert channel comparator | rank-order-preserving-encoding
`sortByRank` | rank-order-preserving-encoding
sortByRank | rank-order-preserving-encoding
`isRankSorted` | rank-order-preserving-encoding
isRankSorted | rank-order-preserving-encoding
`assertRankSorted` | rank-order-preserving-encoding
assertRankSorted | rank-order-preserving-encoding
`rankSearch` | rank-order-preserving-encoding
rankSearch | rank-order-preserving-encoding
Array.prototype.sort undefined quirk | rank-order-preserving-encoding
undefined at end of sort | rank-order-preserving-encoding
reverse comparator undefined fixup | rank-order-preserving-encoding
shortlex | rank-order-preserving-encoding
shortlex comparison | rank-order-preserving-encoding
subset ranks earlier | rank-order-preserving-encoding
prefix ranks earlier | rank-order-preserving-encoding
inverse sorted property names | rank-order-preserving-encoding
NaN compareRemotables default | rank-order-preserving-encoding
deep-tied remotables | rank-order-preserving-encoding
`memoOfSorted` | rank-order-preserving-encoding
comparator memoization | rank-order-preserving-encoding
`comparatorMirrorImages` | rank-order-preserving-encoding
first-seen ordering of remotables | rank-order-preserving-encoding
`nameForPassableSymbol` | rank-order-preserving-encoding

## Reasoning about Risk and Trust (Drossopoulou-Noble-Miller-Murray 2015, cycle 85)

`obeys` | object-capability
o obeys Spec | object-capability
obeys predicate | object-capability
hypothetical trust | object-capability
hypothetical trust predicate | object-capability
trust as hypothesis | object-capability
trust as a hypothetical | object-capability
first-class trust predicate | object-capability
runtime trust bit | object-capability
trust bit | object-capability
`MayAccess` | four-ways-to-acquire-references
MayAccess | four-ways-to-acquire-references
`MayAccess(o, p)` | four-ways-to-acquire-references
transitive points-to closure | four-ways-to-acquire-references
points-to closure | four-ways-to-acquire-references
abstract reachability closure | four-ways-to-acquire-references
`MayAffect` | principle-of-least-authority
MayAffect | principle-of-least-authority
`MayAffect(o, p)` | principle-of-least-authority
mutation closure | principle-of-least-authority
mutation reach | principle-of-least-authority
only connectivity begets connectivity | object-capability
only-connectivity-begets-connectivity | object-capability
connectivity begets connectivity | object-capability
risk bound | principle-of-least-authority
risk bounds | principle-of-least-authority
open world specification | object-capability
open-world specification | object-capability
closed world assumption | object-capability
closed-world assumption | object-capability
open world | object-capability
open-world | object-capability
ValidPurse | mint-purse-money
`ValidPurse` | mint-purse-money
ValidPurse specification | mint-purse-money
`Pol_deposit_1` | mint-purse-money
`Pol_deposit_2` | mint-purse-money
`Pol_sprout` | mint-purse-money
`Pol_can_trade_constant` | mint-purse-money
`Pol_protect_balance` | mint-purse-money
purse sprouting | mint-purse-money
sprout | mint-purse-money
`sprout` | mint-purse-money
sprouted purse | mint-purse-money
sprouted malicious purse | mint-purse-money
sprouted-malicious-purse attack | mint-purse-money
ValidEscrow | smart-contract
`ValidEscrow` | smart-contract
four-case ValidEscrow | smart-contract
four-case spec | smart-contract
four-case specification | smart-contract
case analysis on participant trust | smart-contract
participant purses | smart-contract
PPrs | smart-contract
GoodPrs | smart-contract
OthrPrs | smart-contract
BadPPrs | smart-contract
matching pairs of untrustworthy purses | smart-contract
jointly conspiring untrustworthy | smart-contract
return value does not communicate trustworthiness | smart-contract
deal_version1 | smart-contract
`deal_version1` | smart-contract
deal_version2 | smart-contract
`deal_version2` | smart-contract
escrow exchange | smart-contract
escrow purse | smart-contract
escrow purses | smart-contract
escrowMoney | smart-contract
sellerMoney | smart-contract
buyerMoney | smart-contract
mutual trust by reciprocal deposits | smart-contract
reciprocal zero-amount deposit | smart-contract
zero-amount deposit handshake | smart-contract
biconditional on obeys | smart-contract
mutual-trust handshake | smart-contract
two-way trusted transfer | smart-contract
CanTrade | brand-and-trademark
`CanTrade` | brand-and-trademark
`CanTrade(prs1, prs2)` | brand-and-trademark
CanTrade abstract predicate | brand-and-trademark
CanTrade reflexive | brand-and-trademark
Focal | object-capability
`Focal` | object-capability
Featherweight Object Capability Language | object-capability
Chainmail | object-capability
`Chainmail` | object-capability
Chainmail specification language | object-capability
named policy | object-capability
named policies | object-capability
specification policies | object-capability
invariant policy | object-capability
any_code policy | object-capability
`any_code` | object-capability
Hoare four-tuple | object-capability
Hoare four-tuples | object-capability
four-tuple Hoare logic | object-capability
during-execution invariant | object-capability
intermediate state invariant | object-capability
code-agnostic inference rule | object-capability
code-agnostic rules | object-capability
code agnostic rules | object-capability
`METH-CALL-2` | object-capability
METH-CALL-2 | object-capability
`FRAME-METHCALL` | principle-of-least-authority
FRAME-METHCALL | principle-of-least-authority
POLA framing rule | principle-of-least-authority
POLA framing | principle-of-least-authority
`CODE-INVAR-1` | object-capability
CODE-INVAR-1 | object-capability
`CODE-INVAR-2` | object-capability
CODE-INVAR-2 | object-capability
trust preserved across execution | object-capability
linking operator | vat-and-compartment
module linking | vat-and-compartment
`M * M'` | vat-and-compartment
Arising configurations | object-capability
Reach function | object-capability
Drossopoulou-Noble-Miller-Murray | object-capability
Drossopoulou et al | object-capability
defensive consistency formal | object-capability

## Chat Playwright Build-and-Load Smoke (chat-playwright-smoke, cycle 86)

chat-playwright-smoke | chat-ui
chat playwright smoke | chat-ui
chat bundle smoke | chat-ui
playwright smoke | chat-ui
browser-tests workflow | chat-ui
browser-tests job | chat-ui
canary spec | chat-ui
`canary.spec.js` | chat-ui
Vite production bundle | chat-ui
production bundle smoke | chat-ui
`packages/chat/dist/` | chat-ui
chat dist | chat-ui
`vite build` chat | chat-ui
SES lockdown smoke | chat-ui
SES bundle regression | chat-ui
Gateway not configured heading | chat-ui
Gateway not configured | chat-ui
deterministic fallback heading | chat-ui
fragment-less navigation | chat-ui
daemon-free smoke | chat-ui
daemon-free Playwright test | chat-ui
fixture-free Playwright test | chat-ui
`pageerror` | chat-ui
pageerror handler | chat-ui
`requestfailed` | chat-ui
requestfailed handler | chat-ui
silent bundle regression | chat-ui
bundle parse failure | chat-ui
top-level import failure | chat-ui
asset path mismatch | chat-ui
lockdown-time error | chat-ui
chat-test-coverage | chat-ui
chat test coverage | chat-ui
chat e2e suite | chat-ui
yarn dev vs production bundle | chat-ui
dev-server bundle divergence | chat-ui
`browser-test/server.js` | chat-ui
extend browser-test/server.js | chat-ui
mount /chat/ prefix | chat-ui
static-file route | chat-ui
second Playwright webServer | chat-ui
`webServer` config | chat-ui
http-server dependency | chat-ui
`http-server` | chat-ui
`browser-test/tests/chat.spec.js` | chat-ui
chat.spec.js | chat-ui
injection-revert verification | chat-ui
injection-revert pattern | chat-ui
test-the-test discipline | chat-ui
falsifiable in the right direction | chat-ui
out-of-scope enumeration | chat-ui
negative spec | chat-ui
console-error strictness | chat-ui
failed-request strictness | chat-ui
browser engine scope | chat-ui
chromium-next | chat-ui
chrome-dev project | chat-ui
screenshot artifact | chat-ui
`page.screenshot` | chat-ui
playwright-report artifact | chat-ui
maintainer call open question | chat-ui
deliberate regression | chat-ui
deliberate-regression test | chat-ui
zero-cost CI step | chat-ui
zero new dependencies | chat-ui
dependency-minimal CI | chat-ui

## packages/pass-style/src/error.js (cycle 87, seventh comment-fragment ingest)

`makeTypeError` | object-capability
makeTypeError | object-capability
belt and suspenders | object-capability
belt-and-suspenders | object-capability
suspenders on our overalls | object-capability
realm intrinsic TypeError | object-capability
realm intrinsic by language syntax | object-capability
syntax-constructed exception | object-capability
`null.null` trick | object-capability
null.null syntax trick | object-capability
Start Compartment | vat-and-compartment
start compartment | vat-and-compartment
primary realm | vat-and-compartment
guest compartment | vat-and-compartment
gratuitously frozen globalThis | vat-and-compartment
gratuitiously frozen | vat-and-compartment
multi-guest shared compartment | vat-and-compartment
unfrozen globalThis | vat-and-compartment
incoherent compartment | vat-and-compartment
no mutual safety | vat-and-compartment
SES initializes first | object-capability
prior code is benign | object-capability
boot-order assumption | object-capability
pre-SES attacker | object-capability
host configuration regimes | object-capability
`makeRepairError` | object-capability
makeRepairError | object-capability
repairError | object-capability
`repairError` | object-capability
V8 own stack accessor | object-capability
V8 stack accessor | object-capability
undeniable channel | object-capability
undeniable capability channel | object-capability
stack internal slot | object-capability
arbitrary capabilities through stack | object-capability
same-realm getter equality | object-capability
same-realm-getter-equality repair | object-capability
`feralStackGetter` | object-capability
feralStackGetter | object-capability
Hermes stack accessor | object-capability
captureStackTrace proposal | object-capability
`Error.captureStackTrace` | object-capability
proposal-error-capturestacktrace | object-capability
FF/SpiderMonkey stack | object-capability
Moddable/XS stack | object-capability
error stack proposal | object-capability
hardenTaming unsafe | object-capability
`hardenTaming: "unsafe"` | object-capability
unsafe hardenTaming | object-capability
hardenIsNoop | object-capability
`hardenIsNoop` | object-capability
fake harden | object-capability
non-actually-freezing harden | object-capability
calls getter during harden | object-capability
PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR | object-capability
`PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` | object-capability
SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR | object-capability
SES error-code document | object-capability
isErrorLike | pass-invariant-handle-equality
`isErrorLike` | pass-invariant-handle-equality
assertError | pass-invariant-handle-equality
confirmErrorLike | pass-invariant-handle-equality
`confirmErrorLike` | pass-invariant-handle-equality
confirmRecursivelyPassableError | pass-invariant-handle-equality
`confirmRecursivelyPassableError` | pass-invariant-handle-equality
confirmRecursivelyPassableErrorPropertyDesc | pass-invariant-handle-equality
ErrorHelper | pass-invariant-handle-equality
`ErrorHelper` | pass-invariant-handle-equality
passable error | pass-invariant-handle-equality
malformed error | pass-invariant-handle-equality
passable by itself | pass-invariant-handle-equality
passable as part of a structure | pass-invariant-handle-equality
two-tier passability | pass-invariant-handle-equality
diagnostic preservation | pass-invariant-handle-equality
diagnostic-vs-security tension | pass-invariant-handle-equality
security-vs-diagnostic-preservation | pass-invariant-handle-equality
validity complaints as notes | pass-invariant-handle-equality
notes on the error | pass-invariant-handle-equality
attach notes to malformed error | pass-invariant-handle-equality
four-property allowlist | pass-invariant-handle-equality
error own property allowlist | pass-invariant-handle-equality
error message stack cause errors | pass-invariant-handle-equality
own data property | pass-invariant-handle-equality
extra unpassed property | pass-invariant-handle-equality
error constructor registry | object-capability
errorConstructors map | object-capability
`errorConstructors` | object-capability
getErrorConstructor | object-capability
`getErrorConstructor` | object-capability
AggregateError construction non-uniformity | object-capability
AggregateError errors iterable | object-capability
non-uniformity disclaimer | object-capability
makeError encapsulates | object-capability
SES whitelist coordination | object-capability
maintenance hazard | object-capability
SES whilelist | object-capability
passStyleOf side effect | object-capability
passStyleOf side-effect | object-capability
side effect during passStyleOf | object-capability
alters object as side effect | object-capability
deliberately accepted defensive-consistency violation | object-capability
deliberate controlled risk | object-capability
acknowledge the hazard then bound it | object-capability
NOTE calls getter during harden | object-capability
hazards we think we understand | object-capability
diagnostic priority over validity bug | object-capability
fail loud on unexpected accessor | object-capability
captureStackTrace forward-compatibility | object-capability

## ACLs Don't (Tyler Close ~2009, cycle 88)

ACLs don't | object-capability
ACLs Don't | object-capability
ACL model | object-capability
ACL critique | object-capability
access matrix | object-capability
access matrix model | object-capability
1971 Protection paper | object-capability
Lampson Protection | object-capability
column-stored access matrix | object-capability
row-stored access matrix | object-capability
ACL checking | object-capability
capability transfer | four-ways-to-acquire-references
construction-time access check | object-capability
receipt-time access check | object-capability
Confused Deputy | object-capability
Confused Deputy attack | object-capability
deputy software agent | object-capability
Vendor User Compiler | object-capability
compilation scenario | object-capability
log.txt overwrite attack | object-capability
A_R,c,p entry | object-capability
access matrix entry notation | object-capability
file descriptors not filenames | object-capability
capabilities by reference everywhere | object-capability
crucial step Confused Deputy | object-capability
object identifier through intermediate | object-capability
RBAC IBAC ABAC | object-capability
role-based access control | object-capability
attribute-based access control | object-capability
identity-based access control | object-capability
setuid | object-capability
stack introspection | object-capability
single authorization chain per operation | object-capability
multi-argument authorization | object-capability
delaying-the-access-check | object-capability
Speaks-for paper | object-capability
client authentication misleading | object-capability
who said this | object-capability
who relayed vs who intended | object-capability
accountability assignment | object-capability
deputy held accountable | object-capability
Horton capability protocol | object-capability
Horton protocol | object-capability
capability-application caveat | object-capability
re-implementing ACL on capabilities | object-capability
string name to capability mapping | object-capability
CSRF | object-capability
Cross-Site Request Forgery | object-capability
cross-site request forgery | object-capability
clickjacking | object-capability
click fraud | object-capability
unguessable token | object-capability
unguessable URL | object-capability
web-key | object-capability
web key | object-capability
web-key paper | object-capability
mashing with permission | object-capability
no infrastructure change | object-capability
URL namespace migration | object-capability
capability-Web migration | object-capability
Same Origin Policy | object-capability
SOP integrity boundary | object-capability
Table 3 mapping | object-capability
HTTP cookie principal | object-capability
opening then writing pattern | object-capability
IFRAME clickjacking | object-capability
transparent IFRAME | object-capability
click on a private page | object-capability
Norm Hardy 1988 | object-capability
Hardy 1988 Confused Deputy | object-capability
SIGOPS 1988 | object-capability
Shiflett CSRF | object-capability
Hansen Grossman clickjacking | object-capability
Speaks-for Lampson | object-capability
Tyler Close | object-capability
HP Labs Palo Alto | object-capability
ACL doesn't authorize correctly | object-capability
ACL doesn't authenticate reliably | object-capability
ACL doesn't assign accountability correctly | object-capability
contradictory access decisions | object-capability
not benignly differ | object-capability
multi-party scenario | object-capability
more than two principals | object-capability

## Chat Voice Command Parser (chat-voice-command-parser, cycle 89)

voice command parser | chat-ui
voice transcript parser | chat-ui
chat voice | chat-ui
Web Speech API | chat-ui
SpeechRecognition | chat-ui
`SpeechRecognition` | chat-ui
voice-input.js | chat-ui
`voice-input.js` | chat-ui
microphone button | chat-ui
asynchronous parse monad | chat-ui
async parse monad state machine | chat-ui
ParseState | chat-ui
ParseStep | chat-ui
ParseFn | chat-ui
parse-monad | chat-ui
voice effects | chat-ui
inert passable effects | chat-ui
enter-mode effect | chat-ui
commit-token effect | chat-ui
set-field effect | chat-ui
open-command-menu effect | chat-ui
pick-command effect | chat-ui
submit effect | chat-ui
cancel effect | chat-ui
append-text effect | chat-ui
wake word | chat-ui
wake-word table | chat-ui
per-mode wake-word | chat-ui
voiceHints | chat-ui
modeline voice line | chat-ui
voice modeline | chat-ui
literal quote escape | chat-ui
quote prefix | chat-ui
`quote` escape | chat-ui
quote unquote | chat-ui
framing pause | chat-ui
framing-pause submit | chat-ui
framed pause cue | chat-ui
silence threshold | chat-ui
endpointing parameter | chat-ui
600 ms silence | chat-ui
send now wake word | chat-ui
push-to-talk | chat-ui
push to talk | chat-ui
mic release submit | chat-ui
buffer and rollback | chat-ui
interim result retraction | chat-ui
roll back on retraction | chat-ui
effect inverse | chat-ui
inverse of commit-token | chat-ui
rollback at word boundary | chat-ui
end event flushes parser | chat-ui
flush on end | chat-ui
command-registry vocabulary | chat-ui
registry-driven vocabulary | chat-ui
vocabulary as data | chat-ui
new command gets voice automatically | chat-ui
field-name as wake word | chat-ui
nine-mode inventory | chat-ui
Empty Send Mode | chat-ui
Token Autocomplete Visible | chat-ui
Token Only | chat-ui
Token plus Message Text | chat-ui
Text Only mode | chat-ui
Command Selecting mode | chat-ui
Inline Command Form mode | chat-ui
Eval Command Inline | chat-ui
Value Modal mode | chat-ui
Google Assistant okay disambiguation | chat-ui
Apple Dictation press period | chat-ui
voice-assistant prior art | chat-ui
five interaction patterns | chat-ui
one-line message pattern | chat-ui
immediate command pattern | chat-ui
inline command form fill pattern | chat-ui
cancel mid-command pattern | chat-ui
edit-a-value cancel-and-restart | chat-ui
no invented edit gestures | chat-ui
dual mechanism disambiguation | chat-ui
wake-word vs prose collision | chat-ui
escape and enter | chat-ui
why two mechanisms not one | chat-ui
modal toggle context switch | chat-ui
confidence threshold not enough | chat-ui
pure parser test | chat-ui
stub SpeechRecognition test | chat-ui
feature flag voice migration | chat-ui
4-phase implementation | chat-ui
parser scaffold phase | chat-ui
effect dispatcher phase | chat-ui
modeline voice line phase | chat-ui
voice-input.js migration phase | chat-ui
canonical command-menu wake word | chat-ui
inline vs deferred pet-name lookup | chat-ui
modeline aural cue | chat-ui
session isolation vs resume | chat-ui
literal-escape word alternative | chat-ui
framing-pause threshold tunability | chat-ui
non-voice long-press submit | chat-ui

## packages/eventual-send/src/track-turns.js (cycle 90, eighth comment-fragment ingest)

track-turns | object-capability
track-turns.js | object-capability
trackTurns | object-capability
`trackTurns` | object-capability
TurnStarterFn | object-capability
`TurnStarterFn` | object-capability
TurnStartFn | object-capability
causal console | object-capability
causal annotation | object-capability
assert.note | object-capability
`assert.note` | object-capability
annotateError | object-capability
sending event | object-capability
receiving event | object-capability
sending event causes receiving events | object-capability
event causality DAG | object-capability
turn number | object-capability
event-within-turn counter | object-capability
hiddenPriorError | object-capability
hiddenCurrentTurn | object-capability
hiddenCurrentEvent | object-capability
hidden- prefix | object-capability
meta-level privilege | object-capability
meta-level-privilege framing | object-capability
deliberate global mutable state | object-capability
no observably mutable state | object-capability
diagnostic-only mutable state | object-capability
cyclic dependency disclaimer | object-capability
not in scope before lockdown | object-capability
agoric-sdk 9515 | object-capability
TRACK_TURNS env option | object-capability
`TRACK_TURNS=enabled` | object-capability
TRACK_TURNS=enabled | object-capability
TRACK_TURNS disabled by default | object-capability
DEBUG=track-turns | object-capability
DEBUG track-turns verbose | object-capability
environmentOptionsListHas | object-capability
getEnvironmentOption | object-capability
inert-fallback guard | object-capability
inert when disabled | object-capability
returns funcs unchanged | object-capability
zero-impact-when-disabled | object-capability
closure hoisting | object-capability
closures retain too much | object-capability
HandledPromise retention | object-capability
HandledPromise argument retention | object-capability
hoist out of trackTurns | object-capability
wrapFunction | object-capability
`wrapFunction` | object-capability
addRejectionNote | object-capability
`addRejectionNote` | object-capability
bidirectional error annotation | object-capability
sync throw via try catch | object-capability
async rejection via Promise.catch | object-capability
must capture this now | object-capability
must-capture-this-now timing rule | object-capability
detailsNote eager capture | object-capability
detailsNote string | object-capability
THROWN to top of event loop | object-capability
REJECTED at top of event loop | object-capability
top of event loop | object-capability
microturn top | object-capability
microturn top callback | object-capability
this-free TurnStarterFn | object-capability
this-sensitive function | object-capability
bottom of stack to start a new turn | object-capability
finally clear hiddenPriorError | object-capability
inter-turn hygiene | object-capability
do not leak state across turn boundaries | object-capability
Caused by chain | object-capability
sendingError | object-capability
Event: T.E format | object-capability
Mark S. Miller track-turns | object-capability

## Automated Analysis of Security-Critical JavaScript APIs (Taly et al 2011, cycle 91)

SES_light | object-capability
SES light | object-capability
ENCAP | object-capability
ENCAP tool | object-capability
API confinement | object-capability
API confinement problem | object-capability
overt confinement problem | object-capability
API+Sandbox | object-capability
API plus Sandbox | object-capability
trusted API service | object-capability
API as reference monitor | object-capability
transitively immutable built-in objects | object-capability
deeply immutable global object | object-capability
variable-restricted eval | object-capability
ECMA TC39 | object-capability
ECMA-262 | object-capability
ES5S | object-capability
ES5 strict | object-capability
strict mode JavaScript | object-capability
lexical scoping property | object-capability
safe closure-based encapsulation | object-capability
no ambient access to global object | object-capability
arguments.caller leak | object-capability
.callee .caller forbidden | object-capability
this coercion to global | object-capability
delete on variable name | object-capability
prototype on scope object | object-capability
with statement forbidden | object-capability
Confinement Property | object-capability
PtsTo Reach | object-capability
labeled semantics | object-capability
allocation site label | object-capability
alpha-renaming bisimilarity | object-capability
Theorem 1 renaming preserves bisimilarity | object-capability
flow-insensitive context-insensitive | object-capability
Datalog points-to | object-capability
bddbddb | object-capability
inclusion-based points-to | object-capability
Soundness Theorem 2 | object-capability
soundness over approximation | object-capability
Yahoo ADSafe | object-capability
ADSafe vulnerability | object-capability
ADSafe lib method | object-capability
ADSafe go method | object-capability
triple underscore property | object-capability
___ property hiding | object-capability
$Safe annotation | object-capability
$Num annotation | object-capability
$All annotation | object-capability
JSLint filter | object-capability
Sealer Unsealer | object-capability
Sealer-Unsealer pair | object-capability
Morris 1973 sealer | object-capability
Mint function verified | object-capability
conservation of currency | object-capability
Nat function natural number | object-capability
brand seal unseal | object-capability
Ankur Taly | object-capability
Ulfar Erlingsson | object-capability
John Mitchell Stanford | object-capability
Jasvir Nagra | object-capability
IEEE S&P 2011 | object-capability
Google Caja | object-capability
Facebook FBJS | object-capability
Crockford ADSafe | object-capability
Featherweight Java analogue | object-capability
A-normal form | object-capability
Maffeis Mitchell Taly 2008 | object-capability
LambdaJS Guha Krishnamurthi | object-capability
points-to map | object-capability
PtsTo_D over approximation | object-capability
Cons consequence closure | object-capability
Herbrand semantics Datalog | object-capability
object-sensitive analysis | object-capability
CFA2 context-free | object-capability
Gatekeeper Guarnieri Livshits | object-capability
VEX browser extension | object-capability
Pixy SQL injection | object-capability
Staged Information Flow | object-capability
Whaley Datalog | object-capability
Robust Composition reference | object-capability
api un store push attack | object-capability
priv.push override attack | object-capability
trusted code reference monitor | object-capability
language-based sandbox | object-capability
iframe alternative | object-capability
write-only log API | object-capability
critical log array | object-capability

## Chat Test Coverage (chat-test-coverage, cycle 92)

chat-test-coverage | chat-ui
chat test coverage | chat-ui
chat test suite | chat-ui
packages/chat/test | chat-ui
happy-dom | chat-ui
jsdom alternative | chat-ui
mock-powers | chat-ui
makeMockPowers | chat-ui
Far remotable mock | chat-ui
mock daemon powers | chat-ui
DOM globals before import | chat-ui
dom-setup.js | chat-ui
keyboard-events.js | chat-ui
test/helpers/ | chat-ui
test/unit/ | chat-ui
test/component/ | chat-ui
test/e2e/ | chat-ui
command-registry tests | chat-ui
command-executor tests | chat-ui
message-parse tests | chat-ui
ref-iterator tests | chat-ui
time-formatters tests | chat-ui
markdown-render tests | chat-ui
value-render tests | chat-ui
send-form tests | chat-ui
petname-path-autocomplete tests | chat-ui
inline-command-form tests | chat-ui
monaco-wrapper tests | chat-ui
form-request-inbox tests | chat-ui
spaces-gutter-home tests | chat-ui
untestable behaviors | chat-ui
Selection API limitations | chat-ui
contenteditable cursor | chat-ui
Monaco iframe | chat-ui
cross-window postMessage | chat-ui
WebSocket connection mock | chat-ui
token-autocomplete.spec.ts | chat-ui
monaco-editor.spec.ts | chat-ui
Playwright spec ts | chat-ui
.spec.ts vs .test.js | chat-ui
protocol documentation as tests | chat-ui
skipped tests as docs | chat-ui
postMessage protocol | chat-ui
test count by module | chat-ui
283 total tests | chat-ui
244 unit and component | chat-ui
39 E2E tests | chat-ui
Complete partial protocol-documentation | chat-ui
coverage-honesty | chat-ui
coverage table annotations | chat-ui
cost-tier hierarchy testing | chat-ui
6.3 to 1 fast slow ratio | chat-ui
extracted from packages/chat/DESIGN.md | chat-ui
PR 93 dismiss-all to clear | chat-ui
chat-reply-chain-visualization deprecated | chat-ui
chat-focus-message supersedes | chat-ui
origin/llm chat designs | chat-ui
chat-lane verification branch families | chat-ui

## packages/ses/src/error/tame-v8-error-constructor.js (cycle 93, ninth comment-fragment ingest)

tame-v8-error-constructor | object-capability
tameV8ErrorConstructor | object-capability
tame V8 error constructor | object-capability
SES stack-trace taming | object-capability
V8 stack-trace API | object-capability
v8.dev/docs/stack-trace-api | object-capability
Error.prepareStackTrace | object-capability
prepareStackTrace hook | object-capability
Error.captureStackTrace | object-capability
captureStackTrace shim | object-capability
structured stack trace | object-capability
structuredStackTrace SST | object-capability
CallSite method permit list | object-capability
safeV8CallSiteMethodNames | object-capability
safeV8CallSiteFacet | object-capability
safeV8SST | object-capability
getThis suppressed | object-capability
getFunction suppressed | object-capability
isPromiseAll suppressed | object-capability
getPromiseIndex suppressed | object-capability
getTypeName | object-capability
getFunctionName | object-capability
getMethodName | object-capability
getFileName | object-capability
getLineNumber getColumnNumber | object-capability
getEvalOrigin | object-capability
isToplevel isEval isNative | object-capability
isConstructor isAsync | object-capability
getPosition | object-capability
getScriptNameOrSourceURL | object-capability
filename censor | object-capability
FILENAME_CENSORS | object-capability
node_modules censor | object-capability
node:internal censor | object-capability
SES assert.js censor | object-capability
eventual-send censor | object-capability
ses-ava censor | object-capability
filterFileName | object-capability
ridiculously expensive callsite attenuation | object-capability
TODO ridiculously expensive | object-capability
CALLSITE_ELLIPSIS_PATTERN | object-capability
CALLSITE_PACKAGES_PATTERN | object-capability
CALLSITE_FILE_2SLASH_PATTERN | object-capability
shortenCallSiteString | object-capability
path shortening regex | object-capability
lerna monorepo convention | object-capability
file:// vs file:/// VS Code | object-capability
VS Code clickable file URL | object-capability
agoric-sdk #2326 thread | object-capability
agoric-sdk issuecomment-773020389 | object-capability
system prepareFn | object-capability
user prepareFn | object-capability
input prepareFn | object-capability
systemPrepareFnSet WeakSet | object-capability
systemPrepareFnFor | object-capability
WeakSet branding prepareFn | object-capability
double-wrap prevention | object-capability
stackInfos WeakMap | object-capability
ParsedStackInfo | object-capability
StructuredStackInfo | object-capability
lazy stringification cache | object-capability
errorTaming safe | object-capability
errorTaming unsafe | object-capability
errorTaming unsafe-debug | object-capability
stackFiltering concise | object-capability
stackFiltering omit-frames | object-capability
stackFiltering shorten-paths | object-capability
omitFrames boolean | object-capability
shortenPaths boolean | object-capability
__HIDE_ function name censor | object-capability
__HIDE_ prefix concise stacks | object-capability
getStackString TC39 shim | object-capability
proposal-error-stacks | object-capability
TC39 Error Stacks | object-capability
start-compartment-only capability | object-capability
stackStringFromSST | object-capability
callSiteFilter | object-capability
callSiteStringifier | object-capability
defaultPrepareFn | object-capability
prepareStackTrace accessor pair | object-capability
prepareStackTrace setter wrap | object-capability
void error.stack force populate | object-capability
exported only for unit test | object-capability
seems to suppress builtins anonymous | object-capability
TODO move not just to v8 | object-capability
TODO user configure FILENAME_CENSORS via lockdown | object-capability
TODO user configure CALLSITE_PATTERNS via lockdown | object-capability
Richard Gibson tame-v8 | object-capability

## OCPL — Robust and Compositional Verification of Object Capability Patterns (Swasey-Garg-Dreyer OOPSLA 2017, cycle 94)

OCPL | object-capability
OCPL Logic for OCPs | object-capability
Swasey Garg Dreyer | object-capability
MPI-SWS | object-capability
Saarland Informatics Campus | object-capability
robust safety | object-capability
RobustSafety theorem | object-capability
AdequacySafety | object-capability
low-integrity value | object-capability
low value | object-capability
lowval | object-capability
high-integrity location | object-capability
low-integrity location | object-capability
high vs low location | object-capability
lowloc | object-capability
HLA language | object-capability
Higher-order with Locations and Assertions | object-capability
goodness bit | object-capability
goodness bit Fail | object-capability
assert expression HLA | object-capability
assume expression HLA | object-capability
progressive Hoare triple | object-capability
non-progressive Hoare triple | object-capability
lift Psi | object-capability
lift Ψ predicate transformer | object-capability
LiftRec LiftLoc LiftLit LiftUnit LiftPair LiftInl LiftInr | object-capability
LiftApp | object-capability
Iris separation logic | object-capability
Iris concurrent separation logic | object-capability
Iris higher-order ghost state | object-capability
Iris step-indexed Kripke | object-capability
Iris proof mode | object-capability
Coq mechanization Iris | object-capability
plv.mpi-sws.org/iris | object-capability
guarded recursive predicates | object-capability
later modality | object-capability
RustBelt project | object-capability
Krebbers Iris | object-capability
Jung Iris 2015 | object-capability
readonly motivating example | object-capability
readonly wrapper | object-capability
usetwo example | object-capability
adversarial context AdvCtx | object-capability
verified code vs untrusted code | object-capability
Abadi 1999 secrecy by typing | object-capability
Bengtson 2011 RCF F7 | object-capability
Gordon Jeffrey 2001 | object-capability
Devriese 2016 | object-capability
Devriese effect parametricity | object-capability
Kripke logical relations | object-capability
dynamic sealing OCPL | object-capability
makeseal | object-capability
seal unseal pair | object-capability
sealer-unsealer Morris 1973 | object-capability
intervals worked client | object-capability
makeint imin imax isum | object-capability
isseal isunseal issealed | object-capability
SealSpec UnsealSpec | object-capability
SealedInv SealedAgree | object-capability
UnsealAnySpec | object-capability
SealedLow | object-capability
representation invariant φ | object-capability
caretaker OCPL | object-capability
API caretaker | object-capability
location caretaker | object-capability
makecaretaker | object-capability
enabled disabled caretaker | object-capability
wrap enable disable | object-capability
temporary-invariant-break | object-capability
membrane OCPL | object-capability
MembraneSpec | object-capability
ismon predicate | object-capability
recursive instantiation | object-capability
public membrane | object-capability
Caja language invariants membrane | object-capability
shadow location | object-capability
makepub pubref pubwrap pubunwrap | object-capability
shadowread shadowwrite | object-capability
ismembrane | object-capability
isprivloc isprivval | object-capability
backward-compatible library invariant | object-capability
Sumii Pierce 2004 bisimulation sealing | object-capability
Van Cutsem Miller 2013 trustworthy proxies | object-capability
Trustworthy Proxies ECOOP 2013 | object-capability
Spiessens Van Roy | object-capability
Spiessens 2007 patterns of safe collaboration | object-capability
Murray 2010 OCP patterns | object-capability
Clarke 1998 owners-as-dominators | object-capability
ownership types | object-capability
Banerjee Naumann state-based ownership | object-capability
Patrignani join calculus | object-capability
Stiegler Miller 2006 How Emily tamed the Caml | object-capability
HPL-2006-116 | object-capability
Joe-E Mettler 2010 | object-capability
Firefox same-origin policy membrane | object-capability
Mozilla Script Security | object-capability
Barth 2011 Web Origin RFC 6454 | object-capability
OOPSLA 2017 | object-capability
RustBelt grant 683289 | object-capability

## chat-rename-dismiss-to-clear (cycle 95)

dismiss-all to clear | chat-ui
clear command | chat-ui
dismiss-all alias | chat-ui
deprecation period alias | chat-ui
hidden CLI alias | chat-ui
PR 93 chat | chat-ui
endo clear | chat-ui
endo dismiss-all | chat-ui
.command alias | chat-ui
clear-command.test.js | chat-ui
internal vs external naming | chat-ui
dismissAll daemon power | chat-ui
chat-vs-CLI alias asymmetry | chat-ui
minimal deprecation surface | chat-ui
roadmap calibration git-blame | chat-ui
65-calendar-day window | chat-ui
three implementation bursts | chat-ui
verbose unfamiliar name | chat-ui
tab-completion prefix collision | chat-ui
shortest-common-prefix advancement | chat-ui
dismiss vs dismiss-all collision | chat-ui
clear inbox conventional term | chat-ui
post-implementation retrospective | chat-ui
rename decision record | chat-ui
merge commit 31df9e3cf | chat-ui

## packages/ses/src/error/console.js (cycle 96, tenth comment-fragment ingest)

console.js SES | object-capability
causal-console | object-capability
SES causal console | object-capability
makeCausalConsole | object-capability
makeLoggingConsoleKit | object-capability
loggingConsole | object-capability
takeLog | object-capability
pumpLogToConsole | object-capability
delayed application buffer | object-capability
capture then replay | object-capability
no-special-privilege axiom | object-capability
do not reference free variable console | object-capability
internalDebugConsole | object-capability
consoleLevelMethods | object-capability
consoleOtherMethods | object-capability
consoleMethodPermits | object-capability
consoleOmittedProperties | object-capability
false-entries-in-SES-permits | object-capability
console permit list | object-capability
nine level methods | object-capability
ten other methods | object-capability
Whatwg console spec | object-capability
Chrome devtools console api | object-capability
debug log info warn error | object-capability
trace dirxml group groupCollapsed | object-capability
assert timeLog clear dir | object-capability
profile profileEnd timeStamp | object-capability
ErrorInfo NOTE MESSAGE CAUSE ERRORS | object-capability
ERROR_NOTE | object-capability
ERROR_MESSAGE | object-capability
error cause property | object-capability
AggregateError errors | object-capability
extractErrorArgs | object-capability
tag instead of toString | object-capability
errorTag tag-string | object-capability
errorsLogged WeakSet | object-capability
logError function | object-capability
logErrorInfo | object-capability
logSubErrors | object-capability
nested error grouping | object-capability
makeNoteCallback | object-capability
annotation arrived after error logged | object-capability
most-informative-message rule | object-capability
messageLogArgs | object-capability
takeMessageLogArgs | object-capability
takeNoteLogArgsArray | object-capability
getStackString console call | object-capability
loggedErrorHandler | object-capability
tagError | object-capability
defineCausalConsoleFromLogger | object-capability
AVA t.log adapter | object-capability
single-function logger | object-capability
VirtualConsole | object-capability
indentAfterAllSeps | object-capability
horrible kludge TODO | object-capability
indent stack management | object-capability
group groupEnd indent | object-capability
filterConsole | object-capability
canLog severity gating | object-capability
severity-gated filter | object-capability
LogSeverity | object-capability
defineName arrow function name | object-capability
three-wrapper composability | object-capability
logging causal filter composition | object-capability
TODO do something with optional topic string | object-capability
top-level mutable state observable to loggedErrorHandler | object-capability
honest mutable-state admission in file header | object-capability
declassifiers WeakMap | object-capability
quote bestEffortStringify wrapper | object-capability
bare canBeBare regex safe-prose gate | object-capability
canBeBare /^[\w:-]( ?[\w:-])*$/ | object-capability
DetailsToken hiddenDetailsMap | object-capability
DetailsTokenProto toString | object-capability
redactedDetails X template tag | object-capability
unredactedDetails errorTaming unsafe | object-capability
getMessageString redacted type-tag | object-capability
type-tag substitution (a TypeError) | object-capability
type-tag substitution (an Object) | object-capability
getLogArgs unquoting space-trimming | object-capability
console-substitution adjacent-space trim | object-capability
hiddenMessageLogArgs WeakMap | object-capability
errorTagNum global counter | object-capability
errorTags WeakMap | object-capability
Error#3 cross-reference tag | object-capability
resetErrorTagNum test reproducibility | object-capability
sanitizeError host-added own-property strip | object-capability
sanitizeError dropped properties annotation | object-capability
V8 stack getter to data property | object-capability
fileName lineNumber columnNumber host leak | object-capability
moved-not-lost diagnostic preservation | object-capability
makeError factory | object-capability
AggregateError errors special-casing | object-capability
opts.cause Error cause forwarding | object-capability
errorName option for tagError | object-capability
sanitize option default true | object-capability
hiddenNoteCallbacks WeakMap | object-capability
note streaming-annotation mode | object-capability
note queued-annotation mode | object-capability
addNoteLogArgs takeAllNoteLogArgs queue | object-capability
defaultGetStackString unprivileged fallback | object-capability
globalThis.getStackString privileged | object-capability
de facto error.stack property | object-capability
frozen capability-bundle loggedErrorHandler | object-capability
takeMessageLogArgs destructive read | object-capability
getMessageLogArgs non-destructive read | object-capability
take-vs-get nomenclature | object-capability
narrow-gate to module-internal state | object-capability
makeAssert factory | object-capability
optRaise raise-before-throw hook | object-capability
unredacted flag errorTaming select | object-capability
fail makeError raise throw | object-capability
Fail template-tag one-line-throwing | object-capability
||-fail short-circuit idiom | object-capability
cond || Fail`got ${value}` prose idiom | object-capability
assert condition short-circuit | object-capability
assert.equal Object.is is | object-capability
RangeError default for assert.equal | object-capability
is same as value-equality semantics | object-capability
NaN === NaN false but Object.is true | object-capability
+0 === -0 true but Object.is false | object-capability
assert.typeof TypeError default | object-capability
an() article-agreement helper | object-capability
a string vs an object | object-capability
typeWithDeterminer phrase | object-capability
recursive-assertion idiom typeof typename string | object-capability
assert.string convenience | object-capability
assertionFunctions equal typeof string fail | object-capability
assertionUtilities makeError note details Fail quote bare | object-capability
deprecated bag error makeError | object-capability
assign(assert, ...) augment-then-freeze | object-capability
new-canonical-over-deprecated spread order | object-capability
finishedAssert freeze | object-capability
module-level assert = makeAssert() | object-capability
X redactedDetails re-export | object-capability
q quote re-export | object-capability
b bare re-export | object-capability
annotateError note re-export | object-capability
assertEqual assert.equal direct binding | object-capability
makeError direct re-export | object-capability
one-letter mnemonic exports | object-capability
obviate polymorphic dispatch | object-capability
honest-debugger-affordance breakpoint comment | object-capability
particularly fruitful place to put a breakpoint | object-capability
message-of-interest MOI spotlight model | chat-ui
spotlight model one MOI at a time | chat-ui
MOI never indented at left edge | chat-ui
MOI selection IS the alignment decision | chat-ui
scroll-pinned auto-promote new-message | chat-ui
click to change MOI | chat-ui
ephemeral MOI resets on reload | chat-ui
MOI parent flush-left on spine | chat-ui
chronologically last reply terminus | chat-ui
earlier replies as branches indent 1 | chat-ui
intermediate messages between MOI and last-reply | chat-ui
computeLayout messages moiId | chat-ui
Map id indent lines layout output | chat-ui
single indent level invariant | chat-ui
two-zone layout vocabulary spine and aside | chat-ui
vertical-alignment-as-emergent property | chat-ui
focus-as-alignment-decision idiom | chat-ui
gutter-local line rendering | chat-ui
CSS pseudo-element gutter lines | chat-ui
::before vertical ::after horizontal | chat-ui
data-line continue end branch attribute | chat-ui
reply-line-color CSS custom property | chat-ui
indent-width 2ex font-relative | chat-ui
2px stroke muted grey | chat-ui
#9ca3af Tailwind gray-400 | chat-ui
#6b7280 Tailwind gray-500 | chat-ui
CSS-over-SVG simpler-when-segments-are-gutter-local | chat-ui
SVG-rejection three-criterion test animation gradient cross-virtualization | chat-ui
simple right-angle junction no ornament | chat-ui
off-screen-messages render lines regardless | chat-ui
visually-hidden in reply to previous message | chat-ui
visually-hidden audibly-present a11y pattern | chat-ui
virtualization debounce caching performance triad | chat-ui
requestAnimationFrame line recalc | chat-ui
13-row Decisions Made table | chat-ui
knob-by-knob rationale record | chat-ui
flat list with thread indicators alternative | chat-ui
separate thread view alternative | chat-ui
GitHub-style collapsed threads alternative | chat-ui
Slack-style thread panel alternative | chat-ui
moi-layout.js pure layout algorithm | chat-ui
reply-lines.css pseudo-element gutter rendering | chat-ui
inbox-component.js MOI state tracking | chat-ui
Phase 1 MOI state management | chat-ui
Phase 2 layout computation | chat-ui
Phase 3 indentation rendering | chat-ui
Phase 4 line drawing | chat-ui
Phase 5 click interaction | chat-ui
Phase 6 polish unfinished | chat-ui
Phases 1-5 checked done | chat-ui
Deprecated see chat-focus-message | chat-ui
deprecated-but-preserved design-doc pattern | chat-ui
implemented-then-superseded lifecycle | chat-ui
Out-of-Scope keyboard navigation deferred | chat-ui
design-doc-as-implementation-tracker | chat-ui
design-doc-as-rationale-history | chat-ui
follow-along mode scroll-pinned | chat-ui
focus is the layout decision | chat-ui
user-selection-as-layout-input | chat-ui
defer-to-incumbent-mechanism scroll pinning | chat-ui
unhandled rejection tracking | object-capability
browser-prevent-access unhandledrejection event | object-capability
serve from http or https workaround | object-capability
makeRejectionHandlers reportReason factory | object-capability
fail-loud-not-degrade discipline | object-capability
FinalizationRegistry GC-driven detection | object-capability
unhandled-and-no-longer-reachable condition | object-capability
idToReason Map strong record | object-capability
promiseToReasonId WeakMap weak back-reference | object-capability
finalizeDroppedPromise GC callback | object-capability
unhandledRejectionHandler three-write commit | object-capability
rejectionHandledHandler cancel after the fact | object-capability
processTerminationHandler at-exit flush | object-capability
empty-pool-cancel-checking idiom | object-capability
cancelChecking thunk | object-capability
no-work-no-timer discipline | object-capability
defensive-fallback no-op on undefined | object-capability
mapDelete no-op on missing key | object-capability
lastReasonId monotonic counter | object-capability
finalizationRegistryRegister unregister token | object-capability
promise-itself-as-unregister-token | object-capability
mapEntries iterator safe with delete-current | object-capability
spec-defined Map iteration with mutation | object-capability
platform-limitation-attribution discipline | object-capability
division-of-responsibility JSDoc comment | object-capability
synchronous-throw vs asynchronous-rejection paths | object-capability
full SES error-observation surface | object-capability
agent cluster termination flush | object-capability
beforeExit unhandled rejection report | object-capability
commands as self-addressed messages | daemon
asymmetric transcript missing-half-of-conversation | daemon
followMessages records inbound only | daemon
from === to self-send corner case | daemon
mail.js self-delivery suppression | daemon
type-aware self-delivery lift | daemon
command message type | daemon
commandName args promiseId resolverId | daemon
result as replyTo reply | daemon
durable command formula | daemon
durable reply formula | daemon
session reconstruction from message log | daemon
evaluate subsumes eval-proposal pair | daemon
eval-proposal-proposer eval-proposal-reviewer collapse | daemon
8-operation table dismiss adopt resolve reject evaluate request send grant | daemon
agent tool audit trail | daemon
capability-confined agent observability | daemon
readFile exec as commands | daemon
daemon-capability-bank built-in observability | daemon
chat-pending-commands UI-only predecessor | daemon
chat-pending-commands subsumed | daemon
pending command spinner settled checkmark | daemon
reply-fold into command card | daemon
daemon-form-request reply pattern | daemon
daemon-value-message reply mechanism reuse | daemon
2x message volume cost | daemon
no markdown body no embedded references | daemon
durable-log enables undo replay | daemon
design-dependency graph six designs | daemon
unified transcript no separate pending region | daemon
agent-visible history via followMessages | daemon
new-design-deprecates-predecessor lifecycle | daemon
one-design-solves-two-problems cross-cutting payoff | daemon
minimal-mechanism-maximal-semantics discipline | daemon
type-aware conditional lift in mail.js | daemon
Confirm Is Assert trio pattern | patterns
one internal predicate three external entry points | patterns
Rejector callable-or-false dual mode | patterns
reject && reject template-literal short-circuit | patterns
hideAndHardenFunction discipline | patterns
function name leak prevention | patterns
keyMemo WeakSet | patterns
don't memoize negatives discipline | patterns
positives-only memoization | patterns
isAtom early return atoms cannot inhabit WeakSet | patterns
confirmKey confirmKeyInternal recursion | patterns
recursion-on-passStyle dispatch | patterns
unexpected passStyle throws | patterns
expected-vs-unexpected-state trichotomy | patterns
copySetMemo copyBagMemo copyMapMemo | patterns
confirmCopySet confirmCopyBag confirmCopyMap | patterns
five-layer copyMap structural validation | patterns
only-keys-and-values invariant | patterns
ownKeys rest.length === 0 strict-record | patterns
makeCopyBagFromElements sort-then-adjacent-counting | patterns
history-dependent state does not survive | patterns
fullOrder antiComparator | patterns
makeFullOrderComparatorKit | patterns
BigInt(j - i) multiplicity count | patterns
makeCopyMap reverse-rank-sort | patterns
compareAntiRank | patterns
copyMap cover issue TODO | patterns
patternMatchers.js cover issue cross-reference | patterns
getCopyMapEntries Far iterable | patterns
getCopyMapEntryArray eager hardened | patterns
offer-both-shapes dual API | patterns
copyMapKeySet internal-form shortcut | patterns
shared-internal-form tag-rewrite | patterns
makeTagged copySet payload | patterns
layered-invariant check most-specific-diagnostic-first | patterns
break-import-cycle by relocation | patterns
ScalarKey atom or remotable | patterns
copyRecord all values must be keys | patterns
copyArray all elements must be keys | patterns
copyMap keys are keys values are keys layered | patterns
value message type | daemon
ValueMessage required replyTo | daemon
valueId FormulaIdentifier | daemon
reply-only invariant | daemon
single value per message | daemon
sendValue messageNumber petNameOrPath resultName | daemon
recipient inferred from parent | daemon
security-by-topology | daemon
auto-retain mechanism | daemon
resultName hint not guarantee | daemon
zero-ceremony value delivery | daemon
VALUE edge primary payload | daemon
seven-edge message hub directory | daemon
FROM TO DATE TYPE MESSAGE REPLY VALUE edges | daemon
fire-and-forget value already exists | daemon
no promise resolver infrastructure | daemon
package empty template workaround | daemon
adopt ceremony gap | daemon
LLM agent tool results | daemon
core loop of agentic interaction | daemon
human sends task agent replies with result | daemon
foundational reply-primitive | daemon
value-as-reply pattern | daemon
14-row Files Modified surface | daemon
design-doc-as-implementation-tracker shape | daemon
endo send-value CLI command | daemon
send-value command-registry | daemon
one result per task | daemon
envelope-vs-out-of-band carriage open question | daemon
partial-order vs total-order distinction | patterns
keys form a partial order | patterns
NaN as incommensurate signal | patterns
setCompare bagCompare makeCompareCollection | patterns
keycollection-operators | patterns
CopySet subset semantics | patterns
CopyBag multi-set semantics | patterns
ABSENT Symbol private sentinel | patterns
Symbol vs Symbol.for global registry | patterns
not passable JS-level sentinel | patterns
endo PR 1737 review thread | patterns
copyMap comparison undecided semantics | patterns
compareKeys passStyle dispatch | patterns
NaN === NaN compares as 0 in key semantics | patterns
NaN vs non-NaN returns NaN | patterns
remotable identity-only key comparison | patterns
non-identical remotables incommensurate | patterns
copyArray lexicographic prefix-shorter-is-smaller | patterns
copyRecord Pareto partial order | patterns
same property set required for comparison | patterns
mixed-direction returns NaN | patterns
key-order-is-a-refinement-of-rank-order | patterns
five-comparator predicate suite | patterns
keyLT keyLTE keyEQ keyGTE keyGT | patterns
all-five-false-when-incommensurate | patterns
boolean predicate wrappers around partial-order | patterns
-0 and 0 in same equivalence class | patterns
Daemon Capability Bank meta-design | daemon
family of nine sibling designs | daemon
OWASP Top 10 for Agentic Applications | capability-security
ASI01 Agent Goal Hijack | capability-security
ASI02 Tool Misuse and Exploitation | capability-security
ASI03 Identity and Privilege Abuse | capability-security
ASI05 Unexpected Code Execution | capability-security
ASI06 Memory and Context Poisoning | capability-security
ASI08 Cascading Failures | capability-security
ASI09 Human-Agent Trust Exploitation | capability-security
ASI10 Rogue Agents | capability-security
dangerous ambient authority | capability-security
AIShellJack 84% attack success | capability-security
IDEsaster 100% vulnerable AI IDEs | capability-security
Liu et al arXiv 2509.22040 | capability-security
prompt-injection-to-tool-abuse | capability-security
Capabilities are objects not configurations | capability-security
ocap-vs-ACL canonical distinction | capability-security
guest cannot name resource outside scope | capability-security
recursive attenuation via sub-capabilities | capability-security
narrower-power-via-narrower-capability | capability-security
caretaker separation guest vs host facet | capability-security
defense-in-depth deny patterns optional | capability-security
denylists as secondary safety net | capability-security
structural confinement vs behavioral confinement | capability-security
LLM discoverability help() | capability-security
M.interface guards maximally-specific shapes | capability-security
named fields literal enumerations descriptive tags | capability-security
existing Endo patterns directory capability | capability-security
LAL agent dynamic capability discovery | daemon
namespaced tool registration | daemon
fs.readText git.status namespace prefix | daemon
9-category capability bank table | daemon
filesystem process network git env credentials userio timer persona | daemon
composition layer named role profiles | daemon
read-only developer CI runner data analyst | daemon
OWASP coverage matrix threat-by-defending-capability | capability-security
interface guards reject structurally invalid calls | capability-security
maker pattern restricts creation to HOST | capability-security
host writes Handle formula chain enforcement | capability-security
no-default-authority discipline | capability-security
evidence-based threat framing | capability-security
tameConsole factory lockdown entry point | object-capability
SES integration top-level wiring | object-capability
don't-import-Error invariant | object-capability
TypeError minimizes feral Error exposure | object-capability
commons.js TypeError captured-and-tamed | object-capability
failFast short-circuit failure helper | object-capability
wrapLogger frozen-apply-binding | object-capability
three-tier originalConsole fallback | object-capability
globalThis.console derivation | object-capability
globalThis.print eshost SpiderMonkey | object-capability
five-method-log-stub | object-capability
log-only console upgrade | object-capability
warn error alias for log | object-capability
defineProperty alias method | object-capability
consoleTaming safe vs unsafe | object-capability
errorTrapping platform exit abort report none | object-capability
unhandledRejectionTrapping report none | object-capability
optGetStackString override | object-capability
spread-extended handler | object-capability
avoid Parcel overweaning gaze | object-capability
globalThis.process not bare process | object-capability
globalThis.window not bare window | object-capability
Parcel sloppy-mode shim | object-capability
SES strict-mode invariant bundle | object-capability
escape bundler scanner lexical form | object-capability
@endo/no-polymorphic-call ESLint rule | object-capability
platform-API polymorphic-call opt-out | object-capability
process.on uncaughtException | object-capability
process.on unhandledRejection rejectionHandled exit | object-capability
window.addEventListener error | object-capability
addEventListener unhandledrejection rejectionhandled beforeunload | object-capability
event.preventDefault take-over-platform-reporting | object-capability
about:blank browser exit equivalent | object-capability
SES_UNCAUGHT_EXCEPTION error code prefix | object-capability
SES_UNHANDLED_REJECTION error code prefix | object-capability
named-error-prefix URL-to-doc discipline | object-capability
ses/error-codes documentation | object-capability
process.exit exitCode-or-minus-one | object-capability
fail-loud-not-degrade missing process.exit | object-capability
extensible record return shape | object-capability
Claw Claude-Code-like AI agent | daemon
Dir Shell Git capability shapes | daemon
agent tool registry | daemon
readFile writeFile listDir glob stat | daemon
Shell exec execInteractive | daemon
allowedCommands allowlist | daemon
node npm npx yarn python pip make cargo go grep find sed awk curl | daemon
filteredEnv no secrets | daemon
array-based execution no shell expansion | daemon
prevent shell injection | daemon
Git status diff log add commit checkout branch | daemon
Git split by authority | capability-security
local Git excludes push pull | capability-security
git config excluded prevent hook setting | capability-security
git hook excluded prevent persistence attack | capability-security
raw git command execution forbidden | capability-security
one-capability-one-authority-domain invariant | capability-security
endo grant pet-name capability granting | daemon
makeDir makeShell makeGit programmatic grants | daemon
capability-driven dynamic tool registration | daemon
try lookup catch skip pattern | daemon
same agent code works with or without coding capabilities | daemon
form-based capability provisioning | daemon
manager-worker capability flow | daemon
phased approach Filesystem Shell Git Integration | daemon
filesystem first lowest risk | daemon
Revision note refining sketch | daemon
refined-but-not-deprecated lifecycle | daemon
daemon-mount-capabilities successor | daemon
daemon-git-capability successor | daemon
daemon-git-remotes successor | daemon
GitRemote bounded capability | daemon
mount-scoped descriptor | daemon
EndoMount derivation | daemon
defineExoClass factory | exo
defineExoClassKit factory | exo
makeExo singleton convenience | exo
exo construction surface | exo
makeSelf private helper | exo
LABEL_INSTANCES debug knob | exo
DEBUG=label-instances env-option | exo
per-instance Symbol.toStringTag Tag#3 | exo
emptyRecord initEmpty zero-state convenience | exo
WeakMap self context bookkeeping | exo
defendPrototype guarded prototype | exo
defendPrototypeKit per-facet prototype | exo
callback-options hooks pattern | exo
finish receiveAmplifier receiveInstanceTester | exo
host receives privileged capability via callback | exo
state-sealed-not-frozen invariant | exo
Be careful not to freeze the state record | exo
seal init args | exo
values mutable shape fixed | exo
context state self frozen wrapper | exo
contextMap.set self context | exo
class-vs-kit symmetry | exo
per-facet contextMapKit WeakMaps | exo
makeInstanceKit constructs all facets atomically | exo
context two-phase construction facets null then set | exo
amplify exoFacet walking contextMaps | exo
facet-to-siblings amplification | exo
privileged caretaker mechanism | exo
isInstance optional facetName | exo
reject facetName for non-kit class | exo
Only facets of an exo class kit can be amplified | exo
initEmpty zero-state stateless singleton | exo
makeExo defineExoClass plus immediate-invoke | exo
objectMap per-facet WeakMaps | exo
callWhen transformation static typing caveat | exo
short-circuit assert Fail template-tag | exo
factory grants public and private references | exo
Familiar Electron Shell | daemon
native desktop application packaging Endo | daemon
non-developer users installable | daemon
daemon outlives the Familiar | daemon
detached: true daemon.unref | daemon
matches CLI endo start behavior | daemon
just-another-client of persistent daemon | daemon
localhttp:// custom protocol | daemon
intercept-before-DNS pattern | daemon
per-weblet unique origin | daemon
without requiring DNS resolution of *.localhost | daemon
Host header proxy to daemon | daemon
browser security isolation per weblet | daemon
separate cookie jars localStorage | daemon
WebSocket proxy fallback | daemon
Electron protocol.handle does not support WebSocket upgrade | daemon
MessagePort bridge | daemon
play well with existing daemons five-scenario table | daemon
E(bootstrap).ping() alive and compatible | daemon
two-layer compatibility socket plus protocol | daemon
nine shipped modules file-level enumeration | daemon
electron-main.js daemon-manager protocol-handler | daemon
exfiltration-defense navigation-guard | daemon
Design deviations honest departures | daemon
src not resources Electron Forge URL fragment | daemon
familiar-gateway-migration dependency | daemon
familiar-unified-weblet-server dependency | daemon
familiar-daemon-bundling dependency | daemon
Purge destructive confirmation dialog | daemon
electron-updater auto-update | daemon
daemon-side migration progress indicator | daemon
200MB Electron distribution | daemon
Chromium Node.js bundled | daemon
preload.js minimal IPC bridge | daemon
privileged scheme protection | daemon
expand audience via packaging | daemon
copySet element-validation surface | patterns
confirmNoDuplicates fullCompare reject | patterns
fullOrder antiComparator built fresh per call | patterns
this fullOrder contains history dependent state does not survive | patterns
sort-then-adjacent-duplicate-scan algorithm | patterns
&&= once tooling ready TODO | patterns
memoize no-duplicate finding independent of fullOrder | patterns
assertNoDuplicates public throw-form | patterns
three-layer confirmElements | patterns
The keys of a copySet or copyMap must be a copyArray | patterns
The keys of a copySet or copyMap must be sorted in reverse rank order | patterns
isRankSorted compareAntiRank | patterns
reverse-rank-sorted invariant for copySet | patterns
coerceToElements iterable to array | patterns
makeSetOfElements makeTagged copySet | patterns
canonical copySet internal form | patterns
tagged copySet rank-sorted no-duplicates copyArray | patterns
one-validation-serves-multiple-consumers | patterns
hideAndHardenFunction assertElements | patterns
short-circuit reject template-tag | patterns
ties cluster for downstream scan-based algorithms | patterns
deferred optimization TODO with trigger | patterns
honest known perf limit with named mitigation | patterns
familiar gateway migration | daemon
gateway moved from Chat to daemon | daemon
gateway-server.js retained as Vite standalone | daemon
@apps formula web-server-node guest | daemon
ENDO_ADDR default 127.0.0.1:8920 | daemon
dual-purpose HTTP plus WebSocket listener | daemon
WebSocket at / for CapTP | daemon
HTTP for weblet virtual hosts | daemon
E(gatewayBootstrap).fetch(token) capability handshake | daemon
formula-identifier-derived unguessable token | daemon
self-connect-via-internal-CapTP | daemon
endoBootstrap.gateway() method reused | daemon
endo gateway CLI print URL | daemon
endo start --gateway-port CLI option | daemon
daemon-must-own-cross-cutting-service | daemon
cross-cutting-service-belongs-in-shared-substrate | daemon
attack-surface-reduction with named metric | daemon
one fewer process with Unix socket access | daemon
consolidation-as-security-improvement | daemon
protocol-preservation-across-migration | daemon
WebSocket protocol unchanged existing clients work | daemon
honest-retention discipline | daemon
named-upgrade-path-with-detected-fallback | daemon
pre-migration daemon detection | daemon
localhost-only IPv4 ::1 restriction | daemon
endopi family of designs | daemon
agentskills.io specification | daemon
cross-harness skill format Pi Claude Code Codex | daemon
SKILL.md frontmatter | daemon
name max 64 chars lowercase | daemon
description max 1024 chars | daemon
allowed-tools experimental | daemon
disable-model-invocation flag | daemon
license compatibility frontmatter fields | daemon
my-skill directory with scripts references assets | daemon
progressive disclosure descriptor in system prompt | daemon
read full SKILL.md on demand | daemon
discoverSkills paths walker | daemon
~/.pi/agent/skills | daemon
~/.claude/skills | daemon
~/.codex/skills | daemon
.agents/skills walk-up from cwd | daemon
.pi/skills | daemon
adopt-the-existing-standard rather than fragment | daemon
de-facto cross-harness standard | daemon
lenient-validation warn but accept | daemon
foreign skills load discipline | daemon
authoring-surface-vs-granting-surface split | daemon
endoclaw-skill-registry daemon-side complement | daemon
guest module bridges filesystem to EndoDirectory | daemon
/skill:my-skill slash command forced load | daemon
user-override for LLM skill selection | daemon
allowed-tools as structural capability grant open question | daemon
Endo answer more rigorous than Pi | daemon
cite-the-reference-implementation discipline | daemon
filesystem-as-canonical-name | daemon
bounded-context-via-on-demand-load | daemon
be-the-most-inclusive-harness posture | daemon
Pi mono badlogic coding-agent citation | daemon
familiar daemon bundling | daemon
self-contained Electron daemon artifact | daemon
Option A single-file esbuild bundle | daemon
Option B packaged directory | daemon
two-option-exploration-with-preferred-choice | daemon
dynamic import for workers weblets guest code | daemon
SES lockdown global side effect | daemon
ocapn-noise.wasm co-location | daemon
three-challenges-with-three-mitigations | daemon
worker-resolve-relative-to-bundle-location | daemon
new URL endo-worker.cjs import.meta.url pathname | daemon
sibling-artifact via import.meta-url | daemon
endo-daemon.cjs endo-worker.cjs ses-shim.cjs | daemon
ocapn-noise.wasm node-platform-arch | daemon
five-file dist build artifacts | daemon
self-contained-from-resources launch | daemon
familiar-resources directory | daemon
50MB total size target | daemon
Node.js 40MB daemon 10MB | daemon
platform-specific Node.js binary matrix | daemon
macOS arm64 x86_64 Linux Windows | daemon
trusted Node.js source checksum verification | daemon
supply-chain attack mitigation | daemon
packaging-doesn't-change-product invariant | daemon
It's the same code just packaged differently | daemon
interchangeable bundled vs development daemon | daemon
~/.local/state/endo state directory shared | daemon
play well with existing daemons compatibility | daemon
foundational-dependency-with-no-upstream | daemon
None can proceed independently | daemon
pinned bundled Node.js version per Familiar release | daemon
tree-shaking bundle size reduction | daemon
yarn bundle build script | daemon
packages/familiar-build vs packages/daemon placement | daemon
Familiar dependency triangle 2 of 3 complete | daemon
familiar unified weblet server | daemon
Familiar dependency triangle complete | daemon
Key design revision 2026-04-17 | daemon
two-mode split Familiar vs Chat | daemon
Electron protocol-handler intercepts | daemon
browsers cannot intercept scheme | daemon
hierarchical multiplexing problem | daemon
user persona agent weblet routing | daemon
session confidentiality 127.0.0.1 trust breaks | daemon
ocapn-network-transport-separation dependency | daemon
ocapn-noise-network dependency | daemon
Implemented Not implemented status enumeration | daemon
Previous status note honest correction | daemon
prospective status section discipline | daemon
file does not exist on origin/llm | daemon
single HTTP server replaces servePortHttp | daemon
webletHandlers Map hostname to respond connect | daemon
virtual host routing | daemon
<weblet-id>.localhost | daemon
webletId.slice(0,32) hash-prefix truncation | daemon
RFC 6761 *.localhost browser resolution | daemon
no DNS configuration needed | daemon
weblet location URL format change | daemon
http://<weblet-id>.localhost:<gateway-port>/ | daemon
fall through to gateway WebSocket | daemon
backward compatibility standalone mode | daemon
makeWeblet signature port to server-registrar | daemon
unguessable 128-char-hex weblet identifier | daemon
browser SOP cookie isolation per subdomain | daemon
N-weblets-N-ports to N-weblets-1-port | daemon
two-environment-different-mechanisms discipline | daemon
honest-design-correction-inline | daemon
deeper-problem identification points to dependency | daemon
copyBag entry validation | patterns
confirmNoDuplicateKeys bag entries | patterns
key-significance-over-value | patterns
fullOrder lexicographic-key-first composite-key sort | patterns
five-layer confirmBagEntries | patterns
per-entry-shape 2-element copyArray bigint count | patterns
per-entry-positive-count count >= 1n | patterns
absent keys mean count-zero | patterns
bigint count arbitrary-large multiplicity | patterns
assertBagEntries hideAndHardenFunction | patterns
coerceToBagEntries iterable to array | patterns
makeBagOfEntries makeTagged copyBag | patterns
canonical copyBag internal form | patterns
tagged copyBag [key,count] 2-tuples | patterns
bag-analog of set validation | patterns
sister-file design discipline | patterns
one-discipline-shared-across-implementations | patterns
additive-validation-layers richer-payload-more-layers | patterns
no zero entries multi-set invariant | patterns
positive count discipline | patterns
fullOrder antiComparator key-first lexicographic | patterns
bag entry tuple shape validation | patterns
Form message type | daemon
FormField name label example pattern | daemon
fields-as-ordered-array-vs-record | daemon
separates semantic key from display text | daemon
fire-and-forget form() returns immediately | daemon
multi-submission via value replies | daemon
form() polling for value replies | daemon
submit messageNumber values | daemon
mustMatch daemon-side enforcement | daemon
patterns are a contract not a hint | daemon
default M.string() when no pattern | daemon
formulateMarshalValue values record | daemon
makeForm envelope + messageId | daemon
form() guest-facing method | daemon
getForm retrieval | daemon
endo form CLI command | daemon
endo submit CLI command | daemon
--field fieldName:label colon-on-first | daemon
/form modal form builder | daemon
inline form rendering with labels | daemon
field.example || field.name placeholder fallback | daemon
five named Gaps for form-request | daemon
no forwarding or sharing | daemon
FormulaNumber vs FormulaIdentifier forward-safety | daemon
limited pattern vocabulary Chat UI | daemon
CLI values are strings only | daemon
no reusable form templates | daemon
agent-level abstraction for reuse | daemon
ten numbered Design Decisions | daemon
pattern → widget mapping table | daemon
M.string M.number M.boolean M.scalar M.remotable M.promise widgets | daemon
pet-name path selector capability reference | daemon
pattern-introspection M.gte M.lte HTML min max | daemon
extensible-by-pattern widget mapping | daemon
unrecognized patterns fall back text input | daemon
simplified internals no PROMISE RESOLVER RESULT edges | daemon
makeForm no promise resolver pair | daemon
DESCRIPTION + FROM/TO/DATE/TYPE/MESSAGE edges only | daemon
daemon-rich CLI-simple trade-off | daemon
values support capability references | daemon
which worker should I use form-value | daemon
structured-question-with-named-fields | daemon
LLM agent configuration scenario | daemon
multi-field input scenario | daemon
correlation across multiple messages fragile | daemon
single-response-promise vs multi-submission-value | daemon
reply-chain history submissions | daemon
form definition vs value submission | daemon
sender and receiver both see input fields | daemon
Pi-compatible JSONL transcript format | daemon
endoclaw Persistence and Memory directive | daemon
openclaw localgpt JSONL adoption | daemon
on-disk projection of in-memory tree | daemon
five entry types header message compaction branchSummary custom | daemon
custom entries with endo:* discriminator | daemon
extension-namespaced entries via custom role | daemon
$ENDO_STATE/sessions/<guest-id>/<timestamp>_<session-id>.jsonl | daemon
mode 0600 owner-private | daemon
O_APPEND atomicity | daemon
partial-line recovery truncate to last newline | daemon
loadFromJsonl path helper | daemon
claw uses these as a form of memory | daemon
endo session list show CLI verbs | daemon
off-the-shelf JSONL tooling jq fx | daemon
transparent-persistence-not-opaque-database | daemon
compaction entry firstKeptEntryId pointer | daemon
full history stays in file compaction is reversible | daemon
$ENDO_STATE vs $HOME/.pi/agent/sessions open question | daemon
UUIDv7 vs 256-bit formula ID open question | daemon
store both with endo:messageId field | daemon
Pi-mono session-format.md citation | daemon
adopt-existing-standard-with-extension-namespace | daemon
cite-Pi-reference-implementation discipline | daemon
endopi family arc adopt-Pi-format | daemon
agent reads own transcripts long-term memory | daemon
inspectable append-only JSONL | daemon
RawMethodGuard no-validation sentinel | exo
REDACTED_RAW_ARG sentinel for pass-through | exo
PassableMethodGuard minimum-validation | exo
defendSyncArgs raw-guard redaction | exo
buildMatchConfig one-time-slow per-call-fast | exo
M.splitArray paramsPattern | exo
M.raw() pass-through guard | exo
defendSyncMethod concise-method-syntax-via-destructure | exo
this-preserving wrapper | exo
desync transformer await-arg-guards | exo
isAwaitArgGuard isRawGuard | exo
Rest args may not be awaited | exo
defendAsyncMethod Promise.all awaitList | exo
TOCTTOU-aware context lookup | exo
Get the context after all waiting | exo
revocation by removing context entry | exo
chained .catch not onRejected | exo
mustMatch throws in onFulfilled | exo
toThrowable passable error coercion | exo
defendMethod callKind sync vs async | exo
bindMethod name length defineProperties | exo
Method X called without this object | exo
may only be applied to a valid instance | exo
defendPrototype tag contextProvider behaviorMethods | exo
constructor-filter for class.prototype | exo
shiftedMethod for non-thisful style | exo
this becomes context for thisful methods | exo
symmetric listDifference validation | exo
methods X not implemented by tag | exo
methods X not guarded by interfaceName | exo
sloppy true alias for defaultGuards passable | exo
defaultGuards undefined vs passable vs raw | exo
symbolMethodGuards via getCopyMapEntries | exo
GET_INTERFACE_GUARD auto-installation | exo
runtime-introspection method for interface guard | exo
Far(tag, prototype) final wrap | exo
defendPrototypeKit multi-facet | exo
A multi-facet object must have multiple facets | exo
4-way listDifference facet/interface/context | exo
objectMap per-facet defendPrototype | exo
amortize compilation cost across calls | exo
exo construction + defense surface | exo
user-call-tree defineExoClass to defendSyncMethod | exo
the daemon is the capability bus | daemon
daemon-as-message-router | daemon
language-agnostic message router | daemon
CBOR envelope four-tuple | daemon
handle verb payload nonce | daemon
fd 3/4 pipe layout | daemon
CBOR-framed envelopes | daemon
symmetric handle rewriting | daemon
handle field denotes local-side identity of peer | daemon
no sender field needed | daemon
CapTP-over-envelope encapsulation | daemon
deliver verb payload | daemon
transparent to the CapTP layer | daemon
bus-daemon-node.js manager entry | daemon
bus-daemon-node-powers.js makeWorker no longer forks | daemon
bus-worker-node.js worker entry | daemon
bus-daemon-rust-xs.js XS manager bootstrap | daemon
bus-worker-xs.js XS worker bootstrap | daemon
endor manager -e xs | daemon
endor binary subcommand dispatch | daemon
unified endor binary daemon manager worker | daemon
spawn verb spawn-tree daemon-controls-process-config | daemon
init ready envelope handshake | daemon
manager-requests-worker-creation-via-envelope | daemon
workers are children of the daemon not of the manager | daemon
handle topology daemon-0 manager-1 workers-2-plus | daemon
spawn-tree deadlock prevention canBlock | daemon
sync calls only child to ancestor | daemon
nonce-0 fire-and-forget vs nonce-gt-0 request-response | daemon
inherited from endo-engo prototype | daemon
incremental syscall migration unbounded | daemon
syscall log verb worker stderr | daemon
fs.read fs.write net.listen crypto.random candidates | daemon
new envelope verbs for syscall migration | daemon
workers can be fully OS-confined | daemon
sandbox-exec namespaces seccomp | daemon
handles unforgeable within envelope protocol | daemon
two-layer ocap discipline stacked | daemon
envelope-level + CapTP-level ocap | daemon
daemon runs no JavaScript | daemon
manager is the privileged child | daemon
manager runs the formula graph and pet-name store | daemon
bus prefix denotes protocol participation not role | daemon
rolling back is trivial -node modules remain | daemon
ENDO_BIN switch between legacy and bus daemon | daemon
keycollection-operators patterns infrastructure | patterns
generateFullSortedEntries refine rank-sorted | patterns
generateCollectionPairEntries sorted-merge-join | patterns
makeCompareCollection factory | patterns
Pareto partial-order over collections | patterns
absentValue caller-supplied default | patterns
key absent in c1 means valueA equals absentValue | patterns
key absent in c2 means valueB equals absentValue | patterns
absent keys mean count zero for CopyBag | patterns
absent keys mean false for CopySet | patterns
compareAntiRank reverse rank order | patterns
makeFullOrderComparatorKit antiComparator | patterns
history-dependent comparator scoped to active invocation | patterns
fresh fullOrder per call | patterns
two-flag Pareto leftIsBigger rightIsBigger | patterns
early-exit if leftIsBigger and rightIsBigger return NaN | patterns
NaN-passthrough value-level incomparability | patterns
nonEntry destructure with default | patterns
single-result done key value buffer pre-advance | patterns
sorted-merge-join lockstep iteration | patterns
strict total-order lift from rank preorder | patterns
duplicate-key check via Math.sign-or-Fail | patterns
sortByRank with fullCompare tie-breaking | patterns
private helper to export chain | patterns
virtual-collection generalization future | patterns
generateEntries IterableIterator replacement | patterns
worked CopyBag Pareto example | patterns
multiplicity-wise less than or equal | patterns
defaulting absent keys to a count of zero | patterns
Boolean lattice absentValue false | patterns
per-key value comparator | patterns
makeCompareCollection consumed by compareKeys | patterns
keycollection operators sister to compareKeys | patterns
KeyCollection getEntries returns rank-sorted array | patterns
@endo/marshal makeFullOrderComparatorKit antiComparator | marshal
call-local-scoping covert-channel mitigation | marshal
fullOrder does not survive the call | marshal
EndoPi comparative analysis Pi agent harness | agent-conventions
badlogic pi-mono canonical reference | agent-conventions
Mario Zechner pi harness 49.5k stars MIT | agent-conventions
endoclaw companion reference assistant shape | agent-conventions
Pi frames Endo coding-agent shape | agent-conventions
ambient authority plus ergonomics | agent-conventions
least authority plus auditable structure | agent-conventions
the bet of Endo agents acting for users | agent-conventions
users who cannot evaluate the agent source code | agent-conventions
edit-by-replacement oldText newText | agent-conventions
unique-match normalized line endings | agent-conventions
structured diff preview | agent-conventions
JSONL session tree id parentId | agent-conventions
slash tree slash fork slash clone | agent-conventions
unified provider registry pi-ai | agent-conventions
30 plus providers auto-discovered models | agent-conventions
subscription auth Claude Pro ChatGPT Plus Copilot | agent-conventions
cross-provider session handoff | agent-conventions
TS modules full system access | agent-conventions
plug-in vs guest extension shape | agent-conventions
pi.registerTool pi.registerCommand pi.registerShortcut | agent-conventions
hot-reload slash reload | agent-conventions
pi-package keyword in package.json | agent-conventions
SKILL.md frontmatter progressive disclosure | agent-conventions
agentskills.io specification | agent-conventions
context files AGENTS.md CLAUDE.md walking parents | agent-conventions
SYSTEM.md append vs replace | agent-conventions
RPC over stdio LF-delimited JSONL | agent-conventions
endor-bus-tui subsumes RPC | agent-conventions
keepRecentTokens reserveTokens compaction knobs | agent-conventions
slash compact slash branch summarization | agent-conventions
pi-share-hf Hugging Face publishing | agent-conventions
slash export to HTML slash share gist | agent-conventions
packages genie Pi inside Endo | agent-conventions
@mariozechner pi-agent-core pi-ai runtime deps | agent-conventions
makePiAgent runAgentRound boundary translation | agent-conventions
buildOllamaModel masquerade as openai-completions | agent-conventions
http 127.0.0.1 11434 v1 ollama bypass | agent-conventions
ToolSpec to AgentTool boundary conversion | agent-conventions
toAgentTool genie tool conversion | agent-conventions
tool-gate.js per-tool argument gating | agent-conventions
tool execution is gated on expected pairs | agent-conventions
not capability-confined by SES grants | agent-conventions
packages sandbox confinement layer | agent-conventions
podman primary driver bwrap also present | agent-conventions
macOS Windows sandbox drivers anticipated | agent-conventions
endo-posix-sandbox Phase 1.5 | agent-conventions
9p filesystem server alternative | agent-conventions
vfs-endo backend vs 9p server trade-off | agent-conventions
SOUL.md HEARTBEAT.md Claw workspace | agent-conventions
observations.md reflections.md profile.md | agent-conventions
observer subagent token threshold idle timer | agent-conventions
reflector subagent long-term consolidation | agent-conventions
heartbeat subagent autonomous task executor | agent-conventions
HEARTBEAT.md pending tasks tick log | agent-conventions
makeIntervalScheduler cron-style periodic prompts | agent-conventions
buildSystemPrompt flexible library of prompt parts | agent-conventions
skillsPrompt option on buildSystemPrompt | agent-conventions
pi-agent vs pi-coding-agent vs pi-ai package split | agent-conventions
Genie closer to pi-agent than pi-coding-agent | agent-conventions
embedding-shaped SDK not cli-shaped | agent-conventions
fill-the-Pi-gap-from-the-Endo-side adaptor | agent-conventions
event-translation at boundary embedding pattern | agent-conventions
many guests many spaces many capabilities | agent-conventions
human is one of N participants | agent-conventions
Endo bot fleet eventual self-organization | agent-conventions
adopting Pi developer-velocity moves | agent-conventions
without giving up Endo multi-agent-system shape | agent-conventions
Pi source-file citations 33 file-level | agent-conventions
review-driven incremental refinement bot revision | agent-conventions
endopi-edit-tool edit by replacement | agent-conventions
oldText newText pair | agent-conventions
M.arrayOf M.splitRecord oldText newText | agent-conventions
edit method on File capability not Dir | agent-conventions
Dir.lookup name to File then File.edit edits | agent-conventions
unique-match required else error | agent-conventions
agent must add disambiguating context | agent-conventions
no overlap between edits in one call | agent-conventions
applyEditsToNormalizedContent | agent-conventions
computeEditsDiff | agent-conventions
detectLineEnding restoreLineEndings | agent-conventions
normalize to LF for matching | agent-conventions
restore original line endings on write | agent-conventions
BOM preserved if present | agent-conventions
structured diff in tool result | agent-conventions
Chat UI renders diff inline LLM sees as confirmation | agent-conventions
file-mutation-queue.ts unnecessary in Endo | agent-conventions
eventual-send semantics already serialize per capability | agent-conventions
single-await-per-method discipline TOCTTOU | agent-conventions
regex multiplies the prompt-injection surface | agent-conventions
follow Pi to reduce migration friction | agent-conventions
reuse-don't-import-Pi-TS-verbatim | agent-conventions
algorithm migrates code is re-implemented | agent-conventions
contract not heuristic discipline | agent-conventions
multi-edit batched in one call | agent-conventions
edit vs multi-edit single tool both shapes | agent-conventions
edit-by-replacement primitive coding agent default | agent-conventions
File.edit returns applied diff conflicts | agent-conventions
merge-set-operators set algebra | patterns
windowResort element variant | patterns
merge xelements yelements triple stream | patterns
T xCount yCount bigint triples | patterns
For sets these counts are always 0 or 1 | patterns
generalizes nicely for bags | patterns
iterIsSuperset boolean early-exit fold | patterns
iterIsDisjoint boolean early-exit fold | patterns
iterCompare Pareto two-flag NaN short-circuit | patterns
iterUnion push each fold | patterns
iterDisjointUnion assert no common push | patterns
iterIntersection filter both present | patterns
iterDisjointSubtract assert x present filter y absent | patterns
mergeify lifts iterOp to elementsOp | patterns
rawSetify for predicates | patterns
setify for constructors re-tags | patterns
makeSetOfElements preserves canonical copySet form | patterns
three-layer factory chain iterOp elementsOp setOp | patterns
TODO share more code with keycollection-operators | patterns
raw JS array iterator does not harden IteratorResult | patterns
unfrozen value does not escape this file | patterns
correctness by closed scope confidence | patterns
13 exported set operations 7 elementsOps + 6 setOps | patterns
elementsIsSuperset elementsIsDisjoint elementsCompare | patterns
elementsUnion elementsDisjointUnion elementsIntersection elementsDisjointSubtract | patterns
setIsSuperset setIsDisjoint setUnion setDisjointUnion setIntersection setDisjointSubtract | patterns
asymmetry compareKeys setCompare uses makeCompareCollection not iterCompare | patterns
same algebra in two places | patterns
abstraction debt marker | patterns
merge-bag-operators sister file | patterns
right element was not in left | patterns
Sets must not have common elements | patterns
endopi-iterative-compaction proposed partially satisfied | agent-conventions
Genie ships observer reflector compaction substrate | agent-conventions
observer subagent token-threshold 30k plus idle-timer | agent-conventions
reflector subagent 40k-token plus daily heartbeat | agent-conventions
prunes stale low-priority entries merges related observations | agent-conventions
projection layer remaining work | agent-conventions
keepRecentTokens reserveTokens knobs | agent-conventions
find cut point walk backwards accumulating tokens | agent-conventions
generate summary structured prompt | agent-conventions
Goals Decisions Files touched Open threads Code patterns | agent-conventions
pass prior summary as iterative context | agent-conventions
append compaction entry to JSONL firstKeptEntryId | agent-conventions
reload in-memory transcript with summary | agent-conventions
one summary not N summaries | agent-conventions
structured-summary-format as iteration substrate | agent-conventions
cumulative file-operations record across compactions | agent-conventions
observes Dir File capabilities the agent invokes | agent-conventions
capability-traffic as tracking substrate | agent-conventions
compaction is lossy | agent-conventions
in-memory window prunes JSONL preserves | agent-conventions
operator or agent can recover detail by re-reading JSONL | agent-conventions
contextTokens contextWindow reserveTokens trigger | agent-conventions
slash compact instructions manual compaction | agent-conventions
optional instructions focus the summary | agent-conventions
preserve the bug-hunt thread drop the API exploration | agent-conventions
compaction.enabled compaction.reserveTokens | agent-conventions
compaction.keepRecentTokens compaction.customInstructions | agent-conventions
branch summarization on tree navigation out of scope | agent-conventions
multi-agent context sharing across compactions out of scope | agent-conventions
honest-design-correction partially-satisfied | agent-conventions
anticipated-algorithm-vs-shipped-substrate mismatch | agent-conventions
two-axis trigger discipline token-threshold plus idle | agent-conventions
substrate now exists role shifts from specify to harmonise | agent-conventions
lal-transcript-memory-management problem statement | agent-conventions
merge-bag-operators bag algebra | patterns
bagWindowResort entry variant | patterns
assertNoDuplicateKeys bag key uniqueness | patterns
six let buffer variables for merge | patterns
real multiplicities not hardcoded 0n 1n | patterns
bagIterIsSuperbag count comparison | patterns
xc less than yc not superbag | patterns
bagIterIsDisjoint identical to set | patterns
bagIterUnion sum counts xc plus yc | patterns
bagIterIntersection min xc yc | patterns
bagIterDisjointSubtract mc equals xc minus yc | patterns
mc greater equal 1n filter preserves invariant | patterns
Boolean lattice vs multiplicity lattice | patterns
bag algebra subsumes set algebra | patterns
set algebra is bag with counts clipped to 0 or 1 | patterns
generalization is free callout | patterns
the code is identical callout | patterns
Based on merge-set-operators but altered for bag | patterns
TODO share more code with that file and keycollection | patterns
bagify makeBagOfEntries re-tag | patterns
preserves canonical copyBag internal form | patterns
no bagDisjointUnion bag union already sums counts | patterns
no bagIterCompare bag-compare via makeCompareCollection | patterns
five exports vs cycle 123 six | patterns
two algebras one merge-iterator | patterns
multiplicity arithmetic | patterns
three code-sharing callouts visible | patterns
abstraction debt acknowledged in three places | patterns
coordinated-update commit e56bf00f | patterns
Keys substrate seven cycle-ingested files | patterns
endopi-stdio-rpc-bridge stdio JSONL | agent-conventions
endo agent rpc invocation surface | agent-conventions
stdio and WebSocket two transports to same daemon agent | agent-conventions
transports interleave through same transcript | agent-conventions
transport-agnostic-agent discipline | agent-conventions
capability boundaries independent of how invoked | agent-conventions
LF-delimited JSON records | agent-conventions
do not split on backslash r U+2028 U+2029 | agent-conventions
Node readline is non-compliant strict split | agent-conventions
six commands prompt steer abort list_models set_model get_status | agent-conventions
six events message_start message_update message_end | agent-conventions
tool_execution_start tool_execution_end agent_end | agent-conventions
embedding-host gets the same events invariant | agent-conventions
endor-bus-tui horizon | agent-conventions
stdio bridge becomes thin front-end for the bus | agent-conventions
deprecation-in-place lifecycle pattern | agent-conventions
phased implementation multiplexing channel ID per record | agent-conventions
spawn-implies-authorization | agent-conventions
you can spawn the process so you are authorized | agent-conventions
ssh-tunneled-stdio gateway-bearer-token-auth fallback | agent-conventions
MCP server compatibility declined at protocol level | agent-conventions
guest plugin translates for MCP | agent-conventions
process-management features out of scope | agent-conventions
no PTY no resize no bg | agent-conventions
Pi-byte-compatible framing with endo-namespaced extensions | agent-conventions
adopt existing standard with endo-prefix discipline | agent-conventions
three transports same identity stdio WebSocket future bus | agent-conventions
getGuardPayloads legacy-guard-tolerance | patterns
get*GuardPayload adapters normalize | patterns
pre-1712 klass discriminator record shape | patterns
post-1712 payload envelope shape | patterns
PR #1712 worldview shift | patterns
getAwaitArgGuardPayload getMethodGuardPayload getInterfaceGuardPayload | patterns
three-granularity adapter chain | patterns
match-current-or-legacy destructure recursively-adapt-children harden re-validate | patterns
LegacyAwaitArgGuardShape LegacyMethodGuardShape LegacyInterfaceGuardShape | patterns
LegacySyncMethodGuardShape LegacyAsyncMethodGuardShape | patterns
LegacyArgGuardShape LegacyArgGuardListShape | patterns
exploitable-bug warning AwaitArgGuard | patterns
shape-collision-only-matters-where-overlap-exists | patterns
record matching legacy shape is also valid parameter pattern | patterns
no current context where methodGuard and copyRecord both meaningful | patterns
TODO manually maintain correspondence | patterns
nine TODO markers tag abstraction debt | patterns
legacy shapes frozen current shapes evolve | patterns
no LegacyRawGuardShape | patterns
raw guards postdate PR #1712 introduced in PR #1831 | patterns
adaptLegacyArgGuard adaptMethodGuard | patterns
reconstruct via public builder chain M.call optional rest returns | patterns
mustMatch internal-consistency-post-check | patterns
internalMethodGuardAdaptor internalInterfaceGuardAdaptor | patterns
Hoare-logic-style postcondition-on-adapter | patterns
getInterfaceMethodKeys union string-named symbol-named | patterns
getCopyMapKeys emptyCopyMap sentinel | patterns
getNamedMethodGuards interface-guard inheritance via spread | patterns
M.interface I2 spread getNamedMethodGuards I1 doMore | patterns
symbol-named method guards deprecated | patterns
tests-co-located-with-consumer not implementation | patterns
test-legacy-guard-tolerance.js in @endo/exo | patterns
exo defendPrototype + guard-payload-adapter pair | patterns
end-of-life marker explicit deletion plan | patterns
endopi-provider-registry-and-oauth | agent-conventions
subscription auth highest-leverage user-facing capability | agent-conventions
ProviderInterface M.interface declaration | agent-conventions
apiStyle openai anthropic google bedrock custom | agent-conventions
authShape apiKey oauth vertex none | agent-conventions
listModels complete stream provider methods | agent-conventions
authorization-code-with-PKCE OAuth flow | agent-conventions
dual-redirect-URI Familiar pane vs 127.0.0.1 | agent-conventions
encrypted-at-rest credential discipline | agent-conventions
encryption key derived from host passphrase or hardware key | agent-conventions
account-level vs workspace-level distinction | agent-conventions
subscription tokens equivalent to logging in on the web | agent-conventions
broader-blast-radius warning | agent-conventions
UI confirmation step on first use | agent-conventions
headline-has-moved discipline | agent-conventions
30+ providers framing is no longer the headline | agent-conventions
Lal vs Genie consolidation three options | agent-conventions
deferred to maintainer | agent-conventions
@endo/lal vs @endo/lal-ai package placement | agent-conventions
@endo/ai shared package option | agent-conventions
six-axis scope-satisfaction enumeration | agent-conventions
genuinely missing OAuth Claude ChatGPT Plus Copilot | agent-conventions
cross-provider handoff mid-session slash model | agent-conventions
image input on user messages | agent-conventions
pi-ai api-registry.ts oauth.ts providers directory | agent-conventions
30+ provider modules directory citation | agent-conventions
buildOllamaModel ollama as openai-completions | agent-conventions
don't-adopt-Pi's-weaker-storage | agent-conventions
secrets boundary is different | agent-conventions
partially-satisfied lifecycle pattern repeated | agent-conventions
Vercel AI Gateway Cloudflare AI Gateway out of scope | agent-conventions
endopi-extension-package-manifest family unifier | agent-conventions
one package.json keyword one install command | agent-conventions
multiple resource kinds with per-kind confinement | agent-conventions
endo manifest key in package.json | agent-conventions
guests skills prompts providers four resource directories | agent-conventions
auto-discovery-defaults convention over configuration | agent-conventions
forward-compatibility no v2 manifest | agent-conventions
unknown keys ignored | agent-conventions
endo install npm git local path | agent-conventions
endo install --project project-local | agent-conventions
per-kind-confinement table | agent-conventions
Package authors do not get to ask for new capabilities silently | agent-conventions
skills are markdown files instruct only | agent-conventions
power is to instruct not to do anything directly | agent-conventions
prompts are pure text no capability surface | agent-conventions
providers run confined daemon-gated network | agent-conventions
safer than endo install is today | agent-conventions
expanding the surface without expanding the attack surface | agent-conventions
endo list packages endo remove | agent-conventions
endo config enable disable mirroring pi config | agent-conventions
endo install pinning and updates | agent-conventions
centralized registry declined | agent-conventions
no-moderation-surface discipline | agent-conventions
endo-package keyword npm convention | agent-conventions
forever-v1 manifest discipline | agent-conventions
endopi family unifier consumes four prior designs | agent-conventions
the right move cited solution from keystone | agent-conventions
makeMessageBreakpointTester factory | eventual-send
MatchStringTag MatchMethodName MatchCountdown | eventual-send
three-axis match grammar with wildcard | eventual-send
external internal representation transpose | eventual-send
tag method countdown vs method tag countdown | eventual-send
human-organized vs lookup-organized | eventual-send
simplifyTag strip Alleged DebugName prefix | eventual-send
one-level-strip only outer one removed | eventual-send
Just use simple tag X rather than Y | eventual-send
canonical-tag enforcement at setBreakpoints | eventual-send
countdown semantics star always zero always positive decrement | eventual-send
shouldBreakpoint method-or-wildcard tag-or-wildcard fallback | eventual-send
in-place decrement on internal table | eventual-send
getBreakpoints-returns-original-not-mutated | eventual-send
default-argument-to-stored-breakpoints reset countdowns | eventual-send
env-option-yields-undefined-when-unset | eventual-send
zero-cost-when-unset property | eventual-send
TODO enable function breakpointing | eventual-send
__proto__ null on internal records | eventual-send
@ts-expect-error confused by __proto__ | eventual-send
async-call-debugging-pain-point | eventual-send
break on third call to send on object tagged wallet | eventual-send
debugger eventual-send call site delivers later than receiver | eventual-send
predates the @endo/harden migration | eventual-send
freeze without harden | eventual-send
getEnvironmentOption caller-supplied optionName | eventual-send
isJSONRecord predicate | eventual-send
endopi-prompt-templates Mustache placeholders | agent-conventions
template is editor expansion not agent invocation | agent-conventions
template-is-text-not-trigger discipline | agent-conventions
slash templatename autocomplete expansion | agent-conventions
agent loop does not run until user presses Enter | agent-conventions
double-brace variable interpolation | agent-conventions
form-field prompts for missing variables | agent-conventions
bash-style positional arguments inline | agent-conventions
two-modes-for-one-knob | agent-conventions
shared-discovery-walker with skills | agent-conventions
parallel-paths-with-cross-harness-aliasing | agent-conventions
.pi/ for Pi .agents/ for cross-harness | agent-conventions
walk up from cwd for project override | agent-conventions
template body can reference a skill | agent-conventions
natural composition via text not API | agent-conventions
slash skill colon name in user message | agent-conventions
endopi family 9 of 9 complete | agent-conventions
endopi family arc closure 19 cycles | agent-conventions
smallest endopi design 104 lines | agent-conventions
follow Pi for simplicity discipline | agent-conventions
no autonomous execution endoclaw proactive-messages territory | agent-conventions
no variable types beyond strings | agent-conventions
plain string substitution Pi convention | agent-conventions
one-walker-many-resource-kinds substrate-reuse | agent-conventions
prompts directory consumer for cycle 129 unifier | agent-conventions
localApplyFunction localApplyMethod localGet | eventual-send
three local-delivery primitives | eventual-send
HandledPromise local dispatch | eventual-send
ENDO_DELIVERY_BREAKPOINTS env option | eventual-send
onDelivery makeMessageBreakpointTester consumer | eventual-send
STEP INTO APPLY inline comment | eventual-send
placement-at-the-actual-delivery-point | eventual-send
debugger pauses at receiver dispatch not call site | eventual-send
base-case-bottom-out-to-apply-functions | eventual-send
getMethodNames prototype walk | eventual-send
Set to deduplicate across prototype layers | eventual-send
test val name rather than layer name | eventual-send
respect subclass override of inherited method | eventual-send
stop at Object.prototype | eventual-send
don't leak Object.prototype methods | eventual-send
primitive early exit isPrimitive | eventual-send
compareStringified prioritize symbols earlier than strings | eventual-send
target has no method has X Y Z | eventual-send
error message shows available method names | eventual-send
isPrimitive duplication TODO | eventual-send
cyclic-dependency-between-packages | eventual-send
acknowledged-cost-of-layering | eventual-send
freeze not harden at top level | eventual-send
evaluation-ordering-constraint before SES lockdown | eventual-send
ntypeof null is its own type | eventual-send
typeof null is object JavaScript bug fix | eventual-send
cannot invoke target as a function | eventual-send
cannot deliver methodName to target | eventual-send
daemon-guest-eval-simplification PR #92 | agent-conventions
Guests can eval without permission | agent-conventions
eval-proposal handshake removed | agent-conventions
three configurations of eval authority | agent-conventions
No eval Mark Miller advisory-only model | agent-conventions
reasoning about capability composition is tractable | agent-conventions
Eval with approval reflexive approval no safety | agent-conventions
users approve reflexively gaining neither security nor productivity | agent-conventions
Eval with authority ocap is the safety boundary | agent-conventions
ocap discipline is the safety boundary not message approval | agent-conventions
evaluate is a tool of tools | agent-conventions
one capability subsumes special-purpose tools | agent-conventions
withholding eval forces building bespoke tools | agent-conventions
mail.evaluate mail.grantEvaluate mail.counterEvaluate removed | agent-conventions
EvalProposalReviewer EvalProposalProposer message types removed | agent-conventions
host.grantEvaluate host.counterEvaluate removed | agent-conventions
Responder exo preserved contrary to design assumption | agent-conventions
resolverId persisted fields | agent-conventions
formulateEval directly with endowments in guest pet store | agent-conventions
structurally identical to host path | agent-conventions
regression test posts no message to host or guest mailbox | agent-conventions
future re-introduction of proposal-style send fails fast | agent-conventions
attenuation-via-proxy-not-via-default | agent-conventions
default is authority attenuation is opt-in | agent-conventions
capability discipline mechanism choice is policy | agent-conventions
agent that can only reach Dir for project cannot read ssh | agent-conventions
guest evaluate executes code directly | agent-conventions
worker constraint @main pet name | agent-conventions
honest-design-correction applied to removal | agent-conventions
design retrospective with Status correction | agent-conventions
canBeMethod function-not-passable | pass-style
PASS_STYLE in func means already a remotable | pass-style
methods cannot be Far functions | pass-style
canBeMethodName string symbol number | pass-style
TODO HAZARD cannot check func is hardened | pass-style
prototype chain may mutate after PASS_STYLE check | pass-style
getRemotableMethodNames alias for getMethodNames | pass-style
abstraction-anticipating-restriction | pass-style
layering-stepwise discipline | pass-style
confirmIface Remotable Alleged DebugName prefix | pass-style
prefix-required-when-producing | pass-style
prefix-stripped-when-matching | pass-style
iface must be pure PureData | pass-style
confirmRemotableProtoOf recursive proto walk | pass-style
tag record PASS_STYLE remotable plus toStringTag | pass-style
Remotables must be explicitly declared | pass-style
never direct inheritance from Object.prototype | pass-style
remotables can inherit from other remotables | pass-style
confirmedRemotables WeakSet cache | pass-style
cache-positive-not-negative discipline | pass-style
we don't remember rejections | pass-style
possible to correct with harden | pass-style
getInterfaceOf overloaded TypeScript type | pass-style
PassStyled any T narrowed-T recovery | pass-style
RemotableHelper confirmCanBeValid | pass-style
two-distinct-shapes object vs function | pass-style
Far functions cannot be methods and cannot have methods | pass-style
object remotables bag of methods plus toStringTag | pass-style
function remotables single callable plus metadata | pass-style
.name .length optional @@toStringTag | pass-style
restKeys.length === 0 exactly these three properties | pass-style
PASS_STYLE cannot be shadowed | pass-style
A pass-by-remote cannot shadow PASS_STYLE | pass-style
no accessors only data properties | pass-style
no non-method properties on object remotable | pass-style
every always-true short-circuit | pass-style
remotables are leaves in pass-style tree | pass-style
hideAndHardenFunction assertIface | pass-style
endo locator URL format | daemon
endo:// scheme nodeNumber id type | daemon
nodeNumber 64-char hex Ed25519 public key | daemon
formulaNumber 64-char hex SHA-256 content address | daemon
formulaType host guest handle worker directory remote | daemon
at query parameter connection hints | daemon
ephemeral transport addresses | daemon
invitation locator from parameter | daemon
formula identifier number colon node | daemon
internal vs external locator distinction | daemon
LOCAL_NODE sentinel zero repeat 64 | daemon
all-zeros never valid Ed25519 public key | daemon
safe-by-impossibility-in-the-domain | daemon
externalizeId LOCAL_NODE to agent key | daemon
internalizeLocator agent key to LOCAL_NODE | daemon
localKeys set isLocalKey predicate | daemon
round-trip invariant internalId | daemon
parseLocator strict validation | daemon
reject unknown parameters | daemon
invitation locators bypass parseLocator | daemon
identify locate lookup three resolution targets | daemon
reverseIdentify reverseLocate reverseLookup | daemon
list listIdentifiers listLocators | daemon
write writeLocator | daemon
writeLocator canonical write through exos | daemon
define-once-destructure-up discipline | daemon
followNameChanges followLocatorNameChanges | daemon
addressing-is-not-identity | daemon
hints not stored with formula looked up fresh | daemon
addPeerInfo forwarding | daemon
locator.js formula-identifier.js formula-type.js | daemon
directory.js host.js guest.js mail.js | daemon
locator-design cluster cycles 49 51 60 135 | daemon
nine-method taxonomy four families | daemon
Remotable Far ToFarFunction make-far | pass-style
GET_METHOD_NAMES __getMethodNames__ | pass-style
modeled on GET_INTERFACE_GUARD from exo | pass-style
makeRemotableProto inherits from original prototype | pass-style
strict-original-prototype invariant | pass-style
object remotables inherit from objectPrototype | pass-style
Far functions inherit from Function.prototype | pass-style
mutate-harden-check-twice | pass-style
fail-fast via fresh object dry run | pass-style
dry-run-then-commit pattern | pass-style
caller's remotable doesn't get mutated mid-failure | pass-style
isFrozen comparison-against-fresh | pass-style
isFrozen always returns true under unsafe hardenTaming | pass-style
pattern-for-detecting-environment-quirks | pass-style
COMMITTED keep the interface for future reference | pass-style
Alleged colon farName prefix | pass-style
Far prepends Alleged colon | pass-style
allegation-not-attestation | pass-style
Alice can tell Bob about Carol misrepresent iface | pass-style
SwingSet Comms Vat not yet support iface attestation | pass-style
prefix-produces / prefix-requires / prefix-strips triad | pass-style
getMethodNamesMethod thisful for far-object inheritance | pass-style
getMethodNamesDescriptor enumerable false | pass-style
configurable false writable false unalterable | pass-style
Far adds GET_METHOD_NAMES only for object remotables | pass-style
Far functions excluded call-behavior only | pass-style
Far mutates the input But it is surprising | pass-style
ToFarFunction wrap-only-when-needed | pass-style
works-even-if-func-is-already-frozen | pass-style
better-Far-when-you-can | pass-style
arrow function wrap forwards calls to func | pass-style
pass-style remotable surface complete cycles 71 87 134 136 | pass-style
daemon-message-streaming progressive text delivery | daemon
streamReply streamSend StreamWriter StreamReader | daemon
append setPhase end abort StreamEvent | daemon
stream formula promise-kit-backed async iterator | daemon
streamId optional message envelope field | daemon
opt-in-via-extension-field | daemon
immediate-envelope-late-content shape | daemon
Genie LLM-token streaming use case | daemon
Thinking Calling tool X final buffered workaround | daemon
choppy UX from multi-message workaround | daemon
thinking tool-call responding phases | daemon
cross-peer streams ride CapTP method calls | daemon
no new transport primitive needed | daemon
re-use-existing-substrate discipline | daemon
CapTP promise pipelining handles streaming | daemon
CapTP method dispatch is already a streaming transport | daemon
in-memory during streaming buffer authoritative | daemon
durable on end concatenated text persisted | daemon
partial text plus abort reason on abort | daemon
static-message-eventually invariant | daemon
fallback-to-static-strings UI | daemon
honest-deferral on four open questions | daemon
chunk granularity 50ms debounce | daemon
back-pressure promise vs fire-and-forget | daemon
multiple parallel streams per message | daemon
stream cancellation by recipient | daemon
Joshua T Corbin jcorbin (evoked) attribution | daemon
PR #287 daemon-message-streaming Phase 1 | daemon
first non-Kris-Kowal daemon design | daemon
safe-promise definition Hardened JS | pass-style
isSafePromise assertSafePromise | pass-style
confirmSafePromise four-conjunction check | pass-style
safety-via-no-reentrancy-during-then | pass-style
reentrancy attack via then override | pass-style
isFrozen frozen-promise invariant | pass-style
isPromise from @endo/promise-kit realm-independent | pass-style
Promise.prototype direct inheritance | pass-style
strict-prototype-check rules out subclasses | pass-style
confirmPromiseOwnKeys allowlist | pass-style
@@toStringTag tolerance only symbol own property | pass-style
toStringTag must be data property not accessor | pass-style
toStringTag value must be string | pass-style
toStringTag must not be enumerable | pass-style
Node async_hooks explicit allowlist | pass-style
cite-Node-source-verbatim-in-comment | pass-style
host source code part of safety surface | pass-style
destroyTracking trackPromise registerDestroyHook | pass-style
async_id_symbol asyncId number | pass-style
destroyedSymbol destroyed false | pass-style
three Node async_hooks shapes allowed | pass-style
reentrancy-via-test-itself meta-hazard | pass-style
agoric-sdk issue 9 safe promise testing | pass-style
honest-limitation discipline JSDoc admits gap | pass-style
hideAndHardenFunction vs harden | pass-style
assertion function name hidden from stack trace | pass-style
rejector-as-callback pattern | pass-style
isXxx vs assertXxx rejector wrap | pass-style
safe-promises not themselves a pass-style | pass-style
pre-condition for safe pass-by-reference | pass-style
daemon-docker-selfhost always-on server | daemon
Docker image Node 22-slim base | daemon
pre-built bundles in container | daemon
VOLUME /data/endo state persistence | daemon
EXPOSE 8920 gateway port | daemon
bind 0.0.0.0 vs local 127.0.0.1 | daemon
ENDO_STATE ENDO_ADDR ENDO_GATEWAY_REMOTE env vars | daemon
docker-entrypoint.sh lazy-init exec daemon | daemon
external TLS via reverse proxy | daemon
Caddy nginx Traefik cloud load balancer | daemon
avoids bundling certificate management | daemon
Let's Encrypt OCSP stapling out of scope | daemon
design-as-deferral pattern | daemon
each-layer-handles-its-concern | daemon
Docker Compose two-services-one-volume | daemon
caddy reverse proxy depends_on endo | daemon
restart unless-stopped policy | daemon
state subdir keys subdir worker subdir | daemon
single-volume-three-subdirectories | daemon
bundled-agents optional via env paths | daemon
parity-with-Familiar | daemon
Chat UI URL anchor agent id | daemon
URL-anchor-not-query-string for auth | daemon
fragments not sent to server | daemon
token never appears in server logs | daemon
reuse-Familiar-bundle-script | daemon
no separate build system | daemon
parity between desktop and server deployments | daemon
minimal-daemon-side-change | daemon
add --addr flag and ENDO_GATEWAY_REMOTE | daemon
codification-as-Design-Decisions | daemon
deployment-shape Familiar Docker | daemon
deeplyFulfilled deep Promise.all for Passables | pass-style
DeeplyAwaited recursive type | pass-style
Simplify Callable DeeplyAwaitedObject types | pass-style
copied from @agoric/internal utils.js | pass-style
canonical-home-yet-to-be-resolved | pass-style
three failure modes reject never-settle not-Passable | pass-style
non-hardened-promise tolerance at top level | pass-style
isPromise checked before passStyleOf | pass-style
exemption-is-top-level-only | pass-style
unwrap promise to settlement dispense with promise | pass-style
seven-case switch on passStyle | pass-style
copyRecord recurse fromEntries harden | pass-style
copyArray recurse Promise.all harden | pass-style
byteArray pass through unchanged | pass-style
tagged recurse makeTagged tag payload | pass-style
remotable pass through leaf | pass-style
error pass through leaf | pass-style
promise E.when await and recurse | pass-style
key-status-deferred-to-patterns | pass-style
layering-discipline pass-style doesn't know Keys | pass-style
use-E.when-not-await for HandledPromise compat | pass-style
@ts-expect-error not assignable to DeeplyAwaited | pass-style
TypeScript-limitation acknowledged endo issue 1257 | pass-style
bridge between pass-style and eventual-send | pass-style
resolve embedded promises for fully-Passable marshal | pass-style
daemon-cas-management Content Address Store | daemon
Endor Content Address Store Management | daemon
content-addressable storage typed content | daemon
ContentStore Rust struct | daemon
supervisor-owned vs worker-owned CAS | daemon
shared resource accessed by all workers | daemon
GC requires handle-liveness knowledge | daemon
background thread GC routing loop | daemon
verbs-are-the-same-interface | daemon
embedded systems worker-role future alternative | daemon
four content types blob snapshot tree archive | daemon
sha256hex meta sidecar JSON | daemon
sidecar-not-database SQLite alternative | daemon
type field is advisory self-describing content | daemon
flat-entries-map tree representation | daemon
structural sharing between archives | daemon
stable hash via flat paths not nested | daemon
cas-store cas-fetch cas-has envelope verbs | daemon
cas-retain cas-release fire-and-forget | daemon
cas-store-tree recursive store | daemon
cas-gc control verb | daemon
streaming-variants cas-store-stream cas-content-stream | daemon
mark/sweep GC algorithm | daemon
reference-counting not tracing GC | daemon
hybrid ref-counting plus JS-manager-roots | daemon
new stores safe during GC refs zero | daemon
eventual-consistency-of-GC | daemon
off-thread GC std::thread spawn_blocking | daemon
RwLock HashMap in-memory ref count cache | daemon
flushed to .meta atomic write-rename | daemon
auto-retain hashes for suspended workers | daemon
endor gc CLI subcommand | daemon
five Design Decisions codify choices | daemon
supersedes JS-side daemon-content-store-gc | daemon
integrates with daemon-xs-worker-snapshot | daemon
extends daemon-endor-architecture | daemon
PASS_STYLE typed as string literal | pass-style
Symbol passStyle as nameable string type | pass-style
TS4023 TS9006 unique symbol declaration emit | pass-style
unique symbol nameable only via declaring module | pass-style
JS computed property keys accept any value | pass-style
typedArrayPrototype getter extraction at module load | pass-style
%TypedArray%.prototype @@toStringTag getter | pass-style
brand-check-via-getter | pass-style
isTypedArray duplicates make-hardener.js | pass-style
don't-depend-on-ses discipline | pass-style
isPrimitive adhoc set of type tests | pass-style
safer but slower on XS Object val box | pass-style
Beware not safe in the face of possible evolution | pass-style
isObject deprecated use not isPrimitive | pass-style
hasOwnPropertyOf deprecated use Object.hasOwn | pass-style
assertChecker deprecated use Fail rejector | pass-style
carry-forward-with-deprecation | pass-style
confirmOwnDataDescriptor four-condition check | pass-style
desc-or-undefined return shape both predicate and lookup | pass-style
makeConfirmTagRecord factory | pass-style
parameterize the proto-check only | pass-style
confirmTagRecord Object.prototype | pass-style
confirmFunctionTagRecord Function.prototype with subclass | pass-style
two-variants object-vs-function tag-record | pass-style
hideAndHardenFunction on predicates | pass-style
predicates-are-assertion-adjacent | pass-style
helper-root position imported by all pass-style files | pass-style
Turadg Aleahmad commit c05c9a88 | pass-style
familiar-app-ui-hosting partial sandbox | agent-conventions
Aaron prompted third attribution shape | agent-conventions
thin app-UI layer over weblet substrate | agent-conventions
UI manifest entry assets sandbox bridge | agent-conventions
readable-tree of static files | agent-conventions
sandbox tier isolated connected trusted | agent-conventions
isolated tier connect-src none no CapTP | agent-conventions
connected tier default CapTP only to own exo | agent-conventions
trusted tier author-declared origins surfaced at install | agent-conventions
tiers-widen-reach-never-relax-origin-isolation | agent-conventions
per-app unique origin invariant | agent-conventions
object-src none form-action self baseline | agent-conventions
UI bound to specific app exo not ambient authority | agent-conventions
exo-binding-rule CapTP bootstrap to instance | agent-conventions
run.powers from app handle | agent-conventions
two share-modes referenced cloned | agent-conventions
reference-vs-clone determines which exo | agent-conventions
referenced UI bridges to author's running exo | agent-conventions
cloned UI bridges to recipient's local exo | agent-conventions
ambient-authority-prevention at UI layer | agent-conventions
capabilities-not-configurations applied at UI layer | agent-conventions
MessagePort preferred no network surface | agent-conventions
WebSocket fallback for external browser | agent-conventions
chrome/guest barrier hard requirement | agent-conventions
host-chrome-not-guest-chrome | agent-conventions
close button pane title outside iframe | agent-conventions
app authors potentially untrusted third parties | agent-conventions
three-phase implementation manifest connected isolated trusted external | agent-conventions
user-surface trusted origins at install | agent-conventions
six dependencies weblet-server chat-weblet daemon-weblet localhttp endo-app-sharing milestone | agent-conventions
most-recent design ingested 2026-06-01 | agent-conventions
dot-membrane via marshal | marshal
makeDotMembraneKit target proxy revoke | marshal
mirror converter recursive setup | marshal
mineToYours WeakMap | marshal
yoursToMine destructured-under-mirror-side-names | marshal
convertMineToYours convertYoursToMine | marshal
myUnserialize yourUnserialize | marshal
pass passBack symmetric pair | marshal
serialize-and-then-unserialize-in-the-other-direction | marshal
every-mirror-name-is-the-other-direction | marshal
revocation by undefining the WeakMap | marshal
ReferenceError Revoked reasonString | marshal
two-step-revocation propagates to mirror | marshal
optInnerRevoke mirror revoke | marshal
mineIf vs mine GC-friendliness | marshal
correct error behavior may not enable mine to be gc'ed | marshal
two-level metaReason error handling | marshal
three-level fallback chain for promise crossing | marshal
Far functions have no static methods assumption | marshal
NOTE revisit if we change our minds | marshal
temporal-dead-zone hack | marshal
arrow-function-captures-the-binding-not-the-value | marshal
convertSlotToVal wraps convertYoursToMine | marshal
makeConverter mirror converter factory | marshal
crown jewel of @endo/marshal | marshal
membrane from serialization paired with itself | marshal
unforgeable revocable proxy primitive | marshal
ocap substrate composes into revocable proxy | marshal
revocable membrane capability primitive | marshal
Turadg Aleahmad commit ec42cb7b | marshal
formula inspector pop the bonnet | daemon
26 formula types | daemon
pet-name-hides-the-formula | daemon
rendered value vs richer formula structure | daemon
InspectorHub.lookup petName | daemon
makePetStoreInspector daemon.js 3210-3319 | daemon
formula type-specific metadata | daemon
eval lookup guest make-bundle make-unconfined peer | daemon
endowments source worker hub path NODE ADDRESSES | daemon
formula-references-as-clickable-links | daemon
formula-graph-as-hypertext | daemon
navigation-via-formula-identifiers | daemon
walk the formula graph node by node | daemon
edit-toggle-with-revise-API | daemon
read-only-default-edit-toggle-opt-in | daemon
E(agent).revise petName patch | daemon
revised-formula-identifier return | daemon
validation-on-revise discipline | daemon
worker field must reference valid worker formula | daemon
retention-path-reveal facility | daemon
every retention path in the formula graph | daemon
why-retention-paths-matter | daemon
removing last retention path GCs the formula | daemon
endo inspect name CLI command | daemon
two-surfaces-one-API discipline | daemon
host-level authority for revise | daemon
audit-trail-on-revise | daemon
inspection-vs-editing-security-asymmetry | daemon
three-affected-packages partition | daemon
thin-API-thick-UI principle | daemon
Not-Started-design-as-roadmap | daemon
existing-API-leverage observation | daemon
Maybe-prefix-on-tests discipline | daemon
E.js eventual-send user-facing surface | eventual-send
makeE HandledPromise factory | eventual-send
E(x).method() E(x)() E.get(x) E.resolve(x) E.sendOnly(x).method() E.when() | eventual-send
makeEProxyHandler makeESendOnlyProxyHandler makeEGetProxyHandler | eventual-send
baseFreezableProxyHandler four meta-traps return false | eventual-send
set isExtensible setPrototypeOf deleteProperty | eventual-send
return-false-not-throw preserves strict-mode invariants | eventual-send
this-receiver-check via concise-method-syntax | eventual-send
Unexpected receiver for method of E | eventual-send
prevents method-detach attacks | eventual-send
concise-method-syntax-not-arrow | eventual-send
avoid-function-syntax non-constructable | eventual-send
computed-property-key-preserves-name | eventual-send
ts-expect-error microsoft TypeScript 50319 | eventual-send
funcTarget objTarget freeze but not harden | eventual-send
freeze-not-harden discipline | eventual-send
preparing-for-stabilize.md reference | eventual-send
stabilize discipline | eventual-send
proxy target remains trapping | eventual-send
should not be shared outside this module | eventual-send
V8 Proxy short-circuits bypass meta-traps | eventual-send
onSend ENDO_SEND_BREAKPOINTS | eventual-send
shouldBreakpoint recipient propertyKey | eventual-send
placement-at-the-call-site vs at-delivery | eventual-send
LOOK UP THE STACK comment-as-debugger-instruction | eventual-send
zero-cost-when-unset short-circuit | eventual-send
SendOnly fire-and-forget returns undefined | eventual-send
applyMethodSendOnly applyFunctionSendOnly | eventual-send
throw-not-reject-in-SendOnly synchronous | eventual-send
or-Fail short-circuit | eventual-send
makeE callable-with-methods discipline | eventual-send
harden assign fn methods | eventual-send
five-surface api E.get E.resolve E.sendOnly E.when | eventual-send
E.when wraps trackTurns | eventual-send
has-trap-pretends-everything-exists | eventual-send
pretend everything exists | eventual-send
unknown-shape-of-remote | eventual-send
FarRef DataOnly ERef EReturn EResult | eventual-send
EAwaitedResult ECallableReturn ECallable EMethods EGetters | eventual-send
ESendOnlyCallable ESendOnlyMethods ESendOnlyCallableOrMethods ECallableOrMethods | eventual-send
FilteredKeys PickCallable RemoteFunctions LocalRecord | eventual-send
EPromiseKit EOnly | eventual-send
0 extends (1 & T) any-detector idiom | eventual-send
propagate any cleanly avoid distributive collapse | eventual-send
TypeScript 61838 generic callable return types | eventual-send
Turadg Aleahmad commit c88bc8311 | eventual-send
workers panel observability tool | daemon
workers are opaque | daemon
which worker processes running | daemon
what capabilities tenanted in each worker | daemon
resource consumption logs metrics correlation | daemon
five-feature panel sparkline tenants retention logs correlated | daemon
event-loop-latency sparkline | daemon
setTimeout(0) probe scheduling delay | daemon
single most informative metric for single-threaded JS worker | daemon
green<10ms yellow<100ms red>100ms thresholds | daemon
threshold-as-product-discipline | daemon
1-second default probe interval | daemon
60 samples per minute | daemon
configurable probe interval | daemon
followMetrics async iterator | daemon
timestamp eventLoopLatencyMs | daemon
iterator-not-event-bus shape | daemon
tenant capabilities reverse lookup | daemon
worker field eval make-bundle make-unconfined | daemon
existing-GC-graph-as-tenant-source | daemon
listWorkerTenants petName formulaType | daemon
reuse graph.js for retention path | daemon
union-find and reachability analysis | daemon
retentionPath name formulaType array | daemon
why-is-this-worker-alive question | daemon
trace from worker back to GC roots | daemon
PINS directory agent pet stores | daemon
followWorkerLog filtered async iterator | daemon
per-worker log filtering | daemon
existing-infrastructure-needs-surfacing | daemon
correlated view shared X-axis time | daemon
top-lane sparkline bottom-lane log entries | daemon
click-spike-to-find-log affordance | daemon
flame-graph-without-the-flame idiom | daemon
discrete-events-as-markers-on-continuous-axis | daemon
endo workers list command | tooling
endo worker name logs metrics tenants | tooling
subcommand-flag-shape | tooling
three-affected-packages partition | daemon
thin-API-thick-UI principle | daemon
sparkline fixed-size ring buffer 60 samples | chat-ui
observability-without-unbounded-state | daemon
incremental-update-not-recompute retention cache | daemon
pre-compute-the-reverse-edge tenant index | daemon
host-level only observability | daemon
inspection-not-control invariant | daemon
observability-vs-guest-isolation tension | daemon
host-as-debugger guest-as-debuggee asymmetry | daemon
graceful-degradation upgrade discipline | daemon
process-behavior-changes-not-schema | daemon
no data instead of sparkline | chat-ui
log entries without worker tags filtered out | daemon
worker.js main probe entry point | daemon
graph.js union-find for GC | daemon
types.d.ts worker formula type | daemon
Kris Kowal prompted | daemon
workers panel sister to formula-inspector | daemon
daemon observability pair | daemon
passable symbols Hilbert-Hotel encoding | pass-style
Hilbert Hotel encoding technique | pass-style
well known symbols registered symbols | pass-style
Symbol.for Symbol.keyFor | pass-style
wellKnownSymbolNames Map | pass-style
ownKeys(Symbol) at module load | pass-style
identity-keyed Map for symbol singletons | pass-style
@@ prefix convention | pass-style
@@iterator @@toStringTag well-known wire form | pass-style
@@@@ double prefix for shifted registered | pass-style
nameForPassableSymbol three-case decoder | pass-style
passableSymbolForName three-case parser | pass-style
isPassableSymbol predicate | pass-style
assertPassableSymbol throws | pass-style
unpassableSymbolForName Symbol(name) escape hatch | pass-style
AtAtPrefixPattern regex frozen constant | pass-style
forward-compatibility-via-throw discipline | pass-style
future well-known symbol throws on decode | pass-style
Reserved for well known symbol error | pass-style
throw-rather-than-lose-identity | pass-style
break equality across realm upgrades | pass-style
fail-at-load-not-at-use precondition | pass-style
host-platform invariant gate | pass-style
no well-known symbol name starts with @@ | pass-style
two encoding spaces disjoint | pass-style
two-kinds-of-passable-symbols | pass-style
anonymous Symbol(description) excluded | pass-style
hideAndHardenFunction only on assertion | pass-style
hide-only-assertion-functions discipline | pass-style
symbol-passability-as-pass-style-leaf | pass-style
identity-vs-description-as-substrate | pass-style
well-known symbol identity is its role | pass-style
registered symbol identity is registry string | pass-style
anonymous symbol identity is allocation moment | pass-style
Kris Kowal coordinated-update commit e56bf00f | pass-style
unhandled rejection display CapTP disconnect | daemon
CTP_DISCONNECT.reason carrying Error encodes as empty curly | captp
JSON.stringify drops non-enumerable Error properties | errors
name message stack non-enumerable | errors
defaultOnReject prints empty braces | captp
socket has been ended race vs assert.fail | daemon
two-coordinated-changes discipline | captp
either part alone insufficient | captp
sender side preserves Error structure no good without receiver fix | captp
smarter receiver display has nothing to display without wire structure | captp
@@error sentinel | captp
@@error: true marker | captp
sentinel-not-duck-typing | captp
messageToBytes narrow guard | captp
CTP_DISCONNECT cold path vs CTP_CALL hot path | captp
narrow-guard-keeps-out-of-hot-path | captp
three-property-extraction name message stack | errors
renderRejection helper | captp
four-case-fallback ladder | captp
real Error reconstructed name colon message backslash-n stack | errors
@@error sentinel reconstructed | errors
passable isPassable passableAsJustin | marshal
non-passable parens type prefix | errors
passableAsJustin not JSON.stringify | errors
project-standard rendering for diagnostic display | errors
CLAUDE.md Diagnostic Discipline rule | errors
use-marshal-for-display-not-wire | errors
marshal-for-display one-way read-only | marshal
error-path-cannot-depend-on-error-path | captp
diagnostic paths must not depend on substrate they diagnose | captp
disconnect path runs when connection state is unreliable | captp
marshal tables may have been GC'd | captp
c-list may be partially torn down | captp
disconnect may be happening because marshal itself failed | captp
extraction-is-intentionally-syntactic | captp
no method dispatch no proxy traps no table lookups no exo invocation | captp
cannot fail mid-disconnect | captp
narrow-guard-not-tree-walk | errors
JSON replacer over-applies tree-walks | errors
two-different-error-encodings-must-coexist | captp
@@error plain shape vs marshal errorIdNum | errors
you-cant-fix-it-on-receiver-because-bytes-are-lost | captp
information-theoretic constraint forces two-coordinated structure | captp
peer-compatibility-during-rollout | captp
Justin language needs parser on receiver | errors
wire-incompatible with non-upgraded peers | captp
strictly-additive design | captp
progressive-rollout-without-flag-day | captp
helper-lives-next-to-encoder | captp
wire-and-display-as-conjugate-sides | captp
future-portability gesture to @endo/captp | captp
defaultOnReject has same bug for captp consumers | captp
three-day-active-development calibration | captp
roadmap-calibration-via-git-blame | captp
PR #187 squash-merge a588f0b80 | captp
parallel non-bot 74a56009a | captp
migration-without-caller-change | captp
strictly-additive-on-receiver-side | captp
three-open-questions honest-deferral | captp
@@error vs marshal errorIdNum question | errors
lift renderRejection to @endo/captp question | captp
plain shape vs CapData blob question | captp
issue 171 PR 174 repro test | captp
formatRejectionReason in daemon.js | captp
Kris Kowal prompted designer dispatch | captp
typeGuards.js user-facing type-guard surface | pass-style
isCopyArray isByteArray isRecord isRemotable | pass-style
assertCopyArray assertByteArray assertRecord assertRemotable | pass-style
isAtom assertAtom predicates | pass-style
Atom passable-leaf subset | pass-style
eight AtomStyle cases | pass-style
undefined null boolean number bigint string byteArray symbol | pass-style
atoms without composition or identity | pass-style
marshal-table-free Atom property | pass-style
all-predicates-and-assertions-hide-name | pass-style
hideAndHardenFunction on every export | pass-style
departure from hide-only-assertions pattern | pass-style
user-facing-thin-wrapper rationale | pass-style
wrapper-identity-irrelevant in stack traces | pass-style
confirmAtom private with Rejector | pass-style
two-level-rejection discipline | pass-style
Not even Passable error prefix | pass-style
A passStyle cannot be an atom error | pass-style
two-different-error-prefixes-discriminate-cause | pass-style
Alleged array record byteArray remotable default name | pass-style
default-name-for-anonymous-throw | pass-style
no-memo-for-Atom cheap check | pass-style
thin-wrappers-over-passStyleOf | pass-style
minimal-dependency-surface | pass-style
bottom of @endo dependency stack | pass-style
ninth pass-style file in cluster | pass-style
Mark S. Miller authored 2025-09-15 | pass-style
cycle 150 milestone tick | pass-style
app-sharing milestone three pillars | daemon
milestone-not-bucket discipline | daemon
end-to-end make a thing send it run it | daemon
distribute chat app downloadable | daemon
connect to peers deep-link URL | daemon
endo:// deep link scheme | daemon
make and share runnable apps | daemon
cloneable apps remote-reference vs independent copy | daemon
three-pillars distributable peer-deep-link runnable-apps | daemon
verified-current-state methodology | daemon
audit-before-spec discipline | daemon
file-path-and-PR-citation density | daemon
live map of codebase and tracker | daemon
Pillar-1-adopts-familiar-release.md | daemon
adopt-existing-plan-don't-compete-with-it | daemon
two-designs-must-not-define-the-same-thing-twice | daemon
named-deferral move | daemon
macOS-arm64-first MVR scope | daemon
maintainer-platform-first ordering | daemon
G1-G16 sixteen gaps catalog | daemon
swarm-of-G-item-PRs | daemon
familiar-release.md PR 231 | daemon
host.invite host.accept locator | daemon
localhttp template for endo:// scheme | daemon
template-for-the-missing-piece | daemon
similar-shape-as-precedent | daemon
make-from-tree formula | daemon
endo-fs FsBackend seam | daemon
readable-tree readable-blob formulas | daemon
endo checkin endo checkout | daemon
app handle bundling source exec UI | daemon
cross-daemon clone | daemon
streamed tree-archive durable backing | daemon
familiar-deep-link-invitations | daemon
endo-app-sharing | daemon
familiar-unified-weblet-server | daemon
familiar-chat-weblet-hosting | daemon
daemon-weblet-application | daemon
reconcile-don't-duplicate posture | daemon
parallel-substrate-acknowledgment | daemon
familiar-run-apps-vfs PR 241 | daemon
exo-zip exo-unzip PR 160 | daemon
exo-stream PR 330 | daemon
daemon git-tree archive PR 367 | daemon
four-phase plan P0 P1 P2 P3 | daemon
exit-criterion-per-phase | daemon
user-flow-as-completion-gate | daemon
P3-honors-cloneable-policy | daemon
transport-handles-integrity | daemon
OCapN-Noise provides integrity | daemon
one-paragraph-Exit-Criterion | daemon
genuinely-net-new-vs-substrate distinction | daemon
minimize-new-work-maximize-leverage | daemon
raw-doc-URLs-not-durable caveat | daemon
two-anchor-policy PR durable | daemon
coordination-doc-as-graph-edge role | daemon
milestone-as-clustering-event | daemon
Aaron-authored-pair Pillar 3 | daemon
three distinct attribution shapes | daemon
memo-race memoRace memory-safe Promise.race | eventual-send
native Promise.race memory leak | eventual-send
never-settling inputs pin race result | eventual-send
Brian Kim 2017 nodejs node 17469 | eventual-send
public-domain Unlicense | eventual-send
knownPromises WeakMap | eventual-send
PromiseMemoRecord settled deferreds | eventual-send
WeakMap-shared-deferred-sets architecture | eventual-send
one-then-per-value-lifetime invariant | eventual-send
shared-record-across-races | eventual-send
amortize-one-then-across-many-races | eventual-send
broadcast-pattern-via-shared-set | eventual-send
markSettled atomic-transition | eventual-send
state-machine-with-frozen-terminal-state | eventual-send
idempotent markSettled | eventual-send
primitive-fake-settled-record | eventual-send
isPrimitive duplicated layering-constraints | eventual-send
layering-constraints-block-DRY | eventual-send
finally-as-cleanup-hook | eventual-send
deferred removed from pending Set | eventual-send
result no longer pinned after cleanup | eventual-send
cachedValues defends iterable-might-not-be-rerunnable | eventual-send
this-as-PromiseConstructor subclassable | eventual-send
named-function-via-object-destructure | eventual-send
method-syntax-non-constructable | eventual-send
first promise-kit source file ingested | eventual-send
ci-no-npm-lifecycle supply-chain defense | tooling
GitHub Actions runner attack surface | tooling
malicious postinstall in transitive dependency | tooling
lifecycle scripts run before source audit | tooling
event-stream ua-parser-js node-ipc XZ typosquatting | tooling
preinstall postinstall install prepare prepack postpack | tooling
three-concerns supply-chain reproducibility correctness | tooling
multiple-independent-justifications discipline | tooling
existing-posture-at-rest audit | tooling
enableScripts false yarnrc.yml | tooling
@lavamoat/preinstall-always-fail | tooling
@lavamoat/allow-scripts | tooling
@ipshipyard/node-datachannel better-sqlite3 native addons | tooling
dependenciesMeta built | tooling
pin-the-posture-don't-invent-it framing | tooling
light-migration property | tooling
three-layer-auditable defense | tooling
Config Allowlist Named-step layers | tooling
each-layer-can-fail-without-catastrophic-loss | tooling
defense-in-depth-against-three-different-mistakes | tooling
belt-and-suspenders env mechanism | tooling
YARN_ENABLE_SCRIPTS=false | tooling
npm_config_ignore_scripts=true | tooling
reviewer-visible-defense | tooling
explicit-named-step-not-implicit-side-effect | tooling
observability-through-explicitness | tooling
yarn install --immutable | tooling
lockfile-immutability-as-supply-chain-defense | tooling
yarn allow-scripts run named step | tooling
narrow-allowlist-for-legitimate-exceptions | tooling
named-list-not-pattern-match | tooling
enumerate-every-workflow discipline | tooling
every-build-already-explicit observation | tooling
workspace-prepack scripts handling | tooling
don't-rename-don't-touch-existing-mechanisms-just-control-call-sites | tooling
control-the-call-not-the-callee | tooling
two-layer enforcement | tooling
check-no-ci-lifecycle.mjs repo-level lint | tooling
check-action-pins parallel CI job | tooling
canary-package-fails-loud | tooling
five Design Decisions for CI security | tooling
16-day calendar window | tooling
design-burst-then-queue-wait | tooling
calendar-time-vs-active-time distinction | tooling
batch-of-seven-proposals same day | tooling
self-contained-by-construction | tooling
PR 126 ddbc8ad7e | tooling
master-base mirror PR 250 | tooling
trap.js Trap synchronous CapTP proxy | captp
Lifted mostly from @endo/eventual-send/src/E.js | captp
sibling-via-lifting relationship | captp
shared-shape-different-semantics | captp
synchronous-blocking vs eventual-send | captp
three-method TrapImpl applyFunction applyMethod get | captp
nearTrapImpl default local fast-path | captp
TrapProxyHandler arrow function | captp
narrowed-API-for-narrower-semantics | captp
no-this-receiver-check | captp
arrow-function-is-already-detach-safe | captp
baseFreezableProxyHandler identical to E.js | captp
funcTarget objTarget freeze-not-harden | captp
verbatim-comment-shared-across-derived-files | captp
code-reuse-via-duplication-not-via-shared-import | captp
preserves package independence | captp
local-fast-path-via-trivial-impl | captp
minimal-trampoline form | captp
makeTrap factory callable-with-methods | captp
Trap function plus .get property | captp
simpler-shape-because-fewer-methods | captp
has-trap with honest TODO | captp
has property not yet transferrable over captp | captp
honest-acknowledgment-of-API-gap | captp
cite-the-missing-feature naming | captp
first captp source file ingested | captp
SharedArrayBuffer Atomics.wait substrate | captp
synchronous-CapTP via Atomics | captp
captp cluster six source files | captp
daemon-rename-to-manager rename design | daemon
Daemon Manager rename | daemon
MignonicPowers WorkerPowers rename | daemon
mignonic small dainty subordinate | daemon
ManagerMode ENDO_MANAGER_NODE | daemon
Rust-already-calls-it-manager precedent | daemon
JS-not-the-daemon observation | daemon
asymmetric-vocabulary-across-boundary | daemon
namer procedure roles/namer.md | daemon
Laws 0 1 2 naming discipline | daemon
antonym dual pair coherence | daemon
verdict-line per candidate | daemon
methodology-not-just-decision | daemon
namer-procedure-applied-with-citations | daemon
pair-coherence-matters | daemon
Daemon Worker fractured Manager Worker symmetric | daemon
forbidden-synonym argument | daemon
two-names-for-one-thing-is-the-forbidden-synonym | daemon
existing-name-wins-the-tie tiebreaker | daemon
opaque-metaphor-to-non-native-readers | daemon
prompt-author's-spelling-correction | daemon
verify-the-prompt-before-acting | daemon
coinage-was-defensive-no-longer-needed | daemon
Daemonic collapses to Manager | daemon
what-stays section negative space | daemon
scope-boundary-explicit | daemon
user-facing-prose-untouched | daemon
three-phased rename Phase 1 2 3 | daemon
minimum-disruptive-PR-boundary | daemon
phase-1-safest-review-rationale | daemon
big-churn-but-easy-review | daemon
git-mv-preserves-blame | daemon
exhaustive-mechanical-inventory | daemon
grep-recipe-as-source-of-truth | daemon
wire-protocol-coordination-window | daemon
coordinated-rename-because-coordinated-deployment | daemon
atomic-rename-when-deployment-is-atomic | daemon
no-deprecated-alias-kept | daemon
search-confirms-rename-is-outright-cut | daemon
evidence-based-deprecation-decision | daemon
absence-of-consumers-means-no-deprecation | daemon
package-name-stays | daemon
inside-vs-outside-the-name-boundary | daemon
nested-naming-scopes | daemon
don't-retroactively-edit-older-designs | daemon
sweep-only-new-prose | daemon
don't-rewrite-history norm | daemon
finalize.js Weak-Value-Map | captp
makeFinalizingMap finalizer opts | captp
WeakRef FinalizationRegistry | captp
weak-on-values-not-on-keys | captp
multi-map-coordinated-removal | captp
gc-as-side-channel warning | captp
dangerous capability must be closely held | captp
timing-independent-side-channel | captp
blockchain-replay hazard | captp
nondeterminism-breaks-consensus | captp
validators differ from each other | captp
gc-as-consensus-blocker | captp
primitive-exists-but-must-not-be-used-in-some-contexts | captp
two-mode design weakValues opt-in | captp
graceful-fallback-via-fakeFinalizingMap | captp
honest-tagging-when-degraded | captp
dangerous-mode-not-default | captp
unified-finalize-path gc delete set | captp
unregister-immediately-suppresses-finalization | captp
honest-acknowledgment-of-spec-uncertainty | captp
JS-standards-WeakRef-end-of-turn-stability | captp
method-by-method derefing classification | captp
has-must-deref-or-it-lies | captp
getSize-may-lie | captp
atomicity-within-a-turn-via-deref | captp
replace-finalizes-old | captp
!isPrimitive ref assert | captp
clearWithoutFinalizing-exempt | captp
teardown-bypass | captp
TODO-with-issue-link endo#1514 | captp
Far-as-the-protective-wrapper | captp
RemotableBrand-typing | captp
second @endo/captp source file ingested | captp
papers-lane blocked 50 cycles milestone | captp
exo-zip-package design | exo
makeExoZip in-memory ZIP | exo
@endo/exo-zip new package | exo
ReadableTree exo over CapTP | exo
PR #128 inline review comment | exo
design-as-formalized-review-comment | exo
inline-comment-becomes-traceable-design | exo
extractZipToTemp anti-pattern | exo
three-costs tmpdir doubled-IO conflated-concerns | exo
enumerate-the-costs methodology | exo
show-the-collapse before-after pattern | exo
asymmetric-by-design read/write API | exo
asymmetry-is-real-and-load-bearing | exo
write-side-no-WritableTree-interface | exo
don't-invent-WritableTree-just-for-symmetry | exo
inline-is-fine-until-multiple-uses | exo
wait-for-second-consumer-before-extracting-a-helper | exo
authority-trail review citation | exo
eight Design Decisions three Resolved Questions | exo
resolved-questions-not-open-questions | exo
captured-resolution-trail | exo
three-step-design-lifecycle | exo
pure-ECMAScript-no-Node-builtins | exo
portability-as-constraint | exo
lazy-materialisation discipline | exo
grouping-pass-produces-child-factories | exo
amortize-allocation-over-lookups | exo
hostile-input-rejection-at-construction | exo
fail-fast-at-construction | exo
security-check-at-the-entry-point | exo
reuse-platform-interface-not-daemon-interface | exo
ReadableTreeInterface vs EndoReadableTree | exo
minimal-interface-conformance-keeps-dependencies-narrow | exo
which-side-of-CapTP-determines-the-interface | exo
single-chunk-streamBase64 acceptable | exo
no-API-change-needed-for-future-chunking | exo
forward-compatible-by-iterator-shape | exo
Uint8Array-not-stream input | exo
defer-streaming-zip-until-seekable-stream-exists | exo
seekable-stream concept | exo
three-constraint-combination | exo
future-compatibility-via-overload | exo
separate-package-not-sibling-export | exo
package-cleanliness-as-design-constraint | exo
don't-pollute-a-clean-package | exo
Uint8Array-not-Buffer | exo
reshape-blocker-for-PR-128 | exo
design-documents-its-downstream-impact | exo
three-phase-implementation S-sized-phases | exo
ZipReader central directory | exo
ReadableBlobInterface streamBase64 text json | exo
PR 160 exo-zip exo-unzip | exo
loopback.js makeLoopback async-isolated channel | captp
in-process CapTP test fixture | captp
two-CapTP-instances-cross-wired | captp
forward-reference-via-arrow | captp
closure-captures-binding-not-value | captp
eslint-as-design-discipline | captp
eslint-disable-no-use-before-define | captp
single-bootstrap-shared-by-both-sides | captp
Far refGetter getRef nonce | captp
getRef-also-deletes use-once-then-remove | captp
nonce-as-handshake-key | captp
makeRefMaker closure factory | captp
two-callers-one-pattern-via-closure | captp
makeFar makeNear async | captp
uniform-async-shape | captp
harden-the-value-before-set | captp
uses-finalize.js-Weak-Value-Map | captp
plain-Map-via-fakeFinalizingMap branch | captp
test-utility-doesn't-want-gc-nondeterminism | captp
synchronous-trap-bridge via trapGuest | captp
sync-trap-by-crossing-the-boundary-immediately | captp
use-the-far-side's-marshal-functions | captp
trap-bypasses-the-async-protocol | captp
isException-tagged-tuple-result | captp
tagged-tuple-because-no-Promise-rejection-channel | captp
slotBody-hardcoded canonical-marshal-string | captp
@qclass slot index 0 | captp
which-side's-marshal-tables-do-we-use | captp
marshal-side-tracks-object-ownership | captp
re-export-E-from-captp convenience | captp
single-entry-point-for-test-fixtures | captp
test-utility-composes-substrate | captp
distributed-protocol-test-fixture-as-genre | captp
third @endo/captp source file ingested | captp
17-file coordinated-update cluster | captp
daemon-debug-worker-restart design | daemon
debugWorker pet name | daemon
restart worker from snapshot with debugger active | daemon
too-late-by-the-time-debugger-attaches | daemon
hot-attach vs cold-attach debugger | daemon
XS engine paused before any code | daemon
breakpoints set before any code runs | daemon
three-invariants | daemon
enumerate-the-invariants pattern | daemon
user-facing-one-method | daemon
XS <login> break | daemon
pause-by-default-explicit-resume | daemon
compose-existing-not-invent-new | daemon
don't-invent-restart-as-a-concept | daemon
preserve-identity-across-snapshot | daemon
two-approaches-considered | daemon
debug-flag-plus-normal-resume | daemon
minimize-protocol-additions | daemon
flag-set-before-action-not-action-with-flag | daemon
fire-and-forget-control-verb nonce 0 | daemon
debug_flags HashSet Handle | daemon
take_debug_flag atomic remove | daemon
one-shot-flag-not-persistent | daemon
opt-in-per-resume | daemon
six-step JS manager implementation | daemon
inbox-as-resume-trigger | daemon
opportunistic-shortcut | daemon
debug-ping no-op message | daemon
XS-debug-loop-fires-at-machine-creation | daemon
earliest-possible-break | daemon
metering-survives-debug-restart | daemon
debug-doesn't-grant-unlimited-computation | daemon
existing-mechanism-handles-escape-hatch | daemon
meterSetQuota hard_limit 0 | daemon
escape-hatch-exists-elsewhere | daemon
CapTP-connections-broken acceptance | daemon
accept-the-cost-because-developer-tool | daemon
don't-build-the-proxy-layer-for-now | daemon
user's-perspective-not-implementation-detail | daemon
debugWorker not restartWorkerInDebugMode | daemon
five Design Decisions coherent-shape | daemon
phased-with-tests pattern | daemon
thin-layer-on-thick-substrate | daemon
runtime-introspection-duo with cycles 145+147 | daemon
marshal-stringify.js JSON-equivalent | marshal
pure-data Passable serialization | marshal
stringify parse symmetric to JSON | marshal
pure-data-version-of-marshal | marshal
badArray-Proxy-traps-on-slot-access | marshal
loud-failure-when-input-violates-contract | marshal
badArrayHandler get throws | marshal
length-returns-zero-everything-else-throws | marshal
refuse-converter-as-explicit-config | marshal
three-layered-defense | marshal
each-layer-has-its-own-error-message | marshal
freeze-but-not-harden-the-target | marshal
stabilize-discipline | marshal
verbatim-comment-shared-across-derived-files | marshal
triple-stabilize-citation in this file | marshal
stringify-discards-the-empty-slots-array | marshal
symmetric-API-via-asymmetric-bodies | marshal
parse-passes-freeze-with-badArray-slots | marshal
every-mention-cites-the-rationale | marshal
capdata-not-smallcaps | marshal
legacy-format-pinned-with-TODO | marshal
upgrade-blocked-on-test-rewrite | marshal
honest-TODO-not-silent-pin | marshal
errorTagging-off configuration | marshal
round-trip-identity not logically-equivalent-with-new-tag | marshal
throw-is-noop-since-Fail-throws | marshal
linter-noise-as-documentation | marshal
same-substrate-three-API-faces | marshal
three-faces-of-marshal full membrane stringify | marshal
sixth @endo/marshal source file ingested | marshal
cycle 160 milestone tick | marshal
25 cycles of design+comment alternation | marshal
18-file coordinated-update cluster | marshal
filesystem-watchers EndoMount followNameChanges | daemon
EndoDirectory vs EndoMount parity gap | daemon
surface-parity mechanism-parity | daemon
fs.watch rename events | daemon
stat-reconciled-rename-events | daemon
direction-agnostic OS notification | daemon
in-memory-set-as-truth pattern | daemon
editor-save-dance-coalescing | daemon
50ms debounce | daemon
bookkeeping-over-in-memory-entry-set-not-timer-per-event | daemon
FilePowers.watchDirectory primitive | daemon
FilePowers-extension-not-reach-into-Node | daemon
minimal-platform-seam discipline | daemon
platform-agnostic-body | daemon
polling-fallback-inside-FilePowers | daemon
MountNameChange vs PetStoreNameChange | daemon
interface-asymmetry-tracks-ownership-asymmetry | daemon
discriminant-stable-additional-fields-vary | daemon
subscription-bound-to-path-not-name | daemon
matches-EndoDirectory-semantics | daemon
try-finally-is-load-bearing | daemon
iterator-return-as-cleanup-trigger | daemon
async-generator-finally-is-the-cleanup-hook | daemon
remote-cleanup-via-CapTP-propagates-to-finally | daemon
confinement-flows-through-unchanged | daemon
silent-drop-not-error | daemon
four-alternatives-considered polling chokidar inotify watchFile | daemon
three-of-four-deferred | daemon
defer-with-named-trigger | daemon
50KB-dependency-for-thin-daemon | daemon
punt-platform-bindings-to-rust-port | daemon
wait-for-the-natural-home | daemon
captured-resolution-trail filesystem-watchers | daemon
parity-first-then-extend | daemon
test-by-absence-of-events | daemon
absence-test-via-bounded-timeout | daemon
external-mount-parity test | daemon
sibling-design-already-dispatched | daemon
NameHub-interface-unification open question | daemon
runtime-cleanup-pairs-with-GC | daemon
parity-as-design-axiom | daemon
minimized-to-what-the-new-substrate-strictly-requires | daemon
three-design-sources-lifecycle | daemon
Issue 110 source | daemon
MetaMask ocap-kernel monorepo | daemon
ocap-kernel reference shelf entry | daemon
sibling-implementation-comparison genre | daemon
reference-for-future-work | daemon
reference-not-substrate stance | daemon
Chip Morningstar agentmask service discovery | daemon
SwingSet-derived kernel-vat architecture | daemon
30 packages 6 docs monorepo | daemon
Ken protocol HPL-2010-155 | daemon
Output-Valid Rollback-Recovery | daemon
Kelly Karp Stiegler Close Cho | daemon
exactly-once delivery FIFO | daemon
output validity transactional turns | daemon
consistent frontier local recovery | daemon
sender-based message logging | daemon
deferred transmission cumulative ACK | daemon
named-protocol-as-acceptance-criterion | daemon
self-assessment-against-named-protocol | daemon
crank-buffering atomic-output-or-rollback | daemon
CrankBuffer enqueueSend enqueueNotify | daemon
database savepoint transactional crank | daemon
kref vref rref eref four-layer name-space | daemon
canonical-vocabulary survey | daemon
kernel manager vats distributed objects | daemon
vat unit of compute | daemon
baggage persistent key-value storage | daemon
bootstrap vat root object | daemon
exo makeDefaultExo @metamask/kernel-utils/exo | daemon
forbid-direct-Far in favor of makeDefaultExo wrapper | daemon
endowment capability | daemon
kernel service registerKernelServiceObject | daemon
VatSupervisor VatHandle | daemon
KernelQueue KernelRouter KernelServiceManager | daemon
SubclusterManager system subcluster | daemon
clist capability list bidirectional mapping | daemon
channel BaseDuplexStream | daemon
stream remote async iterator @endo/stream lineage | daemon
subcluster ClusterConfig | daemon
run queue crank one item per | daemon
ocap-kernel garbage collection mutually independent | daemon
revocation revoke kref | daemon
@metamask/superstruct runtime type checking | daemon
type-not-interface TypeScript discipline | daemon
never-enum string literal unions | daemon
public-private-namespace-split @metamask/ @ocap/ | daemon
queued-for-future-cycles ingestion plan | daemon
ken-protocol-assessment.md doc | daemon
kernel-guide.md doc | daemon
identity-backup-recovery BIP39 mnemonic | daemon
platform-specific.md Node browser split | daemon
kernel-store SQLite WASM | daemon
streams package SES-compatible | daemon
remote-iterables Remotable iterable objects | daemon
llm-bridge Unix-socket IOChannel | daemon
service-matcher service-discovery-types | daemon
kernel-test kernel-test-local | daemon
omnium-gatherum miscellaneous collection | daemon
ocap-kernel HEAD a3eff0efb 2026-05-28 | daemon
user-directed manual ingest | daemon
between cycles 161 162 | daemon
does not consume autonomous lane-rotation slot | daemon
Ken protocol HPL-2010-155 Kelly Karp Stiegler Close Cho | daemon, captp, persistence
seven Ken properties exactly-once delivery output validity transactional turns | daemon, captp, persistence
consistent frontier local recovery sender-based message logging deferred transmission | daemon, captp, persistence
output-valid rollback recovery | daemon, captp, persistence
canonical-protocol-citation | daemon, captp, persistence
named-protocol-as-acceptance-criterion | daemon, captp, persistence
completion-claim-against-named-protocol | daemon, captp, persistence
twelve-row self-assessment table | daemon, captp, persistence
each-property-points-at-a-named-implementation-artifact | daemon, captp, persistence
issue-numbers-anchor-the-claims | daemon, captp, persistence
verifiable-provenance-not-just-assertion | daemon, captp, persistence
crank buffering Issue #786 | daemon, captp, persistence
enqueueSend enqueueNotify resolvePromises immediate=false | daemon, captp, persistence
flushCrankBuffer | daemon, captp, persistence
default-safe-default-deferred | daemon, captp, persistence
run-queue-as-the-commit-fence | daemon, captp, persistence
RemoteHandle remotePending | daemon, captp, persistence
don't-conflate-the-two-persistence-purposes | daemon, captp, persistence
same-table-two-invariants | daemon, captp, persistence
output validity at-least-once retransmit | daemon, captp, persistence
SQLite savepoint as checkpoint mechanism | daemon, captp, persistence
kernel-store savepoint wrap | daemon, captp, persistence
receive-side savepoint-wrapped processing Issue #808 | daemon, captp, persistence
savepoint-with-named-rollback-on-throw | daemon, captp, persistence
deterministic-savepoint-name | daemon, captp, persistence
receive_${remoteId}_${seq} | daemon, captp, persistence
revert-in-memory-state-too-not-just-the-database | daemon, captp, persistence
highestReceivedSeq | daemon, captp, persistence
duplicate-detection-via-seq-comparison | daemon, captp, persistence
guard-on-seq-comparison-not-Set-lookup | daemon, captp, persistence
high-water-mark-discipline | daemon, captp, persistence
FIFO-via-TCP-not-receive-side-reordering | daemon, captp, persistence
borrow-FIFO-from-the-transport | daemon, captp, persistence
libp2p streams in-order delivery | daemon, captp, persistence
don't-reinvent-the-FIFO | daemon, captp, persistence
post-crash-out-of-order-handled-by-dedup | daemon, captp, persistence
all-Ken-protocol-properties-are-now-implemented | daemon, captp, persistence
confident-completion-claim posture | daemon, captp, persistence
Ken-turn-model code block | daemon, captp, persistence
atomic-checkpoint-before-transmit | daemon, captp, persistence
checkpoint-includes-output-queue | daemon, captp, persistence
Done-table-tracks-processed-to-completion | daemon, captp, persistence
gap-revealing-comparison cycles 119 137 149 100 156 141 | daemon, captp, persistence
synthesis-target adopt-vocabulary-not-implementation | daemon, captp, persistence
Stiegler-name observation Mark Stiegler five Ken authors | daemon, captp, persistence
HPL-2006-116 OCPL Stiegler 2006 cycle 94 | daemon, captp, persistence
Waterken Java implementation | daemon, captp, persistence
Ken project U Michigan Tom Kelly | daemon, captp, persistence
queued-doc-1 from cycle 161 overview | daemon, captp, persistence
queued-doc-2 from cycle 161 overview | daemon, captp, capability-security
authoritative-vocabulary-surface | daemon, captp, capability-security
runnable-glossary-not-frozen-prose | daemon, captp, capability-security
each-entry-links-to-a-source-file | daemon, captp, capability-security
every-term-is-a-pointer-to-code | daemon, captp, capability-security
verifiable-provenance-not-just-glossary | daemon, captp, capability-security
naming-convention-as-organizing-principle | daemon, captp, capability-security
glossary.md two-axis structure Concepts Abbreviations | daemon, captp, capability-security
kref kernel-globally-unique generated-on-first-crossing | daemon, captp
vref vat-locally-unique either-side-can-generate | daemon, captp
rref channel-scope does-not-survive-the-channel | daemon, captp
eref vref rref union polymorphic-over-locality | daemon, captp
location-transparency-at-the-type-level | daemon, captp
scoped-lifetime channels ephemeral-namespaces | daemon, captp
clist bidirectional channel-runtime mapping per-channel | daemon, captp
trade-off-named four-layer scoping vs one-layer formula-identifier | daemon, captp
vocabulary-drift-where-substrate-is-shared | daemon, captp
channel stream connection vocabulary | daemon, captp
exo prescriptive Do not use Far from endo/far | daemon, capability-security
forbid-direct-Far canonical-doc promotion | daemon, capability-security
wrap-not-bypass discipline | daemon, capability-security
makeDefaultExo only blessed remotable constructor | daemon, capability-security
wrap-gives-a-bottleneck-for-audit | daemon, capability-security
endowment callable-but-attenuated | daemon, capability-security
security-as-attenuation-not-removal | daemon, capability-security
preserve-shape-mutate-semantics | daemon, capability-security
per-vat-timer-queues attenuation | daemon, capability-security
monotonically-clamped Date.now() attenuation | daemon, capability-security
timer-as-side-channel clock-as-side-channel | daemon, capability-security
determinism-by-clamping | daemon, capability-security
compartments-expose-nothing-by-default | daemon, capability-security
explicit-globals-via-VatConfig | daemon, capability-security
capability-shape-discipline-applied-to-host-endowments | daemon, capability-security
three-independent-GC-systems kernel liveslots JavaScript | daemon, capability-security
don't-conflate-GC-domains | daemon, capability-security
gc-side-channel-surface-is-three-domains-wide | daemon, capability-security
determinism-requires-explicit-coordination | daemon, capability-security
six-delivery-types message notify | daemon
dropExports retireExports retireImports bringOutYourDead | daemon
bringOutYourDead Monty-Python-named-syscall SwingSet folklore | daemon
bootstrap-called-exactly-once | daemon
bootstrap-is-not-resuscitation | daemon
idempotence-by-construction-not-by-code | daemon
named-lifecycle-events synthesis target | daemon
crank-can-be-aborted-and-rolled-back | daemon
crank-as-transactional-unit | daemon
decider as authorization target | daemon
decider-reverts-on-rollback | daemon
authorization-snapshot-restored-on-abort | daemon
rollback-must-cover-non-database-state-too | daemon
kernel-promise-not-JS-promise | daemon
two-promise-systems-with-translation-layer | daemon
liveslots-as-the-promise-bridge | daemon
kernel-promise-survives-vat-restarts | daemon
kernel-services-cannot-return-Exos | daemon
architectural-asymmetry-between-vat-and-service | daemon
system-subcluster privilege-by-subcluster-declaration | daemon, capability-security
identity-survives-restart | daemon
systemOnly services privilege boundary | daemon, capability-security
tier-1 vocabulary borrowing candidates | daemon, captp, capability-security
tier-1-borrowing-would-add-clarity-not-collision | daemon, captp, capability-security
adopt-vocabulary-not-implementation | daemon, captp, capability-security
vocabulary-borrowing-without-code-borrowing | daemon, captp, capability-security
citation-discipline-when-borrowing | daemon, captp, capability-security
cite-the-origin in design body or commit message | daemon, captp, capability-security
centralized-glossary-as-artifact-shape | daemon, captp, capability-security
ocap-kernel-mini-series cycles 161 162 163 | daemon, captp, capability-security
baggage durable KV per vat resuscitation | daemon
liveslots JS-to-durable boundary | daemon
syscall vat-to-kernel call | daemon
delivery kernel-to-vat call | daemon
subcluster ClusterConfig | daemon
kernel-service in-kernel-context method | daemon
57+ consecutive papers-lane blocks | daemon, captp, capability-security
queued-doc-3 from cycle 161 overview | daemon, capability-security, persistence
human-portable-cryptographic-identity-surface | daemon, capability-security, persistence
BIP39 mnemonic phrase identity backup recovery | daemon, capability-security, persistence
identity-from-seed-not-from-storage | daemon, capability-security, persistence
portability-equals-determinism-of-derivation | daemon, capability-security, persistence
identity-recovery-equals-seed-recovery | daemon, capability-security, persistence
identity-is-a-derivation-chain-not-a-stored-blob | daemon, capability-security, persistence
identity-flows-through-the-stack | daemon, capability-security, persistence
PBKDF2-HMAC-SHA512 2048 iterations empty passphrase | daemon, capability-security
standard BIP39 test vector compatibility | daemon, capability-security
twelve-or-twenty-four-words 12 15 18 21 24 | daemon, capability-security
human-readable-entropy-encoding | daemon, capability-security
write-down-on-paper backup mechanism | daemon, capability-security
five-supported-lengths 128 160 192 224 256 bits | daemon, capability-security
Ed25519 keypair generation from seed | daemon, capability-security
libp2p peer-id multihash | daemon, capability-security
generateMnemonic isValidMnemonic mnemonicToSeed | daemon, capability-security
generateKeyPairFromSeed peerIdFromPrivateKey | daemon, capability-security
Kernel.make options mnemonic resetStorage | daemon, capability-security, persistence
initRemoteComms relays mnemonic | daemon, capability-security
mnemonicToSeed-is-irreversible one-way derivation | daemon, capability-security
store-the-mnemonic-not-the-seed | daemon, capability-security
opt-in-recoverability pre-commit-design | daemon, capability-security, persistence
random-seeds-cannot-be-mnemonicized-after-the-fact | daemon, capability-security, persistence
generate-mnemonic-first pattern recommended | daemon, capability-security
four-scenario decomposition scenario-as-named-flow | daemon, capability-security
scenario-1 create recoverable identity | daemon, capability-security
scenario-2 random identity no backup | daemon, capability-security
scenario-3 recover on new device | daemon, capability-security
scenario-4 verify before migration | daemon, capability-security
dry-run-derive-without-init | daemon, capability-security
verify-before-recovery pattern | daemon, capability-security
compare-with-known-good-identity | daemon, capability-security
don't-trust-user-input-blindly | daemon, capability-security
the-utility-functions-are-pieces-not-just-private-implementation | daemon, capability-security
existing-identity-conflict-guard | daemon, capability-security, persistence
refuse-to-overwrite-existing-identity | daemon, capability-security, persistence
explicit-opt-in-via-resetStorage | daemon, capability-security, persistence
single-mistake-cannot-overwrite-identity | daemon, capability-security, persistence
error-message-is-actionable | daemon, capability-security
two-step-explicit-confirmation | daemon, capability-security
two-API-locations-with-explicit-precedence-rule | daemon, capability-security
last-write-wins precedence | daemon, capability-security
avoid-silent-disagreement | daemon, capability-security
six-security-best-practices generate-first never-log clear-from-memory secure-input verify store-securely | daemon, capability-security
principle-of-least-authority-applied-to-secrets-too | daemon, capability-security
each-is-a-named-rule-not-vague-suggestion | daemon, capability-security
minimize-memory-residency | daemon, capability-security
don't-touch-the-clipboard avoid clipboard-readers | daemon, capability-security
digital-backup-as-attack-surface | daemon, capability-security
don't-invent-your-own-crypto | daemon, capability-security
use-standard-test-vectors | daemon, capability-security
interoperability-as-design-axiom | daemon, capability-security
key-reuse-hazard mnemonic shared with wallet | daemon, capability-security
two-factor-secret passphrase-as-deniable | daemon, capability-security
peer-id-from-seed Tier-1 vocabulary borrowing | daemon, capability-security, persistence
mnemonic-as-portable-backup Tier-1 vocabulary borrowing | daemon, capability-security, persistence
resetStorage-conflict-guard Tier-1 vocabulary borrowing | daemon, capability-security, persistence
verify-before-recovery Tier-1 vocabulary borrowing | daemon, capability-security, persistence
opt-in-recoverability Tier-2 vocabulary borrowing | daemon, capability-security, persistence
dry-run-derive-step Tier-2 vocabulary borrowing | daemon, capability-security, persistence
user-portable-daemon-identity synthesis target | daemon, capability-security, persistence
reference-with-runnable-examples doc genre | daemon, capability-security
every-API-method-has-a-code-example | daemon, capability-security
every-scenario-is-end-to-end-runnable | daemon, capability-security
errors-shown-as-exact-strings | daemon, capability-security
Bewlay locator path-like address Endo | daemon, capability-security, persistence
58+ consecutive papers-lane blocks | daemon, capability-security, persistence
queued-doc-4 from cycle 161 overview | daemon, tooling, getting-started
contributor-onboarding-document | daemon, tooling, getting-started
distinctively-not-about-the-system about-the-development-workflow | daemon, tooling, getting-started
doc-as-contract-with-future-contributors | daemon, tooling, getting-started
two-audience-surface user-docs vs contributor-docs | daemon, tooling, getting-started
two-platforms-Node-and-browser canonical | daemon, tooling
kernel-browser-runtime kernel-test extension nodejs packages | daemon, tooling
core-packages-contain-both-abstraction-and-platform-impls | daemon, tooling
runtime-packages-orchestrate-by-choosing | daemon, tooling
single-source-of-truth-for-the-abstraction | daemon, tooling
platform-obvious-vs-platform-implicit-exports | daemon, tooling
naming-convention-tells-platform | daemon, tooling
mechanism-named-when-platform-is-implied | daemon, tooling
WASM implies browser | daemon, tooling
reader-literacy-prerequisite | daemon, tooling
discipline-by-disclosure | daemon, tooling
mermaid-diagram-of-package-relationships | daemon, tooling
six-step-development-guideline | daemon, tooling, getting-started
Package Creation Platform-Agnostic Implementation Platform-Specific Implementation Package Configuration Platform Integration End-to-End Testing | daemon, tooling, getting-started
steps-are-ordered-with-explicit-dependency | daemon, tooling, getting-started
abstraction-first-then-platforms-then-integration-then-tests | daemon, tooling, getting-started
two-directory-structure-choices simple complex | daemon, tooling
my-package/src/<platform>/ | daemon, tooling
my-package/src/<feature>/<platform>/ | daemon, tooling
convention-with-justified-flexibility | daemon, tooling
directory-structure-becomes-export-paths | daemon, tooling
no-mismatch-between-filesystem-and-package-graph | daemon, tooling
reduce-cognitive-overhead-by-removing-renames | daemon, tooling
integration-points-named-explicitly | daemon, tooling
vat-worker.ts make-kernel.ts Node integration | daemon, tooling
kernel-worker.ts iframe.ts browser integration | daemon, tooling
don't-leave-the-contributor-guessing | daemon, tooling
per-platform-e2e-package | daemon, tooling
amortize-platform-setup | daemon, tooling
extension package browser e2e tests | daemon, tooling
kernel-test package Node e2e tests | daemon, tooling
named-core-vs-runtime-layering Tier-1 borrowing | daemon, tooling
six-step-development-flow Tier-1 borrowing | daemon, tooling
canonical-per-platform-test-package Tier-1 borrowing | daemon, tooling
name-the-integration-file Tier-1 borrowing | daemon, tooling
surface-the-choice-don't-hide-it | daemon, tooling
small-doc-doesn't-mean-shallow-ingest | daemon, tooling
six-step-flow is the spine | daemon, tooling
contributor flow for adding platform-specific feature | daemon, tooling, getting-started
59+ consecutive papers-lane blocks | daemon, tooling, getting-started
daemon-mount design In Progress Phases 1-3 + 5 shipped | daemon, capability-security, patterns
live-mutable-filesystem-as-capability | daemon, capability-security
AI-coding-agent-as-motivating-use-case | daemon, capability-security
mount formula scratch-mount formula | daemon, capability-security
two-formula-type-split | daemon, capability-security, patterns
lifecycle-asymmetry-vs-implementation-symmetry | daemon, patterns
ReadableTree-compatible-reads has list lookup | daemon, patterns
mutation suite write remove move makeDirectory | daemon, capability-security
snapshot bridge-to-immutable readable-tree | daemon, capability-security
mount-snapshot round-trip | daemon, capability-security
realpath-at-operation-time-confinement | daemon, capability-security
TOCTOU mitigation operation-time check | daemon, capability-security
operation-time-verification | daemon, capability-security
read-soft-write-hard discipline | daemon, capability-security
hidden-not-rejected for reads | daemon, capability-security
escaping symlinks silently excluded | daemon, capability-security
readOnly on the exo no new formula | daemon, capability-security
sub-mount via host creates new formula | daemon, capability-security
exo-vs-host axis creates-formula | daemon, patterns
deferred-task atomicity GC race prevention | daemon, capability-security
transient exos from lookup | daemon, patterns
formula-store hygiene don't pollute | daemon, patterns
weak-value-map GC cycle 156 | daemon, patterns
..-is-clamped-not-rejected POSIX-ergonomic | daemon, patterns
path-validation segment rules slash backslash null | daemon
path-based-not-inode-based limitation | daemon, capability-security
POSIX *at family openat renameat fstatat mkdirat | daemon, capability-security
future-hardening-target | daemon, capability-security
honest-limitation-disclosure | daemon, capability-security
scratch-mount survives cancellation | daemon, capability-security, persistence
intentional-deletion-requires-removing-all-pet-name-references | daemon, capability-security
single-mistake-cannot-destroy-state | daemon, capability-security
eight Design Decisions enumerated | daemon, capability-security, patterns
phased implementation 6 phases | daemon
twenty integration tests confinement symlink | daemon
five design dependencies | daemon
platform-fs daemon-capability-filesystem daemon-checkin-checkout daemon-agent-tools daemon-content-store-gc | daemon
speculative-vision-realized-as-concrete-subset | daemon, patterns
concrete-mergeable-slice | daemon, patterns
daemon-capability-filesystem wider vision | daemon
synthesis-target two-formula-type-split applicable | daemon, patterns
our-design we are the substrate | daemon
endo-but-for-bots-design genre | daemon
designs-lane after 5-cycle comments-lane streak | daemon
breaks ocap-kernel-mini-series streak | daemon
direct-prerequisite-design for filesystem-watchers | daemon
60+ consecutive papers-lane blocks | daemon, capability-security, patterns
@endo/where index.js path resolution | tooling, daemon, getting-started
canonical-path-resolution-surface | tooling, daemon, getting-started
where-Endo-finds-its-files-per-platform | tooling, daemon, getting-started
four-state-domains durable ephemeral sock cache | tooling, daemon
whereEndoState durable | tooling, daemon
whereEndoEphemeralState ephemeral PID | tooling, daemon
whereEndoSock UNIX socket Windows named pipe | tooling, daemon
whereEndoCache re-creatable | tooling
XDG-precedence-with-platform-fallback-chain | tooling, daemon
XDG_STATE_HOME XDG_CACHE_HOME XDG_RUNTIME_DIR | tooling, daemon
cache-vs-state-split-honors-XDG-canon | tooling, daemon
the-OS-cleans-up-after-us reboot | tooling, daemon
whereHomeWindows internal helper | tooling
four-env-var-fallback-chain Windows-historical-accretion | tooling
LOCALAPPDATA APPDATA USERPROFILE HOMEDRIVE HOMEPATH | tooling
roaming AppData TODO future content-addressable state merge | tooling
per-platform naming conventions POSIX macOS Windows | tooling, daemon
when-in-Rome platform aesthetic | tooling
lowercase-with-dot-prefix POSIX | tooling
CapitalE-with-space macOS | tooling
CapitalE-backslash Windows | tooling
~/.local/state/endo Linux | tooling, daemon
~/Library/Application Support/Endo macOS | tooling, daemon
%LOCALAPPDATA%\\Endo Windows | tooling, daemon
UNIX-socket-vs-Windows-named-pipe asymmetry | tooling, daemon
Named pipes have a special place in Windows and in our ashen hearts | tooling, daemon
wry-acknowledgment-of-Windows-IPC-quirks | tooling, daemon
named pipe namespace prefix reserved | tooling, daemon
ENDO_SOCK override discipline | tooling, daemon
last-resort-user-override | tooling, daemon
protocol-suffix-in-socket-names captp0 default | tooling, daemon
reserves-pattern-for-future-protocols additive-API | tooling, daemon
five-functions-form-coherent-surface | tooling
uniform 3-arg signature platform env info | tooling
two-strategies-for-the-same-problem | tooling, getting-started
platform-specific packages vs platform-specific functions | tooling
re-creatable-cache-permits-purge-without-losing-state | tooling
weak-collections-permit-collection | tooling
same-discipline-different-scope heap-vs-filesystem | tooling
reading-this-file-tells-you-Endo's-deployment-shape | tooling, daemon, getting-started
LOC-doesn't-reflect-the-load-bearing-knowledge | tooling
small-file-but-load-bearing-knowledge | tooling
slot machine library reuse @endo/where synthesis target | tooling, daemon
Tier-1 borrowing four-state-domains | tooling, daemon
Tier-1 borrowing XDG-precedence-with-platform-fallback-chain | tooling, daemon
Tier-1 borrowing protocol-suffix-in-socket-names | tooling, daemon
Tier-1 borrowing ENDO_SOCK-override | tooling, daemon
XDG_RUNTIME_DIR canonical-tmpfs-cleared-on-reboot systemd | tooling, daemon
PID-files-after-reboot-are-misleading | tooling, daemon
61+ consecutive papers-lane blocks | tooling, daemon, getting-started
endo checkin checkout commands ci co | daemon, tooling
complete-bidirectional-bridge local FS formula store | daemon, tooling
single-substrate-four-modes directory zip checkin checkout | daemon, tooling
same-formula-tree-from-two-input-sources | daemon, tooling
zip-is-just-serialization | daemon, tooling
CLI-side-formulation-not-daemon-side | daemon, tooling, capability-security
checkout-entirely-CLI-side zero new daemon methods | daemon, tooling
readable-tree-stores-formula-IDs-not-content-hashes | daemon, tooling
identity-vs-content distinction | daemon
formula-graph-for-GC needs identity edges | daemon
zip-mode-reuses-tree-formulation | daemon, tooling
no-metadata-preservation content-only-not-filesystem-replica | daemon, tooling
permissions timestamps ownership not captured | daemon, tooling
future-extension-as-sidecar-formula | daemon
symlinks-skipped-with-warning readable-tree | daemon, tooling
different-substrate-different-policy mount checkin | daemon, capability-security
.endoignore not new flag reuse-familiar-discipline | daemon, tooling
gitignore syntax | daemon, tooling
don't-grant-daemon-ambient-FS-access | daemon, capability-security
capability-security-at-architectural-axis | daemon, capability-security
push-the-FS-side-to-the-component-that-already-has-FS-authority | daemon, capability-security
operation-time discipline vs architectural-time discipline | daemon, capability-security
type-discrimination-via-locator | daemon, tooling
locator-encodes-formula-type ?type=readable-tree | daemon, tooling
locators-encode-type-information-too | daemon, tooling
relationship-to-mkweblet zip extraction | daemon, tooling
zip-extraction-extracted-from-mkweblet | daemon, tooling
mkweblet-now-accepts-readable-tree-directly | daemon, tooling
decomposition-of-bundled-verbs refactor-discipline | daemon, tooling, capability-security
roadmap-calibration-via-git-blame | daemon
62 days three discrete bursts long unattended gaps | daemon
documentation-tracks-reality | daemon
five-phase-implementation all complete S-sized | daemon
each-phase-can-ship-independently no flag day | daemon
bidirectional-bridge-pattern two symmetric commands | daemon, tooling
pair-design daemon-mount daemon-checkin-checkout | daemon
mount.snapshot-produces-readable-tree | daemon
round-trip mount snapshot checkout local directory | daemon
live-mutable vs point-in-time-snapshot-and-restore | daemon
empty-directories-are-valid-formulas | daemon
maximum-depth CLI-side guard 64 levels | daemon, tooling
content-deduplication store-sha256 automatic | daemon
Tier-1 borrowing single-substrate-four-modes | daemon, tooling
Tier-1 borrowing CLI-side-formulation | daemon, tooling, capability-security
Tier-1 borrowing bidirectional-bridge-pattern | daemon, tooling
Tier-1 borrowing locator-encodes-formula-type | daemon, tooling
Tier-1 borrowing reuse-familiar-discipline | daemon, tooling
Tier-1 borrowing don't-bake-metadata-in-yet | daemon
Tier-1 borrowing decomposition-of-bundled-verbs | daemon, tooling, capability-security
62+ consecutive papers-lane blocks | daemon, tooling, capability-security
@endo/captp atomics.js SharedArrayBuffer Trap transport | captp, patterns, tooling
SharedArrayBuffer-as-synchronous-RPC-transport | captp, tooling
Atomics wait notify blocking RPC | captp, tooling
three-buffer-split-in-one-SharedArrayBuffer | captp, patterns
lenbuf BigUint64Array statusbuf Int32Array databuf Uint8Array | captp, patterns
TRANSFER_OVERHEAD_LENGTH BigUint64Array Int32Array bytes per element | captp
MIN_DATA_BUFFER_LENGTH 1 pathological minimum | captp, patterns
MIN_TRANSFER_BUFFER_LENGTH | captp
STATUS_WAITING STATUS_FLAG_DONE STATUS_FLAG_REJECT | captp
bit-flags-not-enum-when-states-are-orthogonal | captp, patterns
why-Int32Array-for-status MDN citation | captp, tooling
standard-API-constraint-acknowledged-in-comment | captp, tooling
32-bit-atomic-integer canonical-wake-target | captp
async-generator-as-trapHost | captp, patterns
async-generator-as-resumable-state-machine | captp, patterns
yield-as-resume-point | patterns
JS-language-feature-as-control-flow-primitive | patterns
iterator-protocol-as-bidirectional-channel | captp, patterns
host yields chunks via Atomics.notify | captp
guest controls iteration via it.next return throw | captp
chunked-transfer-by-buffer-size | captp, patterns
allocate-once-zero-copy-chunk subarray | captp, patterns
special-case-done-on-first-try | captp, patterns
allocation-elision-for-common-case | patterns
optimization-by-shape-recognition | patterns
cleanup-via-iterator-protocol it.throw | captp, patterns
TODO use error type captp noisy logging | captp
honest-limitation-with-named-future-improvement | captp, patterns
test-the-boundary-not-just-the-happy-path | patterns
pathological-test-case-anchors-the-design | patterns
three-buffer-write-order discipline data length status notify | captp, patterns
status-write-plus-notify-is-commit-point | captp, patterns
JSON-encoding-not-marshal-direct | captp
encode-to-JSON-then-UTF-8-bytes | captp
two-step-encoding JSON UTF-8 | captp
layering-discipline marshal upstream | captp
synchronous-RPC-as-meta-capability | captp, tooling
rare-and-valuable-primitive | captp, tooling
this-enables-Trap-in-cycle-154 | captp
this-enables-XS-debugger-style-stepping cycle 159 | captp
pair-with-cycle-154-trap.js | captp
trap.js abstract interface atomics.js concrete implementation | captp
abstract-then-concrete pattern | patterns
small-file-but-load-bearing-knowledge sibling | captp, tooling
Atomics.notify buf 0 +Infinity wake all waiters | captp
Atomics.wait buf 0 STATUS_WAITING blocking | captp
TextEncoder TextDecoder UTF-8 | captp
thirteenth file in e56bf00f coordinated-update cluster | captp
e56bf00f cluster cycles 108 110 115 118 123 125 132 134 138 140 144 167 169 | captp
Tier-1 borrowing three-buffer-split | captp, patterns
Tier-1 borrowing Atomics-wait-notify-for-blocking-RPC | captp, patterns
Tier-1 borrowing async-generator-as-resumable-state-machine | patterns
Tier-1 borrowing bit-flags-not-enum | patterns
Tier-1 borrowing allocation-elision-for-common-case | patterns
Tier-1 borrowing cleanup-via-iterator-protocol | captp, patterns
Tier-1 borrowing pathological-test-case-anchors-the-design | patterns
63+ consecutive papers-lane blocks | captp, patterns, tooling
daemon-capability-filesystem reference vision | daemon, capability-security, patterns
speculative-vision-document | daemon, patterns
reference-status-after-narrower-subset-shipped | daemon
reference-design-as-genre | daemon, patterns
encodes-design-space-exploration | daemon, patterns
seeds-future-concrete-designs | daemon, patterns
per-idea-factoring migration-path | daemon, patterns
first Endo-internal Reference design ingested | daemon
14-day-design-phase reference-transition 2026-03-21 | daemon
three-layer-architecture Guest VFS-Namespace Backends | daemon, patterns
single-interface-multiple-backings | daemon, patterns
four-backend-types Physical Git-Tree Memory CAS | daemon, patterns
guest cannot tell which backend serves which path | daemon, capability-security
chroot-jail-shape | daemon, capability-security
Bazel-style-selective-dependency-mounting | daemon, capability-security
absence-is-structural-not-policy | daemon, capability-security
undeclared-dependencies-are-absent-not-denied | daemon, capability-security
no-amount-of-clever-prompting-can-construct-authority-it-doesn't-have | daemon, capability-security
materialization-bridge-VFS-to-OS-sandbox | daemon, capability-security
two-staged-confinement | daemon, capability-security
syncBack validates changes within scope | daemon
single-dimension-attenuation-via-method-chaining | daemon, capability-security, patterns
readOnly subDir composable | daemon, capability-security, patterns
composable-by-chaining | patterns
replaces attenuate(opts) with composable chainable calls | patterns
attenuation-is-irreversible | capability-security
caretaker-facet-separation DirControl FileControl | daemon, capability-security
canonical-ocap-caretaker-pattern Miller-1973 | capability-security
setWritable revoke without guest cooperation | daemon, capability-security
defense-in-depth-deny-patterns | daemon, capability-security
primary structural confinement secondary deny patterns | daemon, capability-security
**/.ssh/** **/.aws/** **/.env** **/*.pem credentials | daemon, capability-security
backend-level not Dir-exo-level cannot-be-circumvented | daemon, capability-security
configurable-by-host | daemon
non-physical-backends-don't-need-deny-patterns | daemon, capability-security
LLM-discoverability-via-help-plus-interface-guards | daemon, patterns
help-as-LLM-onboarding | daemon
two-channels-for-machine-and-human-understanding | patterns
path-segment-validation-multi-layer | daemon, capability-security
enforced-even-for-in-memory-backends | daemon, capability-security
subDir-resolves-eagerly avoid TOCTOU | daemon, capability-security
Endo-already-has-this-pattern map | daemon, patterns
six-named-relationships pet-name-directory VFS-sketch FilePowers OS-sandbox-plugin EndoDirectory | daemon
map-to-existing-substrate-not-parallel-abstractions | daemon, patterns
seven-Open-Questions honest-deferral | daemon
threat-model-with-citations | daemon, capability-security
arxiv:2509.22040 Your AI My Shell Liu et al | daemon, capability-security
IDEsaster report Marzouk December 2025 | daemon, capability-security
84%-success-rate-against-unprotected-editors | daemon, capability-security
defense-driven-by-evidence-not-theoretical | daemon, capability-security
reference-document-as-roadmap-source | daemon, patterns
Git-tree-backend future-concrete-design candidate | daemon
Memory-backend future-concrete-design candidate | daemon
CAS-backend future-concrete-design candidate | daemon
VFS-namespace-compositor future-concrete-design candidate | daemon
Materialization-bridge future-concrete-design candidate | daemon
the-wider-vision daemon-mount concrete-mergeable-slice | daemon
backend-isolation FilePowers trusted computing base | daemon, capability-security
Tier-1 borrowing three-layer-architecture | daemon, patterns
Tier-1 borrowing single-interface-multiple-backings | daemon, patterns
Tier-1 borrowing Bazel-style-selective-dependency-mounting | daemon, capability-security
Tier-1 borrowing absence-is-structural-not-policy | daemon, capability-security
Tier-1 borrowing materialization-bridges-VFS-to-OS-sandbox | daemon, capability-security
Tier-1 borrowing caretaker-facet-separation | daemon, capability-security
Tier-1 borrowing defense-in-depth-deny-patterns-as-secondary | daemon, capability-security
Tier-1 borrowing help-plus-interface-guards-for-LLM-discoverability | daemon, patterns
64+ consecutive papers-lane blocks | daemon, capability-security, patterns
@endo/stream index.js canonical async-stream substrate | streams, patterns, captp
Endo-async-stream-substrate | streams, patterns
makeQueue makeStream makePipe pump prime mapReader mapWriter | streams, patterns
symmetric-stream-interface | streams, patterns
Reader and Writer differ only by convention | streams
sends-data-and-receives-undefined Writer | streams
receives-data-and-sends-undefined Reader | streams
compatible-with-AsyncIterator-and-Generator-but-stricter | streams
every-method-and-argument-required | streams
three-method-symmetry next return throw | streams, patterns
functional-async-queue promise-chain cons-cells | patterns
producer-makes-cons-cell consumer-walks-chain | patterns
promise-as-pointer | patterns
no-bounded-buffer producer-never-blocks | patterns
acks-and-data paired queues | streams, captp
cross-wired-pair-of-queues | streams, captp
back-pressure-via-acks | streams, captp
makePipe two-queues-cross-wired three-line implementation | streams, captp
pump tick-tock-mutual-recursion | streams, patterns
behold-mutual-recursion literal comment | streams
E.when-not-await remote-eventual-send-values | streams, captp
prime captures first-returned-promise | streams, patterns
async-generator-priming-asymmetry | patterns
the-first-.next(value)-is-actually-the-second-value | patterns
mapReader async-generator transform | streams, patterns
mapWriter method-wrapping transform | streams, patterns
two-different-shapes-for-same-pattern | patterns
the-direction-of-iteration-matters-for-implementation-shape | patterns
harden-everything-individually | streams, patterns
defensive-harden-discipline | patterns
harden-the-factory-not-just-the-result | patterns
shallow-freeze typed-arrays-are-not-freezable | streams
throw-puts-rejected-promise | streams
done-flag-on-return | streams
stream-substrate-ecosystem | streams, captp
vocabulary-drift-where-substrate-is-shared | streams, captp
ocap-kernel channel stream @endo/stream Stream @endo/captp connection | streams, captp
three-different-vocabularies-for-shared-substrate | streams, captp
promise-kit-foundation makePromiseKit | streams
cycle-152-memo-race racing-with-cleanup sibling | streams
sequencing-with-back-pressure | streams
small-file-but-foundational | streams
the-substrate-files-are-often-the-shortest | streams
fourteenth file in e56bf00f coordinated-update cluster | streams, captp
Tier-1 borrowing symmetric-stream-interface | streams, patterns
Tier-1 borrowing makePipe-from-two-cross-wired-queues | streams, patterns
Tier-1 borrowing functional-async-queue | patterns
Tier-1 borrowing back-pressure-via-acks | streams, captp
Tier-1 borrowing prime-captures-first-returned-promise | streams, patterns
Tier-1 borrowing E.when-not-await | streams, captp
Tier-1 borrowing harden-everything-individually | patterns
65+ consecutive papers-lane blocks | streams, patterns, captp
@endo/bytes design new utility package | tooling, patterns, pass-style
endo-bytes Uint8Array helpers cross-platform | tooling, patterns
maximal-power-minimal-area discipline | tooling, patterns
ship-the-smallest-API-that-retires-the-existing-duplicates | tooling, patterns
add-helpers-when-a-real-consumer-asks | tooling, patterns
audit-first-design-second | tooling, patterns
three-platform-constraint Node XS SES | tooling, pass-style
Buffer is Node-only Uint8Array is cross-platform | tooling, pass-style
five-existing-duplicates audit | tooling, patterns
three-concrete-costs of duplication | tooling, patterns
each-new-caller-invents-another-copy | tooling, patterns
subtle-drift-between-copies | tooling, patterns
Buffer-ports-still-landing | tooling
four-helpers-MVP concatBytes bytesEqual bytesFromText bytesToText | tooling, pass-style
helper-rationale-table-with-existing-duplicates-counts | tooling, patterns
six-helpers-explicitly-deferred | tooling, patterns
document-what's-not-included-and-why | tooling, patterns
negative-space-is-load-bearing | tooling, patterns
no-barrel-module-per-helper-surface | tooling, patterns
tree-shaking-friendliness | tooling, patterns
per-helper-surface-area-easy-to-audit | tooling, patterns
qualified-export-names | tooling, patterns
file-name-doesn't-stutter export-name-carries-qualifier | tooling, patterns
kebab-case-file-names-for-multi-word | tooling
single-word-files-keep-plain-form | tooling
module-scoped-TextEncoder-and-TextDecoder | tooling, pass-style
capture-at-module-load no-per-call-allocation | tooling
captured-before-lockdown-can't-be-defeated | tooling, pass-style
no-input-validation-beyond-primitives | tooling, patterns
leaf-utility-stays-leaf | tooling, patterns
don't-add-pass-style-dependency to leaf utility | tooling, patterns
eight-Decisions recorded from PR review | tooling, patterns
Open-Questions-resolved-during-implementation | tooling, patterns
first-release-at-1.0.0 no-0.x-purgatory | tooling, patterns
API-stable-from-day-one | tooling, patterns
major changeset bump from 0.x baseline | tooling
four-phase migration package + sibling duplicates + TextEncoder | tooling
decoupled-rollout package-first call-sites-later | tooling, patterns
defer-to-sibling-packages | tooling, patterns
each-package-has-one-concern | tooling, patterns
don't-build-a-mega-package | tooling, patterns
sourced-from-PR-inline-review-comment lifecycle | tooling, patterns
PR-122-comment-3205507716 source | tooling
fourth-lifecycle-instance cycles 149 157 161 172 | tooling, patterns
family-of-small-focused-leaf-utility-packages | tooling, patterns
sibling-utility-package | tooling, patterns
@endo/where cycle 167 @endo/stream cycle 171 sibling | tooling, patterns
@endo/base64 @endo/hex sibling-precedent | tooling
synthesis-target eight-step-pattern monorepo deduplication | tooling, patterns
eight-step-pattern audit + maximal-power-minimal-area + per-helper-surface + qualified-export-names + module-scoped + no-peer-deps + start-at-1.0.0 + resolve-OQ-during-implementation | tooling, patterns
Tier-1 borrowing maximal-power-minimal-area | tooling, patterns
Tier-1 borrowing no-barrel-module-per-helper-surface | tooling, patterns
Tier-1 borrowing qualified-export-names | tooling, patterns
Tier-1 borrowing module-scoped-TextEncoder-TextDecoder | tooling, pass-style
Tier-1 borrowing first-release-at-1.0.0 | tooling, patterns
Tier-1 borrowing Open-Questions-resolved-during-implementation | tooling, patterns
Tier-1 borrowing sourced-from-PR-inline-review-comment-lifecycle | tooling, patterns
66+ consecutive papers-lane blocks | tooling, patterns, pass-style
@endo/promise-kit promise-executor-kit.js | patterns, async-flow
makeReleasingExecutorKit | patterns, async-flow
reference-release-on-settle | patterns, async-flow
three-state-internal-reference-lifecycle | patterns, async-flow
undefined function null states | patterns
undefined-vs-null-meaningful-distinction | patterns
falsy-check distinguishes state 1 from states 0+2 | patterns
executor-is-single-use assert-on-double-invocation | patterns
resolve/reject-are-fire-once | patterns, async-flow
symmetric-release of paired references | patterns, async-flow
once-settled-neither-can-fire | patterns, async-flow
captured-state-as-mutable-let | patterns
three-distinct-states-distinguishable-by-JS-value-shape | patterns
symmetric-release-on-first-firing | patterns, async-flow
why-not-just-WeakRef timing-guarantees | patterns, async-flow
immediate-release-by-explicit-assignment | patterns, async-flow
release-when-GC-runs WeakRef | patterns
explicit-release-on-known-event | patterns, async-flow
weak-when-no-strong-reference | patterns
two-different-promises-about-GC | patterns, async-flow
decomposed-for-composition | patterns
executor-half only no promise | patterns, async-flow
caller-passes-executor-to-Promise-constructor | patterns, async-flow
any-promise-constructor HandledPromise future variants | patterns, async-flow
naming-discipline-releasing-as-qualifier | patterns
if-your-function-does-cleanup-name-the-cleanup-in-the-function-name | patterns
action-verb-or-adjective-in-function-name @endo discipline | patterns
defendPrototype trackTurns safe-promise sibling | patterns
reference-release-on-settle micro-pattern | patterns, async-flow
applicable to watchdog-timers one-shot-event-emitters | patterns
single-use-cleanup-handlers | patterns
assert-without-condition-is-just-Fail | patterns
genuine-invariant-check not user-facing-error | patterns
two-functions-named-resolve-and-reject vs one-with-mode-arg | patterns
intentional-readability over DRY | patterns
sibling-to-cycle-152-memo-race racing-with-cleanup | patterns, async-flow
used-by-cycle-171-stream-substrate | patterns, async-flow
makePromiseKit per cons-cell | patterns, async-flow
the-stream-queue-is-GC-friendly-because-this-file-releases-references | patterns, async-flow
cycle-156-finalize-WeakValueMap sibling | patterns
two-functions-symmetric-in-shape | patterns
slot machine promise-callbacks need this hygiene | patterns
Tier-1 borrowing three-state-internal-reference-lifecycle | patterns, async-flow
Tier-1 borrowing reference-release-on-settle | patterns, async-flow
Tier-1 borrowing releasing-as-qualifier-in-function-name | patterns
Tier-1 borrowing symmetric-release-of-paired-references | patterns, async-flow
Tier-1 borrowing undefined-vs-null-meaningful-distinction | patterns
fifteenth file in e56bf00f coordinated-update cluster | patterns, async-flow
67+ consecutive papers-lane blocks | patterns, async-flow
zizmor | (see section: endo--contributing--initial-setup)
zizmor pedantic | (see section: endo--contributing--initial-setup)
zizmor mismatched version comment | (see section: endo--contributing--initial-setup)
action's hash pin has mismatched or missing version comment | (see section: endo--contributing--initial-setup)
action hash pin | (see section: endo--contributing--initial-setup)
GitHub Action pin | (see section: endo--contributing--initial-setup)
`uses:` SHA pin | (see section: endo--contributing--initial-setup)
`# v1` version comment | (see section: endo--contributing--initial-setup)
`update-action-pins.mjs` | (see section: endo--contributing--initial-setup)
`update-action-pins-major.yml` workflow | (see section: endo--contributing--initial-setup)
action-pin updater | (see section: endo--contributing--initial-setup)
`--check-pins` | (see section: endo--contributing--initial-setup)
`--min-age-days` | (see section: endo--contributing--initial-setup)
floating-tag drift | (see entry: 2026/06/03/230728Z-message-shepherd-dfe4c4)
@endo/gateway design overarching | daemon, tooling, capability-security
gateway-package researcher-tracked-gap-1 addressed | daemon, tooling
one-factory-many-configurations | daemon, tooling, patterns
ten-feature-decomposition-of-one-package | daemon, tooling
five-deployment-shapes | daemon, tooling
configuration-gates-features | daemon, tooling
WebletFormula typedef contentRoot mimeTypes ssrHandler virtualHosts | daemon, tooling
@apps NameHub virtual hosting | daemon, tooling
fetchContentTree daemon-side exo | daemon, tooling
content-tree-resolution-five-step | daemon, tooling
path-suffix-to-flat-entries-map-walk | daemon, tooling
/ocapn-cbor-np WebSocket subprotocol | daemon, tooling
path-name-encodes-codec-and-network | daemon, tooling
ocapn protocol family cbor codec np Noise Protocol | daemon, tooling
frame-relay-without-decryption | daemon, capability-security
Noise-handshake intended-responder-prefix | daemon, capability-security
end-to-end-encryption-survives-relay | daemon, capability-security
external-TLS-via-reverse-proxy | daemon, tooling
X-Forwarded-trust-via-CIDR-allowlist | daemon, capability-security
trust-boundary-is-TCP-peer-not-header-contents | daemon, capability-security
formula-identifier-as-bearer-token-reuse | daemon, capability-security
resource-ledger-in-gateway-not-daemon | daemon, tooling
gateway-is-the-layer-where-traffic-accrues | daemon, tooling
UDS-bootstrap-as-administrator-channel | daemon, capability-security
admin-authority-is-not-on-the-network-surface | daemon, capability-security
proof-of-possession registration | daemon, capability-security
GatewayBootstrap GatewayAdmin AppsNameHub RelayRegistration ResourceLedger | daemon
ENDO_HTTP_ADDR 0.0.0.0:3469 default | daemon, tooling
eight-Design-Decisions seven-Open-Questions | daemon
eighteen-named-dependencies | daemon
the-junction-design daemon Familiar OCapN stacks meet | daemon
supersedes-vs-deprecates | daemon
three-design-lifecycle-statuses Deprecated Supersedes Revision-note-refined | daemon
strategic-vs-tactical-phase-numbering | daemon, tooling
four-strategic-phases vs eleven-plus-tactical-PRs | daemon
researcher-tracked-gaps-1-2-3-4 partially addressed by single ingest | daemon, tooling
a-single-ingest-can-address-multiple-related-gaps | daemon, tooling
subsystem-package vs leaf-utility-package | daemon, tooling, patterns
sibling-extract-pattern @endo/bytes cycle 172 | daemon, tooling, patterns
Tier-1 borrowing one-factory-many-configurations | daemon, tooling
Tier-1 borrowing ten-feature-decomposition-of-one-package | daemon, tooling
Tier-1 borrowing path-name-encodes-codec-and-network | daemon, tooling
Tier-1 borrowing frame-relay-without-decryption | daemon, capability-security
Tier-1 borrowing external-TLS-via-reverse-proxy | daemon, tooling
Tier-1 borrowing X-Forwarded-trust-via-CIDR-allowlist | daemon, capability-security
Tier-1 borrowing supersedes-keeps-prior-as-citable-reference | daemon
Tier-1 borrowing strategic-vs-tactical-phase-numbering | daemon, tooling
68+ consecutive papers-lane blocks | daemon, tooling, capability-security
@endo/harden make-selector.js | hardened-javascript, patterns, tooling
race-to-install-harden-at-well-known-slot | hardened-javascript, patterns
Object[Symbol.for('harden')] slot | hardened-javascript
three-tier-lookup-with-fallthrough | patterns
Object[@harden] new convention | hardened-javascript
globalThis.harden HardenedJS legacy convention | hardened-javascript
fresh makeHardener pin | hardened-javascript
pin-on-first-install non-configurable non-writable | hardened-javascript, patterns
defineProperty configurable false writable false | hardened-javascript
Symbol.for-as-coordination-slot | patterns
registered-symbols-cross-realm-boundaries | patterns
forward-compat-via-pin vs backward-compat-via-non-installation | hardened-javascript
honest-warning HardenedJS lockdown succeeds | hardened-javascript
type-check-the-existing-implementation | patterns
fail-loud-on-corruption with helpful diagnostic | patterns
@endo/harden expected callable | hardened-javascript
lazy-IIFE-closure defer-to-first-use | patterns
race-window-handled | patterns
Object.freeze on wrapper two-levels-of-defensiveness | hardened-javascript, patterns
race-semantics multiple loaders share same harden | hardened-javascript
no-double-install | hardened-javascript, patterns
all-loaders-share-same-instance | hardened-javascript, patterns
legacy-bridge-via-fallback | patterns
accept-both-conventions during migration | patterns
e56bf00f-coordinated-update-cluster anchor | hardened-javascript
fifteen-plus-files migrated @endo/harden adoption | hardened-javascript
sixth-member small-files-with-large-knowledge-density | tooling, patterns
small-files-with-large-knowledge-density family | tooling, patterns
69 lines @endo/harden make-selector | hardened-javascript
Mark S. Miller fifth file ingested | hardened-javascript
Tier-1 borrowing race-to-install-at-well-known-slot | patterns
Tier-1 borrowing three-tier-lookup-with-fallthrough | patterns
Tier-1 borrowing pin-on-first-install | patterns
Tier-1 borrowing defer-to-first-use | patterns
Tier-1 borrowing Symbol.for-as-coordination-slot | patterns
Tier-1 borrowing type-check-the-existing-implementation | patterns
Tier-1 borrowing fail-loud-on-corruption-with-helpful-diagnostic | patterns
69+ consecutive papers-lane blocks | hardened-javascript, patterns, tooling
endor Rust supervisor architecture | daemon, tooling, hardened-javascript
endor binary multi-tool subcommands | daemon, tooling
endo crate xsnap crate two-crate-decomposition | daemon
three-worker-platforms separate shared node | daemon, tooling
byte-identical-CBOR-envelopes across transports | daemon, tooling
supervisor-is-transport-agnostic | daemon, tooling
graceful-downgrade shared to separate | daemon
manager-must-be-co-resident hard requirement | daemon
the-daemon-binary-is-self-contained | daemon
pool-of-machine-runner-threads | daemon
ENDO_MACHINE_THREADS default CPU count | daemon
cooperative-not-preemptive scheduling | daemon
machines-yield-at-envelope-boundaries | daemon
XS Machine !Send !Sync pinned to OS thread | daemon
blocking-call-authorization-via-parent-tree | daemon
deadlock-prevention-by-structure | daemon
parent-can-call-child-synchronously child-cannot-block-parent | daemon
suspend-resume-via-CAS-streaming | daemon
the-full-snapshot-never-resides-in-memory | daemon
SHA-256-as-content-address streaming | daemon
atomic-rename-after-write CAS | daemon
unified-runner-four-mode-table | daemon
Bundle Archive program Transport Some None | daemon
endor implements Ken protocol properties implicitly | daemon
CESU-8 surrogate-pair encoding XS | daemon
fast-path no 4-byte UTF-8 | daemon
six-host-power-modules fs crypto modules process sqlite debug | daemon, tooling
cap-std capability-safe filesystem | daemon
five-embedded-JS-bundles include_str! | daemon, tooling
polyfills host_aliases ses_boot worker_bootstrap daemon_bootstrap | daemon
renames-from-kind-to-platform | daemon
kind locked node platform separate shared node | daemon
defaultWorkerKind defaultPlatform | daemon
workerKind workerPlatform | daemon
path-resolution-mirrors-@endo/where | daemon, tooling
ENDO_STATE_PATH ENDO_SOCK_PATH ENDO_EPHEMERAL_STATE_PATH ENDO_CACHE_PATH | daemon, tooling
PipeTransport ChannelTransport | daemon
fd 3 fd 4 pipes child process | daemon
std::sync::mpsc channel transport | daemon
sibling-design cycle 141 daemon-cas-management | daemon
status-Active design lifecycle | daemon
seven-distinct-design-lifecycle-statuses Complete Active Proposed Reference Not-Started Implemented In-Progress | daemon
Tier-1 borrowing three-worker-platforms | daemon, tooling
Tier-1 borrowing supervisor-is-transport-agnostic | daemon, tooling
Tier-1 borrowing graceful-downgrade | daemon
Tier-1 borrowing manager-must-be-co-resident | daemon
Tier-1 borrowing pool-of-machine-runner-threads | daemon
Tier-1 borrowing blocking-call-authorization-via-parent-tree | daemon
Tier-1 borrowing suspend-resume-via-CAS-streaming | daemon
Tier-1 borrowing unified-runner-four-mode-table | daemon
Tier-1 borrowing five-embedded-JS-bundles-via-include_str | daemon, tooling
70+ consecutive papers-lane blocks | daemon, tooling, hardened-javascript
@endo/netstring reader.js canonical netstring decoder | streams, patterns, captp
netstring format length colon data comma | streams, captp
self-delimiting binary protocol | streams, patterns
two-state-iterator state-machine | streams, patterns
waiting-for-length-prefix waiting-for-data | streams
state-encoded-as-lengthBuffer-null-or-not | patterns
zero-copy-fast-path subarray-instead-of-allocate | patterns
allocate-on-multi-chunk one-allocation-per-message | patterns
three-character-cases digit COLON anything-else | streams
pre-computed-byte-constants COLON COMMA ZERO NINE | streams
sanity-caps-defense-in-depth maxMessageLength maxPrefixLength | streams, patterns
comma-separator-validation sanity-check-length-was-honest | streams
dangling-message-detection at EOF | streams, patterns
four-pieces-of-context-per-error what actual-bytes offset name | patterns
async-generator-yields-as-it-decodes | streams, patterns
stream-in-stream-out | streams
back-pressure-via-await-of-next | streams
legacy-export-as-alias migration discipline | patterns
the-canonical-decoder netstring-protocol-family | streams, captp
Rust-supervisor-re-implements-byte-for-byte cycle 176 | streams, captp
Mathieu Hofman authored | streams
two-Hofman-authored-files ingested | streams
seventh-member small-files-with-large-knowledge-density | streams, patterns
small-files-with-large-knowledge-density 165 167 169 171 173 175 177 | streams, patterns
sixteenth file e56bf00f coordinated-update cluster | streams, captp
Tier-1 borrowing two-state-iterator-state-machine | patterns
Tier-1 borrowing zero-copy-fast-path | patterns
Tier-1 borrowing allocate-on-multi-chunk | patterns
Tier-1 borrowing sanity-caps-defense-in-depth | patterns
Tier-1 borrowing four-pieces-of-context-per-error | patterns
Tier-1 borrowing dangling-message-detection-at-EOF | patterns
71+ consecutive papers-lane blocks | streams, patterns, captp
daemon-xs-worker-snapshot suspend resume | daemon, persistence
snapshot-as-internal-implementation-detail | daemon, patterns
snapshot-not-user-visible-formula | daemon, persistence
suspend-only-when-idle | daemon, patterns
avoids-CapTP-reconnection-problem-entirely | daemon
transparent-resume-on-message | daemon, persistence
streaming-snapshot-to-CAS-not-in-memory | daemon, persistence
CAS-storage-with-ephemeral-GC-roots | daemon, persistence
callback-table-is-append-only | daemon, patterns
fxWriteSnapshot fxReadSnapshot XS heap snapshot | daemon
XS snapshot captures heaps chunks stack key name symbol tables | daemon
XS snapshot does NOT capture host function pointers context platform state debug | daemon
three-axes-of-snapshot-incompatibility XS version architecture callback table | daemon
signature-string-identifies-callback-table-version | daemon
two-state-machine Live Suspended | daemon, patterns
suspend suspended suspend-error restore four control verbs | daemon
all-payloads-UTF-8-text | daemon
big-data-through-filesystem small-coordination-through-envelopes | daemon, patterns
two-init-paths init restore one-entry-point | daemon, patterns
SHA-256-computed-on-the-fly streaming | daemon, persistence
atomic-rename-after-write | daemon, persistence
stable-indices-across-suspend-resume | daemon, patterns
phased-implementation Phase 1 Complete Phase 2 In Progress Phase 3 Future | daemon
revised-scope-discussion design-evolution | daemon, patterns
honest-design-evolution-record | daemon, patterns
sibling-design-pair feature-spec and substrate | daemon
cycle 162 Ken atomic-checkpoint at worker layer | daemon
72+ consecutive papers-lane blocks | daemon, persistence, patterns
lp32 length-prefix-framing host-byte-order | streams, captp
WebExtension Native Messaging stdio IPC | streams
host-byte-order-as-deliberate-IPC-marker | streams, patterns
DataView default-big-endian quirk | streams
runtime-endianness-probe Uint16Array trick | streams, patterns
single-growing-buffer doubling-capacity | streams, patterns
copyWithin in-place buffer shift | streams, patterns
Must allocate to support concurrent reads | streams, captp
slice-not-subarray correctness for concurrent reads | streams, patterns
1MB-default matches WebExtension spec | streams
symmetric-maxMessageLength-enforcement reader writer | streams, patterns
DOS-protection symmetric reader-writer | streams
per-message-allocation on write side | streams, patterns
single-shared-host-endian-constant avoids mismatch | streams, patterns
symmetric-asyncIterator-self-return type-compatibility | streams, patterns
dangling-message-error with offset diagnostic | streams
sibling-encoding-pair lp32 netstring | streams, patterns
implicit-state-machine length-at-offset-0 | streams, patterns
small-files-with-large-knowledge-density eighth-member | patterns
73+ consecutive papers-lane blocks | streams, patterns
designs-chat-alternation maintained 14 cycles | patterns
@endo/hex ponyfill hex encode decode | hardened-javascript, tooling
canonical-leaf-package-skeleton | hardened-javascript, patterns
sibling-package-cloned-file-for-file from base64 | patterns
design-after-implementation-as-ratification-discipline | patterns
ratification-by-design | patterns
deliberate-omission-not-oversight atob btoa shim | patterns
native-fallthrough-detection-bound-once-at-module-load | hardened-javascript, patterns
TC39 Uint8Array.prototype.toHex Uint8Array.fromHex | hardened-javascript
belt-and-suspenders-discipline SES lockdown | hardened-javascript, patterns
lowercase-default-with-uppercase-fallback-to-JS-path | patterns
error-rewrapping-at-the-native-boundary | hardened-javascript, patterns
stable-error-contract | patterns
audit-drives-scope mechanical-review | patterns
three-way-classification-of-sites migration boundary non-byte-array | patterns
test-files-included-in-audit | patterns
portability-by-removing-Node-specific-imports | patterns
boundary-sites-explicitly-named-and-defended | patterns
don't-pessimize-the-boundary | patterns
transitional-alias-pattern zero-flaky-window | patterns
add-if-a-consumer-asks YAGNI-with-extension-point | patterns
lockstep-sibling-design-discipline | patterns
honest-roadmap-calibration design-phase-after-implementation-phase | patterns
belt-and-suspenders-for-input-but-not-for-output | patterns
sibling-extract-pattern leaf-utility-package subsystem-package | patterns
canonical-Design-Decisions-format | patterns
fourteenth consecutive designs-chat alternation cycles 166-180 | patterns
74+ consecutive papers-lane blocks | patterns
@endo/base64 canonical leaf-package skeleton source | hardened-javascript, tooling
three-tier-dispatch native TC39 legacy XS pure JS | hardened-javascript, patterns
Reflect.apply captured at module load defensive binding | hardened-javascript, patterns
captured-Reflect.apply survives Function.prototype.call tampering | hardened-javascript, patterns
IIFE returns chosen impl bound to const at module load | patterns
nativeFromBase64Options lastChunkHandling strict alphabet base64 | hardened-javascript
strict-options-pinning-via-frozen-bag | hardened-javascript, patterns
native-error-fallback-via-polyfill-rerun | hardened-javascript, patterns
polyfill-as-error-oracle | patterns
use-polyfill-as-error-oracle | patterns
safety-net propagate native error if polyfill doesn't throw | patterns
adaptDecoder for legacy XS ArrayBuffer return | hardened-javascript, patterns
bit-register-quantum-accumulator | patterns
three-class-padding-switch | patterns
internal-bad-quantum sanity-throw | patterns
padding-acceptance-permissive-per-RFC-4648-§3.5 | patterns
don't-over-validate-by-default-with-RFC-citation | patterns
three-class-decode-errors invalid-char missing-padding trailing-garbage | hardened-javascript
Object.freeze-not-harden for pre-lockdown shim safety | hardened-javascript, patterns
pre-lockdown-shim-discipline | hardened-javascript, patterns
monodu etymology alpha beta mono duo | hardened-javascript
code-comment-as-vocabulary-instruction | patterns
reading-source-after-design-that-clones-it | patterns
ninth-member small-files-with-large-knowledge-density | patterns
75+ consecutive papers-lane blocks | patterns
designs-chat-alternation maintained 15 cycles 166-181 | patterns
daemon-xs-worker-debugger XS interactive debugger | daemon, hardened-javascript
six-layer-XML-pass-through-architecture | daemon, patterns
break-on-uncaught-via-firstJump-walk-before-fxJump | daemon, patterns
exploit-the-pre-jump-window-as-the-decision-point | patterns
zero-cost-if-the-answer-is-don't-break | patterns
xsbug-protocol XML SAX parser | daemon
mxDebug compile-time flag | daemon
always-compiled-dormant-by-default | daemon, patterns
hot-attach-via-debug-attach-envelope | daemon, patterns
XML-pass-through Rust as opaque byte ferry | daemon, patterns
fxConnect fxDisconnect fxIsConnected fxReceive fxSend platform hooks | daemon
thread-local-buffers with mutex __thread C11 | daemon, patterns
DebugSession SAX parser Jessie-compatible JS | daemon, hardened-javascript
Debugger exo CapTP-remotable | daemon, capability-security
followBreaks async iterator subscription | daemon, patterns
fxDebugThrow before fxJump | daemon
breakOnUncaughtExceptionsFlag | daemon
txJump linked list firstJump walk | daemon
uncaughtExceptions pseudo-breakpoint path | daemon
finally-without-catch as accepted-false-negative-for-v1 | daemon, patterns
three-option-architectural-decision-table | patterns
six-layer-strict-stratification | patterns
forward-compatible-protocol-extension | patterns
xs-worker-capability-trio snapshot debugger metering | daemon
no-`endo debug`-CLI CapTP-attachment-is-the-API | daemon, capability-security
sibling-design-pair worker capability extensions | daemon, patterns
sixteenth consecutive designs-chat alternation cycles 166-182 | patterns
76+ consecutive papers-lane blocks | patterns
@endo/init canonical bootstrap entry taxonomy | hardened-javascript, getting-started
@endo/lockdown wrapped lockdown sniffs LOCKDOWN_OPTIONS | hardened-javascript
two-phase-init pre commit | hardened-javascript, patterns
tolerance-ladder via separate entry-point files | hardened-javascript, patterns
index debug legacy unsafe-fast entry-point ladder | hardened-javascript
sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch | hardened-javascript, patterns
LOCKDOWN_OPTIONS global variable then environment variable | hardened-javascript
Initialization is often awkward design anchor | patterns
init-module-violates-normal-ocap-discipline | patterns, hardened-javascript
honest-confession-in-prose-comment | patterns
NOTE-TO-REVIEWERS-pattern two-polarities | patterns
commented-out-means-accident-in-debug-file | patterns
not-commented-out-means-accident-in-production-file | patterns
mechanical-review grep-friendly | patterns
domainTaming-unsafe-always-injected | hardened-javascript
named-hole-with-named-mitigation | patterns, hardened-javascript
resigned-to-leave-this-hole-open | patterns
post-lockdown-explicit-hardening | hardened-javascript
per-platform-availability-comments on harden calls | hardened-javascript, patterns
TextEncoder TextDecoder URL Base64 platform matrix | hardened-javascript
shim-assembly-order-as-load-bearing | hardened-javascript, patterns
canonical-Agoric-shim-stack lockdown base64 promise-kit eventual-send | hardened-javascript
DEPRECATED-with-redirect-comment | patterns
console-warn-on-discipline-violation | patterns
re-export-then-invoke discipline | patterns
import-as-side-effect-only vs import-the-function-without-running-it | patterns
seventeenth consecutive designs-chat alternation cycles 166-183 | patterns
77+ consecutive papers-lane blocks | patterns
tenth-member small-files-with-large-knowledge-density | patterns
daemon-xs-worker-metering computrons computation steps | daemon
admission-control-eliminates-embargo | daemon, patterns
budget-as-pre-payment-not-post-payment | daemon, patterns
three-mode-meter Measurement Quota Rate-limited | daemon, patterns
named-modes-as-discriminated-union | patterns
hard-limit-as-termination-not-pause | daemon
XS_TOO_MUCH_COMPUTATION_EXIT meterIndex fxBeginMetering | daemon
lazy-rate-limit-refill compute-on-demand | daemon, patterns
ready_time as tokio scheduling hint | daemon
burst-ceiling-prevents-budget-hoarding | daemon, patterns
structural-bound-not-runtime-decision | patterns
meter-config-once-not-per-crank | daemon, patterns
custom-fxAbort longjmp recoverable abort | daemon
fxRunPromiseJobsMetered setjmp guard | daemon
CRANK_LIMIT thread-local | daemon, patterns
meter-query meter-reset meter-set-quota meter-set-rate meter-refill meter-config meter-report | daemon
xs-worker-capability-trio snapshot debugger metering | daemon, patterns
exploit-a-pre-condition-to-eliminate-a-mechanism | patterns
three-mechanisms-eliminated by admission control invariant | patterns
design-evolution-record-in-prompt-section | patterns
key-insight-section names the realization explicitly | patterns
re-creation-from-snapshot makes hard-limit-termination acceptable | daemon
SuspendedWorker meter field round-trips through suspend resume | daemon
restore_meter last_refill recomputed to now on resume | daemon
avoid-crediting-idle-time-during-suspension | daemon, patterns
ready_time-as-single-wake-up-rather-than-polling | daemon, patterns
eighteenth consecutive designs-chat alternation cycles 166-184 | patterns
78+ consecutive papers-lane blocks | patterns
@endo/check-bundle hash verification | bundles, capability-security
powered-and-powerless-symmetric-pair | capability-security, patterns
ocap-discipline-via-explicit-power-injection | capability-security, patterns
three-public-function-progression powered-ness-axis | patterns
frozen-bundle-assertion Object.isFrozen | bundles, hardened-javascript
accessor-attacks getter property defense | bundles, capability-security
three-class-property-rejection no-getters no-non-strings | bundles, patterns
record-of-strings-only bundle shape | bundles
three-moduleFormat-cases endoZipBase64 getExport nestedEvaluate | bundles
not-necessarily-consistent across toolchain versions | bundles, patterns
parseArchive hash-of-hashes via compartment-mapper | bundles
parseLocatedJson wraps SyntaxError with file location | hardened-javascript, patterns
await-null-at-function-start async-rejection discipline | hardened-javascript, patterns
module-scoped-TextDecoder captured at module-load | hardened-javascript, patterns
gap-between-design-and-implementation | patterns
designs-are-guides-not-contracts | patterns
verify-against-source-not-design | patterns
boundary-site-migration-despite-design-prediction | patterns
checkBundle checkBundleBytes checkBundleFile | bundles
endoZipBase64 endoZipBase64Sha512 sha512 verification | bundles
@ts-check reference types ses TypeScript view | hardened-javascript
hash-of-hashes verification via compartment-mapper | bundles
canonical-powered-powerless-pair-pattern | capability-security, patterns
eleventh-member small-files-with-large-knowledge-density | patterns
nineteenth consecutive designs-chat alternation cycles 166-185 | patterns
79+ consecutive papers-lane blocks | patterns
break-dev-dependency-cycles synthetic test packages | repository-governance, tooling
sink-only-synthetic-test-packages | repository-governance, patterns
sink-only-is-the-load-bearing-constraint | patterns
package-downstream-of-SCC-cannot-extend-SCC | patterns
the-cycle-is-all-in-devDependencies | repository-governance, patterns
Tarjan-SCC-survey workspace dependency graph | tooling
illusion-of-an-option rejection language | patterns
fix-that-looks-like-cycle-break-but-only-renames-edge | patterns
Option-B-naming-convention subsystem-test alphabetical-adjacency | repository-governance, patterns
@endo/stream-types-test existing precedent | repository-governance
package-namespaced-test-conditions test-endo-foo | repository-governance, hardened-javascript
internal-only-test-surfaces via subpath exports | hardened-javascript
which-realm-owns-this-channel | patterns
duplication-preferred-over-indirection-that-creates-cycles | patterns
"I'm fine with duplication where necessary to avoid a utils package" | patterns
audit-as-cycle-break-precondition | patterns
review-iteration-archived-in-design | patterns
cuts-can-land-independently | repository-governance, patterns
recommended-order-smallest-to-largest by diff size | patterns
three-cited-costs-of-the-cycle cosmetic-noise silent-by-default cache-hash | repository-governance
@endo/ses-test @endo/hex-test @endo/harden-test @endo/eventual-send-test | repository-governance
turbo affected-set dependsOn ^build | tooling
dependencyTypes traversal restriction | tooling
literal-path-subpath-exports two-named-benefits | hardened-javascript
twentieth consecutive designs-chat alternation cycles 166-186 | patterns
80+ consecutive papers-lane blocks | patterns
shim-and-prepare-endo-cluster | eventual-send, hardened-javascript
two-shim-strategies-side-by-side | hardened-javascript, patterns
conditional-install respect-prior-correctness | patterns
unconditional-replacement of broken builtin | patterns
asymmetric-shim-discipline | hardened-javascript, patterns
BestPipelinablePromise globalThis.HandledPromise or Promise | eventual-send
pick-the-better-Promise-at-module-load | eventual-send, patterns
makePromiseKit three-step executor wrap harden | eventual-send
racePromises explicit-API paired with builtin replacement | eventual-send
considered-and-rejected releasing-executor alternative | patterns
isPromise Promise.resolve(x)===x realm-agnostic detection | eventual-send, patterns
postponedHandler interlockP shared await point | eventual-send, patterns
six-handler-traps converging on one promise | eventual-send
@ts-expect-error 2454 named issue number | hardened-javascript, patterns
don't-suppress-blindly-name-the-runtime-invariant | patterns
prepare-endo three-purpose lockdown env ava-wrap | testing, getting-started
default-export-masking-via-thin-re-import | patterns
comment-block-is-the-value | patterns
canonical-thin-barrel public-API-surface | patterns
AVA config require array default-export expectations | testing
TRACK_TURNS debug list track-turns | testing
SCC-member-cluster eventual-send promise-kit ses-ava | repository-governance
five-cycle-dependency-cluster | patterns
twelfth-member small-files-with-large-knowledge-density | patterns
twenty-first consecutive designs-chat alternation cycles 166-187 | patterns
81+ consecutive papers-lane blocks | patterns
daemon-rust-xs-performance benchmark investigation | daemon, tooling
three-variant-benchmark-as-bottleneck-triangulation | daemon, patterns
Node.js Rust+XS Rust+Node benchmark variants | daemon
fxHasPendingJobs check-and-reset latch | daemon
latch-not-counter read-once-consume-once | patterns
two-wrong-fixes-considered-and-rejected | patterns
1ms sleep pump loop performance penalty | daemon
three-phase-drain-loop | daemon, patterns
fxRunPromiseJobs loop until quiescence | daemon
subtle-final-check sendRawFrame queued jobs without envelopes | daemon, patterns
blocking-recv-deadlock | daemon
zero-sleep zero-polling correct-and-fast | daemon, patterns
off-by-one frame.sub(2+i) should be frame.sub(1+i) | daemon
XS-stack-frame-layout 64-bit LE 32-bytes-per-slot | daemon
mxArgv mxArgc mxThis macros | daemon
systematic-misreading fixed across 6 files | patterns
XS-block-scoping-with-eval+try/catch | daemon
inline-at-usage-site workaround | daemon, patterns
XS-engine-quirks-taxonomy | daemon, patterns
benchmark-numbers-cited-from-three-angles | patterns
4-remaining-optimization-opportunities | daemon
working-copy-inventory navigation-aid | patterns
designs-as-archives-of-in-progress-work | patterns
Active-status as living-investigation | patterns
seven-distinct-design-lifecycle-statuses Complete InProgress Proposed Active Reference Implemented NotStarted | patterns
ping 9.7x eval_warm 17.9x storeValue_lookup 26.6x | daemon
twenty-second consecutive designs-chat alternation cycles 166-188 | patterns
82+ consecutive papers-lane blocks | patterns
marshal-justin passableAsJustin diagnostic substrate | marshal
CLAUDE.md cites passableAsJustin not JSON.stringify | marshal, hardened-javascript
two-pass-decoder-with-mirror-control-flow | marshal, patterns
prepare validates recur renders | patterns
indenter-trait two-implementations makeYes makeNo | marshal, patterns
SGML-comment-injection-defense | marshal, patterns
badPair-detector regex angular-bracket | marshal, patterns
accidental-formation-of-html-like-comment | patterns
badArray-proxy rejecting-all-slot-positions | marshal
__proto__-bracket-escape | marshal, patterns
JSON vs JS prototype-set syntax | marshal
nestedRender try/finally-with-mutable-binding | marshal, patterns
qp template tag quasi-quoted Justin | marshal
qp-vs-q-template-tag-pair lazy redact vs eager unredact | marshal, errors
three-layer-defense for no-slot path | marshal, patterns
freeze-but-not-harden proxy target | hardened-javascript, patterns
throw is noop since Fail throws linter-workaround | patterns
TODO-in-comment names known-blockers | patterns
honest-uncertainty in source comment | patterns
eleven-qclass-cases decoder | marshal
three-fail-fast-error-cases unimplemented features | marshal
passableAsJustin four-step-flow | marshal
slot-numbering-not-identity-preserving s0 s1 s2 | marshal
Hilbert-Hotel round-trip preserved | marshal, pass-style
canonical-passable-rendering-pair | marshal
thirteenth-member small-files-with-large-knowledge-density | patterns
twenty-third consecutive designs-chat alternation cycles 166-189 | patterns
83+ consecutive papers-lane blocks | patterns
endo-posix-sandbox slice of POSIX-like system | daemon, capability-security
cap-not-string-mounts | capability-security, patterns
three-rule-security-boundary-clarity | capability-security, patterns
plugin-does-not-receive-daemon's-host-paths-power | capability-security, patterns
misconfig-is-error-not-relaxation | patterns
confused-deputy-named-explicitly | capability-security, patterns
pluggable-backend-driver-with-capability-blind-drivers | daemon, patterns
SandboxFactory SandboxHandle ProcessHandle MountHandle | daemon, capability-security
bwrap podman lima containerization wsl five drivers | daemon
six-position-network-confinement-ladder | daemon
private-network RFC-1918-blocklist CGNAT link-local IPv6-ULA host-loopback | daemon
PATH-synthesis-from-rootfs-shape | daemon
host-bind mount minimal oci four rootfs modes | daemon
five-forbidden-PATH-prefixes home Users root tmp var-tmp run-user | daemon
anti-shadowing-rule caller-mounts-after-rootfs-derived | daemon, patterns
caller-supplied-env.PATH-always-wins over synthesis | daemon, patterns
living-phase-list-records-its-own-renumbering | patterns
Phase 5 intentionally absent folded into Phase 4 | patterns
supersedes-record-pattern with three-improvements | patterns
source-mirror-to-PLAN with named-update-protocol | patterns
two-documents-with-named-authoritative-source | patterns
update-protocol-named-explicitly avoiding two-documents-drift | patterns
four-handle-capability-surface lifecycle-decomposition | capability-security, patterns
GC-pinning-and-disposal-protocol SIGTERM-grace-SIGKILL | daemon, patterns
five-cross-phase-invariants test-discipline | patterns
plugin-explicitly-refuses-power-it-could-have | capability-security, patterns
six-non-goals-explicitly-named | patterns
non-goals-discipline as scope-clarification-via-negation | patterns
additional-defense-not-primary-boundary | capability-security
genie-integration-as-workspace-not-tool-surface | daemon
GENIE_WORKSPACE slice-internal path | daemon
kernel-feature-probing uid_map max_user_namespaces | daemon
podman-image-PATH-injection podman-create | daemon
twenty-fourth consecutive designs-chat alternation cycles 166-190 | patterns
84+ consecutive papers-lane blocks | patterns
@endo/zip store-only zip substrate | bundles, tooling
WeakMap-private-fields-with-bound-get | hardened-javascript, patterns
module-load-capture-of-primitive-method | hardened-javascript, patterns
asymmetric-defense-based-on-construction-invariant | patterns
pre-pasted-pako-crc32-with-attribution-comment | patterns
audit-trail-in-source for borrowed code | patterns
three-element-attribution-comment source license URL | patterns
IE10-defense-comment-for-historical-ghost | patterns
don't-silently-remove-defenses-for-dead-platforms | patterns
historical-ghost-defense-with-named-rationale | patterns
STORE-only-zip implicit-non-goal | bundles
scope-limitation-named-in-tiny-file | patterns
u-helper ASCII-to-Uint8Array | bundles, patterns
six-canonical-zip-signatures PK\x03\x04 | bundles
LOCAL_FILE_HEADER CENTRAL_FILE_HEADER ZIP64 | bundles
five-state-BufferReader bytes data length index offset | bundles, patterns
offset+index-pair sub-window-without-copying | bundles, patterns
doubling-capacity-with-DataView-rebuild | patterns
assertNatNumber Number.isSafeInteger | patterns
DOS-date-time-six-bit-fields | bundles
Ralph-Brown-Interrupt-List @see URL | bundles
year-offset-1980 seconds-at-2-second-precision | bundles
isEncrypted bit-flag detection | bundles
MAX_VALUE_16BITS MAX_VALUE_32BITS ZIP64 awareness | bundles
read-tolerant-write-strict Postel's law | patterns
benchmarked-decision-named-in-comment | patterns
fourteenth-member small-files-with-large-knowledge-density | patterns
twenty-fifth consecutive designs-chat alternation cycles 166-191 | patterns
85+ consecutive papers-lane blocks | patterns
daemon-engo-supervisor Go supervisor unrealized predecessor | daemon
unrealized-predecessor-of-cycle-176 | patterns
implicit-supersedes neither design records relationship | patterns
when-pivoting-architectures-write-an-explicit-Supersedes-record lesson | patterns
three-architecture-diagrams current target future | patterns
visualize-the-transition each stage complete and runnable | patterns
-platform.js + -platform-powers.js naming convention | daemon, patterns
four-file-quadruple-per-platform daemon daemon-powers worker worker-powers | daemon
near-copies-with-channel-adapted migration-path | patterns
progressive-syscall-migration with named priority order | daemon, patterns
fs-first net-second crypto-third most-impactful-first | daemon
Phase 4 unbounded migration | patterns
incrementalism-as-the-key-constraint | patterns
rollback-trivial preserve existing alongside new | patterns
two-implementations-coexist | patterns
five-phase-incremental-implementation with Validation-per-phase | patterns
process-tree-inspection-via-ps test discipline | patterns
handle-rewriting sender field implicit in asymmetry | daemon, patterns
spawn-tree-deadlock-prevention canBlock check | daemon, patterns
sync-from-child-to-ancestor-or-control-plane | daemon, patterns
async-messages-always-permitted | daemon, patterns
CBOR-with-4-byte-big-endian-length-prefix | daemon
big-endian-for-cross-language-IPC | daemon, patterns
fxamacker/cbor/v2 Go library | daemon
cbor-x @ipld/dag-cbor Node.js libraries | daemon
out-of-scope-but-architecture-supports-it | patterns
unix-socket-at-the-same-path supervisor transparent to client | daemon, patterns
substantial-DNA-inherited-by-endor | daemon
what-changed-in-the-pivot Rust-instead-of-Go | patterns
web-future-architecture-pair dashes-for-worker-entries | patterns
twenty-sixth consecutive designs-chat alternation cycles 166-192 | patterns
86+ consecutive papers-lane blocks | patterns
inescapable-Compartment-wrapper-pattern | compartments, hardened-javascript
wrapInescapableCompartment three-named-requirements | compartments
dual-signature-compatibility via __options__ sigil | compartments, patterns
positional vs options-bag migration | patterns
three-detection-branches zero new old | patterns
two-double-binding-asserts modules-and-globals | patterns
new.target===undefined throw constructor-only-discipline | hardened-javascript, patterns
Reflect.construct subclass-forwarding | hardened-javascript, patterns
propagate-the-wrapper-via-globalThis-Compartment-reassignment | compartments, patterns
prototype-aliasing for instanceof-preserving | hardened-javascript, patterns
SECURITY-NOTE-prefix greppable security-disclosure-comments | patterns
non-SES-leak c.prototype.constructor untamed | compartments
"Kris says" attribution-in-source | patterns
"hard-to-fix-until-rewrite" honest-deferral | patterns
Reflect.ownKeys full-key-enumeration symbols non-enumerable | hardened-javascript, patterns
TC39 Compartments YouTube discussion URL-attribution | patterns
four-named-deviations from longer-term-agreement | patterns
writable-true configurable-true enumerable-false globalThis-properties | hardened-javascript
inescapable-defense-via-reinstall-per-Compartment-not-pin | compartments, patterns
co-located-design-doc-pattern package-level | patterns
NewCompartment-as-local-name Compartment-as-function-name | hardened-javascript, patterns
preserve-.name-via-function-name lint-friendly-shadowing | patterns
named-TODO-with-shape-of-future-fix-sketched | patterns
imposed-transforms-must-appear-at-the-end | compartments, patterns
order-matters-for-non-override | patterns
swingset dynamic vats canonical consumer | compartments
first-pivot-this-session loopback-already-ingested-cycle-158 | patterns
twenty-seventh consecutive designs-chat alternation cycles 166-193 | patterns
87+ consecutive papers-lane blocks | patterns
daemon-endo-rust-sqlite SQLite host functions for XS | daemon, persistence
passable-by-construction-discipline | daemon, capability-security
five-SQLite-types five-canonical-passable-JS-types | persistence
INTEGER-always-bigint avoids precision loss | persistence
BLOB-as-Uint8Array-not-sentinel | persistence
$bigint $bytes FFI tags confined to internal plumbing | persistence
strictest-default-removes-a-mode-flag | patterns
re-prepare-instead-of-caching-Statement | persistence, patterns
self-referential-borrow workaround | patterns
store-the-recipe-not-the-instance | patterns
STMT_MAP DB_MAP handle maps | persistence
explicit-lock-ordering-discipline | patterns
nine-host-functions CRUD surface | persistence
sqliteOpen sqliteClose sqliteExec sqlitePrepare sqliteStmtRun sqliteStmtGet sqliteStmtAll sqliteStmtColumns sqliteStmtFinalize | persistence
three-pragma-bundle WAL foreign_keys busy_timeout | persistence
WAL-mode-by-default concurrent reads daemon + GC scan | persistence
two-step-cleanup-with-retain-cascade | patterns
explicit-finalize-instead-of-GC XS host handles | persistence
transactions-via-exec lean-API-discipline | persistence, patterns
rusqlite bundled feature self-contained-binary | persistence
~2MB binary ~30s first build honest-cost-disclosure | patterns
synchronous-JS-API matches node:sqlite DatabaseSync | persistence
nine-Design-Decisions canonical format | patterns
six-implementation-phases all Complete | patterns
Phase-1-validates-toolchain-before-source | patterns
Phase-N-integration-test-with-key-correctness-property | patterns
Supersedes-field-in-metadata explicit-prior-relationship | patterns
cycle-192-lesson-learned applied via metadata field | patterns
twenty-eighth consecutive designs-chat alternation cycles 166-194 | patterns
88+ consecutive papers-lane blocks | patterns
@endo/cli utility cluster six tight helpers | tooling
designs-are-guides-not-contracts confirmed-twice | patterns
verify-against-source not verify-against-design | patterns
two-of-two-audit-boundary-sites migrated | patterns
parsePetNamePath dot-delimited path parsing | tooling
empty-segment-rejection in dot-delimited paths | patterns
parseOptional-variant-pattern undefined-passthrough | patterns
@-mention-format/parse-pair | tooling
@-escape-via-backslash | tooling, patterns
@-mention-regex 128-char-max | tooling
five-properties-of-the-regex | patterns
example-comments-in-source-not-tests | patterns
parseBigint strict-regex non-negative integer | tooling, patterns
randomHex16 promise-wrap-Node-callback-API | tooling
128-bit-output 16-bytes 32-hex-chars | tooling
async-readline-prompt trim-and-toLowerCase | tooling
single-shot-cleanup rl.close in callback | tooling
one-purpose-per-file no-internal-dependencies | patterns
implicitly-tested-by-the-CLI-itself | patterns
audit-table-row-23 check-bundle migrated | patterns
audit-table-row-32 cli-random migrated | patterns
greppable-check beats reading-audit | patterns
mechanical-grep-and-replace-pass audit-didn't-anticipate | patterns
twenty-ninth consecutive designs-chat alternation cycles 166-195 | patterns
89+ consecutive papers-lane blocks | patterns
library-reaches-700-sections at cycle 195 | patterns
parity-comparison-as-design-document-genre | patterns
thirteen-feature-categories with status-matrix | patterns
five-status-tags (Complete / Available / Designed / Not designed / Not planned) | patterns
honest-architectural-difference-named-at-design's-opening | patterns
ambient-vs-object-capability architectural axis | capability-security
gap-priority-classification (High / Medium / Low) | patterns
three-named-attacks paired with three-structural-defenses | capability-security
symmetric-attack/defense-enumeration | capability-security
seven-Endo-specific-advantages with one-line-explanation | patterns
inline-co-author-quote-blocks for editorial-disagreement-preserved | patterns
three-rename-history (OpenClaw / ClawdBot / Moltbot) in parenthetical-aside | patterns
Reference-status-with-Related-Designs-hub-and-spoke-navigation | patterns
explicit-scope-refusal-at-table-level (Not planned tag) | patterns
markdown-reference-style-for-external-link-attribution | patterns
Available-vs-Complete subtle-distinction | patterns
thirtieth consecutive designs-chat alternation cycles 166-196 | patterns
library-reaches-701-sections at cycle 196 | patterns
three-layer-dispatch-chain-as-imperfect-ponyfill | patterns
Eval Twin Problem (endojs/endo#1583) | capability-theory
Eval-Twin-defense-via-registered-symbol | patterns
PanicEndowmentSymbol modeled on PassStyleOfEndowmentSymbol | patterns
infinite-regress-defense via thisFn !== globalThis.fn | patterns
throw-rather-than-infinite-loop with reasoned justification | patterns
ponyfill-vs-shim distinction with two-stage-rollout-discipline | patterns
two-identity-checks with named-tradeoffs (forgeable+twin-safe vs non-forgeable+twin-vulnerable) | patterns
prepare-commit-transactional-pattern with panic-as-mid-commit-escape | patterns
default-erroneous-exit + no-ambient-normal-exit asymmetry | capability-security
"no-further-loss-in-security" historical-note rationale | patterns
two-thirds-prose-one-third-code comment density | patterns
caveat-emptor-at-the-end of README | patterns
TC39 "Don't Remember Panicking" proposal | references
freeze-but-not-harden preparing-for-stabilize-doc | patterns
cross-package-composition optional upgrade path | patterns
roadmap-in-the-README with what-blocks-them | patterns
Eval-Twins-as-the-shim-coordination-mechanism (first-to-load-wins-and-installs) | patterns
small-files-with-large-knowledge-density seventeenth-member cycle 197 | patterns
thirty-first consecutive designs-chat alternation cycles 166-197 | patterns
library-reaches-702-sections at cycle 197 | patterns
three-revision-pivots-visible-in-Prompt-section | patterns
the-data-is-already-there-just-locked discovery | patterns
non-throwing-matcher-mirroring-`matches`-shape | patterns
opt-in-submodule-with-cost-asymmetry | patterns
submodule-not-sibling-package (avoids drift-vs-stable-internal-surface tension) | patterns
rich-not-configurable rendering convention | patterns
Rust-compiler-error-analogy cited prior art | references
all-alternatives-reported-no-closest-alternative-heuristic | patterns
two-consumer-postures (library users + AI agents) | patterns
AI-agents-cannot-walk-the-specimen-interactively | patterns
default-favors-the-tighter-budget-consumer (AI-agent token economy) | patterns
compact-default + expanded-opt-in | patterns
pipe-separated-columns `path | found | expected | reason` not JSON-Lines | patterns
ASCII not unicode for terminal/log/CI compatibility | patterns
tracing-recursion-reuses-helpers-in-place (one source of matcher truth) | patterns
seven-trace-step-kinds discriminated-union | patterns
each-Design-Decision-names-the-alternative-it-rejected | patterns
nine-Design-Decisions canonical format | patterns
single-PR-scope-despite-three-revision-rounds (each round was simplification) | patterns
explicit-no-predecessors-row in Dependencies table | patterns
negative-space-as-record | patterns
single-Open-Question-discipline as design-maturity-signal | patterns
the-gap-is-render-not-record | patterns
drift-elimination-by-co-location | patterns
each-review-round-was-a-simplification | patterns
discovery-driven-redesign (build a renderer that reads what already exists) | patterns
applyLabelingError SES annotateError chain unreachable to programmatic readers | references
thirty-second consecutive designs-chat alternation cycles 166-198 | patterns
honest-design-evolution-record family ninth-member cycle 198 | patterns
library-reaches-703-sections at cycle 198 | patterns
classic-uncurry-this-via-bind.bind(bind.call) | patterns
capture-the-prototype-not-the-instance | patterns
sync/async-two-color-sharing-via-generator-trampoline | patterns
generator-throw-send-error-into-generator | patterns
eslint-discipline-aware-exceptions-with-file-local-comment | patterns
encapsulated-pumpkin-sentinel (harden({}) must not escape module) | patterns
one-sentinel-three-purposes | patterns
four-tier-safety-hierarchy (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel) | patterns
contingent-safety-framing | patterns
throws-not-memoized + rejected-promises-***are***-memoized | patterns
determinism-with-fresh-identity-allowance | patterns
passStyleOf as cited canonical memoize-user | references
Apps-Script-bigint-literal-workaround | patterns
explicit-narrowing ("not in general trying for compat but...") | patterns
freeze-as-harden-substitute pending PR #3008 | patterns
named-equivalence-rationale (freeze == harden on unadorned arrow functions) | patterns
two-different-error-types (TypeError wrong-kind vs RangeError right-kind-wrong-value) | patterns
coerce-to-bigint-on-success | patterns
safely-representable-IEEE-754-integer-discipline | patterns
skippable-detail-tag as explicit-named-skip-marker | patterns
comment-block-duplicated-verbatim above sibling exports | patterns
harden-the-factory-and-the-products | patterns
minimal-dependency-discipline (the marshal aspiration) | patterns
three-different-approaches-to-the-same-harden-discipline | patterns
small-files-with-large-knowledge-density eighteenth-member cycle 199 | patterns
the-Eval-Twin-Problem is load-bearing across the @endo substrate | patterns
thirty-third consecutive designs-chat alternation cycles 166-199 | patterns
library-reaches-704-sections at cycle 199 | patterns
engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting | patterns
host-compartment-vs-guest-compartment-split-with-cap-std-backed-powers | patterns
three-numbered-problems-each-with-named-defense | patterns
ASCII-architecture-diagram-with-three-process-boxes | patterns
cap-std-as-the-capability-substrate at syscall level | patterns
in-process-host-functions-not-IPC | patterns
worker-process-not-supervisor-process | patterns
heterogeneous-workers-via-byte-identical-envelope-layer | patterns
pre-compiled-bytecode-for-Endo-modules | patterns
L/M/S-effort-sizing-per-phase | patterns
Known-Gaps-instead-of-Open-Questions (checkbox-task-list format) | patterns
SharedArrayBuffer-deferred-with-named-condition | patterns
Prompt-section-preserves-discard-prior-design-narrative | patterns
foundational-design-with-Known-Gaps-that-spawn-sibling-designs | patterns
engine-speed-matters-less-than-confinement-correctness | patterns
the-XS-worker-family (cycles 176/178/182/184/188 build on cycle 200's worker-rust-xs) | references
the-supplant-pattern (worker-rust-xs Not Started → daemon-endor-architecture Active) | patterns
grep-by-source-page-existence-not-section-file-pattern (library protocol) | patterns
short-slug-section-files (rpn--, hurl--) don't share substring with full-design-name | patterns
two-pivots-this-cycle (retention-path-notation + hardened-url-shim already ingested) | patterns
cycle-200-milestone | patterns
thirty-fourth consecutive designs-chat alternation cycles 166-200 | patterns
library-reaches-705-sections at cycle 200 | patterns
Ponyfill+Shim-full-version (sibling to cycle 197 panic's ponyfill-only) | patterns
Purposeful-Violation-section-in-README | patterns
concordance-sniff-defense via Symbol.toStringTag | patterns
WeakMap-as-emulated-private-field-AND-brand-check | patterns
three-different-ways-to-emulate-private-state in JavaScript across @endo | patterns
method-binding-pre-defineProperty (avoid post-hoc prototype lookups) | patterns
intermediate-prototype-inheriting-from-host-prototype | patterns
five-throw-methods + six-getter-overrides on intermediate-prototype | patterns
slice-stays-mutable-vs-sliceToImmutable | patterns
brand-check-via-`getBuffer(this)`-on-every-accessor | patterns
three-tier-fallback (transfer → structuredClone → undefined) | patterns
three-platform-degradation (Hermes / Node ≤16 / some JavaScriptCore) | patterns
zero-length-slice-as-genuine-ArrayBuffer-enforcement | patterns
capture-before-scuttled (pre-lockdown discipline) | patterns
belt-and-suspenders-freeze on must-not-escape factory | patterns
modern-shim-practice-frowns-on-conditional-installation | patterns
shim-still-runs-after-native-implementation (deliberate-policy-with-named-future-cleanup-step) | patterns
warning-not-error-when-overwriting | patterns
two-named-motivations-from-orthogonal-domains | patterns
ROM-vs-RAM Moddable XS rationale | references
by-copy network protocol rationale (Endo pass-style + marshal) | references
plain-JavaScript-not-Hardened-JavaScript-disclaimer | patterns
encapsulated-genuine-ArrayBuffer-with-exclusive-access | patterns
six+-named-Caveats as honest-enumeration-of-limitations | patterns
small-files-with-large-knowledge-density nineteenth-member cycle 201 | patterns
thirty-fifth consecutive designs-chat alternation cycles 166-201 | patterns
library-reaches-706-sections at cycle 201 | patterns
three-input-forms-converging-on-one-runtime-path | patterns
input-form-detection-by-magic-bytes-not-flags (PK\x03\x04 ZIP magic) | patterns
three-option-implementation-with-rejected-option-named | patterns
shell-out-to-Node rejected ("defeats the purpose") | patterns
self-contained-binary-as-design-axiom | patterns
reuse-battle-tested-code-via-running-it-inside-the-target-engine | patterns
XS-hosted-mapper reusing battle-tested @endo/compartment-mapper | references
two-phase-flow (map-in-XS-then-execute-in-fresh-XS) | patterns
two-machines-of-the-same-engine for two-different-capability-scopes | patterns
lazy-module-loading-from-CAS-by-hash-on-demand | patterns
root-hash-printed-to-stderr-for-re-run | patterns
standalone-mode-when-no-daemon | patterns
backward-compatibility-via-flag with named use case (--no-cas) | patterns
Status-section-with-completed-phases-and-code-paths-named | patterns
five-Implementation-Phases each with named test cases per phase | patterns
three-dependencies-with-named-relationship-types (Requires / Enables / Extends) | patterns
CAS-as-universal-backing-store (Design Decision 1) | patterns
honest-cost-disclosure with form-factor-context | patterns
expensive-ingestion-with-cheap-retrieval (the-hash-becomes-the-handle) | patterns
thirty-sixth consecutive designs-chat alternation cycles 166-202 | patterns
library-reaches-707-sections at cycle 202 | patterns
the-CLI-layer-counterpart-to-the-endor-worker-architecture-cluster (cycle 202) | references
bounded-size-cache-with-WeakMap-compatible-interface | patterns
makeMap-option-as-key-strategy (weak vs strong via WeakMap or Map) | patterns
try-as-factory-fall-back-to-constructor | patterns
doubly-linked-ring-with-sentinel-head | patterns
sentinel-head-that-throws-on-direct-access | patterns
touch-moves-to-first; LRU-evicts-last | patterns
LRU-or-better-eviction (CLOCK / SIEVE as named alternatives) | patterns
each-cell-holds-a-SingleEntryMap with three-strategy-cascade for reset | patterns
UNKNOWN_KEY local-symbol sentinel | patterns
"delete" is a keyword idiom (object-literal-then-destructure-with-rename) | patterns
deepCopyJsonable + freezingReviver (one-pass deep-clone-with-freeze) | patterns
metrics-via-defensive-clone-on-read | patterns
TODO-comments-with-citations (Ben-Haim/Tom-Tov streaming histograms) | patterns
WeakCacheMap-vs-CacheMap toStringTag discrimination | patterns
cells-not-frozen-because-closely-encapsulated | patterns
capacity-bounded-strict with implicit-upper-bound-named in error | patterns
don't-establish-entry-until-prior-steps-succeed | patterns
seven-freezes (each method + implementation + kit + factory) | patterns
kit-pattern with named-object-properties | patterns
WeakMap-instances-must-be-replaced-when-key-unknown (information-theoretic limit) | references
four-different-sentinel-shapes in @endo (local-symbol / registered-symbol / pumpkin / WeakMap) | patterns
small-files-with-large-knowledge-density twentieth-member cycle 203 | patterns
implementation-flexibility-via-bounded-quality-promise | patterns
thirty-seventh consecutive designs-chat alternation cycles 166-203 | patterns
library-reaches-708-sections at cycle 203 | patterns
removed-feature-preservation-document genre (design-as-archaeology) | patterns
Removed-Files table with named-role-per-file | patterns
distinguishing-extension-point-from-extension-content | patterns
Architecture-Overview-with-N-layers | patterns
uniform-Detailed-Component-Descriptions-template (Entry / Handler / Arguments / Flow / Code-snippets) | patterns
Patterns-Worth-Preserving section with reusable-shape per pattern | patterns
the-`specials`-extension-point | references
CapTP-over-WebSocket via map-writer/map-reader composition | references
hostname-based-dispatch with handler-pair-per-hostname + cleanup-on-cancellation | patterns
access-token-derivation-from-formula-ID (first-32-chars) | patterns
deterministic-unforgeable-token-without-additional-state | patterns
per-key-next-allowed-timestamp-with-lazy-sweeping (minimal rate-limiter) | patterns
Promise.race-between-transport-close-and-CapTP-close | patterns
connection-lifecycle-tracking with await-all-on-cancellation | patterns
collectPropsAndBind-for-browser-endowment-collection | patterns
Note-on-the-Next-Rendition (forward-looking-shape-without-commitment) | patterns
@webs-as-directory-of-pet-named-web-applications | references
readable-tree-as-content-addressed-static-content | references
Prompt-section-preserves-removal-instruction | patterns
honest-self-critique-in-design-archaeology | patterns
twelfth-honest-design-evolution-record-member (deleted-code's-shape-preserved) | patterns
three-different-shapes-of-unrealized-design (never-shipped / discarded-mid-design / shipped-then-removed) | patterns
three-different-purposes-for-Reference-status (inventory / pre-emptive-supersedes / post-removal-archaeology) | patterns
convergence-on-content-addressed-storage in the endor family (cycles 178/202/204) | patterns
thirty-eighth consecutive designs-chat alternation cycles 166-204 | patterns
library-reaches-709-sections at cycle 204 | patterns
SES-censorship-evasion (named design purpose) | patterns
six-evasion-strategies toolkit (evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + evadeComment/elideComment) | patterns
three-problematic-sequences (import\s*\( + <!-- + -->) | references
comment-defanging-with-three-patterns + end-of-comment-marker-defense (*/ → *X/) | patterns
HTML-comment-in-code-edge-case (x-->y → (0,x--)>y) via SequenceExpression-wrap | patterns
meaning-preserving-lexical-sequence-breaker | patterns
adoptStartFrom-with-zero-width-end | patterns
JSON-roundtrip-to-sever-references (deep-clone for serializable data) | patterns
try/catch-purely-opportunistic | patterns
sync-and-async-API-pair with trivial-async-wrapper | patterns
three-overloads-with-JSDoc-narrowing based on option-presence | patterns
Babel-traverse-default-import-workaround (babelTraverse.default || babelTraverse) | patterns
customVisitor escape-hatch (library extensibility without forking) | patterns
comment-preservation-via-magic-prefix (! prefix industry-convention) | patterns
four-JSDoc-tags (@preserve / @copyright / @license / @cc_on) | references
elideComment-vs-evadeComment two-mode (defang vs strip with column-stability) | patterns
coerces-all-comments-to-CommentBlock | patterns
honest-deferred-work-named-with-PR-discussion-citation | patterns
inline-typedef-deprecation-marker as zero-friction-deprecation-signal | patterns
one-purpose-per-file with named-inter-file-dependencies (layered module pattern) | patterns
homoglyphs-for-@kriskowal source-comment-affectionate-joke | references
nine-cycles-now-addressing-SES-related-defenses-or-accommodations across nine axes | patterns
SES-defense-family in the library | patterns
small-files-with-large-knowledge-density twenty-first-member cycle 205 | patterns
thirty-ninth consecutive designs-chat alternation cycles 166-205 | patterns
library-reaches-710-sections at cycle 205 | patterns
one-button-two-functions (UI density when affordance and status are conceptually related) | patterns
five-state-color-coding (Live/Settled/Pending/Not-incarnated/Cancelled) | patterns
confirm-on-cancel via two-click-3-second-timeout (lightweight alternative to modal) | patterns
deletion-and-cancellation-distinct (naming-operation vs lifecycle-operation) | patterns
pin-as-GC-anchor (pinned capabilities survive pet name deletion via PINS directory) | patterns
disabled-but-still-shown for uncancellable-substrate-capabilities | patterns
coalesced-watcher-protocol (canonical solution to N+1 subscription problem) | patterns
client-mutates-watched-set + server-filters-transitions | patterns
three-method-API (watch + unwatch + watchAll batch) | patterns
E.sendOnly fire-and-forget for state-update-without-round-trip-latency | patterns
watch(id)-immediately-publishes-current-status (initial-value-on-subscribe) | patterns
watcher-scoped-to-agent's-own-pet-store (capability discipline) | patterns
single-watcher-per-component-tree with automatic-GC-on-unmount | patterns
four-lifecycle-hooks (provide / cancel / settle / initial-on-watch) | patterns
single-CapTP-async-iterator carries all transitions | patterns
N+1 subscription problem named-explicitly | references
ASCII-art-as-design-prose for UI mockup | patterns
additive-API + reuse-existing-mechanism | patterns
Upgrade-Considerations-section with named concerns | patterns
design-consolidation-recorded-in-Prompt-section | patterns
honest-design-evolution-record family thirteenth-member (consolidation shape) | patterns
collapse-many-API-instances-into-one principle (sibling to cycle 198) | patterns
centennial-milestone for papers-lane-block (cycle 206) | patterns
fortieth consecutive designs-chat alternation cycles 166-206 | patterns
library-reaches-711-sections at cycle 206 | patterns
pre-SES-prelude-with-cheap-good-enough-imitations | patterns
named-end-prelude-marker (`// end prelude`) | patterns
cannot-depend-on-SES-discipline (for packages that load earlier than SES) | patterns
two-banner-comment-bookends for prelude section | patterns
Reflect.apply-form-of-uncurryThis (readable alternative to bind.bind.bind.call) | patterns
two-different-uncurryThis-shapes in @endo (Reflect.apply vs bind.bind(bind.call)) | references
locally-imitated-Fail-template-tag | patterns
makeEnvironmentCaptor factory with entangled-pair return | patterns
defensive-clone-on-read (fresh frozen snapshot on every call) | patterns
three-tier-API (scalar / list / predicate) with single-source-of-truth | patterns
string-only-restriction-for-data-not-authority (named security invariant) | patterns
exhaustive-allowed-strings-list-with-default-prepended-in-error | patterns
default-binding-for-simple-case + factory-for-advanced-case (two-tier-API-shape) | patterns
dropNames-parameter to opt out of name-tracking | patterns
README-opens-with-conceptual-frame (naming the design space) | patterns
three-namespace-parameterization-frame (global / import / host hooks) | references
worked-example-of-canonical-consumer-pattern (SES Lockdown environment-variable diagnostic warning) | patterns
compat-note-with-issue-citation (Agoric/agoric-sdk#8096 for DEBUG colon-split) | references
test-migration-note (tests moved to @endo/ses-ava to break cycles) | patterns
localThis-aliased-globalThis with named eslint-disable | patterns
SES-defense-family ten cycles (175/183/197/199/200x2/201/203/205/207) | patterns
small-files-with-large-knowledge-density twenty-second-member cycle 207 | patterns
forty-first consecutive designs-chat alternation cycles 166-207 | patterns
library-reaches-712-sections at cycle 207 | patterns
The-Powers-Problem with three-option-analysis | patterns
three-options-enumerated each with named-drawbacks-and-benefits | patterns
resolution-with-named-reasons-for-acceptability | patterns
self-provisioning-from-@endo-powers-to-guest-powers | patterns
brief-bootstrap-window-with-full-authority-acceptable with three-named-mitigating-factors | patterns
Current-Architecture-section-before-Design-section | patterns
Dependency-Analysis-table-with-named-conclusion | patterns
SES-Compatibility-section-with-CLAUDE.md-quoted-constraint | patterns
environment-variable-gating for dev-vs-packaged asymmetry | patterns
auto-incarnation-mirroring-@apps-pattern | patterns
idempotent-provisioning (provideGuest returns existing) | patterns
First-Run-Experience-section as explicit user journey | patterns
Interaction-with-sibling-design-section + explicit-composition-narrative | patterns
Files-Modified-table with named change per file | patterns
extension-point-survives-removal-of-its-content (specials reused in cycle 208 after cycle 204 weblet removal) | patterns
three-different-shapes-for-recording-rejected-alternatives (cycle 198 interleaved / cycle 200 collected / cycle 208 three-option-analysis) | patterns
forty-second consecutive designs-chat alternation cycles 166-208 | patterns
library-reaches-713-sections at cycle 208 | patterns
Shortlex-ordering (Wikipedia-cited formal name) | references
three-tier-comparison (length / cumulative-length / lexicographic UTF-16) | patterns
multi-tier-comparison-with-named-reasons + early-return-per-tier | patterns
undefined-compares-greater-than-anything-else | patterns
multiple-mermaid-diagrams-with-worked-examples-each-demonstrating-one-tier | patterns
honest-Note-about-surprising-defaults (UTF-16 code unit order may be surprising) | patterns
sanity-check-with-c8-ignore-comment | patterns
JSDoc-callback-typedef-with-generic-T (CompareFn<T> reused for both exports) | patterns
building-block-and-derived-form (stringCompare + pathCompare) | patterns
name-the-canonical-consumer in README | patterns
algorithm-numbered-steps-in-JSDoc | patterns
shortlex-discipline-at-two-levels-of-the-stack (cycle 200 retention-path + cycle 209 path-compare) | patterns
three-different-visualization-conventions for design-explanation (mermaid / ASCII-architecture / ASCII-visual-layout) | patterns
small-files-with-large-knowledge-density twenty-third-member cycle 209 | patterns
forty-third consecutive designs-chat alternation cycles 166-209 | patterns
library-reaches-714-sections at cycle 209 | patterns
three-layer-lifecycle (Setup-script / Manager-agent / Worker-loops) | patterns
ASCII-diagram-of-fan-out-pattern | patterns
Architectural-Constraint-named-in-section-header | patterns
Guest-cannot-create-guests (provideGuest is on EndoHost not EndoGuest) | references
introducedNames-@agent-as-consent-boundary | patterns
form-submission-as-consent-mechanism (existing-user-action-as-consent) | patterns
inbox-as-durable-config-store | patterns
followMessages-replays-all-historical-messages-on-restart | references
provideGuest-is-idempotent | references
no-explicit-config-persistence-needed (when operations idempotent + substrate supports replay) | patterns
per-worker-provider (different workers can use different LLM models) | patterns
manager-worker-split discipline with three-named-benefits | patterns
shared-form-fields between Lal and Fae | references
four-form-fields (name / host / model / authToken) | references
three-Alternatives-Considered each rejected with named reason | patterns
design-decision-revised-during-implementation (Phase 3 honest-design-evolution) | patterns
four-Phases-all-Complete (sibling design pair completion) | patterns
complementary-to-cycle-208-familiar-bundled-agents (sibling-pair-completion) | patterns
the-pair-is-the-feature (cycle 208 delivery + cycle 210 configuration) | patterns
fourteenth-honest-design-evolution-record family member with new shape | patterns
decision-revised-during-implementation (cycle 210 new shape for the family) | patterns
two-rhetorical-shapes-in-one-document (three-option-analysis in body + Alternatives-Considered at end) | patterns
forty-fourth consecutive designs-chat alternation cycles 166-210 | patterns
library-reaches-715-sections at cycle 210 | patterns
ten-utility-files with one-purpose-per-file | patterns
tree-shaking-friendly architecture via deep-imports (no index.js) | patterns
each-file-named-after-its-main-export | patterns
four-named-inclusion-criteria for utility packages (low-level / highly-reusable / sufficiently-general / explainable-without-much-external-knowledge) | patterns
applyLabelingError as substrate for cycle 198 patterns-diagnostic-feedback | references
throwLabeled companion (`${label}: ${innerErr.message}` + `X\`Caused by ${innerErr}\``) | references
sync-and-async-error-relabeling-in-one-function | patterns
fast-path-then-slow-path-for-diagnostic-quality | patterns
fromUniqueEntries-defends-against-user-data-property-name-injection | patterns
deprecation-tags-with-forwarding-comment-to-replacement-pattern | patterns
SameValueZero-comparison-noted-explicitly | patterns
hardening-analog-of-built-in-iterators | patterns
self-iterable-via-Symbol.iterator-returns-self | patterns
@ts-expect-error-with-rationale-comment | patterns
four-shape-toolkit-value-vs-descriptor-times-map-vs-extend | patterns
five-named-edge-cases-per-utility (objectMap doc-comments as runtime-spec) | patterns
JSDoc-typed-cast for built-ins with loose default types | patterns
three-canonical-uncurry-shapes in @endo (bind.bind(bind.call) / Reflect.apply-form / Function.prototype.call.bind) | references
hideAndHardenFunction-for-wrappers + harden-for-leaf-utilities semantic distinction | patterns
honest-cross-package-TypeScript-edges-with-explanatory-comments | patterns
generic-named-package-with-named-membership-rules | patterns
three-utility-cluster-shapes (cycle 195 cli/src + cycle 199 trio + cycle 211 common) | references
cycle-198-and-cycle-211-pair completes design-and-substrate picture | patterns
forty-fifth consecutive designs-chat alternation cycles 166-211 | patterns
library-reaches-716-sections at cycle 211 | patterns
Type-3-chat-system (Type 1 chat / Type 2 forum / Type 3 outliner) | references
immutability-at-protocol-level (every action as typed reply) | patterns
seven-built-in-reply-types (Reply / Edit / Deletion / Move / Pro / Con / Supporting-Evidence) | references
user-defined-reply-types-as-string-tags-no-protocol-changes-needed | patterns
extension-via-string-tag-without-protocol-change | patterns
last-write-wins-with-edit-queue-as-resolution-mechanism | patterns
private-reply-trees-as-capability-grant | patterns
layered-confidentiality (private subtrees within private subtrees) | patterns
recursive-mutation-of-typed-replies (deletion-of-deletions) | patterns
queue-walk-by-renderer | patterns
z-index-as-temporal-order-encoding (avatar lineage) | patterns
playback-with-viewer-history-aware-display | patterns
viewer-side-administration-with-retroactive-blocking | patterns
block-propagation-creates-personalized-unique-view per viewer | patterns
custom-attenuation-code in SES-Compartment | references
reference-scoping-no-upward-traversal (file-system principle "you can give the bag and know that nothing but what's in the bag is getting handed over") | patterns
unified-Agent-interface-for-humans-and-bots | patterns
@mention-as-wake-up-command | patterns
explicit-mentions-important in multi-user real-time collaboration | references
Roam-on-Endo-Petdaemon (replaces Automerge CRDTs with object-capability message-passing) | references
what-it-gains-vs-loses-with-pragmatic-substitute trade-off | patterns
named-keyboard-shortcut in design doc (Meta+J) | patterns
eight-Open-Questions as design-maturity-signal (mid-stage) | patterns
three-cycles-sharing-no-upward-traversal-discipline (cycles 161/166/212) | references
three-cycles-relying-on-SES-Compartment-substrate (cycles 200/205/212) | references
forty-sixth consecutive designs-chat alternation cycles 166-212 | patterns
library-reaches-717-sections at cycle 212 | patterns
small-files-with-large-knowledge-density twenty-fourth-member cycle 211 | patterns
Node-stream-adapters (Buffer-to-Uint8Array + hardened-Stream) | patterns
readableObjectMode-and-readableEncoding-guards with named-error-messages | patterns
Buffer-to-Uint8Array-zero-copy-conversion via new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.length) | patterns
Stream-must-have-return-and-throw (stricter than AsyncIterator) | references
iterator.return-preserved-via-assert | patterns
input.destroy(error)-on-throw (propagates Stream error to Node Reader) | patterns
Promise.race-with-finalIteration in writer.next | patterns
three-Node-event-handlers (error / finish / close) | references
honest-comment-about-defensive-redundancy ("watching close is redundant but makes us feel safer") | patterns
cleanup-after-first-fire (writer.off all + writer.on('error', sink)) | patterns
sink-for-Node-14-unhandled-error-race-defense (named Node version compat hack) | patterns
three-different-runtime-version-or-environment-compat-hacks (cycle 199 Apps-Script + cycle 205 Babel-traverse + cycle 213 Node-14) | references
back-pressure-via-await-on-write | patterns
writer.write-callback-and-drain-coordination | patterns
pre-hardened-nonFinalIterationResult-constant (no per-call allocation) | patterns
Fail-on-write-after-finalized | patterns
hybrid-async-iterator-plus-generator as named Writer shape | patterns
two-different-uses-of-Promise.race for multiple-completion-sources (cycle 204 weblet-next + cycle 213 stream-node) | references
small-files-with-large-knowledge-density twenty-fifth-member cycle 213 | patterns
forty-seventh consecutive designs-chat alternation cycles 166-213 | patterns
library-reaches-718-sections at cycle 213 | patterns
`@endo/immutable-arraybuffer` | (see source: endo--packages-immutable-arraybuffer)
immutable ArrayBuffer | (see source: endo--packages-immutable-arraybuffer)
`transferToImmutable` | (see source: endo--packages-immutable-arraybuffer)
`sliceToImmutable` | (see source: endo--packages-immutable-arraybuffer)
ImmutableArrayBuffer | (see source: endo--packages-immutable-arraybuffer)
byteArray codecs | (see source: endo--packages-immutable-arraybuffer)
admit immutable ArrayBuffer through codecs | (see source: endo--packages-immutable-arraybuffer)
no-spackle ponyfill+shim with race-to-install-detect-only | (see source: endo--packages-immutable-arraybuffer)
amplifier-with-this-fallthrough (return `this` when receiver is not an emulated wrapper) | (see source: endo--packages-immutable-arraybuffer)
`amplifyTypedArray` | (see source: endo--packages-immutable-arraybuffer)
`virtualTypedArrayBufferGetter` | (see source: endo--packages-immutable-arraybuffer)
`hiddenTypedArrays` WeakMap (emulated-freezable to genuine TypedArray map) | (see source: endo--packages-immutable-arraybuffer)
`makePseudoTypedArrayConstructor` | (see source: endo--packages-immutable-arraybuffer)
`PseudoTypedArrayPrototype` | (see source: endo--packages-immutable-arraybuffer)
`makeInternalHeir` (intermediate prototype builder for emulated-freezable + emulated-immutable) | (see source: endo--packages-immutable-arraybuffer)
`FERAL_GET_ARRAY_BUFFER` (pre-shim TypedArray.prototype.buffer getter capture) | (see source: endo--packages-immutable-arraybuffer)
`hiddenBuffers` / `reverseHiddenBuffers` WeakMaps | (see source: endo--packages-immutable-arraybuffer)
freezable TypedArray pony | (see source: endo--packages-immutable-arraybuffer)
`%FreezableTypedArrayPrototype%` permits entry (proposed; subject to drop-the-pony redesign) | (see source: endo--packages-immutable-arraybuffer)
`%ImmutableArrayBufferPrototype%` permits entry (subject to drop-the-pony redesign) | (see source: endo--packages-immutable-arraybuffer)
race-to-install detect-then-skip (`'sliceToImmutable' in ArrayBuffer.prototype`) | (see source: endo--packages-immutable-arraybuffer)
drop-the-pony redesign (rename pony->lib, drop the pseudo-prototype layer, shim copies onto genuine prototypes) | (see source: endo--packages-immutable-arraybuffer)
erights six-premises framing on #417 (premise 2: package exports only the shim) | (see source: endo--packages-immutable-arraybuffer)
pseudo-prototype-as-property-record (record-of-properties for shim to copy onto actual prototypes) | (see source: endo--packages-immutable-arraybuffer)
drop-in replacement for genuine prototype method (amplifier-fallthrough enables it) | (see source: endo--packages-immutable-arraybuffer)
genie-integration | (see source: endo-but-for-bots--llm-designs-endopi)
`@endo/genie` integration survey | (see source: endo-but-for-bots--llm-designs-endopi)
`@endo/llm-engine` extraction proposal | (see source: endo-but-for-bots--llm-designs-endopi)
endoclaw-timer prototype in genie | (see section: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts)
`makeIntervalScheduler` | (see section: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts)
interval-scheduler formula type (planned) | (see section: endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles)
`daemon-capability-timer` | (see section: endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles)
pet store as agent memory | (see concept: space)
pet-store-as-memory | (see concept: space)
`ScratchMount` | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
scratch-mount as daemon-managed workspace | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
zizmor CI fix endo#3297 | (see entry: 2026/06/04/000200Z-dispatch-liaison-55a546)
Genie heartbeat subagent | (see section: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts)
Genie observer reflector compaction | (see section: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts)
serial-jobs daemon task queue | (see source: endo-but-for-bots--llm-designs-daemon-message-streaming)
chat-inventory create menu | (see project: endo-but-for-bots; design source not yet ingested)
new-agent wizard three panes (harness / inference / endowments) | (see section: endo-but-for-bots--llm-designs-lal-fae-form-provisioning--three-named-problems-and-three-layer-lifecycle-and-three-option-analysis-for-guest-cannot-create-guests-and-inbox-as-durable-config-store)
+ button on inventory | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
inventory footer row | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
`@root` endowment proposal | (see section: endo-but-for-bots--llm-designs-d256--per-agent-keypairs)
root host agent special place | (see section: endo-but-for-bots--llm-designs-d256--per-agent-keypairs)
Ollama remote variant | (see section: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question)
Open Router authShape extension | (see section: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question)
posix sandbox via `@fs` + `@main` coupling | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
replace not extend lal-fae form provisioning | (see section: endo-but-for-bots--llm-designs-lal-fae-form-provisioning--three-named-problems-and-three-layer-lifecycle-and-three-option-analysis-for-guest-cannot-create-guests-and-inbox-as-durable-config-store)
linked-chain-of-transcript-nodes-with-shared-prefix-stored-once | patterns
branching-is-free (two replies to same parent create new nodes pointing to same parent) | patterns
two-phase-node-lifecycle (Phase 1 inbound + Phase 2 own-outbound-alias) | patterns
honest-design-evolution-visible-in-the-prose (self-correcting prose like "This is getting complex. Let's simplify:") | patterns
ASCII-tree-diagram of branching | patterns
assembly-via-walk-from-leaf-to-root | patterns
pet-store-as-source-of-truth-with-in-memory-cache | patterns
lazy-load-on-cache-miss | patterns
depth-as-text-prefix [depth:N] (no daemon schema changes) | patterns
text-prefix-as-out-of-band-metadata when schema changes are expensive | patterns
no-daemon-changes-required (leverages existing API) | patterns
Phase-N-extracted-to-separate-design when phase is substantive | patterns
Decisions-Made-vs-Tentative-Decisions two-table-shape | patterns
three-completed-Lal/Fae-cluster-designs (cycle 208 delivery + cycle 210 configuration + cycle 214 transcript memory) | references
five-different-uses-of-Alternatives-Considered-or-equivalent (cycle 198/200/208/210/214) | references
fifteenth-honest-design-evolution-record family member (design-evolution-visible-in-the-prose) | patterns
forty-eighth consecutive designs-chat alternation cycles 166-214 | patterns
library-reaches-719-sections at cycle 214 (lal-reply-chain-transcripts) | patterns
assets-should-outlive-execution-paths (Ymax architectural axiom) | references
EIP-1167-minimal-proxy with deterministic-address-derivation-from-multiple-identities | patterns
race-tolerant-idempotent-provisioning via deterministic-address-as-coordination-primitive | patterns
three-state-router-authorization-state-machine (Unknown / Vetted / Authorized) | patterns
two-factor-mechanism with different-authority-per-transition | patterns
compromise-of-single-router-does-not-authorize-new-control-path | patterns
honest-disclosure-of-residual-trust-boundaries | patterns
self-dispatch-pattern with msg.sender==address(this) | patterns
two-benefits-of-self-dispatch (error-isolation-via-event + block-explorer-readability) | patterns
calldata-rewrite-replacing-routing-field-with-authenticated-source | patterns
resolvers-as-bounded-fact-reporters (one bit not arbitrary state) | patterns
finality-checks-before-settlement | patterns
decoupled-command-and-result-transports | patterns
CREATE2-vs-CREATE3-distinction (permissionless for no-per-chain-init-data; permissioned for per-chain-init-data) | references
compromise-of-deployment-key-doesn't-alter-deployed-contract-behavior | patterns
OperationResult-event-common-format with txId-for-event-reporting + target-address-for-sender-authentication | patterns
routed-instruction-lifecycle with seven-named-steps | patterns
the-factory-IS-the-mediator (Remote Accounts statically defer to factory) | patterns
atomic-authorization-of-existing-accounts-to-new-router | patterns
independent-audit-section-with-named-findings + fix-status-per-finding | patterns
Permit2-as-intent with factory-principal-check | references
first-Agoric-Labs-design-ingested into the library | patterns
the-discipline-of-good-architecture-design-transcends-specific-substrate-technologies | patterns
library-reaches-720-sections at cycle 214 (Ymax side-ingest) | patterns
`@endo/hex` | (see source: endo--packages-hex)
`encodeHex` / `decodeHex` | (see source: endo--packages-hex)
`jsEncodeHex` / `jsDecodeHex` | (see source: endo--packages-hex)
ponyfill-with-load-time-dispatch | patterns
pre-lockdown-capture (defense against post-lockdown mutation redirecting dispatched binding) | patterns
race-against-lockdown-to-snapshot-intrinsics | patterns
post-lockdown-freezing-makes-the-snapshot-load-bearing | patterns
Reflect.apply-as-the-defensive-uncurry-against-Function.prototype.call-tampering | patterns
native-error-rerun-polyfill-for-better-diagnostic (run polyfill on native throw for precise offset + name) | patterns
the-polyfill-is-the-error-formatter-not-just-the-fallback | patterns
two-different-shapes-for-dispatching-to-native (unconditional for encode + on-failure-polyfill-rerun for decode) | patterns
direct-nibble-computation-from-charcodes (no lookup table; 2.5-3x faster on V8/Node 22) | patterns
`c | 0x20`-fold-uppercase-onto-lowercase (bitwise OR trick) | patterns
range-check-still-rejects-bit-folded-non-letters | patterns
pre-allocate-the-output-array-to-avoid-quadratic-time-string-concatenation | patterns
name-for-error-diagnostics parameter (`'<unknown>'` default) | patterns
document-where-the-polyfill-is-known-to-be-slow + point-at-the-native-intrinsic-as-the-eventual-answer | patterns
harden-every-export (polyfills + dispatched defaults) | patterns
three-different-ponyfill-shapes (cycle 197 panic + cycle 201 immutable-arraybuffer + cycle 215 hex) | references
four-concrete-canonical-uncurry-shape-instances (cycle 199 + cycle 207 + cycle 211 + cycle 215) | references
eleventh-SES-defense-family member (cycle 215 hex pre-lockdown capture) | references
fourth-instance-of-Reflect.apply-defensive-uncurry-in-endo | patterns
TC39-proposal-arraybuffer-base64-Stage-4 (Uint8Array.toHex / Uint8Array.fromHex) | references
twenty-sixth-member of small-files-with-large-knowledge-density family | patterns
forty-ninth consecutive designs-chat alternation cycles 166-215 | patterns
library-reaches-721-sections at cycle 215 (chat-lane @endo/hex) | patterns
lal-transcript-memory-management | (see source: endo-but-for-bots--llm-designs-lal-transcript-memory-management)
Phase-5-extracted-to-separate-design (cycle 214 → cycle 216 parent-child design pair) | patterns
extracted-from-Phase-N-of-predecessor (child-side language) | patterns
explicit-Predecessor-section pointing back to parent design | patterns
Existing-Infrastructure-named-with-bullet-list | patterns
inherit-don't-redescribe (additive-deltas only in the new document) | patterns
every-message-maps-to-a-durable-node (inbound creates new + outbound creates alias) | patterns
every-conceptual-event-must-map-to-the-canonical-durable-representation | patterns
durability-beyond-message-lifecycle | patterns
two-different-stores-with-two-different-lifecycles (ephemeral inbox vs durable transcript) | patterns
the-user's-action-on-the-inbox-does-not-cascade-to-the-transcript | patterns
accumulation-is-intentional (name the policy not just the mechanism) | patterns
name-the-policy-not-just-the-mechanism | patterns
error-not-silent-truncation | patterns
fail-loud-at-the-application-layer (sibling to cycle 100 fail-loud-not-degrade) | patterns
user-initiated-cleanup with two-named-cleanup-paths (discard-agent or export-then-cleanup) | patterns
the-design-resists-feature-creep-by-naming-future-features-as-out-of-scope | patterns
single-Decisions-table (vs cycle 214 two-table Decisions-Made-vs-Tentative) | patterns
shape-of-the-Decisions-section-tracks-the-Status-section | patterns
sixteenth-honest-design-evolution-record family member | references
design-evolution-visible-across-two-documents (new shape; vs cycle 214 within-one-document) | patterns
five-completed-Lal/Fae-cluster-designs (cycle 208 delivery + 210 configuration + 214 transcript memory + 216 durability) | references
Test-Plan four-scenario shape for durability designs | patterns
Security-Considerations one-line inherit-from-substrate shape | patterns
fiftieth consecutive designs-chat alternation cycles 166-216 (golden cycle 50) | patterns
library-reaches-722-sections at cycle 216 (designs-lane lal-transcript-memory-management) | patterns
`@endo/errors` | (see source: endo--packages-errors)
`hideAndHardenFunction` | (see source: endo--packages-errors)
`Rejector` typedef (`false | typeof Fail`) | (see source: endo--packages-errors)
`assert` / `Fail` / `note` / `quote` / `bare` / `details` / `makeError` | (see source: endo--packages-errors)
public-API-for-SES-assert | patterns
resource-module-discipline (entanglement with console) | patterns
strict-fail-on-load-if-missing-prerequisite + error-message-tells-the-user-what-to-do | patterns
enumerate-required-methods-and-tolerate-missing-ones | patterns
load-bearing-comment-out-lines (encoding tolerance for older SES) | patterns
named-tolerance-for-a-specific-runtime-environment | patterns
pre-1.13.0-SES-Agoric-bootstrap-vat-tolerance | references
rename-utilities-split-from-assertions (destructure + rest-spread) | patterns
rest-spread-collects-everything-not-named (clean way to discriminate two API shapes) | patterns
destructure-with-underscore-prefix-to-deliberately-discard | patterns
honest-fallback-policy with named-runtime-compat-fallback | patterns
conventional-abbreviations (b/X/q) for template-literal use | patterns
named-aliases (annotateError/redacted/throwRedacted) for prose call sites | patterns
when-a-function-is-used-both-in-templates-and-in-prose export-it-under-two-names | patterns
`__HIDE_`-prefix-protocol (cross-module coordination via name prefix) | patterns
protocol-via-name-prefix (lightweight cross-module coordination) | patterns
hideAndHardenFunction canonical definition (the protocol that bridges two packages: censor in tame-v8 + marker-installer in @endo/errors) | patterns
use-`String`-in-case-name-is-a-symbol defensive-coercion | patterns
drop-in-replacement-for-`harden` | patterns
Rejector-three-line-idiom (`cond || reject && reject\`...\``) | patterns
Rejector-three-cases (truthy / false-reject / Fail-reject) | patterns
the-dual-mode-pattern (predicate-or-assertion via parameter) | patterns
parameter-controlled-error-vs-silent-failure | patterns
tests-as-illustrative-examples (the test file is the second half of the documentation) | patterns
when-a-pattern-is-hard-to-express-in-prose-or-types point-readers-at-the-test-file | patterns
two-channels-for-two-audiences (thrown-error redacted for caller + console-log full for debugger) | patterns
security-vs-diagnostic-tension resolved by two-channels-with-different-trust-levels | patterns
the-debugger-channel-is-the-privileged-side | patterns
four-different-runtime-version-or-environment-compat-hacks (cycles 199 / 205 / 213 / 217) | references
twenty-seventh-member of small-files-with-large-knowledge-density family | patterns
fifty-first consecutive designs-chat alternation cycles 166-217 | patterns
library-reaches-723-sections at cycle 217 (chat-lane @endo/errors) | patterns
familiar-chat-weblet-hosting | (see source: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting)
two-part-status (Done-Elsewhere + Remaining-Here) | patterns
the-shape-of-the-Status-section-tracks-the-relationship-with-the-predecessor | patterns
ASCII-mockup-of-UI | patterns
iframe-sandbox-attribute-as-confinement | patterns
browser-iframe-as-the-confinement-substrate | patterns
three-named-sandbox-permissions (allow-scripts + allow-same-origin + allow-forms) | patterns
four-cycles-using-different-substrates-for-confinement (cycles 196/200/212/218) | references
four-step-weblet-install (create-guest → endow → install → register) | patterns
guest-as-the-unit-of-application-installation (the application IS the guest) | patterns
power-levels-as-selectable-options with NONE-as-safe-default | patterns
@host-explicitly-labeled-development/trusted-only | patterns
two-CapTP-transports (WebSocket universal + MessagePort Familiar-specific stretch goal) | patterns
named-trade-off-axes (universality vs performance) | patterns
primary-transport-and-stretch-goal-transport | patterns
the-stretch-goal-is-environment-specific-and-more-performant | patterns
three-chat-commands (/install + /open + /close) | patterns
every-UI-action-also-has-a-command | patterns
three-surfaces-for-the-same-action (UI-button + command + keyboard-shortcut) | patterns
atomicity-as-design-driver (two-steps-that-must-succeed-or-fail-together) | patterns
Affected-Packages-section with named-reason-per-package | patterns
three-named-dependencies-with-named-reason-per-dependency | patterns
five-section-considerations (Security + Scaling + Test Plan + Compatibility + Upgrade) | patterns
each-Considerations-section-names-a-different-concern | patterns
Upgrade-Considerations-distinct-from-Compatibility-Considerations | patterns
compatibility-names-what-keeps-working vs upgrade-names-what-the-user-needs-to-do | patterns
when-a-new-design-creates-a-new-shape-for-old-data name-the-migration-path-explicitly | patterns
eighteenth-honest-design-evolution-record family member | references
two-design-documents-with-asymmetric-implementation-progress (sibling-Ready + this-Not-Started) | patterns
six-completed-Familiar-cluster-designs (cycles 174 + 176 + 182 + 184 + 208 + 218) | references
fifty-second consecutive designs-chat alternation cycles 166-218 | patterns
library-reaches-724-sections at cycle 218 (designs-lane familiar-chat-weblet-hosting) | patterns
`@endo/ses-ava` | (see source: endo--packages-ses-ava)
`MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA` (registered-symbol key) | (see source: endo--packages-ses-ava)
`wrapTest(avaTest)` | (see source: endo--packages-ses-ava)
`logErrorFirst` | (see source: endo--packages-ses-ava)
`makeVirtualExecutionContext` | (see source: endo--packages-ses-ava)
registered-symbol-on-globalThis-as-cross-module-coordination | patterns
privileged-API-on-start-compartment-only | patterns
rely-on-SES-Compartment-isolation-to-keep-privileged-API-out-of-guest-compartments | patterns
experimental-API-flag-via-comment with single-intended-consumer | patterns
co-maintenance-relationship across two packages | patterns
feature-test-at-use-time-with-graceful-degradation | patterns
virtualT-proxy via defineProperty-with-getter-setter-delegation | patterns
three-kinds-of-property-handling (accessor + function-value + data) | patterns
spread-prototype-descriptors-first-so-own-properties-override | patterns
proxy-via-defineProperty-not-via-Proxy when shape-of-original-is-known | patterns
logErrorFirst three-cases (sync-throw + promise-reject + success) | patterns
THROWN-vs-REJECTED log-prefix-distinction | patterns
intercept-without-changing-the-outcome (logger is side-effect, not transformation) | patterns
honest-disclosure-of-observable-difference (delayed-rejection-equivalent-enough-for-testing) | patterns
AVA-method-override-list (seven-named-chainable-methods: after / afterEach / before / beforeEach / failing / serial / only) | patterns
recursive-wrapping-for-chainable-methods | patterns
allow-list-for-recursive-wrapping with honest-fragility | patterns
pre-lockdown-freeze-with-named-correctness-argument | patterns
five-cycles-using-freeze-not-harden-with-named-correctness-argument (cycles 132 + 146 + 154 + 199 + 219) | references
single-import-replaces-multiple-imports | patterns
devDependencies-not-dependencies discipline (avoid AVA bundling bloat) | patterns
multi-config-CLI-as-package.json-driven-runner | patterns
sesAvaConfigs | (see source: endo--packages-ses-ava)
three-different-shapes-for-cross-module-coordination-protocols (cycles 197 / 217 / 219) | references
the-causal-console-substrate-is-fully-wired-now (cycles 90 + 93 + 96 + 98 + 100 + 106 + 217 + 219) | references
eighth-and-final-piece of SES error-channel infrastructure | patterns
twenty-eighth-member of small-files-with-large-knowledge-density family | patterns
fifty-third consecutive designs-chat alternation cycles 166-219 | patterns
library-reaches-725-sections at cycle 219 (chat-lane @endo/ses-ava) | patterns
familiar-localhttp-protocol | (see source: endo-but-for-bots--llm-designs-familiar-localhttp-protocol)
six-layer-defense-in-depth | patterns
each-layer-named-and-numbered-with-its-confinement-purpose | patterns
defense-in-depth-with-named-attack-per-layer | patterns
the-multi-layer-synthesis (cycle 220 as the multi-layer-confinement-stack) | patterns
five-cycles-on-confinement (cycles 196 + 200 + 212 + 218 + 220) | references
three-state-status (Partially-implemented + Not-yet + Design-deviations) | patterns
design-deviations-section (design tracks its own divergence from implementation) | patterns
nineteenth-honest-design-evolution-record family member | references
threat-modeling-as-design-driver (numbered attacks vs goals) | patterns
each-privilege-named-with-purpose (when API takes options bag of booleans) | patterns
two-different-trust-zones-with-two-different-CSPs | patterns
pull-out-the-load-bearing-lines + name-the-reason-for-each | patterns
MessagePort-bridge | patterns
why-WebSocket-doesn't-work-from-localhttp (two-named-reasons) | patterns
when-the-obvious-solution-doesn't-work name-both-reasons-it-doesn't-work | patterns
the-second-reason-is-the-deeper-architectural-constraint | patterns
zero-copy-via-transfer-list (`[buffer]` moves ownership not copies) | patterns
two-different-zero-copy-patterns in library (cycles 213 + 220) | references
ASCII-mermaid-style-flow-diagram | patterns
three-cycles-with-ASCII-illustration in 2026-06 (cycles 214/218/220) | references
allowedProtocols-set with dev-mode-exemption | patterns
invalid-DoH-as-DNS-poisoning | patterns
intentionally-misconfigure-a-platform-API-to-deny-a-capability | patterns
correctness-argument-naming-each-traffic-pattern-that-still-works | patterns
belt-and-suspenders-flags (three Chromium command-line flags as redundant DNS defense) | patterns
each-flag-has-a-named-purpose | patterns
host-resolver-rules MAP * ~NOTFOUND EXCLUDE 127.0.0.1 | (see source: endo-but-for-bots--llm-designs-familiar-localhttp-protocol)
WebRTC-ICE-candidate-exfiltration (ufrag-field encoding STUN/TURN bypassing CSP) | patterns
name-the-out-of-band-channel-that-bypasses-your-primary-defense | patterns
runtime-verification with canary-DNS-resolution | patterns
the-test-that-it-fails-IS-the-verification | patterns
non-blocking-yellow-banner (informed but not blocked) | patterns
detected-via-platform-API (window.familiar; no banner in Vite dev mode) | patterns
the-warning-banner-only-appears-when-the-defense-was-supposed-to-be-active | patterns
Research-needed-section as honest-acknowledgment-of-incomplete-verification | patterns
Open-Questions-(None-remaining) as completeness-signal | patterns
two-different-sections-for-two-different-classes-of-uncertainty (Research-needed = verification + Open-Questions = decision) | patterns
implementation-status-per-package (design doubles as progress-tracker) | patterns
seven-Familiar-cluster-designs (cycles 174 + 176 + 182 + 184 + 208 + 218 + 220) | references
three-different-status-values in one cluster (shipped + Not Started + Partially implemented) | patterns
the-parent-with-ready-infrastructure (cycle 220 is parent referenced by cycle 218's two-part-status) | patterns
four-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220) | references
fifty-fourth consecutive designs-chat alternation cycles 166-220 | patterns
library-reaches-726-sections at cycle 220 (designs-lane familiar-localhttp-protocol) | patterns
`@endo/bundle-source` | (see source: endo--packages-bundle-source)
`bundleSource(startFilename, options, powers)` | (see source: endo--packages-bundle-source)
`bundleZipBase64` / `bundleScript` | (see source: endo--packages-bundle-source)
`makeBundlingKit` | (see source: endo--packages-bundle-source)
`makeReadPowers({ fs, url, crypto })` | (see source: endo--packages-bundle-source)
`endoZipBase64` (default module format) | (see source: endo--packages-bundle-source)
`endoZipBase64Sha512` (integrity hash) | (see source: endo--packages-bundle-source)
`sourceMapJobs` Set | (see source: endo--packages-bundle-source)
`DEFAULT_MODULE_FORMAT` / `SUPPORTED_FORMATS` | (see source: endo--packages-bundle-source)
four-named-output-module-formats (endoZipBase64 + getExport + nestedEvaluate + endoScript) | references
default-format-named-as-a-constant + SUPPORTED_FORMATS-as-allow-list | patterns
distinguish-not-supported-from-not-implemented-with-different-error-messages | patterns
format-dispatch-with-lazy-loading via dynamic-import-per-format | patterns
pay-only-for-what-you-use principle | patterns
shared-options-shape-across-multiple-public-entry-points | patterns
mutual-exclusion-rejected-at-validation-gate | patterns
when-two-options-are-mutually-exclusive reject-at-validation-gate-with-error-naming-both | patterns
readPowers-pattern via @endo/compartment-mapper | patterns
spread-default-powers-then-spread-granted-powers | patterns
later-spread-wins-on-collision (canonical override pattern) | patterns
read-powers-as-a-bundled-capability-shape | patterns
caller-can-override-individual-powers | patterns
SHA-512-content-addressed-source-map-cache | patterns
two-parallel-directory-structures (content-cache + location-tracker) | patterns
the-tracker-IS-the-mutation-point + the-cache-IS-the-immutable-store | patterns
two-letter-prefix-sharding (avoid one-giant-directory) | patterns
directory-sharding-needs-an-empty-directory-cleanup-step | patterns
empty-directory-cleanup-step (rmdir if empty after deletion) | patterns
tolerate-ENOENT-on-first-write (don't conflate with other errors) | patterns
two-parser-defaults with named-aliases-encode-semantics | patterns
transformingParserForLanguage vs transparentParserForLanguage | (see source: endo--packages-bundle-source)
two-third-party-transform-libraries-bundled-into-default-pipeline | patterns
evadeCensor + tsBlankSpace integration | (see source: endo--packages-bundle-source)
async-fan-out-with-Set-tracking | patterns
the-fire-and-collect-async-pattern (don't await individually) | patterns
discriminator-tag-content-integrity-hash output shape | patterns
three-flavor language detection (workspace + workspace-commonjs + workspace-module) | patterns
the-extension-to-language-mapping-depends-on-the-package-type | patterns
thin-dispatch-layer-over-heavy-machinery | patterns
two-different-packages-as-thin-dispatch-layers-over-heavier-substrate (cycles 217 + 221) | references
when-a-package-needs-a-friendly-public-surface-over-heavy-machinery the-package-is-a-thin-dispatch-layer | patterns
two-different-Set-data-structure-uses (cycle 132 deduplication + cycle 221 fan-out-tracking) | references
twenty-ninth-member of small-files-with-large-knowledge-density family | patterns
fifty-fifth consecutive designs-chat alternation cycles 166-221 | patterns
library-reaches-727-sections at cycle 221 (chat-lane @endo/bundle-source) | patterns
endoclaw-skill-registry | (see source: endo-but-for-bots--llm-designs-endoclaw-skill-registry)
Parent-pointer-as-explicit-frontmatter-field | patterns
twentieth-honest-design-evolution-record family member | references
five-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222) | references
four-different-shapes-for-naming-design-relationships in 2026-06 cluster | references
no-new-abstractions (the registry IS a directory; descriptors ARE directories; metadata IS string values) | patterns
three-recursive-EndoDirectory-levels with uniform-shape-with-recursive-nesting | patterns
uniform-shape-with-recursive-nesting | patterns
you-don't-need-to-learn-three-vocabularies-because-everything-uses-the-same-three-operations | patterns
three-cycles-with-no-new-abstractions discipline (cycles 211 + 214 + 222) | references
capability-declaration-via-directory-structure | patterns
encode-structured-metadata-as-directory-structure | patterns
the-directory-IS-the-schema (no JSON schema, no YAML parser) | patterns
no-ambient-authority (host grants; application petitions) | patterns
the-requires-section-is-advisory-not-authoritative | patterns
three-cycles-on-the-host-grants-capabilities-application-doesn't-take-them discipline (cycles 208 + 218 + 222) | references
five-step-CLI-installation composing existing verbs (no-new-verbs) | patterns
single-convenience-command-wrapping-the-explicit-flow | patterns
two-shapes-for-the-same-operation (explicit-flow + convenience-wrapper) | patterns
decentralized-by-default (any agent creates a registry; no central authority) | patterns
the-built-in-registry-is-convenience-not-gatekeeper | patterns
three-cycles-on-decentralized-by-default discipline (cycles 200 + 220 + 222) | references
federation-by-reference (not federation-by-protocol) | patterns
three-named-federation-patterns (multiple-roots + cross-reference + filtered-view-via-copy) | patterns
live-discovery via followNameChanges (reuse existing event-stream primitive) | patterns
when-an-existing-primitive-already-provides-event-streaming use-it-everywhere | patterns
discriminated-union-via-key-presence (`'add' in change`) not via discriminator string | patterns
forward-compatible-via-key-presence-check | patterns
built-in-registry-as-Specials-mechanism (`@apps`, `@lal`, `@fae`) | patterns
publishing-as-a-mail-message-not-an-RPC | patterns
two-actors-with-different-roles (author + operator) | patterns
the-Depends-On-section-with-status-per-dependency | patterns
three-already-implemented + one-precondition | patterns
named-Endo-Idiom-section enumerating five emergent disciplines | patterns
a-named-Idiom-section-listing-the-design-principles-that-emerge-from-the-substrate-choice | patterns
when-a-design-fits-into-an-existing-substrate write-the-Idiom-section-that-names-which-principles-emerge | patterns
fifty-sixth consecutive designs-chat alternation cycles 166-222 | patterns
library-reaches-728-sections at cycle 222 (designs-lane endoclaw-skill-registry) | patterns
`@endo/module-source` | (see source: endo--packages-module-source)
`ModuleSource` class | (see source: endo--packages-module-source)
`AbstractModuleSource` (prototype bridge for forward-compatibility) | (see source: endo--packages-module-source)
`HIDDEN_PREFIX` with U+034F Combining Grapheme Joiner | (see source: endo--packages-module-source)
`HIDDEN_META` sized to match `import.meta` length | (see source: endo--packages-module-source)
`HIDDEN_IDENTIFIERS` enumerated allow-list (seven named identifiers) | (see source: endo--packages-module-source)
ModuleSource-class-as-parsed-cache-shareable-across-Compartments | patterns
class-constructor-must-be-invoked-with-`new` check via `new.target === undefined` | patterns
two-form-of-options-with-single-line-normalization | patterns
when-the-most-common-option-is-a-string accept-it-as-shorthand-and-normalize | patterns
deep-freeze-of-everything via three-levels-of-freezing (inner-entries + map-values + the-instance-itself) | patterns
when-an-object-graph-must-be-immutable traverse-it-and-freeze-each-level-explicitly | patterns
`__double-underscore__`-private-names-convention (SES Compartment internal contract) | patterns
the-babel-vs-babelStar-NESM-RESM matrix encoded as 4-by-2 ASCII table in opening comment | patterns
four-by-two-matrix-encoded-as-comment | patterns
honest-acknowledgment-of-platform-quirks | patterns
five-member runtime-version-or-environment-compat-hacks-and-disclosures family (cycles 199 + 205 + 213 + 217 + 223) | references
disclosure-depth-deepens-cycle-by-cycle | patterns
shebang-comment-out-trick (`if (source.startsWith('#!')) source = '//' + source;`) | patterns
when-you-must-pass-source-text-through-a-parser-that-rejects-the-shebang comment-it-out-with-`//`-prefix | patterns
`sourceOptions`-as-shared-state-bag with ten-named-fields | patterns
Object.create(null)-for-prototype-free-maps | patterns
defensive-shape-against-prototype-pollution | patterns
`{ present: false }` pattern (mutable-boolean-wrapped-in-object as out-parameter) | patterns
when-a-callee-needs-to-mutate-a-boolean-from-deep-inside-a-traversal wrap-it-in-an-object | patterns
JavaScript-doesn't-have-out-parameters an-object-with-a-mutable-field-IS-the-out-parameter | patterns
AbstractModuleSource-prototype-bridge-for-forward-compatibility | patterns
asymmetric-tolerance-discipline | patterns
when-future-evolution-could-go-multiple-ways pick-the-shape-that-tolerates-both | patterns
lockdown-tolerates-absence-but-not-presence-of-unexpected-prototype | patterns
WebAssembly.Module-entanglement-deferred with named rationale | patterns
name-the-temptation-and-resist-it-with-rationale | patterns
invisible-combining-character-as-identifier-prefix (U+034F) | patterns
use-an-invisible-Unicode-character-in-identifier-prefixes-to-avoid-collision-with-user-code | patterns
source-map-friendly-replacement (size the substitute to match the original) | patterns
when-you-substitute-tokens-in-source-text size-the-replacement-to-match-the-original-length | patterns
enumerated-allow-list of reserved identifiers as exported frozen array | patterns
try-catch-wrap-with-cause + location-context (Error `cause` ES2022) | patterns
JSON.stringify-with-fallback-default safe-quoting-with-fallback | patterns
sixth-cycle-using-freeze-not-harden-with-named-correctness-argument family (cycles 132 + 146 + 154 + 199 + 219 + 223) | references
fifty-seventh consecutive designs-chat alternation cycles 166-223 | patterns
thirtieth-member of small-files-with-large-knowledge-density family | patterns
library-reaches-729-sections at cycle 223 (chat-lane @endo/module-source) | patterns
daemon-web-gateway | (see source: endo-but-for-bots--llm-designs-daemon-web-gateway)
single-HTTP+WebSocket-server multiplexing four roles on one port | patterns
single-server-four-roles architecture | patterns
one-port-multiplexing-multiple-protocols-with-named-roles | patterns
GatewayBootstrap as narrow-interface (single-method fetch(agentId)) | patterns
narrow-interface at entry point (a-one-method-interface-is-easy-to-audit) | patterns
bearer-token-as-formula-ID (256-bit formula identifier doubles as auth token) | patterns
the-formula-ID-IS-the-bearer-token | patterns
the-identifier-IS-the-capability discipline (five cycles: 200 + 210 + 211 + 220 + 224) | references
when-an-opaque-identifier-is-already-256-bit-uniformly-random it-can-serve-as-its-own-bearer-token | patterns
per-IP-rate-limiter with three-named-properties (failed-penalty + successful-no-impact + stale-removed-after-10s) | patterns
rate-limiter-with-explicit-rules-named-for-each-traffic-class | patterns
two-modes-of-weblet-hosting (designated-port for browsers + virtual-host for Familiar) | patterns
the-same-content-served-two-different-ways for two-different-client-capabilities | patterns
Caveat-emptor-disclosure (honest-disclosure-of-named-trade-off in less-safe mode) | patterns
three-different-shapes-for-honest-disclosure-of-a-known-trade-off (cycles 218 + 220 + 224) | references
three-mode-address-filtering (Localhost-only default + Remote + CIDR-allowlist) with safe-default | patterns
unsafe-mode-logs-a-named-warning (Remote mode logs TLS warning) | patterns
IPv4-mapped-IPv6-normalization as prerequisite for allowlist matching | patterns
virtual-host-dispatch-for-both-HTTP-and-WebSocket (the Host header IS the shared discriminator) | patterns
the-default-handler-vs-the-registered-weblet-handler-distinction | patterns
two-framings-for-the-same-CapTP-protocol (WebSocket-binary-frame + netstring) | patterns
isolate-the-framing-from-the-payload (when the same protocol runs over two transports) | patterns
makeMessageCapTP shared across both paths | (see source: endo-but-for-bots--llm-designs-daemon-web-gateway)
makeWeblet registration API with mode-dependent getLocation | patterns
Dependencies-table-with-Relationship-column (vs bullet-list-with-named-reason) | patterns
four-different-shapes-for-naming-design-dependencies in 2026-06 cluster | references
the-Prompt-section captures the original solicitation | patterns
two-cycles-with-Prompt-section-captured (cycles 198 + 224) | references
Status-Complete-with-explicit-Design-deviations-None-significant | patterns
the-empty-deviation-marker-is-load-bearing | patterns
three-different-empty-marker-shapes in library (cycles 220 + 222 + 224) | references
two-different-classes-of-completeness-signaled-with-different-empty-markers | patterns
twenty-first-honest-design-evolution-record family member | references
six-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224) | references
eight-Familiar-cluster-designs in library (cycles 174 + 176 + 182 + 184 + 208 + 218 + 220 + 224) | references
four-different-status-values in one cluster (shipped + Not Started + Partially implemented + Complete) | patterns
fifty-eighth consecutive designs-chat alternation cycles 166-224 | patterns
library-reaches-730-sections at cycle 224 (designs-lane daemon-web-gateway) | patterns
`@endo/init/node-async_hooks` | (see source: endo--packages-init-node-async_hooks)
three-named-symbol-slots (async_id_symbol + trigger_async_id_symbol + destroyed) | patterns
two-strategies-for-async-hooks-symbol-discovery (findAsyncSymbolsFromAsyncResource cheap + findAsyncSymbolsFromPromiseCreateHook complete) | patterns
cost-coverage-trade-off + named-option-to-pick | patterns
the-never-resolving-promise-as-trigger (`new Promise(() => {})`) | patterns
observe-construction-without-settlement | patterns
the-reset-hook-enable-then-disable-trick | patterns
enable-then-disable-trick-when-side-effect-is-the-purpose | patterns
named-Node-v14.16.2-version-specific-workaround | references
sixth-member-of-runtime-version-or-environment-compat-hacks-and-disclosures family (cycles 199 + 205 + 213 + 217 + 223 + 225) | references
the-destroy-hook-only-needs-to-exist-to-trigger-Node-installing-the-destroyed-symbol | patterns
when-the-platform's-behavior-depends-on-whether-you-passed-a-callback pass-the-empty-callback-to-trigger-the-behavior | patterns
the-property-descriptor-factory with disallowGet-variant | patterns
the-writable-flag-can-encode-Node-version-quirks-not-just-mutation-policy | patterns
setAsyncSymbol three-case-logic (unknown + first-time + subsequent) | patterns
the-symbol-registration-function-distinguishes-unknown-from-first-time-from-duplicate | patterns
WeakMap-fallback-for-frozen-promises | patterns
Reflect.defineProperty-returns-false-on-failure (not-throws) | patterns
when-an-operation-might-fail-silently-via-return-false check-the-return-and-fall-back-without-throwing | patterns
belt-and-suspenders-primary-path-and-fallback | patterns
named-sentinel-return-value-for-named-platform-condition (-2 for this-version-doesn't-need-the-shim) | patterns
two-named-out-of-scope-cases with named-policy | patterns
debug-prints-left-as-commented-comments | patterns
process._rawDebug-bypasses-SES-tamed-console | patterns
three-different-shapes-for-debug-instrumentation-in-production-code (cycle 90 `__HIDE_`-prefix + cycle 130 env-option-gated + cycle 225 commented-out) | references
pre-lockdown-installation-of-properties-that-lockdown-would-block | patterns
pre-lockdown-installation-of-runtime-discovered-symbols (sibling to cycle 219) | patterns
module-pattern (closure state + exported setup function) vs class-pattern | patterns
two-different-design-choices-for-two-different-shapes (class for value-types-with-instances; module for singleton-with-internal-state) | patterns
fifty-ninth consecutive designs-chat alternation cycles 166-225 | patterns
thirty-first-member of small-files-with-large-knowledge-density family | patterns
library-reaches-731-sections at cycle 225 (chat-lane @endo/init/node-async_hooks) | patterns
endoclaw-six-design-cluster (network-fetch + notifications + proactive-messages + webhooks + voice + browser) | (see source: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster)
cluster-ingest-as-one-section pattern | patterns
the-shared-six-section-template (Frontmatter + Summary + Capability Shape + How It Works + Endo Idiom + Depends On) | patterns
Parent-frontmatter-field-in-all-cluster-members | patterns
two-facet-control-pair canonical shape (Capability + CapabilityControl) | patterns
three-uniform-control-facet-methods (setLimit-style + revoke + help) | patterns
the-uniform-baseline-API | patterns
every-capability-pair-has-revoke-and-help | patterns
two-facets-with-two-different-holders (capability to agent; control to host) | patterns
structural-confinement-checked-inside-exo-at-only-call-site | patterns
the-confinement-is-checked-inside-the-exo-before-the-operation | patterns
two-different-confinement-philosophies (cycle 220 defense-in-depth vs cycle 226 structural-at-only-call-site) | references
no-ambient-X enumeration (no ambient DNS / no ambient socket / no cookie-credential leakage) | patterns
designs-name-their-composability-partners | patterns
four-cycles-on-no-new-abstractions discipline (cycles 211 + 214 + 222 + 226) | references
four-cycles-on-the-host-grants-capabilities-application-doesn't-take-them discipline (cycles 208 + 218 + 222 + 226) | references
design-pattern-not-a-new-capability (composition recipe shape) | patterns
UI-feature-not-a-capability (uniformity IS the design) | patterns
three-different-non-capability-design-shapes in the cluster | patterns
three-options-A-B-C with pros-cons-per-option | patterns
when-an-implementation-has-multiple-viable-paths name-the-options + pros-cons-per-option | patterns
help()-method-on-every-interface as uniform introspection | patterns
the-agent-can-ask-its-capabilities-what-they-do-by-calling-help | patterns
the-cluster-as-design-language (six conventions for future siblings) | patterns
future-designs-in-the-same-cluster-can-elide-the-template + inherit-the-conventions-from-the-cluster-Idiom | patterns
twenty-second-honest-design-evolution-record family member | references
seven-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224 + 226) | references
eight-design-cluster for the-endoclaw-feature (cycle 196 parent + cycle 222 skill-registry + cycle 226's six children) | references
two-different-cluster-ingest-types (cluster-of-code-files cycles 199/211 + cluster-of-design-documents cycle 226) | references
sixtieth consecutive designs-chat alternation cycles 166-226 | patterns
library-reaches-732-sections at cycle 226 (designs-lane endoclaw-six-design-cluster) | patterns
@endo/pass-style helpers cluster (byteArray + copyArray + copyRecord + tagged + iter-helpers + string + makeTagged) | (see source: endo--packages-pass-style-helpers-cluster)
PassStyleHelper-uniform-shape (styleName + confirmCanBeValid + assertRestValid) | patterns
two-phase-validation (cheap discriminator + deep well-formedness) | patterns
split-validation-into-cheap-discriminator + deep-well-formedness | patterns
the-cheap-check-runs-on-every-classification + the-deep-check-runs-only-after-classification-succeeds | patterns
Rejector-typedef-from-cycle-217 used consistently across pass-style helpers | references
rest-spread-collects-everything-not-named (tagged.js) | patterns
the-rest-spread-IS-the-validation-of-no-extra-properties | patterns
second-use-of-rest-spread-collects (cycle 217 omits known + cycle 227 detects unknown) | references
length-vs-ownKeys-check (copyArray invariant) | patterns
invariant-encoded-as-count-check | patterns
adapt-feature-detection (byteArray.js) returns deny-bindings when feature missing | patterns
feature-detection-returns-bindings-that-deny-when-the-feature-is-missing | patterns
the-validation-degrades-to-always-reject-byteArrays when feature absent | patterns
Reflect.apply-as-the-defensive-uncurry fifth-instance (cycles 199 + 207 + 211 + 215 + 227) | references
don't-coerce-input (string.js) via pre-typeof-check-before-platform-method | patterns
explain-why-in-the-comment + cite-the-isNaN-precedent | patterns
wrap-the-platform-method-with-an-explicit-typeof-check | patterns
env-option-gated-strictness with named-three-phase-plan (disabled → enabled → switch-removed) | patterns
the-comment-tells-the-consumer-what-to-expect-over-time | patterns
three-cycles-on-env-option-controlled-features (cycle 130 + cycle 217 + cycle 227) | references
mapIterable + filterIterable lazy iterator utilities (Far-wrapped) | patterns
lazy-iterator-utility-that-returns-Far-wrapped-objects | patterns
the-completion-value-is-passed-through-not-transformed | patterns
!!done boolean-coerce to ensure IteratorResult done is strictly boolean | patterns
pair-the-constructor-with-the-validator in adjacent files (makeTagged + tagged) | patterns
the-constructor-is-the-trusted-path + the-validator-is-the-untrusted-path | patterns
central-dispatcher + uniform-shape-of-handlers-per-case | patterns
the-pass-style-package-comprehensively-ingested across ten cycles | references
twenty-third-honest-design-evolution-record family member | references
two-cluster-shapes-paired (cycle 226 design-documents + cycle 227 code-files) | references
three-cycles-of-code-file-clusters-with-shared-template (cycles 199 + 211 + 227) | references
three-different-shared-disciplines + three-different-purposes-for-the-cluster-shape | patterns
sixty-first consecutive designs-chat alternation cycles 166-227 | patterns
library-reaches-733-sections at cycle 227 (chat-lane @endo/pass-style helpers cluster) | patterns
daemon-os-sandbox-plugin | (see source: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin)
Status-Superseded-by-named-successor (new design-evolution-record shape) | patterns
retained-as-a-historical-proposal | patterns
Roadmap-calibration-via-git-blame (cite commit hashes with dates and message summaries) | patterns
use-git-blame-as-roadmap-archaeology | patterns
the-richest-historical-record-yet in 2026-06 cluster | patterns
explicit-statement-of-deprecation (No further implementation phase is planned against this document) | patterns
LLM-discoverability section with two-mechanisms (comprehensive help() + maximally specific interface guards) | patterns
comprehensive-help()-text-narrative for LLM reader | patterns
maximally-specific-interface-guards (M.splitRecord + M.or + M.literal) | patterns
LLM-as-the-target-reader for API design | patterns
M.splitRecord-for-LLM-discoverable-shapes (distinguish required from optional fields) | patterns
the-API-must-be-self-documenting-to-the-LLM | patterns
capability-flow-as-ASCII-tree with nested-indentation showing creation hierarchy | patterns
fourth-cycle-with-ASCII-illustration in 2026-06 (cycles 214/218/220/228) | references
two-platform-backends (macOS SBPL + Linux bwrap+seccomp) | patterns
named-endowment-to-rule-mapping-table per backend | patterns
the-mapping-IS-the-implementation-contract | patterns
Apple-deprecation-acknowledgment with named-future-replacement-APIs (Endpoint Security + FUSE) | patterns
honest-acknowledgment-of-platform-deprecation | patterns
per-rule-network-filtering-limitation as honest disclosure | patterns
three-named-future-paths-to-fix-the-limitation (nftables + Landlock + container runtime) | patterns
the-initial-Linux-implementation-falls-back-to-all-or-nothing-and-logs-a-warning | patterns
three-named-future-stronger-isolation-mechanisms (Landlock + container runtimes + Lightweight VMs) | patterns
Test-Plan-with-Maybe-subsection (not-required-but-suggested tests) | patterns
four-different-shapes-for-naming-non-essential-future-work (Research-needed + Open-Questions-(None-remaining) + Maybe) | references
two-cycles-with-the-five-section-Considerations-template (cycles 218 + 228) | references
Profile-generation-is-security-critical (name the injection risk + canonicalization requirement) | patterns
the-plugin-itself-is-unconfined with named mitigation (only host holds SandboxMaker) | patterns
twenty-fourth-honest-design-evolution-record family member | references
nine-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228) | references
seven-cycles-on-confinement-substrates (cycles 196 + 200 + 212 + 218 + 220 + 226 + 228) spanning capability-framing-to-OS-syscall-level | references
sixty-second consecutive designs-chat alternation cycles 166-228 | patterns
library-reaches-734-sections at cycle 228 (designs-lane daemon-os-sandbox-plugin) | patterns
@endo/marshal/marshal-justin.js | (see source: endo--packages-marshal-src-marshal-justin)
Justin-as-JavaScript-subset (output IS valid source code) | patterns
pick-a-syntactic-subset-of-the-host-language for evaluatable rendering | patterns
dual-indenter-strategies (makeYesIndenter + makeNoIndenter) with five-method-shared-Indenter-interface | patterns
two-implementations-of-the-same-interface-with-different-strategies + the-caller-picks-via-named-boolean | patterns
badPairPattern regex encoding six-named-token-pair-cases | patterns
the-`<!`-and-`->`-cases-prevent-the-accidental-formation-of-an-html-like-comment | patterns
regex-encoding-token-pairs-that-must-be-separated + honest-comment-admitting-uncertainty | patterns
two-pass-recursion (prepare validates + decode emits) with documented co-maintenance-constraint | patterns
when-two-passes-must-visit-the-same-tree-in-the-same-order document-the-co-maintenance-constraint-in-the-source | patterns
QCLASS-discrimination switch with eleven-named-cases + default-throws | patterns
the-Hilbert-Hotel-encoding for records containing the special @qclass key | patterns
two-different-instances-of-the-Hilbert-Hotel-naming (cycles 148 + 229) | references
nested-render-with-indenter-swap via closure-captures-mutable-state + try-finally-restore | patterns
when-an-inner-rendering-needs-a-different-strategy-than-the-outer-rendering swap-the-state-and-restore-it-in-finally | patterns
`[__proto__]:`-bracket-notation-to-preserve-JSON-meaning | patterns
three-cases-for-property-keys (__proto__ + identifier-pattern + JSON.stringify) | patterns
`qp`-template-literal-tag (quasi-quotes Justin) | patterns
the-error-message-becomes-a-snippet-that-the-reader-can-paste-into-a-REPL | patterns
qp-eager-vs-q-lazy with honest-disclosure-of-layering-constraint | patterns
three-cycles-on-honest-acknowledgment-of-architectural-asymmetry (cycles 220 + 224 + 229) | references
three-named-not-yet-implemented-cases acknowledged with Fail (error cause + AggregateError + error errors) | patterns
refuse-to-silently-produce-wrong-output | patterns
co-maintain-doc-comment-and-test-module instruction | patterns
two-cycles-on-tests-as-the-documentation-pattern (cycles 217 + 229) | references
four-output-shapes for slot-rendering (slot-bound vs iface-defined) | patterns
the-passableAsJustin pipeline of three stages (toCapData → JSON.parse → decodeToJustin) | patterns
the-marshal-package-now-substantially-ingested across six cycles (69 + 74 + 81 + 84 + 158 + 229) | references
thirty-second-member of small-files-with-large-knowledge-density family | patterns
sixty-third consecutive designs-chat alternation cycles 166-229 | patterns
library-reaches-735-sections at cycle 229 (chat-lane @endo/marshal/marshal-justin) | patterns
endor-npm-registry-proxy | (see source: endo-but-for-bots--llm-designs-endor-npm-registry-proxy)
enumerate-the-existing-substrate's-prerequisites-and-eliminate-each-one | patterns
the-replacement-design-IS-the-substitution + the-substitution-IS-defined-by-what-it-removes | patterns
phases-by-number-with-implementation-files-and-remaining-one-line-purposes | patterns
twenty-fifth-honest-design-evolution-record family member | references
ten-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230) | references
fifth-cycle-with-ASCII-illustration in 2026-06 (cycles 214 + 218 + 220 + 228 + 230) | references
two-table-SQLite-schema (packages + package_meta) with two-different-cache-grains | patterns
Go-style-Minimal-Version-Selection (MVS) | patterns
the-greatest-explicitly-mentioned-minor-version-rule | patterns
conservative-not-aggressive (avoid pulling in untested versions) | patterns
comparison-with-Go's-MVS table (five aspects named side-by-side) | patterns
when-the-design-is-inspired-by-a-named-precedent a-side-by-side-table-makes-the-similarities-and-differences-explicit | patterns
six-step-package-fetching-pipeline | patterns
six-step-integration-with-`endor run` for bare-specifier resolution | patterns
offline-mode + registry-table-as-implicit-lock-file | patterns
CAS-tree-structure with three-named-fields-per-entry (type + hash + size) | patterns
automatic-deduplication-at-blob-level (property of content-addressing not separate optimization) | patterns
three-cycles-on-content-addressed-deduplication (cycles 200 + 222 + 230) | references
five-Design-decisions with named-rationale-per-decision | patterns
Known-gaps-section-with-checkboxes | patterns
intentionally-omitted-pre/post-install-scripts (Endo does not execute arbitrary install scripts) | patterns
when-omitting-a-feature-for-security-reasons name-it-as-intentionally-omitted + name-the-security-reason | patterns
honor-npm's-.npmrc-token-format for compatibility | patterns
two-named-Dependencies with verb-prefixed-Relationship-column (Requires + Integrates) | patterns
five-Implementation-Phases each with named-test-per-phase | patterns
the-test-IS-the-completion-criterion-for-the-phase | patterns
three-cycles-with-Prompt-section-captured (cycles 198 + 224 + 230) | references
a-design-doc-as-a-design-reminder (cycle 230's meta self-referential prompt) | patterns
sixty-fourth consecutive designs-chat alternation cycles 166-230 | patterns
library-reaches-736-sections at cycle 230 (designs-lane endor-npm-registry-proxy) | patterns
@endo/marshal/encodeToCapData | (see source: endo--packages-marshal-src-encodeToCapData)
QCLASS-as-special-property-name (`@qclass`) | patterns
the-canonical-JSON-discipline (JSON.stringify(encode(v1)) === JSON.stringify(encode(v2))) | patterns
sort-copyRecord-property-names (only case where order is not implicit in the code) | patterns
honest-disclosure-about-non-determinism-mitigation | patterns
dont-encode-defaults-that-throw | patterns
strict-by-default-with-opt-in-extension | patterns
three-cycles-on-strict-by-default-with-opt-in-extension (cycles 226 + 230 + 231) | references
defense-in-depth-validation-of-callback-return-shape via qclassMatches | patterns
`-0`-normalization-for-canonical-encoding | patterns
three-instances-of-Hilbert-Hotel-encoding family (cycles 148 + 229 + 231) | references
`freeze(rest)`-explicit-after-spread (rest is freshly constructed; freeze restores invariant) | patterns
isErrorLike-tolerance at root only (lenient-at-the-root + strict-deeper) | patterns
when-the-design-is-about-error-reporting be-extra-tolerant-of-malformed-inputs-at-the-error-reporting-path | patterns
three-phase-deprecation (currently accepted + TODO env-option-conditional + eventually remove) | patterns
explicit-BEWARE-comment for known vulnerability with deprecation rationale | patterns
four-cycles-on-honest-acknowledgment-of-architectural-asymmetry (cycles 220 + 224 + 229 + 231) | references
implementation-restriction-with-named-issue-tracker-link (Agoric-sdk#4334) | patterns
the-issue-IS-the-roadmap-entry | patterns
`@ts-expect-error`-as-marker-for-error-cases-that-must-throw | patterns
don't-harden-since-we're-not-done-mutating-it (named comment as protocol against premature hardening) | patterns
seven-cycles-using-freeze-or-don't-harden-with-named-correctness-argument (cycles 132 + 146 + 154 + 199 + 219 + 223 + 231) | references
three-cycles-on-protocol-via-name-prefix family (cycles 217 + 219 + 231) | references
the-marshal-package-now-comprehensively-ingested across seven cycles (cycles 69 + 74 + 81 + 84 + 158 + 229 + 231) | references
the-encode-decode-pair (cycle 229 marshal-justin decode + cycle 231 encodeToCapData encode) | references
thirty-third-member of small-files-with-large-knowledge-density family | patterns
sixty-fifth consecutive designs-chat alternation cycles 166-231 | patterns
library-reaches-737-sections at cycle 231 (chat-lane @endo/marshal/encodeToCapData) | patterns
endoclaw-channel-bridges | (see source: endo-but-for-bots--llm-designs-endoclaw-channel-bridges)
ninth-member-of-the-endoclaw-cluster | references
nine-design-cluster for the-endoclaw-feature (parent 196 + 222 skill-registry + 226 six-children + 232) | references
named-third-party-foundation (Vercel chat SDK) as design discipline | patterns
when-a-design-doesn't-invent-a-bridge-SDK it-builds-on-an-existing-one | patterns
seven-platform-adapters-table with per-platform-feature-list-revealing-asymmetries | patterns
the-asymmetry-table-IS-the-feature-comparison-tool | patterns
three-feature-buckets observable (Mentions + Reactions + Cards) | patterns
unified-event-model + thread-abstraction + JSX-card-components as cross-platform-pillars | patterns
four-layer-architecture-ASCII-diagram (Platform ↕ SDK ↕ Bridge ↕ Agent) | patterns
sixth-cycle-with-ASCII-illustration in 2026-06 (cycles 214 + 218 + 220 + 228 + 230 + 232) | references
five-step-bridge-plugin-flow | patterns
five-named-message-mappings Endo→platform with fallback-to-text-prompt | patterns
form-bridging via JSX with design-the-rich-representation-and-name-the-text-fallback | patterns
the-design-rejects-lowest-common-denominator + also-rejects-platform-specific-implementations + the-JSX-abstraction-IS-the-compromise | patterns
Bridge-is-a-confined-guest (SES-locked worker + no-ambient-X) | patterns
One-bridge-per-agent-per-account (One-instance-per-narrow-scope prevents authority-concentration) | patterns
Platform-credentials-are-capabilities (bridge never sees raw bot token; revocation via OAuthControl.revoke) | patterns
State-is-Endo-native (reject SDK's state adapter; use formula store) | patterns
when-the-SDK-offers-a-state-adapter-but-the-host-has-its-own-storage use-the-host's-storage-not-the-SDK's | patterns
four-cycles-on-no-new-abstractions discipline (cycles 211 + 214 + 222 + 232) | references
SES-Compatibility section with honest-acknowledgment-of-untested + three-named-fallback-paths | patterns
unconfined-plugin-fallback as last-resort with reduced-confinement-in-exchange-for-ecosystem-access | patterns
three-cycles-with-graceful-degradation-of-confinement (cycles 226 + 228 + 232) | references
version-pinning in Depends-On (chat v4.x) | patterns
OR-between-alternative-paths in Depends-On (network-fetch OR oauth) | patterns
twenty-sixth-honest-design-evolution-record family member | references
eleven-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232) | references
later-member-of-an-established-cluster-template | patterns
when-a-cluster-establishes-a-template later-members-follow-it-without-explanation | patterns
sixty-sixth consecutive designs-chat alternation cycles 166-232 | patterns
library-reaches-738-sections at cycle 232 (designs-lane endoclaw-channel-bridges) | patterns
@endo/init/node-async-local-storage-patch | (see source: endo--packages-init-node-async-local-storage-patch)
the-kResourceStore-setter-intercept (Object.defineProperty setter on AsyncLocalStorage.prototype) | patterns
intercept-the-platform's-internal-property-set-via-setter-on-prototype | patterns
three-cycles-on-intercept-platform's-internal-property-set (cycles 219 + 225 + 233) | references
two-level-WeakMap-for-two-level-keying (outer by instance + inner by resource) | patterns
replace-strong-reference-with-WeakMap-for-GC-friendly-resource-tracking | patterns
the-_propagate-hook for store inheritance from trigger resource | patterns
the-run()-four-step-discipline (optimize-fast-path + enable+capture+set + try + finally restore) | patterns
optimize-when-store-is-already-active (skip AsyncResource creation) | patterns
three-cycles-on-fast-path-when-input-matches-current-state (cycles 215 + 222 + 233) | references
ObjectIs-not-equality for SameValue semantics | patterns
ReflectApply-with-null-this for callback invocation | patterns
sixth-instance of Reflect.apply-as-the-defensive-uncurry (cycles 199 + 207 + 211 + 215 + 227 + 233) | references
getStore-undefined-when-disabled (distinct sentinel return value) | patterns
enterWith() as the-other-store-setter without try-finally cleanup | patterns
two-API-shapes-for-two-different-lifetime-models (scoped run + persistent enterWith) | patterns
the-eslint-disable-no-underscore-dangle to honor platform's internal-API convention | patterns
three-cycles-with-underscore-prefix-naming-and-eslint-disable (cycles 217 + 223 + 233) | references
three-different-underscore-conventions for three-different-substrates | patterns
three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation (cycles 219 + 225 + 233) | references
three-cycles-with-try-finally-swap-and-restore (cycles 229 + 231 + 233) | references
`configurable: true` on prototype property to leave door open for platform | patterns
the-file-must-run-before-AsyncLocalStorage-is-instantiated (pre-instantiation discipline) | patterns
thirty-fourth-member of small-files-with-large-knowledge-density family | patterns
sixty-seventh consecutive designs-chat alternation cycles 166-233 | patterns
library-reaches-739-sections at cycle 233 (chat-lane @endo/init/node-async-local-storage-patch) | patterns
endoclaw-oauth | (see source: endo-but-for-bots--llm-designs-endoclaw-oauth)
tenth-member-of-the-endoclaw-cluster | references
ten-design-cluster for the-endoclaw-feature (196 + 222 + 226's-six + 232 + 234) | references
the-agent-never-sees-the-token (canonical ocap pattern) | patterns
authority-to-use-not-authority-to-delegate-outside-the-capability-graph | patterns
a-structural-invariant-of-the-interface-not-a-runtime-check | patterns
the-credential-only-flows-through-the-call-not-through-a-getter | patterns
two-different-capability-shapes-for-credential-handling (cycle 224 bearer-token-as-formula-ID vs cycle 234 hides-token-entirely) | references
two-layer-confinement (baseUrl scope + path allowlist within scope) | patterns
subdomain-vs-path-distinction (the domain is not the confinement boundary; the path is) | patterns
read-only-mode boolean toggle restricts to GET/HEAD | patterns
two-cycles-with-the-setReadOnly-mode-toggle (cycles 226 + 234) | references
six-step-OAuth-flow with step-5-as-five-substep-internal-flow (prepend + validate + check + inject + make) | patterns
token-refresh-handled-transparently-by-default + explicit-control-via-control-facet-method | patterns
two-layered-revocation (local authoritative + remote optional best-effort) | patterns
the-optionally-acknowledges-that-provider-side-revocation-might-fail | patterns
a-higher-level-capability-is-a-wrapper-around-a-lower-level-capability | patterns
the-authenticated-decorator on top of HttpClient substrate | patterns
enumerate-concrete-use-cases-and-then-generalize | patterns
the-OR-between-named-library-and-minimal-implementation in Depends-On | patterns
twenty-seventh-honest-design-evolution-record family member | references
the-design-evolution-record-grows-not-just-by-new-shapes-but-also-by-more-instances-of-existing-shapes | patterns
sixty-eighth consecutive designs-chat alternation cycles 166-234 | patterns
library-reaches-740-sections at cycle 234 (designs-lane endoclaw-oauth) | patterns
@endo/compartment-mapper/src/generic-graph | (see source: endo--packages-compartment-mapper-src-generic-graph)
GenericGraph class with class-private-fields | patterns
class-private-field-syntax (`#name`) for language-level true privacy | patterns
four-different-underscore-or-hash-conventions (cycles 217 + 223 + 233 + 235) | references
honest-attribution-to-third-party with license (datavis-tech/graph-data-structure MIT by Curran Kelleher) | patterns
three-cycles-on-third-party-attribution (cycles 84 + 232 + 235) | references
Dijkstra's-single-source-shortest-path-algorithm with three-named-classical-steps (extractMin + relax + loop) | patterns
cache-the-traversal-context-by-source (amortize O(V²); subsequent calls O(path length)) | patterns
recognize-when-the-algorithm's-natural-product-is-larger-than-the-API's-natural-product + cache-the-larger-product | patterns
when-an-algorithm-is-single-source-but-the-API-is-pairwise cache-by-source | patterns
pathCompare-as-edge-weight (path-itself-is-cost; cycle 209 sibling) | patterns
when-the-cost-is-the-path-not-a-number extending-the-path-is-the-cost-update | patterns
defensive-copy-in-getter (returns new Set(this.#nodes) to prevent mutation) | patterns
chainable-API via return this (mutating methods chainable) | patterns
classical-algorithm-step-names for reader recognition (relax + extractMin) | patterns
three-named-assertions-after-walking-predecessor-chain | patterns
nodeList.reverse() to get source-to-target order from backwards traversal | patterns
`[T, T, ...T[]]` tuple-type-for-non-empty-array-with-minimum-length | patterns
linear-search-priority-queue with named trade-off (O(V²) overall) | patterns
explicit-termination-signal-via-undefined when algorithm cannot proceed | patterns
first-direct-ingest from @endo/compartment-mapper/src | patterns
when-a-package-is-foundational-machinery ingest-its-thin-dispatchers-first + work-down-to-the-heavy-files-over-time | patterns
the-library-builds-up-the-shape-of-the-package-from-its-edges-inward | patterns
thirty-fifth-member of small-files-with-large-knowledge-density family | patterns
sixty-ninth consecutive designs-chat alternation cycles 166-235 | patterns
library-reaches-741-sections at cycle 235 (chat-lane @endo/compartment-mapper/generic-graph) | patterns
phases-grew-beyond-original-scope-and-status-flipped-back-to-in-progress | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
source-only-archive-replaces-precompiled-bundle (three-named-problems + four-named-properties) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
three-axis-table (Method × Source × Confinement) producing four-shapes-of-make | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
`@node` as required-host-only-special-name (three properties: required + host-only + XS-rejects-with-redirect-message) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
state-purge-as-acceptable-design-cost (no migration path) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
naming-by-source-shape-not-by-product (makeFromTree not makeCaplet) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
composable-stageTree-plus-convenience-wrapper-makeUnconfinedFromTree | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
thisDiesIfThatDies (named lifetime-linkage mechanism) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
source-only-contract-preserved-via-parser-map-omits-precompiled-parsers | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
the-absence-of-code-IS-the-enforcement | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
the-legacy-Node.js-bridge-stays-open-indefinitely (goal-is-disuse-not-removal) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
nine-Design-Decisions with numbered rationale | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
four-buckets-classify-every-caplet-source | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
no-on-the-wire-format-change-needed (no-new-abstractions discipline) | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
Dependencies-table-with-Relationship-column | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
Known-Gaps-and-TODOs-section-with-checkboxes | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
open-optimisation-tracked-as-follow-up-not-required-for-correctness | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
fourth-Prompt-section-instance with first-Follow-on-prompt-section | (see section: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper)
twenty-eighth-honest-design-evolution-record family member | patterns
twelfth-different-shape-of-design-evolution-record in 2026-06 cluster | patterns
three-cycles-with-explicit-flow-and-convenience-wrapper (222 + 226 + 236) | patterns
five-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236) | patterns
four-cycles-on-strict-by-default-with-opt-in-extension (226 + 230 + 231 + 236) | patterns
three-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236) | patterns
two-cycles-with-Known-Gaps-checklist (230 + 236) | patterns
two-cycles-with-numbered-Design-Decisions (230 has 5 + 236 has 9) | patterns
three-different-fates-for-legacy-paths-in-library (217 tolerated + 228 superseded + 236 active-indefinitely) | patterns
four-cycles-with-Prompt-section-captured (198 + 224 + 230 + 236) | patterns
first-cycle-with-a-Follow-on-prompt-section | patterns
seventieth consecutive designs-chat alternation cycles 166-236 | patterns
library-reaches-742-sections at cycle 236 (designs-lane daemon-make-archive) | patterns
shortlex-order (length → cumulative-character-count → lexicographic) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
the-doc-comment-IS-the-algorithm-specification with five-numbered-steps | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
three-tiers-of-tie-breaking | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
the-tie-breaker-ordering-IS-the-design | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
undefined-sorts-greater-than-anything-else (canonical comparator decision) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
undefined-is-in-the-type-not-out-of-band (`CompareFn<string[]|undefined>`) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
sanity-check-with-`/* c8 ignore next 5 */` for unreachable defense-in-depth | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
first-explicit-observation of c8-ignore-with-explanation as borrowable pattern | patterns
JSON.stringify-aliased-as-q at file top for terse error messages | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
first-explicit-observation of `const { stringify: q } = JSON` as borrowable pattern | patterns
the-comment-names-the-edge-case-explicitly (one-string-being-a-prefix-of-the-other) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
defense-by-construction-via-step-ordering | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
two-CompareFn-instances (the-larger-uses-the-smaller) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
CompareFn-template-type as JSDoc @callback typedef parameterized by T | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
type-precision via `CompareFn<string>` vs `CompareFn<string[]|undefined>` | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
UTF-16-code-unit-comparison-via-JavaScript-`<`-operator | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
nested-ternary-with-eslint-disable as named-exception | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
sixteen-tests for 84-line-file (test-to-source ratio ~0.8) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
test-titles-name-the-property-not-the-mechanism | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
test-the-tie-breaker-by-constructing-the-tie via `despite` clauses | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
test-undefined-cases-symmetrically (three cases) | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
test-empty-arrays-as-degenerate-case | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
test-uses-t.true-for-sign-not-t.is-for-value (when spec says "negative" not "-1") | (see section: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore)
three-cycle-progression for pathCompare (referenced 209 + used-as-edge-weight 235 + directly-ingested 237) | patterns
when-a-library-references-X-then-uses-X-then-ingests-X (natural-deepening-pattern) | patterns
second-direct-ingest from `@endo/compartment-mapper` neighborhood (cycles 235 + 237) | patterns
thirty-sixth-member of small-files-with-large-knowledge-density family | patterns
first-explicit-observation of "shortlex" as named-ordering in library | patterns
README-mermaid-graphs as named-illustration-mechanism (four mermaid graphs) | patterns
seventy-first consecutive designs-chat alternation cycles 166-237 | patterns
library-reaches-743-sections at cycle 237 (chat-lane @endo/path-compare/src/index) | patterns
design-revision-after-CHANGES_REQUESTED-with-named-PR-and-review-id | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
the-controller-and-client-cap-split (canonical ocap two-facet pattern) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
mutate-the-policy-not-the-client-identity (with three named benefits) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
the-controller-IS-the-pet-name-handle (survives across CLI invocations) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
endo-http-subcommand-tree-replaces-single-verb (room-to-grow pattern) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
method-placement-table as cap-discipline statement | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
the-add-and-remove-convenience-methods-prevent-read-mutate-write-races | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
cancellation-promise-as-platform-neutral-interface (Promise<never>) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
AbortController-is-mapped-one-way-at-the-platform-boundary | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
two-independent-cancellation-channels (host-revoke + caller-cancellation) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
three-named-SSRF-vectors-and-three-named-defenses (redirect + slow-loris + response-flooding) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
redirect-manual to defeat metadata-server pivot | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
truncation-at-read-time-survives-Content-Length-lie | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
local-idioms-cited-table as no-new-abstractions evidence | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
ReadableBlob-IS-the-forward-compatible-shim | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
forward-compatible-shim-with-named-future-target | patterns
Alternatives-Considered-with-three-fates (rejected + rejected + deferred) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
each-rejection-names-the-specific-failure-mode | patterns
deferral-names-the-non-breaking-condition | patterns
identifier-conventions-TBD-pending-namer-dispatch | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
open-questions-with-default-or-proposal | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
test-plan-named-in-the-design-doc (eight named scenarios) | (see section: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED)
Supersedes-in-part as metadata-table-field-shape | patterns
the-design-doc-IS-the-prose-counterpart-to-the-PR-review-thread | patterns
the-design-doc-cites-the-PR-and-the-review-id-by-number | patterns
the-split-is-a-strict-generalization (anything-rejected-can-still-be-expressed-by-not-mutating) | patterns
twenty-ninth-honest-design-evolution-record family member | patterns
thirteenth-different-shape-of-design-evolution-record in 2026-06 cluster | patterns
six-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238) | patterns
four-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238) | patterns
fifth-Prompt-section-instance (198 + 224 + 230 + 236 + 238) | patterns
five-cycles-with-Prompt-section-captured (198 + 224 + 230 + 236 + 238) | patterns
two-different-postures-on-naming-decisions-in-2026-06-cluster (236 named + 238 deferred) | patterns
two-cycles-with-explicit-identity-stability-as-a-named-design-axis (236 state-purge + 238 policy-mutation-without-identity-change) | patterns
eleven-design-cluster for endoclaw + cli-http (cluster grows by partial-supersession-relationship) | patterns
cluster-evolution-by-extraction-and-renaming | patterns
seventy-second consecutive designs-chat alternation cycles 166-238 | patterns
library-reaches-744-sections at cycle 238 (designs-lane cli-http-client) | patterns
GET_INTERFACE_GUARD (`__getInterfaceGuard__`) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
the-named-constant-string-IS-the-protocol-name | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
double-underscore-wrap (CapTP introspection meta-method naming convention) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
two-named-meta-methods-in-CapTP-introspection (getMethodNames + getInterfaceGuard) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
the-cache-staleness-caveat-as-explicit-warning (Beware prefix) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
the-warning-IS-the-protocol-contract | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
Beware-prefix-marks-actionable-warning-not-passive-note | patterns
the-computed-property-key-uses-the-constant | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
defense-by-construction-via-computed-property-key | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
the-PR-discussion-link-IS-the-design-record-of-the-constant | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
two-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239) | patterns
template-with-constraint (`@template {Record<...>} M`) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
two-named-shapes-of-not-having-an-interface (method absent vs method present returning undefined) | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
mapped-type-from-method-record-to-method-guard-record | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
inline-import-expressions-as-fallback-when-@import-isn't-set-up | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
twenty-eight-lines-as-a-complete-protocol-artifact | (see section: endo--packages-exo-src-get-interface--GET_INTERFACE_GUARD-protocol-name-and-double-underscore-wrap-and-typedef-with-computed-property-key-and-cache-staleness-caveat)
the-protocol-artifact-shape-not-the-implementation-shape | patterns
two-different-cache-shapes (deterministic-algorithm-cache cycle 235 + protocol-state-cache cycle 239) | patterns
four-different-underscore-or-hash-conventions in library (cycles 217 + 223 + 235 + 239) | patterns
third-direct-ingest from @endo/exo src (after exo-makers cycle 79 + exo-tools cycle 80) | patterns
thirty-seventh-member of small-files-with-large-knowledge-density family | patterns
seventy-third consecutive designs-chat alternation cycles 166-239 | patterns
library-reaches-745-sections at cycle 239 (chat-lane @endo/exo/src/get-interface) | patterns
Reshape-blocker-for-PR (new relationship type distinct from Supersedes or Dependencies) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
the-third-axis-was-introduced-without-naming | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
three-orthogonal-axes-mixed-in-existing-verbs (source-sink + representation + where-it-lives) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
verb-count-as-named-cost | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
survey-table-of-existing-verbs as baseline with per-axis columns | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
mutual-exclusion-of-flag-groups names the axes | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
same-flag-for-read-and-write (symmetry by verb pair not by flag prefix) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
no-encoding-flag-the-daemon-does-not-negotiate-codecs | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
blobs-are-bytes (load-bearing maxim attributed to PR review) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
no-content-type-on-blobs (three named locations for out-of-band metadata) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
two-different-API-shapes-for-two-different-substrates (formula-creation vs mount-mutation) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
state-dependent-dispatch-anti-pattern (verb effect depends on implicit state cannot be scripted defensively) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
internal-consistency-test-as-design-discipline | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
two-viable-name-choices-with-Pro/Con-per-choice | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
reserved-future-siblings (with explicit non-prejudgment of sibling shape) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
PR-stacking-discipline-named-explicitly | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
three-named-things-per-deferral (feature + trigger + cost) | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
Decisions-section-quotes-the-maintainer-review-verbatim | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
Subsumes-old-verb-annotations-in-canonical-form-examples | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
rejection-tests-explicitly-listed-in-test-plan | (see section: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write)
thirtieth-honest-design-evolution-record family member | patterns
fourteenth-different-shape-of-design-evolution-record in 2026-06 cluster | patterns
seven-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240) | patterns
five-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238 + 240) | patterns
sixth-Prompt-section-instance (198 + 224 + 230 + 236 + 238 + 240) | patterns
three-cycles-with-PR-discussion-link-as-named-provenance (238 + 239 + 240) | patterns
two-cycles-with-PR-driven-redesign-shapes (238 CHANGES_REQUESTED + 240 inline-review-comment) | patterns
two-cycles-with-Alternatives-Considered-section-with-named-fates (238 + 240) | patterns
two-cycles-with-Decisions-section-that-quote-the-maintainer-review-verbatim (238 + 240) | patterns
two-cycles-with-explicit-future-reservation in 2026-06 cluster (238 + 240) | patterns
three-cycles-with-numbered-Design-Decisions (230 had 5 + 236 had 9 + 240 has 3) | patterns
two-cycles-with-Test-plan-named-in-the-design-doc (238 + 240) | patterns
twelve-design-cluster for endoclaw + cli-http + cli-store | patterns
seventy-fourth consecutive designs-chat alternation cycles 166-240 | patterns
library-reaches-746-sections at cycle 240 (designs-lane cli-store-verb-text-modes) | patterns
postponed-handler-pattern (defers every operation until donePostponing callback) | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
interlockP (name a pending promise after the synchronization shape) | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
the-resolve-callback-is-captured-via-closure-in-Promise-executor | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
`assert(callback)`-with-`@ts-expect-error`-and-cited-error-code | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
six-method-handler-protocol-as-2x3-axis-table (operation × send-mode) | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
postponedOperation-as-method-name-string-used-as-key-on-HandledPromise | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
makePostponedOperation-as-method-factory | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
the-returned-function-has-a-debug-name (`function postpone(...)`) | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
`.then(_ =>` ignored-resolve-value with underscore prefix | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
commented-out-console.log-as-debugging-affordance | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
`Required<Handler<any>>` for completeness-of-implementation type discipline | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
defense-by-construction-via-`Required<>`-wrapper | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
the-`<any>`-parameter-as-the-honest-type-when-the-target-is-genuinely-unknown | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
forty-six-lines-as-a-complete-handler-protocol-postponement | (see section: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type)
thin-wrapper-around-a-Promise-no-class-machinery | patterns
two-cycles-with-`@ts-expect-error`-citing-a-specific-TS-issue-or-error-code (146 + 241) | patterns
two-different-comment-shapes-with-named-roles (239 Beware-prefix + 241 commented-out-console.log) | patterns
two-different-shapes-of-deferred-resolution (238 controller-pet-name-handle + 241 postponed-handler) | patterns
two-uses-of-string-as-protocol-key (239 GET_INTERFACE_GUARD + 241 postponedOperation) | patterns
sixth-direct-ingest from @endo/eventual-send/src | patterns
thirty-eighth-member of small-files-with-large-knowledge-density family | patterns
seventy-fifth consecutive designs-chat alternation cycles 166-241 | patterns
library-reaches-747-sections at cycle 241 (chat-lane @endo/eventual-send/src/postponed) | patterns
Roadmap-calibration-per-git-blame (retrospective design-doc structure with named bursts and commit hashes) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
calendar-vs-active-development-distinction | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
conditional-exports-with-three-paths (default-condition-gated + lite-always-available + explicit-platform-bypass) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
type-lattice-as-2x3-axis-table (three-roles × two-kinds) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
Snapshot-extends-Readable (structural subtyping) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
structural-attenuation-not-behavioral-attenuation (readOnly returns readable interface not frozen copy) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
the-"elevator"-module (platform-specific module does the platform import) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
No-help()-in-this-layer (explicit non-inclusion with higher-layer named) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
push-interface-vs-pull-interface-decoupling (TreeWriter vs ReadableTree) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
tree-manifest-format-named-with-explicit-canonicalization | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
three-roles-an-object-can-play (Readable / Snapshot / Mutable with named substrates) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
Relationship-to-existing-interfaces (enumerate each overlap with mapping or omission) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
stops-at-the-filesystem-boundary (named design discipline) | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
four-phase-implementation-plan-with-S/M-complexity-tags | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
The-Prompt-IS-the-naming-spec | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
superset-by-construction | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
subDir-deferred-to-future-VFS-layer-with-reason | (see section: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation)
thirty-first-honest-design-evolution-record family member | patterns
fifteenth-different-shape-of-design-evolution-record in 2026-06 cluster | patterns
eight-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242) | patterns
six-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238 + 240 + 242) | patterns
seventh-Prompt-section-instance (198 + 224 + 230 + 236 + 238 + 240 + 242) | patterns
four-cycles-with-numbered-Design-Decisions (230 had 5 + 236 had 9 + 240 had 3 + 242 has 7) | patterns
three-cycles-with-axis-tables-as-design-vocabulary (236 + 241 + 242) | patterns
two-cycles-with-explicit-structural-attenuation-discipline (238 + 242) | patterns
two-cycles-with-explicit-non-inclusion-of-a-conventional-method (238 + 242) | patterns
two-cycles-with-explicit-future-deferral-with-reason-and-future-layer (238 + 242) | patterns
two-different-temporal-postures-on-PR-provenance (238 forward-looking + 242 retrospective) | patterns
two-different-postures-on-naming (240 namer-dispatch + 242 names-in-prompt) | patterns
two-different-shapes-of-platform-bridge-discipline (188 monkey-patch + 242 elevator-module) | patterns
seventy-sixth consecutive designs-chat alternation cycles 166-242 | patterns
library-reaches-748-sections at cycle 242 (designs-lane platform-fs) | patterns
endianness-detection-via-typed-array-aliasing (Uint8Array + Uint16Array over same buffer) | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
the-test-buffer-is-the-minimum-unit-that-distinguishes-the-orderings (two bytes [1, 0]) | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
the-bytes-have-a-distinguishing-bit-and-don't-care-padding | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
module-load-evaluation-memoizes-the-result | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
the-name-shifts-from-predicate-to-state-when-the-function-result-is-cached | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
the-named-form-over-the-IIFE-form (name IS the documentation) | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
isolate-the-named-decision-in-its-own-file | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
the-constant-IS-the-API (no function call to retrieve the fact) | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
performance-by-construction (detection runs once; cached result on every call) | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
nine-lines-as-a-complete-platform-detection-artifact | (see section: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state)
smallest-file-ingested-so-far (nine lines at cycle 243) | patterns
three-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243) | patterns
two-cycles-with-names-given-to-functions-that-didn't-need-them-syntactically (241 + 243) | patterns
first-direct-ingest from @endo/lp32/src | patterns
thirty-ninth-member of small-files-with-large-knowledge-density family | patterns
seventy-seventh consecutive designs-chat alternation cycles 166-243 | patterns
library-reaches-749-sections at cycle 243 (chat-lane @endo/lp32/src/host-endian) | patterns
two-Author-fields-with-named-roles (prompted + evolving) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
Status-section's-three-named-subsections (Implemented + Not-yet-implemented + Deviations-from-design) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
the-heartbeat-IS-the-core-"there"-that-makes-an-agent-tick | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
heartbeat-vs-cron-vs-policy-three-layered-separation | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
IntervalScheduler/IntervalControl two-facet caretaker pattern | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
TickResponse-as-one-shot-exo-with-three-fates (resolve + reschedule + implicit-timeout-resolve) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
default-resolve-on-timeout-not-default-reschedule (default IS forward progress) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
start-to-start-timing-not-end-to-start | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
missed-ticks-coalesced-not-replayed | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
tick-events-as-messages-not-iterator-values | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
exponential-backoff-with-three-named-bounds | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
thisDiesIfThatDies + onCancel (two named lifetime mechanisms) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
atomic-write-via-write-then-rename | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
in-memory-state-is-derived-from-the-persisted-state | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
pause-suppresses-not-defers (named distinction) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
revocation-is-permanent | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
cited-prior-art-by-name (Go time.Ticker + Tokio time::Interval) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
no-ambient-scheduling (capability by construction) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
four-named-attack-defense-pairs in Security Considerations | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
ten-numbered-Design-Decisions (highest count yet in library) | (see section: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed)
thirty-second-honest-design-evolution-record family member | patterns
sixteenth-different-shape-of-design-evolution-record in 2026-06 cluster | patterns
nine-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244) | patterns
seven-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238 + 240 + 242 + 244) | patterns
five-cycles-with-numbered-Design-Decisions (230 had 5 + 236 had 9 + 240 had 3 + 242 had 7 + 244 has 10) | patterns
three-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244) | patterns
three-cycles-with-explicit-refusal-of-conventional-feature (240 + 242 + 244) | patterns
three-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244) | patterns
three-different-temporal-postures-on-design-implementation-mismatch (238 pre + 244 mid + 242 post) | patterns
two-cycles-with-thisDiesIfThatDies-named-lifetime-linkage (236 + 244) | patterns
two-different-shapes-of-evolution-record (242 temporal + 244 personal) | patterns
three-cycles-on-explicit-three-fates-of-an-operation (238 alts + 240 alts + 244 tick fates) | patterns
seventy-eighth consecutive designs-chat alternation cycles 166-244 | patterns
library-reaches-750-sections at cycle 244 (designs-lane endoclaw-timer) | patterns
pony-vs-shim-distinction (pony is the mechanism + shim is the installation) | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
conditional-method-via-conditional-spread (when platform feature is optional) | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
the-`opt`-prefix-on-optional-pony-functions | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
better-fidelity-emulation-of-class-prototype-via-non-enumerable-properties | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
strip-enumerability-via-defineProperty-loop | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
warning-not-error-on-prior-installation (modern-shim discipline) | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
install-via-defineProperties-plus-getOwnPropertyDescriptors (canonical batch-install) | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
TS-flow-inference-workaround-via-local-rebinding | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
destructure-globalThis-at-top-with-eslint-disable-no-restricted-globals | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
two-eslint-disables-with-distinct-named-justifications | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
getter-as-property-syntax (`get name()` inside object literal) | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
the-TODO-names-a-known-confusing-case | (see section: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation)
three-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator-module + 245 pony-shim) | patterns
three-cycles-with-explicit-absence-as-attenuation (238 + 242 + 245) | patterns
two-cycles-with-explicit-globalThis-destructure (237 + 245) | patterns
two-different-naming-conventions-for-rename-aliases (237 + 245) | patterns
two-different-shapes-of-TypeScript-workaround (241 + 245) | patterns
two-different-shapes-of-warning-discipline (237 + 245) | patterns
two-cycles-with-explicit-acknowledgment-of-a-known-imperfection (235 + 245) | patterns
two-cycles-with-getter-syntax-on-object (235 + 245) | patterns
first-direct-ingest from @endo/immutable-arraybuffer/src | patterns
seventy-ninth consecutive designs-chat alternation cycles 166-245 | patterns
library-reaches-751-sections at cycle 245 (chat-lane @endo/immutable-arraybuffer/src/immutable-arraybuffer-shim) | patterns
webhook-as-formula (formula IS the webhook + formula-id IS the URL path) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
inbox-delivery (webhook payloads as normal inbox messages) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
capability-controlled-creation (host grants the authority) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
HMAC-verification (secret part of formula state; gateway verifies at boundary) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
two-named-external-services-cited-by-header-name (GitHub X-Hub-Signature-256 + Stripe Stripe-Signature) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
WebhookEndpoint/WebhookControl two-facet caretaker pattern | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
two-shapes-of-deactivation (reversible-disable on use facet + permanent-revoke on control facet) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
short-design-doc-as-named-shape (five sections only) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
Depends-On-bullet-list-as-distinct-from-Dependencies-table | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
Endo-Idiom-section as recurring design-doc shape with N-named-disciplines | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
five-section-design-as-named-shape (Summary + Capability-Shape + How-It-Works + Endo-Idiom + Depends-On) | (see section: endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section)
ten-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246) | patterns
four-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246) | patterns
four-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246) | patterns
three-cycles-with-mail-system-as-the-event-substrate (232 + 244 + 246) | patterns
three-cycles-with-stable-cap-handles-via-pet-name-or-formula-id (238 + 244 + 246) | patterns
two-cycles-with-Endo-Idiom-section-with-N-named-disciplines (232 + 246) | patterns
two-different-shapes-of-dependency-record (Dependencies-table 7 cycles + Depends-On-bullet-list 1 cycle) | patterns
two-different-shapes-of-cluster-member-length (244 long 837-lines + 246 short 79-lines) | patterns
thirteenth-design-cluster-member for endoclaw + cli-http + cli-store | patterns
eightieth consecutive designs-chat alternation cycles 166-246 | patterns
library-reaches-752-sections at cycle 246 (designs-lane endoclaw-webhooks) | patterns
augment-the-error-with-location-on-the-error-path-only | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
two-named-error-cases (SyntaxError augmented + non-SyntaxError rethrown undisguised) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
the-`instanceof SyntaxError`-discrimination (narrow augmentation scope) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
Error-constructor-without-`new` (Error subclass callable as function since ES6) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
template-literal-error-coercion-loses-stack-trace (use { cause: error } instead if stack matters) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
location-q-quoted-before-inclusion (JSON.stringify for safe special-character handling) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
the-q-alias-as-direct-property-alias (`const q = JSON.stringify;`) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
three-different-stylistic-conventions-for-q-alias (237 destructure-rename + 245 destructure-no-rename + 247 direct-property) | patterns
comment-`For enquoting strings`-explains-why-the-letter-q | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
the-single-function-file (isolate one error-augmentation utility) | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
the-function-name-encodes-the-discipline | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
the-parameter-name-IS-the-required-context | (see section: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new)
four-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247) | patterns
three-cycles-with-q-in-error-message-context (237 + 247) | patterns
two-cycles-with-deliberate-stylistic-choice-over-equivalent-form (243 named-vs-IIFE + 247 call-vs-new) | patterns
fortieth-member of small-files-with-large-knowledge-density family | patterns
first-direct-ingest from @endo/check-bundle/src | patterns
eighty-first consecutive designs-chat alternation cycles 166-247 | patterns
library-reaches-753-sections at cycle 247 (chat-lane @endo/check-bundle/src/json) | patterns
UI-only-no-daemon-API-changes | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
drop-target-table (Target × Action × Daemon API Call) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
custom-MIME-type-as-discriminator-on-HTML5-drag-payload | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
two-MIME-types-on-drag-data (legacy text/plain + custom application/x-endo-petname) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
five-Considerations-sections (Security + Scaling + Test Plan + Compatibility + Upgrade) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
empty-considerations-section-acknowledged-explicitly (say `None` not omit) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
default-copy-Alt-to-move (modifier-key disambiguation) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
move-operations-not-atomic-acknowledged (matches existing CLI behavior) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
send-confirmation-dialog (defense against accidental capability sharing) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
three-named-visual-affordances-on-drag-interaction (source ghost + target highlight + no-drop cursor) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
multi-select-as-stretch-goal (named scope deferral vocabulary) | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
Affected-Packages-section as narrow-blast-radius-evidence | (see section: endo-but-for-bots--llm-designs-inventory-drag-and-drop--drop-target-table-and-custom-MIME-type-and-five-considerations-sections-and-UI-only-no-daemon-API-changes)
three-different-shapes-of-deferral-vocabulary (`deferred` + `reserved-as-future-sibling` + `stretch goal`) | patterns
eleven-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248) | patterns
two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline (246 + 248) | patterns
three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 + 248) | patterns
two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice (244 + 248) | patterns
three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248) | patterns
four-cycles-with-explicit-deferral-of-a-named-future-feature (238 + 240 + 242 + 248) | patterns
eighty-second consecutive designs-chat alternation cycles 166-248 | patterns
library-reaches-754-sections at cycle 248 (designs-lane inventory-drag-and-drop) | patterns
`export {};`-typedef-only-file-pattern | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
three-method-TrapImpl distinct from six-method-handler-protocol (sync vs async axis) | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
`applyMethod`-as-atomic-lookup-of-method-and-apply (security by construction) | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
TrapCompletion-as-discriminator-payload-tuple `[isRejected, CapData]` | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
the-non-thenable-constraint-as-explicit-sync-guarantee | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
`keyof InterfaceName`-as-defense-by-construction (against string-union drift) | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
out-of-band-communications-as-named-sync-over-async-mechanism | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
AsyncIterator-as-async-side-of-sync-over-async-bridge | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
`Required<Iterator<void, void, any>>` (completeness + all three iterator type params named) | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
Iterator-with-`void, void, any`-as-pure-control-flow-coordination | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
`AsyncIterator<...> | undefined`-as-optional-return | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
branded-string-typedef-for-domain-specific-meaning (CapTPSlot = string) | (see section: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async)
two-cycles-with-protocol-artifact-as-named-file-shape (239 with-named-constant-export + 249 without-runtime-export) | patterns
two-cycles-with-`Required<>`-wrapper-as-completeness-of-implementation discipline (241 + 249) | patterns
two-cycles-with-explicit-undefined-as-no-value-or-no-feature signal (239 + 249) | patterns
two-cycles-with-deferred-or-sync-bridge-patterns (241 + 249) | patterns
two-cycles-with-explicit-defense-against-method-detach-as-named-discipline (146 + 249) | patterns
fifth-direct-ingest from @endo/captp/src (atomics + finalize + loopback + trap + types) | patterns
forty-first-member of small-files-with-large-knowledge-density family | patterns
five-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249) | patterns
eighty-third consecutive designs-chat alternation cycles 166-249 | patterns
library-reaches-755-sections at cycle 249 (chat-lane @endo/captp/src/types) | patterns
Options-Considered-with-preferred (distinct from Alternatives-Considered) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
four-column-Group-table-with-Icon-and-Description | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
catch-all-bucket-explicitly-named (completeness guarantee) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
additive-API-change-via-destructure-immune-consumers | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
substrate-count-named-as-evidence-of-categorization-scope | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
the-design-IS-the-exposure-not-the-computation | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
exposing-X-doesn't-grant-new-capabilities (named security argument shape) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
restrict-interface-metadata-to-host-level-authority (stretch-goal security thinking not deferred) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
no-migration-needed (when API extension exposes existing substrate field) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
design-doc-template-recurs-across-related-designs (named author-discipline) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
Affected-Packages-section-as-blast-radius-evidence with varying row counts | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
a-specific-author's-recurring-deferral-vocabulary (named-discipline-signature) | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
preserve-existing-toggle-as-named-non-change | (see section: endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections)
three-shapes-of-design-doc-alternatives-section in library (Alternatives-with-three-rejected + Alternatives-with-rejected+deferred + Options-with-preferred) | patterns
twelve-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248 + 250) | patterns
two-cycles-with-the-same-Five-Considerations-sections-shape (248 + 250) | patterns
two-cycles-with-Affected-Packages-section (248 single-package + 250 three-packages with different blast radii) | patterns
two-cycles-with-`stretch goal`-as-named-deferral-vocabulary (248 + 250) | patterns
five-cycles-with-explicit-deferral-of-a-named-future-feature (238 + 240 + 242 + 248 + 250) | patterns
three-cycles-with-recurring-section-templates (Endo-Idiom 232+246 + Five-Considerations 248+250) | patterns
two-cycles-with-explicit-catch-all-bucket-as-completeness-guarantee (236 + 250) | patterns
two-different-shapes-of-Upgrade-Considerations-content (236 state-purge + 250 no-migration-needed) | patterns
two-cycles-with-explicit-named-backward-compatibility-discipline (242 forward-compatible-shim + 250 additive-API-change) | patterns
two-cycles-with-explicit-named-security-argument (244 no-ambient-X + 250 X-already-implicitly-available) | patterns
cycle-250-milestone-cycle (the 250th librarian cycle in this session) | patterns
eighty-fourth consecutive designs-chat alternation cycles 166-250 | patterns
library-reaches-756-sections at cycle 250 (designs-lane inventory-grouping-by-type) | patterns
five-named-deliverables-of-a-release | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
multiple-SEPs-collectively-deliver-an-architectural-change | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
Before-and-after-code-block-pair-with-named-version-numbers | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
the-practical-effect-on-production-IS-the-value-statement | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
stateless-protocol-stateful-applications (explicit-handle pattern) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
the-explicit-handle-pattern-makes-state-visible-to-the-model-not-hidden-in-transport-metadata | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
opaque-server-state-echoed-by-client-as-resumption-mechanism (requestState) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
expose-the-routing-discriminator-as-an-HTTP-header-not-in-the-body (Mcp-Method + Mcp-Name) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
cache-control-shape-as-replacement-for-SSE-polling (ttlMs + cacheScope) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
formalize-existing-key-names-in-spec (W3C Trace Context) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
reverse-DNS-IDs-as-named-identifier-convention-for-extensions | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
server-rendered-UI-with-three-named-defenses (sandbox + pre-declaration + uniform-back-channel) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
feature-graduates-to-an-extension-as-named-demotion-from-core | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
per-deprecated-feature-named-replacement | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
twelve-month-minimum-between-deprecation-and-removal | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
named-security-constraints-when-adopting-more-expressive-schema-language | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
named-breaking-change-with-named-affected-consumer-pattern | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
the-breaking-change-IS-the-foundation-for-non-breaking-future-changes | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
conformance-suite-as-gating-mechanism-for-Final-status | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
SEP-numbering-as-traceable-history-of-protocol-decisions | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
release-candidate-to-final-as-named-validation-window-with-tier-1-SDK-expectations | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
the-future-direction-named-in-a-current-release | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
three-state-lifecycle (Active + Deprecated + Removed) | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
Standards-Track-vs-Extensions-Track-distinction | (see section: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum)
first-papers-lane-ingest-after-144+-blocked-cycles | patterns
cycle-251-is-an-out-of-band-cycle-not-part-of-the-designs-chat-alternation | patterns
first-direct-ingest from blog.modelcontextprotocol.io | patterns
first-protocol-spec-blog-post ingested in library | patterns
first-non-Endo-source ingested in library since the long Endo cluster began | patterns
two-cycles-with-explicit-before-and-after-comparison (238 + 251) | patterns
two-cycles-with-three-named-defenses-against-a-substrate-risk (238 + 251) | patterns
two-cycles-with-explicit-named-time-windows (242 + 251) | patterns
three-cycles-with-deferred-response-mechanisms (241 + 249 + 251) | patterns
three-cycles-with-explicit-refusal-or-graduation-of-conventional-feature (240 + 244 + 251 Tasks-demoted) | patterns
three-cycles-with-explicit-test-verification-as-gating-mechanism (244 + 248 + 251) | patterns
three-cycles-with-cited-numbered-decision-tokens (238 + 240 + 251) | patterns
library-reaches-757-sections at cycle 251 (papers-lane MCP-RC out-of-band) | patterns
`Promise.resolve(x) === x`-as-canonical-promise-detection | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
the-Promise.resolve-trick-IS-the-defense-against-malicious-thenables | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (recurring named discipline) | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
`@returns {x is T}`-type-predicate-narrowing | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
harden-immediately-after-export-as-named-SES-discipline | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
`harden`-imported-from-`@endo/harden`-not-from-a-global (package-portability discipline) | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
`maybe<TargetType>`-as-named-parameter-naming-convention-for-detection-functions | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
twelve-lines-as-a-complete-promise-detection-utility | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
single-export-named-the-same-as-the-purpose (file name and export name converge) | (see section: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines)
two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose (243 + 252) | patterns
two-cycles-with-named-defense-against-substrate-confusion-attacks (249 method-detach + 252 thenable-impersonation) | patterns
two-cycles-with-named-TypeScript-discipline-around-validation (249 + 252) | patterns
two-cycles-with-named-identifier-encodes-the-discipline (247 function-name + 252 parameter-name) | patterns
six-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252) | patterns
forty-second-member of small-files-with-large-knowledge-density family | patterns
eighty-fifth consecutive designs-chat alternation cycles 166-250 + 252 (251 was out-of-band) | patterns
library-reaches-758-sections at cycle 252 (chat-lane @endo/promise-kit/src/is-promise) | patterns
graceful-degradation-across-substrates (named capability-implementation discipline) | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
silently-dropped-or-queued (named rate-limit policy) | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
Notify-NotifyControl two-facet at most compact (5th caretaker instance) | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
single-rate-limit-axis as simplest possible control surface | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
named-non-dependency as design discipline | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
the-agent-cannot-discover-or-influence-the-control-facet (canonical phrasing) | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
revocation-is-immediate + all-future-calls-throw (named permanence) | (see section: endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless)
five-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253) | patterns
five-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253) | patterns
four-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253) | patterns
three-cycles-with-named-substrate-routing-discipline (244 forbid-ambient + 246 reuse-existing + 253 degrade-to-alternate) | patterns
three-cycles-with-explicit-acknowledgment-of-no-content-in-named-section (248 Upgrade `None` + 250 Upgrade `No-migration-needed` + 253 Depends-On `No other designs required`) | patterns
three-cycles-with-variable-control-facet-size (244 six methods + 246 four methods + 253 three methods) | patterns
two-cycles-with-five-section-design-shape (246 + 253) | patterns
two-different-shapes-of-default-non-error-policy (244 timeout-resolves-forward-progress + 253 rate-limit-silently-drops-or-queues) | patterns
smallest-endoclaw-cluster-member-yet at 55 lines (cycle 253 displaces cycle 246's 79 lines) | patterns
eighty-sixth consecutive designs-chat alternation cycles 166-250 + 252-253 (251 was out-of-band) | patterns
library-reaches-759-sections at cycle 253 (designs-lane endoclaw-notifications) | patterns
the-no-shim-module-as-counterpart-to-the-pony-shim | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
capture-the-global-at-module-load (defense against later global replacement) | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
XXX-comment-as-named-workaround-prefix (distinct from TODO) | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
three-different-export-styles-in-one-file (export const + export { local as Public } + export *) | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
`export { local as Public }`-form (short-internal-alias + canonical-public-name) | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
file-level-API-overview-via-JSDoc-on-canonical-export | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
makeE(hp)-factory-as-dependency-injection-of-platform-substrate | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
shim-vs-no-shim-package-entrypoints-as-named-dispatch-shape | (see section: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles)
four-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator + 245 pony-shim + 254 no-shim) | patterns
three-cycles-with-short-alias-convention-for-long-canonical-name (237 `q` + 245 `optXferBuf2Immu` + 254 `hp`) | patterns
three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254) | patterns
two-cycles-with-`as`-rename-in-module-boundary (245 import-rename + 254 export-rename) | patterns
two-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254) | patterns
seventh-direct-ingest from @endo/eventual-send/src (E.js + handled-promise.js + local.js + message-breakpoints.js + track-turns.js + postponed.js + no-shim.js) | patterns
forty-third-member of small-files-with-large-knowledge-density family | patterns
eighty-seventh consecutive designs-chat alternation cycles 166-250 + 252-254 (251 was out-of-band) | patterns
library-reaches-760-sections at cycle 254 (chat-lane @endo/eventual-send/src/no-shim) | patterns
voice-input-is-a-UI-concern-not-a-capability-concern | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
UI-vs-capability as named-design-axis | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
the-agent-cannot-distinguish-voice-input-from-typed-input (capability-by-invariance) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
three-Options-with-Pros-Cons-no-preferred (distinct from Options-Considered-with-preferred) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
the-agent-never-receives-raw-audio (only text crosses the capability boundary) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
capability-boundary-IS-the-projection-to-existing-substrate | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
three-explicitly-named-non-changes-as-evidence-of-UI-only-claim (no new capabilities + no new formula types + no new daemon changes) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
Endo-Idiom-section-with-two-paragraphs (no N-named-disciplines) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
conditional-dependencies-IS-an-honest-record (different options have different dep profiles) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
implicit-vs-explicit-axes-in-Pros-Cons-text (Pros/Cons prose vs axis table) | (see section: endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed)
thirteen-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248 + 250 + 255) | patterns
four-shapes-of-design-doc-alternatives-section in library (Alternatives-with-three-rejected 240 + Alternatives-with-rejected+deferred 238 + Options-with-preferred 250 + three-Options-with-Pros-Cons-no-preferred 255) | patterns
three-cycles-with-UI-only-no-substrate-changes (248 + 250 + 255) | patterns
three-cycles-with-named-capability-boundary-discipline (244 forbid-ambient + 253 degrade-across-substrate + 255 project-new-modality-to-existing-substrate) | patterns
three-cycles-with-Endo-Idiom-section-with-varying-shape (232 five-disciplines + 246 four-disciplines + 255 two-paragraphs-no-discipline-headings) | patterns
three-cycles-with-explicit-list-of-substrate-elements-that-don't-change (248 + 250 + 255) | patterns
two-cycles-with-Pros-Cons-without-named-preferred (240 + 255) | patterns
two-cycles-with-explicit-non-dependency-in-Depends-On (253 + 255) | patterns
eighty-eighth consecutive designs-chat alternation cycles 166-250 + 252-255 (251 was out-of-band) | patterns
library-reaches-761-sections at cycle 255 (designs-lane endoclaw-voice) | patterns
PromiseKit-as-reified-Promise | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
resolve-takes-ERef-not-T (canonical PromiseKit resolver shape) | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
ERef-as-four-named-shapes (local T + local presence for remote T + promise for T + thenable for T) | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
four-named-shapes-distinguished-in-prose-not-in-narrower-type | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
thenable-defined-explicitly-as-promise-like-non-promise-with-then-method | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
deprecated-typedef-alias-with-named-replacement-in-JSDoc | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
stack-of-three-typedefs-in-one-file (general-input + canonical + deprecated-alias) | (see section: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file)
two-cycles-with-`export {};`-typedef-only-file-pattern (249 + 256) | patterns
two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction (252 detection + 256 definition) | patterns
two-cycles-with-multiple-typedefs-in-one-file (249 + 256) | patterns
two-cycles-with-named-deprecation-with-named-replacement (251 MCP + 256 PromiseRecord) | patterns
three-cycles-with-`@template`-parameterization (237 + 249 + 256) | patterns
seven-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256) | patterns
forty-fourth-member of small-files-with-large-knowledge-density family | patterns
eighty-ninth consecutive designs-chat alternation cycles 166-250 + 252-256 (251 was out-of-band) | patterns
library-reaches-762-sections at cycle 256 (chat-lane @endo/promise-kit/src/types) | patterns
a-design-pattern-not-a-new-capability (load-bearing classification) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
three-named-categories-of-Endo-feature-classification (capability + UI-feature + design-pattern) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
code-example-as-the-design (replaces Capability-Shape section) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
the-`@`-prefix-as-system-pet-name-convention (`@host`, `@self`, `@agent`) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
cross-cluster-composition-as-named-design-extension-point | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
the-section-inventory-distinguishes-design-pattern-from-capability | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
capability-by-construction-via-composition (the design-pattern is bounded by the substrate caps) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
six-section-design-pattern-shape (Summary + Pattern + How-It-Works + Endo-Idiom + Use-Cases + Depends-On) | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
Use-Cases-section as named design-doc section | (see section: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design)
six-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257) | patterns
two-cycles-with-`@`-prefix-system-pet-names (250 + 257) | patterns
two-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257) | patterns
two-cycles-with-cross-cluster-composition (253 + 257) | patterns
two-cycles-with-evidence-of-cluster-vocabulary-evolution (250 + 257) | patterns
two-cycles-with-explicit-Endo-feature-classification-axis (255 + 257) | patterns
three-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257) | patterns
ninetieth consecutive designs-chat alternation cycles 166-250 + 252-257 (251 was out-of-band) | patterns
library-reaches-763-sections at cycle 257 (designs-lane endoclaw-proactive-messages) | patterns
the-package-IS-a-curated-re-export-set | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
four-named-re-exports-from-two-named-upstream-packages (E + Far + getInterfaceOf + passStyleOf) | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
the-dummy-`.js`-companion-to-a-`.d.ts`-file (TypeScript-and-runtime bridge) | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
the-comment-explains-the-non-obvious-purpose-of-a-trivial-file | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
curated-re-export-package-IS-the-abstraction-boundary | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
the-canonical-Far-vocabulary (E + Far + getInterfaceOf + passStyleOf) | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
five-line-`src/index.js`-as-curated-re-export-package-entry-point (smallest yet) | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
two-line-`exports.js`-as-companion-to-`.d.ts` (smallest file ingested in library) | (see section: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package)
three-cycles-with-`export {};`-marker (249 typedef-only-protocol-file + 256 typedef-only-Promise-and-ERef-vocabulary + 258 runtime-companion-to-`.d.ts`) | patterns
three-cycles-with-named-import-isolation (242 elevator + 254 no-shim + 258 curated-re-export) | patterns
three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258) | patterns
three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 function-name + 252 parameter-name + 258 file-purpose-comment) | patterns
two-cycles-with-named-curated-package-as-stable-import-path (242 + 258) | patterns
two-cycles-with-`export *`-with-named-eslint-disable (254 + 258) | patterns
two-cycles-with-multiple-export-styles-in-one-file (254 + 258) | patterns
eight-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256 + 258) | patterns
forty-fifth-member of small-files-with-large-knowledge-density family | patterns
ninety-first consecutive designs-chat alternation cycles 166-250 + 252-258 (251 was out-of-band) | patterns
library-reaches-764-sections at cycle 258 (chat-lane @endo/far/src/index+exports) | patterns
ninety-second consecutive designs-chat alternation cycles 166-250 + 252-259 (251 was out-of-band) | patterns
library-reaches-765-sections at cycle 259 (designs-lane endoclaw-browser) | patterns
ninety-third consecutive designs-chat alternation cycles 166-250 + 252-260 (251 was out-of-band) | patterns
library-reaches-766-sections at cycle 260 (chat-lane @endo/pass-style/src/byteArray.js) | patterns
ByteArrayHelper as PassStyleHelper concrete instance | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
adaptImmutableArrayBuffer (immediately-invoked factory at module load) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
stage-3-proposal-feature-detection-at-module-load-with-null-prototype-as-impossibility-signal (first-explicit-observation) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
two-shapes-with-same-keys (contract that lets the caller not branch on feature presence) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
sliceToImmutable-as-the-canonical-detection-probe | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
null-prototype-as-impossibility-signal | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
always-deny-getter-when-platform-feature-not-present | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies (first-explicit-observation) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
the-runtime-tells-us-the-shape (rather than source-code presuming) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
direct-prototype-equality-not-instanceof (side-channel defense) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
two-cycles-with-canonical-prototype-as-side-channel-defense (244 TickResponse + 260 ByteArrayHelper) | patterns
three-line-validity-check-with-three-orthogonal-rejection-criteria (first-explicit-observation) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
predicate-OR-fail-idiom (short-circuit as conditional assert) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection (TypeError vs Error) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
captured-getter-pattern-as-defense-against-property-shadowing | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call (235 base64 + 245 panic + 260 byteArray) | patterns
own-keys-check-as-side-channel-strip (no attached own-property credentials) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
two-phase-progressive-tightening (loose phase-1 confirmCanBeValid + tight phase-2 assertRestValid) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
the-styleName-IS-the-protocol-tag-the-marshal-layer-emits-on-the-wire | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
three-disciplines-in-one-export-line (const + harden + PascalCase-Helper-suffix) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
the-binding-name-convention (PascalCase + `Helper` suffix) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
three-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260) | patterns
three-cycles-with-pre-lockdown-capture-and-shim-replacement-discipline (245 + 246 + 260) | patterns
four-cycles-with-named-import-isolation-via-destructuring (242 elevator + 254 no-shim + 258 curated-re-export + 260 byteArray) | patterns
captured-before-lockdown-and-remain-trustworthy-after | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
the-three-concerns-template (imports + adapter-factory + named-helper-export) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
adapt-X-factory pattern (named adaptImmutableArrayBuffer) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
immutableArrayBufferPrototype (canonical prototype reference captured at module load) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
immutableGetter (captured getter for ArrayBuffer.prototype.immutable) | (see section: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline)
ninety-fourth consecutive designs-chat alternation cycles 166-250 + 252-261 (251 was out-of-band) | patterns
library-reaches-767-sections at cycle 261 (designs-lane endoclaw-network-fetch) | patterns
HttpClient/HttpClientControl two-facet (substrate-root canonical-two-facet) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
endoclaw-network-fetch (the foundational HTTP-confinement substrate of the endoclaw cluster) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
reverse-ingestion-order-of-cluster-substrate (first-explicit-observation; library knows derivatives before substrate) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
three-orthogonal-control-knobs (origins=data-exfiltration + rate=DoS + size=large-file-DoS) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
each-knob-is-named-after-the-attack-it-defends-against | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
structural-origin-allowlist (substrate root) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
parse-first-act-second (sequencing discipline) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
four-cycles-with-structural-confinement-discipline (234 path + 238 origin + 259 origin + 261 substrate root) | patterns
no-ambient-DNS-or-socket-access (named-platform-API-non-exposures) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
named-platform-API-non-exposures-as-evidence-of-confinement-by-omission (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
no-`net.connect`-no-`dns.resolve` (canonical Node primitives the agent MUST NOT receive) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
HTTP/HTTPS-only (protocol restriction as named-omission) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
five-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 261 + canonical-source-named-here) | patterns
composable-with-OAuth (the substrate names its derivative by link) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
the-substrate-design-names-the-derivative-design-by-link (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
three-cycles-with-named-cross-design-composition (253 + 257 + 261) | patterns
help-method-IS-a-named-convention (from project CLAUDE.md `## Modules and exports`) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities-named-in-the-project-CLAUDE.md (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
allowedOrigins-as-introspection-on-the-use-facet (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
a-named-introspection-method-on-the-use-facet (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
self-reflective-capability (agent reads its own confinement policy) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
the-control-facet-has-more-methods-than-the-use-facet (established at substrate root) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
the-substrate-establishes-revocation-as-canonical-discipline-for-the-cluster | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
seven-cycles-with-revocation-as-named-permanent-state (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261) | patterns
the-Use-Cases-omission-as-substrate-signal (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
two-cycles-with-section-omission-as-design-kind-signal (257 no-Capability-Shape + 261 no-Use-Cases) | patterns
Endo-Idiom-section-names-four-patterns (origin-allowlist + rate-and-size + no-ambient-DNS + composable-with-OAuth) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
four-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257 + 261) | patterns
Depends-On-with-explicit-no-Endo-designs-required-marker (substrate is standalone) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
four-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional + 259 Optional-prefix + 261 standalone-with-explicit-no-Endo-designs-required-marker) | patterns
Node-22-LTS-floor named in Depends-On (Node.js fetch availability) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
Node-LTS-version-floor-named-in-a-Depends-On-bullet-of-a-design-doc (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
undici (named-as-fallback-HTTP-library) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
two-cycles-with-named-alternative-implementation-paths-in-Depends-On (255 + 261) | patterns
each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
eight-cycles-with-canonical-caretaker-two-facet-pattern (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261) | patterns
eight-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261) | patterns
HttpClient-as-canonical-two-facet-substrate | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
setMaxRequestsPerMinute (DoS-against-allowed-origin-defense) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
setMaxResponseBytes (large-file-DoS-defense) | (see section: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth)
ninety-fifth consecutive designs-chat alternation cycles 166-250 + 252-262 (251 was out-of-band) | patterns
library-reaches-768-sections at cycle 262 (chat-lane @endo/pass-style/src/copyArray.js) | patterns
CopyArrayHelper as PassStyleHelper second concrete instance | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
two-cycles-with-PassStyleHelper-concrete-instance (260 byteArray + 262 copyArray) | patterns
the-pair-IS-the-pedagogy (byteArray + copyArray side-by-side teach the helper template's points of variation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
three-named-import-styles-in-seven-lines (default + named + sibling-module) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
destructuring-with-rename-when-source-name-is-too-generic (first-explicit-observation; `prototype: arrayPrototype` from Array) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
five-cycles-with-named-import-isolation-via-destructuring (242 elevator + 254 no-shim + 258 curated-re-export + 260 byteArray + 262 copyArray) | patterns
Array.isArray-IS-the-canonical-realm-aware-array-test (works across cross-realm boundaries) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
two-cycles-with-phase-1-uses-realm-aware-platform-test (260 instanceof-ArrayBuffer + 262 isArray-realm-aware) | patterns
four-line-validity-check-with-four-orthogonal-rejection-criteria | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
index-property-count-check (`ownKeys(candidate).length === len + 1`) rejects sparse arrays AND extra non-index keys | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
ownKeys-length-check-with-pass-style-specific-arithmetic (first-explicit-observation; `=== 0` byteArray vs `=== len + 1` copyArray) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
two-cycles-with-ownKeys-length-check-as-side-channel-strip-with-pass-style-specific-arithmetic (260 + 262) | patterns
passStyleOfRecur-as-named-callback-for-helper-to-core-recursion-on-each-child-value (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
`Recur`-suffix-IS-the-canonical-naming-for-helper-to-core-callbacks | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
inversion-of-control between helper and core (the helper validates this level; the core handles recursion) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
shared-validation-helper-imported-by-name-into-each-PassStyleHelper (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
confirmOwnDataDescriptor (named cluster helper for property-shape-validation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
confirmOwnDataDescriptor-as-named-cluster-helper-with-enumerability-as-per-call-parameter (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
enumerability-as-a-per-call-parameter (false for `length`; true for indices) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper (first-explicit-observation; `Fail` as 4th argument to `confirmOwnDataDescriptor`) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
the-comment-documents-the-redundancy-of-a-defense-in-depth-check (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
four-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260 + 262) | patterns
two-cycles-with-the-binding-name-convention (260 ByteArrayHelper + 262 CopyArrayHelper) | patterns
two-cycles-with-two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection (260 + 262) | patterns
sparse-array-rejection-at-marshal-boundary | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
ensured-comment-as-named-invariant | (see section: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal)
ninety-sixth consecutive designs-chat alternation cycles 166-250 + 252-263 (251 was out-of-band) | patterns
library-reaches-769-sections at cycle 263 (designs-lane outliner-design-doc-2) | patterns
outliner-design-doc-2 (free-form design fragment without metadata table) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
the-template-deviation-IS-the-pattern (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
the-fragment-form-IS-the-right-form-for-design-in-flight-because-the-template-implies-stability-the-design-doesn't-have (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
the-`-design-doc-2`-suffix-as-named-follow-up-naming-convention (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
three-named-comparison-points-as-UX-positioning-shorthand (Roam Research + Obsidian + Workflowy; first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
Roam Research (named comparison-point for outliner UX) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
Obsidian (named comparison-point for outliner UX) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
Workflowy (named comparison-point for outliner UX) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
cross-directory-relative-path-as-evidence-of-design-doc-drift (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
three-named-deferral-strategies-for-broadcast (cursor-leaves-the-node + debounced-timer + represent-as-edits-later) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
the-cursor-position-IS-the-natural-edit-boundary-for-broadcast-timing (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
"my-current-recommendation"-as-named-tentativeness-marker-in-prose-design (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
two-named-tentativeness-styles (design-doc-template's Status field + design-fragment's prose hedges) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
three-prose-hedges-in-one-design-fragment-as-evidence-of-active-design-discussion (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
decompose-atomic-UI-operation-into-named-protocol-edits-on-named-fields (first-explicit-observation; indent/dedent → replyTo + order-of-nodes) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
two-cycles-with-decompose-atomic-UI-operation-into-named-protocol-edits (234 substrate-flow + 263 indent/dedent) | patterns
two-orderings-coexist-creation-order-implicit-and-visible-order-explicit (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
non-chronological-child-node-order (named-assumption-break) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
two-cycles-with-named-prior-assumption-break (250 @-prefix-system-pet-names + 263 non-chronological-child-order) | patterns
the-sidecar-lives-within-the-channel-not-on-the-individual-message-as-named-scope-decision (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
three-cycles-with-augment-via-named-sidecar-not-by-mutation (245 pre-lockdown-capture + 246 lockdown-relink + 263 sidecar-table-for-visible-order) | patterns
moveNodeToAfter (capability-based mutation requiring the node) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
nine-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261 + 263) | patterns
a-preserved-typo-as-evidence-of-design-fragment's-informal-status (first-explicit-observation; `or something.f`) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
two-cycles-with-document-references-by-named-path (261 substrate-names-derivative-by-link + 263 fragment-names-companion-prose-by-path) | patterns
replyTo (parent-pointer field affected by indent/dedent) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
visible-order-of-child-nodes (distinct from creation order) | (see section: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation)
ninety-seventh consecutive designs-chat alternation cycles 166-250 + 252-264 (251 was out-of-band) | patterns
library-reaches-770-sections at cycle 264 (chat-lane @endo/pass-style/src/copyRecord.js) | patterns
CopyRecordHelper as PassStyleHelper third concrete instance | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
three-cycles-with-PassStyleHelper-concrete-instance (260 byteArray + 262 copyArray + 264 copyRecord) | patterns
the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-work-distribution-between-phases-varies-per-helper (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-three-concerns-template-with-named-local-helpers-extracted (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-`confirm`-prefix-IS-the-naming-convention | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
confirmObjectPrototype (named local helper for record-prototype validation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
confirmPropertyCanBeValid (named local helper for per-property validation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
cross-helper-cluster-disambiguation-import (first-explicit-observation; canBeMethod from `./remotable.js`) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-cross-cluster-disambiguation-discipline (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
canBeMethod (cross-cluster import from `./remotable.js`) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
Rejector (type imported via JSDoc `@import` from `@endo/errors/rejector.js`) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
three-cycles-with-direct-prototype-equality-as-canonical-validation (260 immutableArrayBufferPrototype + 262 arrayPrototype + 264 objectPrototype) | patterns
three-orthogonal-kinds-of-side-channel-defense-across-the-triplet (count-zero + count-equal-to-len-plus-1 + per-key-and-per-value-rules) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
the-side-channel-defense-takes-three-forms-across-the-triplet (first-explicit-observation) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
key-must-be-string-discipline (record-keys-are-string-only-because-symbol-keys-carry-non-passable-identity) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
value-must-not-be-method-like-discipline (a-method-shaped-value-suggests-this-IS-secretly-a-Remotable) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
honest-TODO-acknowledging-design-drift-without-fix | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
two-cycles-with-honest-TODO-acknowledgment (152 memo-race + 264 copyRecord) | patterns
two-cycles-with-named-design-drift-acknowledged-in-comment-without-fix (152 + 264) | patterns
`.every()`-short-circuits-at-first-rejection (fail-fast with named property identification) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
no-own-keys-count-check-at-all (records have no canonical count-invariant) | (see section: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies)
three-cycles-with-the-binding-name-convention (260 ByteArrayHelper + 262 CopyArrayHelper + 264 CopyRecordHelper) | patterns
three-cycles-with-named-import-of-sibling-module-cluster-helper (260 + 262 + 264) | patterns
six-cycles-with-named-import-isolation-via-destructuring (242 elevator + 254 no-shim + 258 curated-re-export + 260 byteArray + 262 copyArray + 264 copyRecord) | patterns
two-cycles-with-destructuring-with-rename-when-source-name-is-too-generic (262 arrayPrototype + 264 objectPrototype) | patterns
five-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260 + 262 + 264) | patterns
three-cycles-with-doc-comment-documenting-defense-in-depth-redundancy (260 + 262 + 264) | patterns
ninety-eighth consecutive designs-chat alternation cycles 166-250 + 252-265 (251 was out-of-band) | patterns
library-reaches-771-sections at cycle 265 (designs-lane endo-but-for-bots/designs/CLAUDE.md) | patterns
designs/CLAUDE.md (the canonical design-doc-template spec) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-template-specification-is-not-itself-an-instance-of-the-template-it-specifies (first-explicit-observation; metalanguage-vs-object-language) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-meta-document-that-prescribes-the-template-is-itself-a-template-instance-of-a-different-kind (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-nested-CLAUDE.md-IS-a-named-subset-of-the-policy-graph (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-metalanguage-vs-object-language-distinction-named-explicitly-in-a-policy-specification | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
three-required-and-two-optional-metadata-fields (Created + Author + Status + Updated + Source + Supersedes) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-metadata-table-encodes-three-named-relationship-types (Source extraction + Supersedes replacement + Updated revision; first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-`(prompted)`-suffix-as-named-attribution-discipline-for-human-LLM-collaboration (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
eight-named-Status-values (Not Started + Proposed + In Progress + Complete + Implemented + Active + Reference + Deprecated) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows (first-explicit-observation; Implemented = Complete) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
bolding-convention-for-the-success-state-as-author-choice-not-template-mandate (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-Status-values-are-eight-named-states-without-an-explicit-state-machine-transition-graph (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
seven-named-document-sections (Status + Problem + Design + Dependencies + Phased + Decisions + Gaps) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-template-allows-section-omission-as-author-choice (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-template-allows-section-title-variation-with-two-named-alternatives-for-the-Problem-statement-section (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-`## Prompt`-section-at-the-end-IS-the-LLM-collaboration-record (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-cross-document-progress-tracking-IS-five-named-artifacts-in-one-README (summary table + Mermaid dep graph + milestone tables + size/time estimates + Gantt timeline; first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
empirical-estimate-discipline-named-explicitly-in-the-CLAUDE.md (first-explicit-observation; "calibrated against observed velocity") | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
the-modification-synchronization-discipline-IS-bold-faced-in-the-CLAUDE.md (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
design-incorporation-IS-five-named-cross-document-updates (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
critical-path-awareness-named-explicitly-in-the-CLAUDE.md (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
two-named-forms-of-template-deviation-in-the-design-doc-cluster (in-flight deviation cycle 263 + metalanguage deviation cycle 265; first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
two-cycles-from-different-angles-meeting-the-same-pattern (261 substrate-Use-Cases-omission + 265 explicit-template-permission-for-section-omission) | patterns
two-cycles-with-template-deviation-from-different-directions (263 in-flight + 265 metalanguage) | patterns
thirteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested (counting cycle 265 itself) | patterns
Source (metadata field encoding extraction provenance) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
Supersedes (metadata field encoding replacement relationship) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
ISO 8601 (YYYY-MM-DD date format mandated by the spec) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
Mermaid dependency graph (cross-document tracking artifact) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
Gantt timeline (cross-document tracking artifact) | (see section: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking)
ninety-ninth consecutive designs-chat alternation cycles 166-250 + 252-266 (251 was out-of-band) | patterns
library-reaches-772-sections at cycle 266 (chat-lane @endo/pass-style/src/internal-types.js) | patterns
PassStyleHelper typedef (metalanguage to byteArray + copyArray + copyRecord) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
two-cycles-with-metalanguage-to-object-language-relationship-discovered-side-by-side (265 CLAUDE.md + 266 internal-types.js; first-explicit-observation) | patterns
the-metalanguage-pattern-now-recognized-at-two-different-scopes-in-the-same-week | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
four-cycles-with-`export {};`-typedef-only-file-pattern (254 no-shim + 256 promise-kit types + 258 far exports + 266 internal-types) | patterns
the-internal-types-file-depends-on-the-public-types-not-the-other-way-around (first-explicit-observation) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly-in-the-internal-types-doc-comment (first-explicit-observation) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
helpers-are-pure-not-ambient (caller provides passStyleOfRecur as a parameter) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-three-attack-classes-implicit-in-the-trust-model-named-explicitly-in-the-internal-types-doc-comment (must-defend + may-defend + need-not-defend; first-explicit-observation) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-trust-model-IS-asymmetric (helpers trust the core; helpers don't trust the candidate) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-italicized-`*assume*`-as-named-emphasis-on-a-load-bearing-trust-assumption (first-explicit-observation) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition (first-explicit-observation; when one helper's confirmCanBeValid returns true, no other helper's would also return true) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants-as-named-discipline (first-explicit-observation) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
two-cycles-with-prose-encoded-invariants-where-structure-cannot-express (265 design-doc-template + 266 PassStyleHelper-mutual-exclusivity) | patterns
six-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260 + 262 + 264 + 266) | patterns
must-defend (helper-must-defend-against-malicious-candidate; security boundary) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
may-defend (helper-may-defend-against-bugs-in-passStyleOfRecur; best-effort defensive coding) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
need-not-defend (helper-need-not-defend-against-malicious-passStyleOfRecur; the core is trusted) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-PassStyleHelper-typedef-defines-a-three-property-protocol (styleName + confirmCanBeValid + assertRestValid) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
the-typedef-uses-the-narrowed-`PassStyle`-string-literal-union-not-`string` (the-type-system-catches-typos-at-the-helper-declaration-site) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
inversion-of-control-to-avoid-cyclic-module-dependency (the architectural rationale for helpers-are-pure-not-ambient) | (see section: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient)
Browser/Page/BrowserControl three-facet (Page derived from Browser.goto()) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
a-derived-capability-from-the-use-facet (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
two-cycles-with-derived-capability-from-the-use-facet (244 one-shot TickResponse + 259 long-lived Page) | patterns
Playwright-backed confined browsing capability | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
structural-origin-confinement | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
three-cycles-with-structural-confinement-discipline (234 path-restrictions + 238 origin-allowlist + 259 origin-confinement) | patterns
setReadOnly with three named mutation methods disabled (fill + click + submit) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
three-cycles-with-setReadOnly-mode-toggle (226 + 234 + 259) | patterns
caretaker-revocation-propagates-to-derived-caps (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259) | patterns
no-cookie-credential-leakage (three named non-exposures) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
three-named-non-exposures-on-Page-interface (cookies + localStorage + network requests) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
confinement-by-omission (the-omission-IS-the-defense) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
three-cycles-with-explicit-confinement-by-omission (234 + 238 + 259) | patterns
use-facet-size-correlates-with-substrate-API-size (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
`Optional:`-prefix-on-Depends-On-bullet (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
three-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional-per-option + 259 with-Optional-prefix) | patterns
running-without-platform-sandbox-when-substrate-IS-the-sandbox (first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
two-named-return-shapes-via-same-method-by-context (snapshot text vs screenshot; first-explicit-observation) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
six-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253 + 259) | patterns
seven-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259) | patterns
three-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257 + 259) | patterns
Page-has-11-methods (largest use-facet of endoclaw cluster ingest) | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
flight-check-in as Use-Case enumeration item | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
web-research as Use-Case enumeration item | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
price-monitoring as Use-Case enumeration item | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
form-automation as Use-Case enumeration item | (see section: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage)
`move` (daemon mount mutation method) | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
move on mount | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
mount move | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
mutation suite (write/remove/move/makeDirectory) | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
POSIX rename atomicity | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
POSIX `*at` family (openat/renameat/fstatat/mkdirat) | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
atomic rename | (see section: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement)
atomic-rename-after-write CAS | (see section: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc)
out-of-band transfer | (see section: endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design)
data-plane capabilities | (see section: endo-but-for-bots--llm-designs-ocapn-network-transport-separation--design-conceptual-model)
transfer-mechanism negotiation | (no concept page yet; topic-typical: capability lattice, sealer/unsealer, CAS-internal moves)
grant matching equality | brand-and-trademark
CAS-internal move (refcount swap, no byte copy) | (see section: endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension)
streaming CAS variants (cas-store-stream / cas-content-stream) | (see section: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc)
cap-not-string mounts | (see section: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface)
destructive-autofix | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)
`@endo/harden-exports` autofix deletes harden() | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)
`jsdoc/require-param` autofix injects empty @param | (see entry: entries/2026/06/07/050114Z-result-fixer-a538e1.md)
