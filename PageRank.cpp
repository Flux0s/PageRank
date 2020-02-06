// PageRank.cpp : This file contains the 'main' function. Program execution
// begins and ends there.
//

#include <iostream>
#include <stdlib.h>
#include <time.h>

// Function declerations
void generateStartingData();
void printMatrix();
void getPageRank();
void printReadableRankResults();

// Constants
// A good value for damping factor is 0.810;
const float DAMPING_FACTOR = 0.81;
const int NUM_PAGES = 25;
const int PRINT_FREQUENCY = 2;
const int USE_STATIC_LINK_MATRIX = 0;
const int STATIC_LINK_SEED = 10;
const int STARTING_PAGERANK = 1;
const float LINK_GENERATION_CHANCE = 0.6f; // Should be between 1 and 0
const int NUM_ITERATIONS = 500000;

// Declerations
int **linkMatrix;
int *countMatrix;
float *pageRankMatrix;

int main() {
  // Initialization
  if (USE_STATIC_LINK_MATRIX)
    srand(STATIC_LINK_SEED);
  else
    srand(time(NULL));
  // Allocation of dynamic memory
  countMatrix = new int[NUM_PAGES];
  pageRankMatrix = new float[NUM_PAGES];
  linkMatrix = new int *[NUM_PAGES];
  for (int i = 0; i < NUM_PAGES; i++) {
    linkMatrix[i] = new int[NUM_PAGES];
    countMatrix[i] = 0;
  }

  generateStartingData();
  getPageRank();
  printReadableRankResults();

  // Deallocation of dynamic memory
  delete[] pageRankMatrix;
  delete[] countMatrix;
  for (int i = 0; i < NUM_PAGES; i++) {
    delete[] linkMatrix[i];
  }
  delete[] linkMatrix;
}

void generateStartingData() {
  std::cout << "Generating page link matrix and resultant link counts...\n";
  for (int i = 0; i < NUM_PAGES; i++) {
    for (int j = 0; j < NUM_PAGES; j++) {
      // Create a link if:
      //    - Page j doesn't already have a link to page i
      //    - Page i and page j are not the same page
      //    - And a random number is greater than the link generation chance
      //      (converted to percentage)
      if (linkMatrix[i][j] != 1 && i != j &&
          rand() % 100 <= 100 * LINK_GENERATION_CHANCE) {
        linkMatrix[i][j] = 1;
        countMatrix[j]++;
      } else
        linkMatrix[i][j] = 0;
    }
    pageRankMatrix[i] = STARTING_PAGERANK;
  }
  printMatrix();
}

void getPageRank() {
  std::cout << "\nPerforming " << NUM_ITERATIONS << " iterations...\n";
  for (int iteration = 1; iteration <= NUM_ITERATIONS; iteration++) {
    for (int i = 0; i < NUM_PAGES; i++) {
      // float averagePageRankChange = 0.0f;
      float prevPageRank = pageRankMatrix[i];
      pageRankMatrix[i] = 0;
      for (int j = 0; j < NUM_PAGES; j++) {
        pageRankMatrix[i] +=
            linkMatrix[i][j] > 0 ? pageRankMatrix[j] / countMatrix[j] : 0;
      }
      pageRankMatrix[i] *= DAMPING_FACTOR;
      pageRankMatrix[i] += (1 - DAMPING_FACTOR);
      // averagePageRankChange +=
    }
    if (PRINT_FREQUENCY > 0 &&
        iteration % (NUM_ITERATIONS / PRINT_FREQUENCY) == 0) {
      std::cout << "\n Iteration " << iteration << ": \n";
      printMatrix();
    }
  }
}

void printMatrix() {
  std::cout << "\n";
  for (int i = 0; i < NUM_PAGES; i++) {
    for (int j = 0; j < NUM_PAGES; j++) {
      std::cout << " " << linkMatrix[i][j] << "  ";
    }
    std::cout << "= " << pageRankMatrix[i];
    std::cout << "\n";
  }
  for (int i = 0; i < NUM_PAGES; i++) {
    std::cout << "(" << countMatrix[i] << ") ";
  }
  std::cout << "\n";
}

void printReadableRankResults() {
  std::cout << "\n";
  for (int i = 0; i < NUM_PAGES; i++) {
    std::cout << "Page " << i << " had rank: " << (int)(pageRankMatrix[i] * 10)
              << "\n";
  }
}