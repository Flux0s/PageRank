use Random;
use List;
use Time;

config var n: int = 30;
config var p: int = 3;
var buckets: [0..p-1] list(real, parSafe=true);
var t1: Timer;
var X: [0..n-1] real;

fillRandom(X);
t1.start();
forall processIndex in 0..p-1 {
    var rangeMin = processIndex*n/p;
    var keys = X[rangeMin..rangeMin+n/p-1];
    // writeln(keys);
    for key in keys {
        buckets[(key*p) : int].append(key);
    }
}

forall bucketIndex in 0..p-1 {
    // buckets[bucketIndex].sort();
    for i in 0..buckets[bucketIndex].size-1 {
        for j in i+1..buckets[bucketIndex].size-1 {
            if buckets[bucketIndex][j] < buckets[bucketIndex][i] {
                var temp: real = buckets[bucketIndex][j];
                buckets[bucketIndex][j] = buckets[bucketIndex][i];
                buckets[bucketIndex][i] = temp;
            }
        }
    }
}

// writeln();
// for bucket in buckets {
//     writeln(bucket);
// }

var count: int = 0;
for i in 0..p-1 {
    for x in buckets[i] {
        X[count] = x;
        count+=1;
    }
}
t1.stop();
// writeln();
// writeln(X);
writeln(p," ", t1.elapsed());