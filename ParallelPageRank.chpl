use Random;
use Time;
use IO;

// Initialization of program parameters
config var input_file: string = "link.txt";
config var generate_links: bool = true;
config var n: int = 15;
config var p: int = -1;
config var max_iterations: int = 10000;
config var debug: bool = false;
config var sort_pages: bool = false;
config var display_ranks: bool = true;
// A good value for damping factor is 0.810
config var damping_factor: real = 0.810;

// Initialization of data structures
var link_matrix: [0..n-1, 0..n-1] bool;
var out_link_counts: [0..n-1] int; 
var page_ranks: [0..n-1] real;
var page_urls: [0..n-1] string;
var t1: Timer;


// Create sample data and populate matrix and link counts
if (generate_links && input_file == "link.txt") { 
    fillRandom(link_matrix);
    if (debug) {
        writeln(link_matrix);
    }

// Read link matrix and page link count from file.
} else {
    // Open an input file with the specified filename in read mode.
    var infile = open(input_file, iomode.r);
    var reader = infile.reader();
    if (debug) {
        writeln("Reading file...");
    }
    // Read link names and link matrix
    reader.read(page_urls);
    reader.read(link_matrix);

    if (debug) {
        writeln(link_matrix);
    }
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
for iteration in 0..max_iterations-1 {
    var p_size: int = n/p;
    var next_page_ranks: [0..n-1] real;
    forall process_num in 0..p-1 {
        for r in process_num*p_size..p_size+(process_num*p_size)-1 {
            // writeln(process_num*p_size, " -> ", p_size+(process_num*p_size)-1);
            if (debug) {
                writeln(r);
            }
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
    
if (sort_pages) {
    for i in 0..n-1 {
        for j in i+1..n-1 {
            if page_ranks[i] > page_ranks[j] {
                var tempRank: real = page_ranks[j];
                var tempString: string = page_urls[j];
                page_ranks[j] = page_ranks[i];
                page_ranks[i] = tempRank;
                page_urls[j] = page_urls[i];
                page_urls[i] = tempString;
            }
        }
    }
}

if (display_ranks) {
    writeln("Page Ranks:");
    for page in 0..n-1 {
        writeln(page_urls[page], ": ", page_ranks[page]);
    }
    writeln();
}
writeln(p, " ", t1.elapsed());