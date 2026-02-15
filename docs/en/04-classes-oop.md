# Interton: classes and OOP

Target version: `Interton beta-v_.6.2`

## 1. When to use a class

Use classes when you need to:

1. persist state across method calls,
2. group related behavior around one entity,
3. model domain objects (session, counter, config, model).

If no state is needed, plain functions are usually enough.

## 2. Basic class structure

```interton
class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value = this.value + 1
        return this.value
    }

    public call add(delta: int) -> int {
        return this.value + delta
    }
}
```

Meaning:

1. `value` is internal state,
2. `init` sets initial state,
3. methods read/update state via `this`.

## 3. Full create-and-use example

```interton
adding std.io

class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value = this.value + 1
        return this.value
    }

    public call add(delta: int) -> int {
        return this.value + delta
    }
}

call main() -> int {
    Counter c = new Counter(5)
    inscribe("init:", c.value)
    inscribe("inc:", c.inc())
    inscribe("add 10:", c.add(10))
    inscribe("final:", c.value)
    return 0
}
```

Expected output:

```text
init: 5
inc: 6
add 10: 16
final: 6
```

## 4. `this` usage in practice

`this` points to the current object instance.

Use it when:

1. reading instance fields,
2. mutating object state,
3. disambiguating field names vs parameters.

```interton
class UserSession {
    string user;

    public call init(user: string) -> void {
        this.user = user
    }

    public call who() -> string {
        return this.user
    }
}
```

## 5. Multiple instances are independent

```interton
adding std.io

class Counter {
    int value;

    public call init(start: int) -> void {
        this.value = start
    }

    public call inc() -> int {
        this.value += 1
        return this.value
    }
}

call main() -> int {
    Counter a = new Counter(1)
    Counter b = new Counter(10)

    inscribe("a:", a.inc())
    inscribe("b:", b.inc())
    inscribe("a:", a.inc())
    return 0
}
```

Expected output:

```text
a: 2
b: 11
a: 3
```

## 6. Class design rules

1. One class = one responsibility.
2. Prefer state updates through methods.
3. Keep heavy math in `pure call` helpers.
4. Keep I/O out of domain classes when possible.
5. Use verb names for behavior (`load`, `save`, `compute`).

## 7. What to document per class

At minimum include:

1. class purpose,
2. field semantics,
3. which methods mutate state,
4. which methods are read-only,
5. one runnable example with expected output.

## 8. Common OOP mistakes

1. Uncontrolled direct field updates.
Fix: centralize mutations in methods.

2. God classes with unrelated concerns.
Fix: split into smaller focused classes.

3. Mixing model and logging concerns.
Fix: move output/logging to orchestration layer.

4. Skipping explicit initialization.
Fix: set clear defaults via `init`.

## 9. OOP quality checklist

1. Class responsibility is clear.
2. State transitions are predictable.
3. Example is reproducible.
4. Output expectations are documented.

