//
//  library.c
//  StaticLib
//
//  Created by Usha on 16/08/2020.
//  Copyright © 2020 developers. All rights reserved.
//

#include "library.h"

void SortMovieRating(struct MovieDetails *movieList, size_t size){    
    struct MovieDetails temp;
    int i = 0;
    int j = 0;
    
    // sorting movies based on their rating
    for (i = 1; i < size; ++i){
        for (j = 0; j < size - i; ++j) {
            if (movieList[j].voteAverage < movieList[j + 1].voteAverage) {
                temp = movieList[j];
                movieList[j] = movieList[j + 1];
                movieList[j + 1] = temp;
            }
        }
    }
}
