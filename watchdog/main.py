import os
import time
import logging
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from validator import validate_file
import shutil

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class FileValidationHandler(FileSystemEventHandler):
    def __init__(self, rejected_folder):
        self.rejected_folder = rejected_folder
    
    def on_created(self, event):
        if not event.is_directory:
            filename = Path(event.src_path).name
            is_valid, message = validate_file(event.src_path)
            
            if is_valid:
                logger.info(f"✅ {filename} - VALID")
            else:
                logger.warning(f"❌ {filename} - REJECTED: {message}")
                # Move to rejected folder
                rejected_path = os.path.join(self.rejected_folder, filename)
                shutil.move(event.src_path, rejected_path)

incoming_folder = os.getenv("INCOMING_FOLDER", "/app/data/incoming")
rejected_folder = os.getenv("REJECTED_FOLDER", "/app/data/rejected")

os.makedirs(incoming_folder, exist_ok=True)
os.makedirs(rejected_folder, exist_ok=True)

event_handler = FileValidationHandler(rejected_folder)
observer = Observer()
observer.schedule(event_handler, incoming_folder, recursive=False)

logger.info(f"🔍 Watching folder: {incoming_folder}")
observer.start()

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
    observer.join()
    logger.info("Watchdog stopped")
