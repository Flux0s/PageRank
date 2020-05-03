use Random;
use Time;

// Initialization of program parameters
config var generate_link_matrix: bool = true;
config var n: int = 15;
config var p: int = -1;
config var max_iterations: int = 10000;
config var debug: bool = false;
// A good value for damping factor is 0.810
config var damping_factor: real = 0.810;
// Initialization of data structures
var link_matrix: [0..n-1, 0..n-1] bool;
var out_link_counts: [0..n-1] int; 
var page_ranks: [0..n-1] real;
var page_urls: [0..n-1] string;
var t1: Timer;

// Create sample data and populate matrix and link counts
if (generate_link_matrix) { 
    fillRandom(link_matrix);
    if (debug) {
        writeln(link_matrix);
    }

// Read link matrix and page link count from file.
} else {
    if (debug) {
        writeln();
    }
    // Read link matrix
    
    // Calculate n
}


// If p not set at runtime, set it to n
if (p == -1) {
    p = n;
}
// Calculate number of links from each page
forall c in 0..n-1 {
    for r in 0..n-1 {
        if (r != c && link_matrix[r, c]) {
            out_link_counts[c] += 1;
        }
    }
}
if (debug) {
    // Calculate number of links to each page (for debug purposes)
    var in_link_matrix: [0..n-1] int; 
    forall r in 0..n-1 {
        for c in 0..n-1 {
            if (r != c && link_matrix[r, c]) {
                in_link_matrix[r] += 1;
            }
        }
    }
    writeln("Links from page:");
    writeln(out_link_counts);    
    writeln("Links to page:");
    writeln(in_link_matrix);
}

t1.start();
var p_size: int = n/p;
for iteration in 0..max_iterations-1 {
    var next_page_ranks: [0..n-1] real;
    forall process_num in 0..p-1 {
        for r in process_num*p_size..p_size+(process_num*p_size)-1 {
            // writeln(process_num*p_size, " -> ", p_size+(process_num*p_size)-1);
            writeln(r);
            // writeln(process_num);
            for c in 0..n-1 {
                if (r != c && link_matrix[r, c]) {
                    next_page_ranks[r] += page_ranks[c] / out_link_counts[c];
                }
            }
            next_page_ranks[r] *= damping_factor;
            next_page_ranks[r] += 1 - damping_factor;
        }
    }
    page_ranks = next_page_ranks;
}
t1.stop();

writeln("Page Ranks:");
for page in 0..n-1 {
    writeln(page_urls[page], ": ", page_ranks[page]);
}
writeln();
writeln(p, " ", t1.elapsed());