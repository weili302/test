import os

# Function to set the directory named 'infradevops' as the root directory
def set_root_dir():
    # Get the current working directory
    current_path = os.getcwd()
    
    # Split the path into parts
    path_parts = current_path.split(os.sep)
    
    # Initialize root directory
    root_dir = None
    
    # Iterate over the parts of the path
    for part in path_parts:
        # Check if the part is 'infradevops'
        if part.lower() == 'infradevops':
            # Set the root directory
            root_dir = os.path.join(os.sep, *path_parts[:path_parts.index(part)+1])
            break
    
    # If 'infradevops' directory is found, change the current working directory
    if root_dir:
        os.chdir(root_dir)
        return f"Root directory set to: {root_dir}"
    else:
        return "Directory named 'infradevops' not found in the current path."

# Set the root directory and print the result
print(set_root_dir())
