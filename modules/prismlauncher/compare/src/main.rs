use std::env;
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::process;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        eprintln!("Usage: compare-files <file1> <file2>");
        process::exit(1);
    }

    let file1 = &args[1];
    let file2 = &args[2];

    let content1 = fs::read_to_string(file1).expect("Unable to read file1");
    let mut content2 = fs::read_to_string(file2).expect("Unable to read file2");

    let mut file2_modified = false;

    for line in content1.lines() {
        if !content2.contains(line) {
            content2.push_str(&format!("\n{}", line));
            file2_modified = true;
        }
    }

    if file2_modified {
        let mut file = OpenOptions::new()
            .write(true)
            .truncate(true)
            .open(file2)
            .expect("Unable to open file2 for writing");
        file.write_all(content2.as_bytes())
            .expect("Unable to write to file2");
    }

    println!("Comparison complete. File2 updated if needed.");
}
