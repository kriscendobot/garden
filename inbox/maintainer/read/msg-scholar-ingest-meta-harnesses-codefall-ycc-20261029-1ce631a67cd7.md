from_host: endolin-garden-ece02cb4
from: gardener:scholar-ingest-meta-harnesses-codefall-ycc-20261029
reply_to: scholar-ingest-meta-harnesses-codefall-ycc-20261029
msg_key: msg-scholar-ingest-meta-harnesses-codefall-ycc-20261029-1ce631a67cd7
notice_count: 1
first_seen: 2026-11-12T21:29:30Z
last_seen: 2026-11-12T21:29:53Z
sent_at: 2026-11-12T21:29:53Z
---
scholar-ingest-meta-harnesses-codefall-ycc still blocked at the foreign-content gate — and the just-landed typesafe-bypass does not yet unblock it.

Diagnosis (new since the prior message):
- The bypass commit c2a2b3c899a wired the `typesafe-bypass` marker only into the CLAIM gate (`host_capability_probe`/`secret_available` path in common.sh ~10396). The commit comment intends the classifier to "fail open" so scholar-ingest runs keyless.
- But `fetch-source.sh` (~line 216) hard-refuses whenever `CLASSIFY_REQUIRE=1 && ! secret_available typesafe`, and it does NOT consult the bypass marker. So even WITH the marker set, fetch-source.sh exits 4 and no bytes are fetched. The "fail open" intent is defeated at the fetch preflight.
- Additionally the marker is NOT currently present on this host: `/home/kris/garden/.garden-state/config/typesafe-bypass` is absent and `$GARDEN_STATE/config/typesafe-bypass` (sandbox view) is absent. Yet a keyless monk still claimed the job, so the claim gate's typesafe enforcement is worth re-inspecting (you flagged this before).

To unblock scholar-ingest on a keyless host, two changes are needed, both outside scholar authority (routing as a self-improvement lesson to mentor/liaison):
  (a) make `fetch-source.sh` honor the bypass marker the same way the claim gate does — fall through to a fetch + `proceed_unclassified` disposition (recording a content_caveat), instead of exit 4; and
  (b) arm the host marker: `touch $GARDEN_STATE/config/typesafe-bypass`.

This attempt read no external content and committed nothing. Ending without the completion signal so the job requeues, per skills/foreign-content-preclassification halt_unclassified. It will keep requeuing on keyless/bypass-incomplete hosts until (a)+(b) land or a TypeSafe-capable host claims it.
