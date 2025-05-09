import os

def create_formulas():
    # create cnfs directory
    os.makedirs("cnfs", exist_ok=True)
    # run cnfgen op 50
    for i in range(5,55,5):
        os.system(f"cnfgen op {i} > cnfs/op_complete_{i}.cnf")
    for i in range(5,55,5):
        os.system(f"cnfgen kcolor 3 gnm {i} {2*i} > cnfs/3color_gnm_{i}.cnf")
    for i in range(5,55,5):
        os.system(f"cnfgen php {i} > cnfs/php_{i}.cnf")

if __name__ == "__main__":
    create_formulas()
