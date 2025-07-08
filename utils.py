import os

def check_metadata(start_dir='.'):
    """
    Prints the content of the first metadata file (.rel) in the first nested directory called 'ict'.
    """
    print("-" * 20)
    print("Checking metadata...")
    for root, dirs, files in os.walk(start_dir):
        if os.path.basename(root).lower() == 'ict':
            for file in files:
                if file.lower().endswith('.rel'):
                    rel_path = os.path.join(root, file)
                    with open(rel_path, 'r', encoding='utf-8') as f:
                        print(f"Found: {rel_path}\n")
                        print(f.read())
                    return  # stop after the first .rel file
    print("No '.rel' file found in any 'ict' folder.")