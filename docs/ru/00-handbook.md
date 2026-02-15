# Interton Handbook (RU)

Целевая версия: `Interton beta-v_.6.2`

Этот файл это основной “нарративный” документ. Он собран из **тематических блоков**, чтобы его можно было читать последовательно без прыжков по десяткам страниц.

Если нужны точные справочные страницы по темам, см. `ru/README.md`.

---

## Блок 1. Модель программы (как выглядит файл)

**Цель:** понять минимальную структуру Interton-программы и смысл “adding/using/call main”.

**Ключевые термины:**
- `adding` подключает пространство имён/модуль (или объявляет foreign-блок).
- `using` управляет разрешением коротких имён (а для `mermaid.*` еще и включает runtime-профиль).
- `call main() -> int` это пользовательская точка входа.

Минимальная программа:

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

Запуск:

```bash
intertonc --run hello_world.it
```

Примеры в репозитории:
- `examples/all_examples/00_basics_hello.it`
- `examples/basic/hello_world.it`

---

## Блок 2. Базовые типы, optional, коллекции

**Цель:** уверенно пользоваться базовыми типами и контейнерами.

Базовые типы:
- `int`, `float`, `bool`, `string`, `void`

Optional:
- `optional<T>` и значения `none`/`some(value)`

Коллекции:
- массивы: `T[]` (индексация: `arr[i]`, срезы: `arr[a..b]`)
- кортежи: `(T1, T2, ...)` (доступ: `.0`, `.1`, ...)

Примеры:
- `examples/all_examples/01_types_optional.it`
- `examples/all_examples/02_arrays_tuples_ranges.it`

---

## Блок 3. Управление потоком (control flow)

**Цель:** писать циклы/ветвления в реально используемом синтаксисе.

Частые формы:
- `if (...) { ... } else { ... }`
- `while cond { ... }`
- `for int i = 0; i < n; i = i + 1 { ... }`
- в примерах также встречается вариант обновления `i += 1`

Примеры:
- `examples/all_examples/03_control_flow.it`
- `examples/basic/control_flow_showcase.it`

---

## Блок 4. Операторы (сначала семантика)

**Цель:** знать смысл операторов, а не только список.

Критичная деталь:
- `a >< b` возвращает `max(a, b)` (выбор значения, не булево сравнение)
- `a <> b` возвращает `min(a, b)` (выбор значения, не булево сравнение)

В логическом контексте (`if`, `&&`, `||`) дальше применяется интерпретация truthy/falsy.

Примеры:
- `examples/all_examples/08_operators_arithmetic.it`
- `examples/all_examples/09_operators_assignment.it`
- `examples/basic/operators_showcase.it`

Справочник:
- `ru/02-operators.md`

---

## Блок 5. Функции, процедуры, лямбды

**Цель:** структурировать код через callable и понимать “pure vs procedure”.

Что встречается в примерах:
- функции: `call name(args...) -> Type { ... }`
- лямбды и callable-значения
- `procedure` блоки и pipeline-паттерны

Примеры:
- `examples/all_examples/04_functions_procedures.it`
- `examples/all_examples/05_lambdas.it`
- `examples/basic/pure_procedure_showcase.it`

Справочник:
- `ru/03-functions-procedures-lambdas.md`

---

## Блок 6. Классы / OOP

**Цель:** понимать классы так, как они используются в примерах (поля, методы, init/this).

Примеры:
- `examples/all_examples/07_classes_oop.it`
- `examples/basic/oop_showcase.it`
- `examples/basic/oop_methods_init_variants.it`

Справочник:
- `ru/04-classes-oop.md`

---

## Блок 7. Модули/неймспейсы, `adding`, `using`

**Цель:** подключать модули и контролировать имена без конфликтов.

Ключевое правило:
- `adding` делает код доступным, `using` меняет *как резолвятся имена* в текущем файле.

Полные пути допустимы и часто лучше для читаемости:
`std.system.files.read_file(...)`

Примеры:
- `examples/all_examples/19_modules_aliases.it`
- `examples/basic/module_alias_using.it`
- `examples/basic/module_using_alias_variants2.it`

Справочник:
- `ru/05-modules-libraries.md`

---

## Блок 8. FFI (интеграция с внешними языками)

**Цель:** понимать поверхность “adding <lang> ...” и формат обмена (как в примерах).

Примеры:
- `examples/all_examples/24_foreign_integration.it`
- `examples/basic/multilang_integration.it`
- `examples/basic/foreign_pipeline.it`

Справочник:
- `ru/06-ffi.md`

---

## Блок 9. Metadata, toning, tunnel, refocus

**Цель:** пользоваться продвинутыми механизмами по реальным примерам.

Примеры:
- `examples/all_examples/12_toning.it`
- `examples/all_examples/13_refocus.it`
- `examples/all_examples/14_tunnel_cache.it`
- `examples/all_examples/15_metadata.it`
- `examples/all_examples/25_metadata_admin_core.it`

Справочник:
- `ru/07-metadata-toning-tunnel-refocus.md`

---

## Блок 10. Quantum / Interference / Ray

**Цель:** понимать где лежат доменные стеки и с чего начинать.

Стеки:
- `quantum.*`
- `interference.*` и `interf.*`
- `rendering.ray.*`

Примеры:
- quantum: `examples/all_examples/17_quantum.it`, `examples/all_examples/30_quantum_gates.it`, `examples/quantum/*`
- interference: `examples/all_examples/16_interference.it`, `examples/interference/*`
- ray: `examples/all_examples/23_ray_tracing_mini.it`, `examples/ray_tracing/*`

Справочник:
- `ru/08-quantum-interference-ray.md`

---

## Блок 11. CLI режимы (интерпретатор vs compiled pipeline)

**Цель:** запускать один и тот же файл через `--run` и `--run-compiled` и понимать, когда какой режим нужен.

Примеры:
- `examples/basic/compiled_pipeline_showcase.it`
- `examples/all_examples/all_in_one.it`

Справочник:
- `ru/09-cli-run-modes.md`

---

## Блок 12. Стандартная библиотека и built-ins (куда смотреть)

**Цель:** быстро находить нужный модуль/std API.

Справочник:
- `ru/11-standard-library-reference.md`

---

## Блок 13. Mermaid (runtime-профили)

**Цель:** понимать что делает `using mermaid.*` сейчас и что еще не реализовано.

Справочник:
- `ru/12-mermaid-guide.md`

