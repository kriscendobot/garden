---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/messaging.md
source_line_range: 1-98
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 413 designs-lane ingest. 97-line messaging.md from
  @endo/lal's agent-facing primer. Fifteenth lal-package
  artifact in the cluster. Sixty-first AUTHORED conformant
  single-body section doc in post-refactor era. One-
  hundred-and-three consecutive non-garden sources after
  the pivot (310-413). §one-hundred-and-three-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  style-as-part-of-surface-boundary — lines 83-97 prescribe
  what the agent must OMIT from user-facing messages:
  internal tool calls, pet name choices, retries, errors,
  technical details about locators/formula IDs/message
  protocol. The agent must "try a different approach
  silently" and "frame [failures] in terms of what you
  cannot do, not why." This extends cycle 405's three-
  surfaces-three-audiences framing: surfaces differ not
  just in API SHAPE (which methods are exposed) but in
  STYLE and VOCABULARY (which content is appropriate).
  §the-named-surface-boundary-includes-style-not-just-API
  as tier-3 meta-pattern. The agent's three-surface
  topology now spans: API shape (which tools each
  audience sees) + content (which vocabulary each
  audience sees) + style (silent retry, no internal
  exposure for user-facing).

  §the-named-abstraction-discipline-across-surfaces — the
  agent must respect the surface boundaries cycle 405
  named at the STYLE level. The user-facing surface
  should hide the LLM-facing and guest-power surfaces
  even in PROSE, not just in tool exposure. §the-named-
  three-surface-styles-not-just-three-surface-APIs as
  tier-3 meta-pattern.

  §the-named-reply-vs-send-as-required-distinction —
  lines 41-44 + 52-54. Cycle 407 named reply() as
  PREFERRED over send() for responses. Cycle 413
  strengthens: "ALWAYS use reply(messageNumber, ...)
  to respond" and "Do NOT use send() for responses —
  send() is only for initiating brand new
  conversations." Not preference, REQUIREMENT.
  §the-named-mandatory-reply-for-responses-mandatory-
  send-for-initiation as tier-3 meta-pattern. The
  cluster's framing on reply-vs-send is refined from
  preference to mandate.

  §the-named-five-step-message-processing-workflow —
  lines 21-46. (1) locate(["@self"]); (2)
  listMessages(); (3) check both from AND to against
  @self; (4) for received: adopt values, reply,
  dismiss; (5) next message. §the-named-canonical-
  agent-loop-iteration-shape as tier-3 meta-pattern;
  the canonical shape of one iteration of the agent's
  message-following loop.

  §the-named-messages-as-data-not-directory-entries —
  lines 3-13. "listMessages() returns message
  objects... messages are not named things in your
  directory. Do NOT try to lookup() message fields."
  Mental-model constraint for the LLM. §the-named-
  data-not-addressable-entity as tier-3 meta-pattern;
  messages live in a different conceptual space
  from named capabilities.

  §the-named-nine-field-message-object — line 5-6:
  number + date + from + to + type + strings + names
  + messageId + replyTo. Nine fields per message.
  Confirms cycle 407's mention of messageId + replyTo
  for threading. §the-named-canonical-message-object-
  shape as tier-3 meta-pattern.

  §the-named-no-prose-only-tool-calls-restated —
  lines 17-19: "IMPORTANT: You must ONLY respond
  with tool calls. Do not include any text content."
  Confirms cycle 401's no-prose-only-tool-calls
  framing. Restated in primer for LLM consumption.

  §the-named-adopt-preserves-sender-edge-name-and-
  creates-own-pet-name — lines 32-40. adopt() takes
  the sender's edge name AND your own chosen pet
  name. Two distinct names, one per side of the
  trust boundary. The sender's edge name is HOW the
  sender refers to the cap; the receiver's pet name
  is HOW the receiver refers to it. §the-named-dual-
  naming-across-trust-boundary as tier-3 meta-
  pattern.

  §the-named-message-number-as-smallcaps-BigInt —
  line 38: `adopt("+3", "counter", "my-counter")`.
  The message number "+3" is SmallCaps for the
  BigInt 3n. Cycle 401's design doc named SmallCaps
  encoding; cycle 413 sees the LLM-facing syntax.
  §the-named-message-numbers-as-BigInt-via-smallcaps
  as tier-3 meta-pattern.

  §the-named-self-message-detection-as-safety-check
  — lines 48-50: "The message list contains your
  own sent messages too! Always check if you are
  the sender before trying to reply to a message —
  you don't want to reply to yourself." The
  bidirectional-journal observation cycle 407 named
  now has a SAFETY consequence — the agent must
  filter own sends. §the-named-bidirectional-
  inbox-requires-self-filter as tier-3 meta-pattern.

  §the-named-mandatory-reply-and-dismiss-pair —
  lines 52-55: "You MUST reply to every message you
  RECEIVE... Always dismiss messages after handling
  them — this is essential for proper operation."
  §the-named-receive-reply-dismiss-as-required-
  triple as tier-3 meta-pattern. The canonical-
  conversation-as-reply-and-dismiss from cycle 403
  now refined to MANDATORY operation.

  §the-named-interleaved-strings-and-edge-references
  — lines 70-75: `reply("+5", ["Here is ", " as
  requested."], ["result"], ["my-result"])` produces
  recipient text "Here is @result as requested."
  Strings array interleaves with edgeName array.
  §the-named-strings-array-as-text-segments-around-
  edge-names as tier-3 meta-pattern.

  §the-named-edge-name-as-sender-label-pet-name-as-
  receiver-label — line 73-74: "Recipient sees:
  'Here is @result as requested.' They can adopt
  @result to get the value named 'my-result'." The
  @-reference in text is the EDGE NAME (sender's
  label); the receiver picks a PET NAME via adopt.
  §the-named-edge-name-and-pet-name-distinction-
  confirmed-at-messaging-level as tier-3 meta-
  pattern; sibling to cycle 386's petname-edgename-
  naming-inversion framing — now confirmed at the
  messaging protocol level.

  §the-named-silent-retry-discipline — line 95:
  "try a different approach silently." The agent's
  exploration is invisible to the user. §the-named-
  visible-success-invisible-process as tier-3 meta-
  pattern.

  §the-named-failure-framed-as-what-not-why — lines
  96-97: "frame it in terms of what you cannot do,
  not why." When the agent must report failure, it
  expresses the LIMIT (what cannot be done) rather
  than the REASON (internal mechanics). §the-named-
  what-not-why-as-failure-framing as tier-3 meta-
  pattern.

  §the-named-IMPORTANT-marker-used-twice-in-this-
  document — lines 17, 48. Two uses of the
  uppercase IMPORTANT marker. Confirms cycle 407's
  framing of IMPORTANT-uppercase-as-LLM-priority-
  signal. §the-named-IMPORTANT-as-distributed-
  attention-affordance as tier-3 meta-pattern.

  §the-named-sixty-one-conformant-cycles-and-
  counting — sixty-first AUTHORED conformant
  single-body section doc in post-refactor era.

  Closes nine citation arcs: cycle 412 (1, adjacent
  forward; provider boundary handles messages; the
  message protocol cycle 413 names is what the
  provider serializes) + cycle 407 (5, cluster
  message-related framings refined: reply-preferred
  now mandatory; inbox-bidirectional-journal now
  has safety implications) + cycle 405 (5,
  three-surfaces-three-audiences extended to three-
  styles-three-vocabularies; SURFACE boundary
  includes STYLE not just API) + cycle 386 (3,
  edge-vs-pet name distinction confirmed at
  messaging level — full circle from cycle 386's
  petname-edgename naming-inversion to messaging
  protocol) + cycle 401 (3, SmallCaps BigInt
  encoding confirmed in LLM-facing syntax) + cycle
  403 (3, reply-and-dismiss canonical pattern
  refined to mandatory) + cycle 326 (75) + cycle
  322 (75) + cycle 346 (3). Pushes citation-arc-
  closures-in-pivot to FIVE-HUNDRED-AND-NINETY-
  SEVEN (588 + 9 net new).
---

97-line messaging.md from @endo/lal's agent-facing primer. Fifteenth lal-package artifact in the cluster. Designs-lane after cycle 412 chat-lane providers/ollama.js. **Single most structurally interesting move**: §the-named-style-as-part-of-surface-boundary — *lines 83-97 prescribe what the agent must OMIT from user-facing messages: internal tool calls, pet name choices, retries, errors, technical details. The user-facing surface differs from the LLM-facing and guest-power surfaces not just in API SHAPE but in STYLE and VOCABULARY. Cycle 405's three-surfaces-three-audiences framing now extends to three-styles-three-vocabularies.* §the-named-surface-boundary-includes-style-not-just-API as tier-3 meta-pattern. §the-named-abstraction-discipline-across-surfaces; §the-named-three-surface-styles-not-just-three-surface-APIs. §the-named-reply-vs-send-as-required-distinction (cycle 407's preference refined to MANDATORY: reply REQUIRED for responses; send REQUIRED for initiating); §the-named-mandatory-reply-for-responses-mandatory-send-for-initiation. §the-named-five-step-message-processing-workflow; §the-named-canonical-agent-loop-iteration-shape (locate self → listMessages → filter sent vs received → adopt+reply+dismiss for received → next). §the-named-messages-as-data-not-directory-entries; §the-named-data-not-addressable-entity (mental-model constraint). §the-named-nine-field-message-object (number + date + from + to + type + strings + names + messageId + replyTo). §the-named-no-prose-only-tool-calls-restated. §the-named-adopt-preserves-sender-edge-name-and-creates-own-pet-name; §the-named-dual-naming-across-trust-boundary. §the-named-message-number-as-smallcaps-BigInt (+3 = 3n). §the-named-self-message-detection-as-safety-check; §the-named-bidirectional-inbox-requires-self-filter. §the-named-mandatory-reply-and-dismiss-pair; §the-named-receive-reply-dismiss-as-required-triple. §the-named-interleaved-strings-and-edge-references (strings array interleaves with edgeName array; recipient sees "@result as requested"). §the-named-edge-name-as-sender-label-pet-name-as-receiver-label (cycle 386's framing confirmed at messaging protocol level); §the-named-edge-name-and-pet-name-distinction-confirmed-at-messaging-level. §the-named-silent-retry-discipline; §the-named-visible-success-invisible-process. §the-named-failure-framed-as-what-not-why. §the-named-IMPORTANT-marker-used-twice-in-this-document; §the-named-IMPORTANT-as-distributed-attention-affordance. §the-named-sixty-one-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-NINETY-SEVEN.
