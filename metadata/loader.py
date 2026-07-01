import json
import os
from pathlib import Path

SCHEMA_MAPPING_DIR = os.path.join(os.path.dirname(__file__), "schema_mapping")

def load_schema_mapping(source_name):
    """Load schema mapping for a data source"""
    mapping_file = os.path.join(SCHEMA_MAPPING_DIR, f"{source_name.lower()}.json")
    
    if not os.path.exists(mapping_file):
        raise FileNotFoundError(f"Mapping not found for: {source_name}")
    
    with open(mapping_file, 'r') as f:
        return json.load(f)

def get_available_mappings():
    """List all available mappings"""
    files = Path(SCHEMA_MAPPING_DIR).glob("*.json")
    return [f.stem for f in files]

# Test
if __name__ == "__main__":
    print("Available mappings:", get_available_mappings())
    print("\nApple mapping:", load_schema_mapping("apple"))
    print("Samsung mapping:", load_schema_mapping("samsung"))
