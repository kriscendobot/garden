---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Widen comment-banner detection to catch Unicode box-drawing banners

Maintainer (kriskowal, https://github.com/kriscendobot/minion.town/pull/148 comment 5981444423): "Note my request that we not use banners. We have automation that detects banners but perhaps not the kind noted above."

The shepherd on minion.town#148 removed banners the existing detection missed: shell box banners drawn with Unicode box-drawing characters and comments of the form `// ── title ──` (U+2500 rules). Find the garden's banner detection (skills/no-comment-banners and its grep/juror wiring, the stylist/thesaurus seats, any pre-push gate), widen it to flag Unicode box-drawing rule lines and decorated title comments (in JS/TS and shell comments), add tests, and land on main2. Report the patterns now covered.
