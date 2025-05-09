import os

def extract_features(file_path):
    # read the cnf file
    base_name = file_path.split("/")[-1]
    os.system(f"./SATZilla/features -base {file_path} > features/{base_name}.out")
        
if __name__ == "__main__":
    os.makedirs("features", exist_ok=True)
    files = os.listdir("cnfs")
    for file in files:
        extract_features(f"cnfs/{file}")
