# Interton: metadata, toning, tunnel, refocus (подробный прикладной гайд)

Целевая версия: `Interton beta-v_.6.1`

## 1. Что это за блок и зачем он нужен

Этот файл описывает четыре advanced-механики, которые чаще всего дают практический эффект в продакшене:

1. `metadata` — контракты и описание данных,
2. `toning` — управляемая коррекция значений,
3. `%%tunnel%%` — кеш результатов функций,
4. `refocus` — контролируемая вариативность.

Отдельно: `interf_i/interf_f` — это другой тип кеширования (история переменной), не то же самое, что `%%tunnel%%`.

## 2. Metadata: контракт данных и контекст

## 2.1 Три типа metadata

1. `structural_metadata` — структура/схема,
2. `descriptive_metadata` — человекочитаемое описание,
3. `technical_metadata` — служебные параметры выполнения.

Пример: `examples/all_examples/15_metadata.it`

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

Фактический вывод:

```text
DataShape: metadata
Dataset: Sensor readings
Build target: run-mode
```

## 2.2 Domain + administrative metadata

Пример: `examples/all_examples/25_metadata_admin_core.it`

Фактический вывод:

```text
doc category: docs
doc version: v2
policy resource: example_docs
```

Практический смысл:

1. `domain_entity` хранит бизнес-атрибуты и связанные метаданные,
2. `administrative_metadata` задает правила доступа/администрирования.

## 3. Toning: как работает и когда применять

`toning` — это встроенная «мягкая трансформация» значения.

Типовые задачи:

1. скорректировать числовой ряд перед расчетом,
2. сделать нормализацию без длинных if/else цепочек,
3. централизовать стили изменения данных в пайплайне.

## 3.1 Inline toning

Пример: `examples/all_examples/12_toning.it`

Фактический вывод:

```text
a: 10 b: 10.5 c: 8.5
s: tone s2: upof
```

Это показывает, что toning работает не только для чисел, но и для строковых трансформаций.

## 3.2 Group/operation toning

Пример: `examples/basic/toned_group_variants2.it`

Фактический вывод:

```text
group: 2.5 4.5
a: 3.5 b: 7.5 s: a f: 4.8
combo: 6 boosted: 2
```

## 4. Tunnel: кеш функции по вызовам

`%%tunnel%%` кеширует результат функции и переиспользует его при близких/совпадающих аргументах.

Где дает эффект:

1. дорогие функции вызываются много раз,
2. повторяются одинаковые входы,
3. важна задержка ответа.

Пример: `examples/all_examples/14_tunnel_cache.it`

Фактический вывод:

```text
mix: 2.28571 2.28571
tunnel stats: 1
```

Интерпретация:

1. второе значение `mix` взято из кеша,
2. `hits=1` подтверждает попадание.

## 5. Интерференционное кеширование (`interf_i` / `interf_f`)

Это отдельный механизм: кеш-история присваиваний переменной.

## 5.1 Основной пример

Файл: `examples/interference/cache_demo.it`

Фрагменты фактического вывода:

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

Итог по кейсу:

1. можно читать элементы по индексу,
2. доступен размер кеша (`|cache|`),
3. видна эволюция буфера при последовательных обновлениях.

## 5.2 Второй пример (не только `cache_demo.it`)

Файл: `examples/interference/resonance.it`

Фактический вывод:

```text
Cache entries: [5, 10, 20]
Resonance pattern: []
```

Это подтверждает, что модель интерференционного кеша используется в разных сценариях, а не в одном демонстрационном файле.

## 5.3 `interf_*` vs `%%tunnel%%` (критично не путать)

1. `interf_*` — кеш-история переменной,
2. `%%tunnel%%` — кеш результата функции.

## 6. Refocus: контролируемая вариативность

`refocus` полезен, когда нужна управляемая недетерминированность.

Пример: `examples/basic/refocus_demo.it`

Фактический вывод одного запуска:

```text
original: 42
refocus value: 108
refocus hits: 2
refocus seed: 71739115
```

Важно: значение `refocus value` и `seed` могут меняться между запусками.

## 7. Комбинированный сценарий

Файл: `examples/basic/tunneling_toning.it`

Фактический вывод:

```text
Cached result: 1.45469
Flavored: Uvofe gmbwpvs 1.2
```

Этот пример показывает совместное применение `%%tunnel%%`, `toning` и `refocus` в одном потоке.

## 8. Практические правила применения

1. Сначала стабилизируйте алгоритм без advanced-механик.
2. Потом добавьте metadata-контракты.
3. Далее подключайте toning в точках нормализации.
4. Включайте tunnel только для дорогих функций.
5. Refocus добавляйте там, где вариативность допустима бизнес-логикой.

## 9. Чеклист качества

1. Для tunnel мониторьте `hits/misses`.
2. Для toning фиксируйте ожидаемую математику/трансформацию.
3. Для refocus сохраняйте `seed` в диагностике.
4. Для `interf_*` проверяйте буфер и индексы реальным выводом.
5. Не смешивайте терминологию `interf_*` и `%%tunnel%%` в документации проекта.
