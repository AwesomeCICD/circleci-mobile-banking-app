# Sidecar Benchmark — Inner vs Outer Loop

Inner loop = chunk-sidecar validation in the agent's lifecycle. Outer loop = traditional CI (push, read CircleCI, fix, repeat). Same task, same model; the only difference is how each arm validates.

- inner trials: **5**  ·  outer trials: **5**

## Headline — Sidecar (inner) vs Traditional CI (outer)

5 trials each, medians.

| Metric | inner | outer | outer ÷ inner |
|---|--:|--:|:--:|
| **Wall-clock to green** | 76 s | 123 s | **1.62× slower** |
| **Cost / change** | $0.155 | $0.216 | **1.39× more** |
| **Total tokens** | 93.6K | 170.2K | **1.82× more** |
| Agent turns | 6 | 8 | 1.33× more |
| **CI compute** | 2.4 min | 2.5 min | 1.03× (≈equal) |
| **CI pipelines** | 1 | 1 | equal |

**What it means:** On a change that passes CI first-try, the sidecar / inner loop is faster and cheaper *per change* — the time win is the CI wait the outer loop pays even on success, and the token/cost win comes from fewer agent turns. CI minutes are ≈equal because both arms run exactly one pipeline; the CI-compute savings only show up when the outer loop has to **iterate**, which this simple task does not trigger.

## Medians (inner vs outer)

| Metric | inner | outer | Δ (outer−inner) | outer / inner |
|---|--:|--:|--:|--:|
| Wall-clock to green (s) | 76 | 123 | 47 | 1.62× |
| Cost per trial ($) | 0.1548 | 0.2156 | 0.0607 | 1.39× |
| Agent turns | 6 | 8 | 2 | 1.33× |
| Total tokens | 93570 | 170150 | 76580 | 1.82× |
| Output tokens | 1872 | 2377 | 505 | 1.27× |
| CI compute (min) | 2.4 | 2.5 | 0.1 | 1.03× |
| CI pipelines | 1 | 1 | 0 | 1.00× |

## Spread (min … median … max)

**Wall-clock to green (s)**

- inner: 74 … 76 … 109
- outer: 106 … 123 … 157

**Cost per trial ($)**

- inner: 0.1437 … 0.1548 … 0.2865
- outer: 0.1659 … 0.2156 … 0.2923

**Agent turns**

- inner: 6 … 6 … 10
- outer: 6 … 8 … 11

**Total tokens**

- inner: 92579 … 93570 … 215604
- outer: 117286 … 170150 … 223382

**Output tokens**

- inner: 1528 … 1872 … 2624
- outer: 1816 … 2377 … 2552

**CI compute (min)**

- inner: 2.2 … 2.4 … 3.3
- outer: 2.3 … 2.5 … 3.0

**CI pipelines**

- inner: 1 … 1 … 1
- outer: 1 … 1 … 1

## Per-trial detail

| arm | trial | wall(s) | cost($) | turns | tokens | CI(min) | pipelines | error |
|---|--:|--:|--:|--:|--:|--:|--:|:-:|
| inner | 1 | 109 | 0.2865 | 10 | 215604 | 2.3 | 1 | ✓ |
| inner | 2 | 75 | 0.1548 | 6 | 93570 | 2.4 | 1 | ✓ |
| inner | 3 | 76 | 0.1443 | 6 | 92624 | 3.3 | 1 | ✓ |
| inner | 4 | 74 | 0.1437 | 6 | 92579 | 2.7 | 1 | ✓ |
| inner | 5 | 83 | 0.1892 | 7 | 142393 | 2.2 | 1 | ✓ |
| outer | 1 | 106 | 0.1659 | 6 | 117286 | 2.3 | 1 | ✓ |
| outer | 2 | 157 | 0.2923 | 11 | 223382 | 3.0 | 1 | ✓ |
| outer | 3 | 123 | 0.2222 | 9 | 190440 | 2.4 | 1 | ✓ |
| outer | 4 | 119 | 0.2100 | 8 | 167075 | 2.5 | 1 | ✓ |
| outer | 5 | 146 | 0.2156 | 8 | 170150 | 2.9 | 1 | ✓ |

_Live dashboard: http://localhost:3000/d/inner-vs-outer_
