Reconciled 295 initially open PRs. Posted six conductor paths (#885, #880, #870, #848, #558, #556) and one shepherd path (#836). Final board check found exactly one live conductor/shepherd job for each of the 13 currently ready PRs.

Approved-current-head PRs:

- https://github.com/endojs/endo-but-for-bots/pull/885 — `ba03ca56fcf45d53438e6a9be329bb09557e80d2`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/880 — `0b3f77fb7f3c11a953e5e45591fe4f01f51a6f24`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/878 — `4cff9d57f39f2e0a5679d092d502e5206870b779`; draft=true; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/873 — `eacb5723c928bd155f4dda83bb9f950812c8bf71`; draft=true; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/870 — `587225ef6adb8fb282f97ed9d602a9b7a34f91c2`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/869 — `3b4c181446e838daf5d66cfd448a569a37f98139`; draft=false; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/860 — `1c818320a7152b22837423667e1bdef8be0fce9a`; draft=false; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/859 — `f948bdaed80ab3d8e7298739dc210590950a7d24`; draft=true; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/857 — `c174de482c2c18b1619917252a1684f47fbb5e81`; draft=true; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/848 — `6b3b71cbdfbc362c0efa1a3f8e810c74cde0fc0a`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/836 — `eb1c3bf5428c4095129170601584fb22ea7143a0`; draft=true; red/MERGEABLE; posted shepherd.
- https://github.com/endojs/endo-but-for-bots/pull/721 — `bee451effb92d00657426170dcc3a9551dbe6dcb`; merged during pass.
- https://github.com/endojs/endo-but-for-bots/pull/713 — `2cb917473764967d2860b3a413e9d164071ed118`; merged during pass.
- https://github.com/endojs/endo-but-for-bots/pull/691 — `9ae1a3e5aaf52ee846588e9e256ad15d8c5f0e2c`; green/UNKNOWN; no dispatch.
- https://github.com/endojs/endo-but-for-bots/pull/676 — `6eae31e53be2543fee3a7bfdbfcdd16b87819cbf`; merged during pass.
- https://github.com/endojs/endo-but-for-bots/pull/656 — `76e6800ee54cf8108c917b81e7dcdfa7f29e5aaa`; green/UNKNOWN; no dispatch.
- https://github.com/endojs/endo-but-for-bots/pull/652 — `bba47327337393e2561cc35089f47d7c20d42a3d`; draft=false; green/MERGEABLE; existing conductor.
- https://github.com/endojs/endo-but-for-bots/pull/563 — `071282dd95fbbdd17cb13455f447669eb96a4c6f`; non-bot author/UNKNOWN; excluded from automatic dispatch.
- https://github.com/endojs/endo-but-for-bots/pull/558 — `b9d0683255bd287ead0cb9d9f7d42a6de6c6053a`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/556 — `bfb775b7ae89866080f5dd1bc07162cb5d1ba3a8`; draft=false; green/MERGEABLE; posted conductor.
- https://github.com/endojs/endo-but-for-bots/pull/340 — `83f55ea937b8692378e3e65ed28b5ca7504aa2d6`; non-bot author; excluded from automatic dispatch.
- https://github.com/endojs/endo-but-for-bots/pull/129 — `77193d0d8f698d3d6e647cad41a2d8529cea44dd`; green/UNKNOWN; no dispatch.

Excluded for stale/no valid trusted approval (273): #889, #888, #887, #886, #883, #882, #881, #879, #877, #876, #875, #874, #872, #871, #868, #867, #858, #856, #855, #853, #847, #846, #845, #844, #838, #837, #835, #832, #825, #823, #822, #820, #819, #814, #811, #808, #807, #804, #797, #796, #790, #788, #781, #780, #779, #778, #775, #774, #771, #769, #768, #765, #764, #763, #762, #761, #760, #759, #758, #757, #756, #752, #751, #747, #741, #738, #737, #736, #735, #730, #723, #719, #718, #717, #715, #712, #711, #709, #704, #703, #702, #701, #700, #698, #697, #695, #694, #693, #692, #690, #689, #688, #686, #685, #684, #683, #677, #675, #674, #673, #670, #667, #666, #665, #664, #663, #660, #654, #648, #647, #646, #638, #637, #631, #630, #629, #627, #626, #621, #610, #608, #604, #603, #602, #600, #599, #594, #593, #592, #589, #588, #587, #586, #581, #579, #578, #577, #575, #572, #569, #555, #554, #553, #551, #550, #546, #541, #539, #536, #535, #534, #533, #529, #514, #511, #509, #508, #503, #500, #475, #472, #469, #466, #463, #461, #450, #438, #432, #431, #427, #420, #413, #412, #410, #409, #403, #399, #398, #397, #396, #395, #394, #393, #392, #389, #377, #369, #360, #359, #357, #356, #355, #353, #350, #348, #347, #346, #344, #337, #335, #334, #331, #329, #328, #324, #323, #322, #321, #320, #319, #318, #317, #316, #313, #311, #308, #306, #305, #303, #301, #300, #298, #297, #289, #288, #286, #283, #282, #281, #280, #279, #278, #266, #264, #263, #262, #258, #257, #256, #254, #253, #251, #250, #249, #248, #242, #241, #239, #238, #237, #235, #234, #231, #224, #216, #186, #182, #179, #170, #166, #155, #152, #151, #149, #138, #132, #124, #101, #96, #89, #79, #71, #60.

No garden source changes were needed.  
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-approved-pr-conductor-reconcile-20260730.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1050s

<!-- garden-usage-end -->
