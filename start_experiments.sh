#!/bin/bash
mkdir -p logs
# Function to submit a solver job
submit_solver() {
    local cnf_file=$1
    local solver_path=$2

    if [ -z "$cnf_file" ] || [ -z "$solver_path" ]; then
        echo "Error: Both CNF file and solver path are required."
        echo "Usage: submit_solver <cnf_file> <solver_path>"
        return 1
    fi

    if [ ! -f "$cnf_file" ]; then
        echo "Error: CNF file '$cnf_file' does not exist."
        return 1
    fi

    if [ ! -f "$solver_path" ] || [ ! -x "$solver_path" ]; then
        echo "Error: Solver '$solver_path' does not exist or is not executable."
        return 1
    fi

    echo "Submitting job to solve $cnf_file using $solver_path"
    # Add your job submission logic here
    # For example, if using SLURM:
    # sbatch --job-name="solve_$(basename $cnf_file)" --wrap="$solver_path $cnf_file"
    
    # For direct execution:
    solver_name=$(basename $solver_path)
    wrapped_command="$solver_path $cnf_file > $cnf_file.$solver_name.log"
    echo "Wrapped command: $wrapped_command"
    # Execute the wrapped command
    sbatch --job-name="solve_$(basename $cnf_file)" --time=01:30:00 --mem=16G --output="outputs/$(basename $cnf_file).out" --wrap="$wrapped_command"
}


# Function to run solver on all CNF files in a directory
run_all_cnfs() {
    local solver_path=$1
    local cnf_dir="cnfs/"

    if [ -z "$solver_path" ]; then
        echo "Error: Solver path is required."
        echo "Usage: run_all_cnfs <solver_path>"
        return 1
    fi

    if [ ! -f "$solver_path" ] || [ ! -x "$solver_path" ]; then
        echo "Error: Solver '$solver_path' does not exist or is not executable."
        return 1
    fi

    if [ ! -d "$cnf_dir" ]; then
        echo "Error: Directory '$cnf_dir' does not exist."
        return 1
    fi

    echo "Running solver on all CNF files in $cnf_dir..."
    for cnf_file in "$cnf_dir"/*.cnf; do
        if [ -f "$cnf_file" ]; then
            echo "Processing $cnf_file..."
            submit_solver "$cnf_file" "$solver_path"
        fi
    done
}

run_all_cnfs "./solvers/kissat"
run_all_cnfs "./solvers/cadical"