import os
import subprocess
import datetime
import sys
from pathlib import Path
import shutil
import re

def _which(*names):
    path_entries = os.environ.get("PATH", "").split(os.pathsep)
    for name in names:
        path = shutil.which(name)
        if path:
            return path
        candidates = [name, f"{name}.exe", f"{name}.cmd", f"{name}.bat", f"{name}.ps1"]
        for entry in path_entries:
            for cand in candidates:
                candidate_path = os.path.join(entry, cand)
                if os.path.isfile(candidate_path):
                    return candidate_path
    return None

def _ensure_env(env_name, *command_names):
    if not os.environ.get(env_name):
        resolved = _which(*command_names)
        if resolved:
            os.environ[env_name] = resolved

def resolve_intertonc(project_root: Path):
    env_path = os.environ.get("INTERTONC_PATH")
    candidates = []
    if env_path:
        candidates.append(Path(env_path))
    candidates.extend([
        project_root / "build" / "compiler" / "compiler" / "Release" / "intertonc.exe",
        project_root / "build" / "compiler" / "compiler" / "Release" / "interton_compiler.exe",
        project_root / "build" / "artifacts" / "windows" / "dist" / "bin" / "intertonc.exe",
    ])
    for candidate in candidates:
        if candidate.exists():
            return str(candidate)
    in_path = shutil.which("intertonc")
    if in_path:
        return in_path
    return None


def run_intertonc_on_examples():
    script_path = Path(__file__).resolve()
    project_root = script_path.parent.parent
    examples_path = project_root / "examples"

    if not examples_path.exists():
        print(f"Папка не найдена: {examples_path}")
        return 1

    intertonc_bin = resolve_intertonc(project_root)
    if not intertonc_bin:
        print("Ошибка: intertonc не найден. Укажи INTERTONC_PATH или собери compiler.")
        return 1
    print(f"Используем intertonc: {intertonc_bin}")
    
    # Обрабатываем только .it файлы
    allowed_extension = '.it'
    # Расширения файлов, которые нужно пропустить
    skip_extensions = {'.md', '.txt', '.log', '.json', '.ps1', '.py', '.cpp', '.c', '.h', '.hpp', '.cc'}
    generated_log_pattern = re.compile(r".*_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}(?:_ERROR)?\.txt$", re.IGNORECASE)
    
    # Подпапки, которые нельзя запускать как самостоятельные (нет main)
    skip_dirs = {os.path.normpath(str(examples_path / "basic" / "modules"))}

    _ensure_env("INTERTON_PY", "python", "python3", "py")
    _ensure_env("INTERTON_NODE", "node")
    _ensure_env("INTERTON_TS", "node", "ts-node")
    _ensure_env("INTERTON_C", "clang++", "g++", "clang", "gcc")
    _ensure_env("INTERTON_CPP", "clang++", "g++")
    _ensure_env("INTERTON_CSHARP", "csc", "mcs", "dotnet", "interton-ffi-csharp", "interton_csharp_runner")
    _ensure_env("INTERTON_JAVA", "javac", "interton-ffi-java", "interton_java_runner")

    # Проходим по всем подпапкам и файлам
    passed = 0
    failed = 0
    skipped = 0
    failed_files = []

    for root, dirs, files in os.walk(examples_path):
        # Пропускаем директории модулей (импортируемые .it без main)
        if os.path.normpath(root) in skip_dirs:
            print(f"Пропускаем папку модулей: {root}")
            continue
        for file in files:
            file_path = os.path.join(root, file)
            file_ext = os.path.splitext(file)[1].lower()

            # Пропускаем автоматически сгенерированные логи запусков примеров.
            if generated_log_pattern.match(file):
                continue
            
            # Пропускаем файлы с указанными расширениями
            if file_ext in skip_extensions:
                print(f"Пропускаем файл: {file_path}")
                skipped += 1
                continue
            if file_ext != allowed_extension:
                print(f"Пропускаем файл: {file_path}")
                skipped += 1
                continue

            # Пропускаем foreign-примеры, если нет рантаймов
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as src:
                    content = src.read()
                needs_py = "<py>" in content
                needs_js = "<js>" in content
                needs_ts = "<ts>" in content
                needs_c = "<c>" in content
                needs_cpp = "<cpp>" in content
                needs_cs = "<cs>" in content
                needs_j = "<j>" in content
                if needs_py and not os.environ.get("INTERTON_PY"):
                    print(f"Пропускаем файл (нет INTERTON_PY): {file_path}")
                    skipped += 1
                    continue
                if needs_js and not os.environ.get("INTERTON_NODE"):
                    print(f"Пропускаем файл (нет INTERTON_NODE): {file_path}")
                    skipped += 1
                    continue
                if needs_ts and not os.environ.get("INTERTON_TS"):
                    print(f"Пропускаем файл (нет INTERTON_TS): {file_path}")
                    skipped += 1
                    continue
                if needs_c and not os.environ.get("INTERTON_C"):
                    print(f"Пропускаем файл (нет INTERTON_C): {file_path}")
                    skipped += 1
                    continue
                if needs_cpp and not os.environ.get("INTERTON_CPP"):
                    print(f"Пропускаем файл (нет INTERTON_CPP): {file_path}")
                    skipped += 1
                    continue
                if needs_cs and not os.environ.get("INTERTON_CSHARP"):
                    print(f"Пропускаем файл (нет INTERTON_CSHARP): {file_path}")
                    skipped += 1
                    continue
                if needs_j and not os.environ.get("INTERTON_JAVA"):
                    print(f"Пропускаем файл (нет INTERTON_JAVA): {file_path}")
                    skipped += 1
                    continue
            except Exception:
                pass
            
            try:
                print(f"Запускаем: intertonc --run {file_path}")
                
                # Запускаем команду и захватываем вывод
                result = subprocess.run(
                    [intertonc_bin, "--run", file_path],
                    capture_output=True,
                    text=True,
                    shell=False
                )
                
                # Получаем текущие дату и время
                now = datetime.datetime.now()
                date_str = now.strftime("%Y-%m-%d")
                time_str = now.strftime("%H-%M-%S")
                
                # Формируем имя лог-файла
                log_filename = f"{os.path.splitext(file)[0]}_{date_str}_{time_str}.txt"
                log_path = os.path.join(root, log_filename)
                
                # Формируем содержимое лог-файла
                log_content = f"Запуск команды:\nintertonc --run {file_path}\n\n"
                log_content += f"Дата и время запуска: {now}\n\n"
                log_content += "=" * 50 + "\n"
                log_content += "ВЫВОД ПРОГРАММЫ:\n"
                log_content += "=" * 50 + "\n"
                
                if result.stdout:
                    log_content += f"STDOUT:\n{result.stdout}\n"
                
                if result.stderr:
                    log_content += f"STDERR:\n{result.stderr}\n"
                
                if result.returncode != 0:
                    log_content += f"\nКод возврата: {result.returncode}\n"
                
                # Записываем лог-файл
                with open(log_path, 'w', encoding='utf-8') as log_file:
                    log_file.write(log_content)
                
                print(f"Лог сохранен: {log_path}")
                if result.returncode == 0:
                    passed += 1
                else:
                    failed += 1
                    failed_files.append(file_path)
                print("-" * 50)
                
            except Exception as e:
                print(f"Ошибка при обработке файла {file_path}: {str(e)}")
                failed += 1
                failed_files.append(file_path)
                
                # Сохраняем информацию об ошибке в лог
                try:
                    now = datetime.datetime.now()
                    date_str = now.strftime("%Y-%m-%d")
                    time_str = now.strftime("%H-%M-%S")
                    
                    log_filename = f"{os.path.splitext(file)[0]}_{date_str}_{time_str}_ERROR.txt"
                    log_path = os.path.join(root, log_filename)
                    
                    with open(log_path, 'w', encoding='utf-8') as log_file:
                        log_file.write(f"ОШИБКА ЗАПУСКА:\n{str(e)}\n\n")
                        log_file.write(f"Файл: {file_path}\n")
                        log_file.write(f"Дата и время: {now}\n")
                    
                    print(f"Лог ошибки сохранен: {log_path}")
                except:
                    pass

    print("Итог test_examples.py:")
    print(f"  Passed: {passed}")
    print(f"  Failed: {failed}")
    print(f"  Skipped: {skipped}")
    if failed_files:
        print("  Failed files:")
        for path in failed_files:
            print(f"   - {path}")

    now = datetime.datetime.now()
    summary_name = f"test_examples_summary_{now.strftime('%Y%m%d_%H%M%S')}.md"
    summary_path = project_root / "test_results" / summary_name
    summary_path.parent.mkdir(parents=True, exist_ok=True)
    with open(summary_path, "w", encoding="utf-8") as summary:
        summary.write(f"# test_examples.py summary - {now}\n\n")
        summary.write(f"- intertonc: `{intertonc_bin}`\n")
        summary.write(f"- Passed: {passed}\n")
        summary.write(f"- Failed: {failed}\n")
        summary.write(f"- Skipped: {skipped}\n")
        if failed_files:
            summary.write("\n## Failed files\n")
            for path in failed_files:
                summary.write(f"- `{path}`\n")
    print(f"Summary сохранен: {summary_path}")
    return 0 if failed == 0 else 2

if __name__ == "__main__":
    rc = run_intertonc_on_examples()
    print("Обработка завершена!")
    sys.exit(rc)
