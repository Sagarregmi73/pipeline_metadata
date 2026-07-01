import os
from pathlib import Path

ALLOWED_EXTENSIONS = ['.xlsx', '.csv', '.json']
MAX_FILE_SIZE = 100 * 1024 * 1024  # 100MB

def validate_file(file_path):
    """Validate file and return (is_valid, error_message)"""
    
    # Check if file exists
    if not os.path.exists(file_path):
        return False, "File not found"
    
    # Check extension
    ext = Path(file_path).suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        return False, f"Invalid extension: {ext}. Allowed: {ALLOWED_EXTENSIONS}"
    
    # Check file size
    file_size = os.path.getsize(file_path)
    if file_size == 0:
        return False, "File is empty"
    if file_size > MAX_FILE_SIZE:
        return False, f"File too large: {file_size} bytes"
    
    return True, "Valid"
