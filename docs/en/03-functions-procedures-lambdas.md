# Interton: functions, procedures, lambdas

Target version: `Interton beta-v_.6.2`

## 1. Why Interton has three callable styles

In user code it is practical to split logic into three layers:

1. `pure call` - deterministic computation with no I/O side effects,
2. `call` - application logic, may orchestrate other calls,
3. `procedure` - orchestration and side effects (output/system actions).

This separation helps you:

1. test math logic independently,
2. keep program flow readable,
3. isolate runtime-specific problems faster.

## 2. `call`: main workhorse

Use `call` for regular returning functions.

```interton
adding std.io

call add(x: int, y: int) -> int {
    return x + y
}

call main() -> int {
    int result = add(5, 7)
    inscribe("sum:", result)
    return 0
}
```

Expected output:

```text
sum: 12
```

Use `call` when:

1. logic is not strictly pure,
2. function may depend on runtime context,
3. function expresses business/application behavior.

## 3. `pure call`: deterministic core

Use `pure call` for transformations that depend only on inputs.

```interton
adding std.io

pure call normalize(x: float, min: float, max: float) -> float {
    return (x - min) / (max - min)
}

call main() -> int {
    float n = normalize(25.0, 0.0, 100.0)
    inscribe("normalized:", n)
    return 0
}
```

Expected output:

```text
normalized: 0.25
```

Guidelines:

1. place formulas and deterministic transforms in `pure call`,
2. avoid I/O and FFI inside pure functions,
3. treat pure functions as your stable testable core.

## 4. `procedure`: explicit side effects

`procedure` is ideal for logging, output, and execution flow steps.

```interton
adding std.io

procedure log_line(msg: string) -> void {
    inscribe("[log]", msg)
}

call main() -> int {
    log_line("pipeline started")
    log_line("pipeline finished")
    return 0
}
```

Expected output:

```text
[log] pipeline started
[log] pipeline finished
```

## 5. Lambdas and higher-order functions

Interton supports passing functions as parameters.

```interton
adding std.io

call apply_twice(x: int, f: (int) -> int) -> int {
    return f(f(x))
}

call main() -> int {
    int plus = apply_twice(3, (n) -> n + 2)
    int square = apply_twice(2, (n) -> n * n)

    inscribe("plus:", plus)
    inscribe("square:", square)
    return 0
}
```

Expected output:

```text
plus: 7
square: 16
```

Usage pattern:

1. lambdas are good for short transforms,
2. extract long lambdas into named `call` functions,
3. keep callback signatures simple.

## 6. Practical composition template

Typical structure: pure compute + message assembly + output.

```interton
adding std.io

pure call score(cpu: float, quality: float) -> float {
    return cpu * 0.7 + quality * 0.3
}

call build_message(cpu: float, quality: float) -> string {
    float s = score(cpu, quality)
    return f"score={s}"
}

procedure print_message(cpu: float, quality: float) -> void {
    inscribe(build_message(cpu, quality))
}

call main() -> int {
    print_message(0.8, 1.0)
    return 0
}
```

Expected output:

```text
score=0.86
```

## 7. Function contract checklist

For each public function, document:

1. required input format,
2. exact return meaning and type,
3. boundary behavior,
4. known limitations and complexity (if relevant),
5. runtime dependencies (if FFI is involved).

## 8. Common mistakes

1. Mixing compute and I/O in one function.
Fix: split into `pure call` + `procedure`.

2. Overusing large anonymous lambdas.
Fix: extract into named functions.

3. Non-informative parameter names.
Fix: use semantic naming (`raw_score`, `max_limit`).

4. Undocumented output contract.
Fix: add short Input/Output section near API docs.

## 9. Quality mini-checklist

1. Pure logic isolated in `pure call`.
2. Side effects isolated in `procedure`.
3. Public `call` names are domain-readable.
4. Every example has expected output.

