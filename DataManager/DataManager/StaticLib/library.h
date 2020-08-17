//
//  library.h
//  StaticLib
//
//  Created by Usha on 16/08/2020.
//  Copyright © 2020 developers. All rights reserved.
//

#ifndef library_h
#define library_h

#include <stdio.h>

// structure for movie details
struct MovieDetails {
    char* posterPath;
    char *originalTitle;
    double voteAverage;
    int releaseDate;
};

//function to sort movies based on their rating
void SortMovieRating(struct MovieDetails *movieList, size_t size);

#endif /* library_h */
