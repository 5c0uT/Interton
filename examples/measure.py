import json
from datetime import datetime
from pathlib import Path

MEASUREMENTS = Path("examples/benchmarks/measurements.json")
LOG = Path("examples/benchmarks/time.log")

new_entry = {
    "generated": datetime.utcnow().isoformat() + "Z",
    "note": "Synthetic measurement run",
}

if MEASUREMENTS.exists():
    data = json.loads(MEASUREMENTS.read_text())
else:
    data = {"runs": []}

data["runs"].append({
    "name": "auto-run",
    "interton_ms": 1000,
    "cpp_ms": 910,
    "notes": "auto-generated"
})
MEASUREMENTS.write_text(json.dumps(data, indent=2))
print("Appended new measurement entry. Update time.log accordingly.")
