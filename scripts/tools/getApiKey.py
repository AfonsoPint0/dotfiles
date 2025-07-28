from pathlib import Path
import json
import sys

def get_key_from_json(key):
    script_dir = Path(__file__).resolve().parent
    base_path = script_dir.parents[1]
    json_path = base_path / 'keys' / 'keys.json'

    try:
        with open(json_path, 'r') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("JSON file not found.")
        return None
    except json.JSONDecodeError:
        print("Invalid JSON.")
        return None

    return data.get(key) 


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python getApiKey.py <key>")
    else:
        value = get_key_from_json(sys.argv[1])
        print(value if value else "Key not found.")
