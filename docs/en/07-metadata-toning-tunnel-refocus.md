# Interton: metadata, toning, tunnel, refocus (detailed practical guide)

Target version: `Interton beta-v_.6.2`

## 1. Scope and purpose

This file covers four advanced mechanisms that usually deliver practical gains:

1. `metadata` — data contracts and context,
2. `toning` — controlled value adjustments,
3. `%%tunnel%%` — function-result caching,
4. `refocus` — controlled variability.

Separate concept: `interf_i/interf_f` is a different caching model (variable history), not the same as `%%tunnel%%`.

## 2. Metadata: data contract and context

## 2.1 Three metadata types

1. `structural_metadata` — schema/structure,
2. `descriptive_metadata` — human-readable context,
3. `technical_metadata` — runtime-related attributes.

Example: `examples/all_examples/15_metadata.it`

```interton
adding std.io

structural_metadata DataShape {
    schema: { fields: ["id", "value"], types: ["int", "float"] };
    version: "v1";
}

descriptive_metadata DatasetInfo {
    title: "Sensor readings";
    tags: ["telemetry", "beta"];
}

technical_metadata BuildInfo {
    compiler: "intertonc";
    target: "run-mode";
}

call main() -> int {
    inscribe("DataShape:", DataShape.type)
    inscribe("Dataset:", DatasetInfo.title)
    inscribe("Build target:", BuildInfo.target)
    return 0
}
```

Observed output:

```text
DataShape: metadata
Dataset: Sensor readings
Build target: run-mode
```

## 2.2 Domain + administrative metadata

Example: `examples/all_examples/25_metadata_admin_core.it`

Observed output:

```text
doc category: docs
doc version: v2
policy resource: example_docs
```

Practical meaning:

1. `domain_entity` stores business attributes plus metadata,
2. `administrative_metadata` defines access/admin policy.

## 3. Toning: behavior and usage

`toning` is a built-in soft transformation mechanism.

Typical uses:

1. adjust numeric data before computation,
2. normalize values without long branching chains,
3. centralize transformation style in a pipeline.

## 3.1 Inline toning

Example: `examples/all_examples/12_toning.it`

Observed output:

```text
a: 10 b: 10.5 c: 8.5
s: tone s2: upof
```

This shows toning affects not only numeric values but also string transforms.

## 3.2 Group/operation toning

Example: `examples/basic/toned_group_variants2.it`

Observed output:

```text
group: 2.5 4.5
a: 3.5 b: 7.5 s: a f: 4.8
combo: 6 boosted: 2
```

## 4. Tunnel: function-call caching

`%%tunnel%%` caches function results and reuses them for matching/similar inputs.

Best fit:

1. expensive functions called repeatedly,
2. repeated inputs,
3. low-latency requirement.

Example: `examples/all_examples/14_tunnel_cache.it`

Observed output:

```text
mix: 2.28571 2.28571
tunnel stats: 1
```

Interpretation:

1. second `mix` value came from cache,
2. `hits=1` confirms cache reuse.

## 5. Interference-style variable caching (`interf_i` / `interf_f`)

This is a separate mechanism: assignment-history cache for variables.

## 5.1 Main example

File: `examples/interference/cache_demo.it`

Observed output snippets:

```text
First element: 10
Last element: 50
Cache size: 5
```

```text
After adding 100: [100]
After adding 200: [100, 200]
After adding 300: [100, 200, 300]
```

Takeaways:

1. indexed access is available,
2. cache size is available (`|cache|`),
3. cache evolution is observable over assignments.

## 5.2 Additional example (not only `cache_demo.it`)

File: `examples/interference/resonance.it`

Observed output:

```text
Cache entries: [5, 10, 20]
Resonance pattern: []
```

This confirms interference caching is used in multiple workflows, not in one sample only.

## 5.3 `interf_*` vs `%%tunnel%%` (critical distinction)

1. `interf_*` = variable history cache,
2. `%%tunnel%%` = function-result cache.

## 6. Refocus: controlled variability

`refocus` is useful when controlled non-determinism is desired.

Example: `examples/basic/refocus_demo.it`

Observed output from one run:

```text
original: 42
refocus value: 108
refocus hits: 2
refocus seed: 71739115
```

Important: `refocus value` and `seed` are run-dependent.

## 7. Combined scenario

File: `examples/basic/tunneling_toning.it`

Observed output:

```text
Cached result: 1.45469
Flavored: Uvofe gmbwpvs 1.2
```

This demonstrates `%%tunnel%%`, `toning`, and `refocus` in one flow.

## 8. Practical adoption order

1. Stabilize logic first without advanced features.
2. Add metadata contracts.
3. Add toning in normalization points.
4. Enable tunnel only for expensive functions.
5. Add refocus where variability is acceptable.

## 9. Quality checklist

1. Track tunnel `hits/misses`.
2. Document expected toning behavior.
3. Persist `seed` for refocus diagnostics.
4. Validate `interf_*` buffers via real output checks.
5. Keep `interf_*` and `%%tunnel%%` terminology separated.

