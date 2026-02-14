# Interton: quantum/interference/ray — deep user guide

Target version: `Interton beta-v_.6.1`

## 1. What this file covers

1. which quantum/interference types are user-available,
2. **what each type stores**,
3. how those types differ,
4. how interference variable caching works,
5. how to split `interference.*` vs `interf.*`,
6. where ray workflows fit.

## 2. Quantum types: storage and differences

| Type | What it stores | Example value | Typical usage | beta-v_.6.1 status |
|---|---|---|---|---|
| `quant_i` | quantum state with integer-oriented measurement path | `H(|0>)`, then `measure(...) -> int` | discrete quantum workflows | public |
| `quant_f` | quantum state with float-oriented representation | `|0>`, `|1>` | mixed numeric/quantum pipelines | public |
| `qubit` | single-qubit state container | `qubit q = |0>` | explicit single-qubit modeling | public |
| `gate` | quantum operation descriptor/label | `gate g = H` | operation description pipelines | public (limited runtime semantics) |
| `quant_b` | boolean quantum container | - | not for direct user syntax | internal/reserved |

Practical rule:

1. use `quant_i`, `quant_f`, `qubit` in user code,
2. avoid `quant_b` in public APIs.

## 3. Interference types: storage and differences

| Type | What it stores | Example value | Typical usage | beta-v_.6.1 status |
|---|---|---|---|---|
| `interf_i` | integer history/cache buffer | `[10, 20, 30]` | counters, discrete state history | public |
| `interf_f` | float history/cache buffer | `[0.15, 0.27, 0.31]` | continuous signals, weights | public |
| `interf_s` | string history/cache buffer | `['a','b']` | string cache scenarios | internal/experimental |
| `interf_b` | boolean history/cache buffer | `[true,false,true]` | boolean signal history | internal/experimental |

Key difference (`interf_i` vs `interf_f`):

1. `interf_i` stores discrete integer history,
2. `interf_f` stores continuous float history.

## 4. Interference variable caching model

This section is about `interf_*` variable caching, not `%%tunnel%%` function cache.

Model intent:

1. keep value history,
2. support indexed access,
3. allow quick reuse of recent variable states.

### 4.1 `cache_demo.it`

File: `examples/interference/cache_demo.it`

Observed output lines:

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

### 4.2 `resonance.it`

File: `examples/interference/resonance.it`

Observed output:

```text
Cache entries: [5, 10, 20]
Resonance pattern: []
```

Interpretation:

1. history storage works,
2. not every expression over `interf_*` produces intuitive transformed buffers,
3. rely on tested operations for production logic.

## 5. `interf_*` vs `%%tunnel%%`

1. `interf_*` = variable-level state/history cache,
2. `%%tunnel%%` = function-result cache.

Tunnel examples:

1. `examples/basic/cache_tunnel_variants2.it`,
2. `examples/all_examples/14_tunnel_cache.it`.

## 6. Operators `><` and `<>`

Current beta-v_.6.1 semantics:

1. `><` = `max(left, right)`,
2. `<>` = `min(left, right)`.

```interton
adding std.io

call main() -> int {
    inscribe("7 >< 3 =", 7 >< 3)
    inscribe("7 <> 3 =", 7 <> 3)
    inscribe("2.5 >< 9 =", 2.5 >< 9)
    inscribe("2.5 <> 9 =", 2.5 <> 9)
    return 0
}
```

Observed output:

```text
7 >< 3 = 7
7 <> 3 = 3
2.5 >< 9 = 9
2.5 <> 9 = 2.5
```

## 7. `interference.*` vs `interf.*`

Responsibility split:

1. `interf.*` - compact math/wave utilities,
2. `interference.*` - broader physical models (light/sound/quantum).

## 8. Ray tracing position

`rendering.ray` is used to:

1. define scene state,
2. compute image output,
3. export rendering result.

Starter examples:

1. `examples/all_examples/23_ray_tracing_mini.it`,
2. `examples/ray_tracing/*.it`.

## 9. New-user checklist

1. Start with `quant_i` + `measure`.
2. Test `interf_i` and `interf_f` separately.
3. Keep `interf_*` and `%%tunnel%%` conceptually separate.
4. Validate `><`/`<>` on your own values.
5. Then move to `interference.*` and `rendering.ray`.
