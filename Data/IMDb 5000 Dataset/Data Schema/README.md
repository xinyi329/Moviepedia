The data schema includes the following fields separated by tabs:
* movie_id: string, starting with tt and following by 7 digits, unique key of a movie
* movie_imdb_link: string
* movie_title: string
* release_year: integer
* color: string with '|' separated if having multiple
* duration: integer with minute as unit
* genres: string with '|' separated if having multiple
* plot_keywords: string with '|' separated if having multiple
* language: string with '|' separated if having multiple
* country: string with '|' separated if having multiple
* content_rating: string
* movie_facebook_likes: integer
* num_user_for_reviews: integer
* num_critic_for_reviews: integer
* num_voted_users: integer
* imdb_score: float
* production_budget: integer
* worldwide_gross: integer
* domestic_gross integer
* cast_total_facebook_likes: integer
* actor_1_name: string, denotes actor/actress in the cast with the most Facebook likes, if applicable
* actor_1_id: string, starting with nm and following by 7 digits, unique key of a person
* actor_1_facebook_likes: integer
* actor_2_name: string, denotes actor/actress in the cast with the second most Facebook likes, if applicable
* actor_2_id: string, starting with nm and following by 7 digits, unique key of a person
* actor_2_facebook_likes: integer
* actor_3_name: string, denotes actor/actress in the cast with the third most Facebook likes, if applicable
* actor_3_id: string, starting with nm and following by 7 digits, unique key of a person
* actor_3_facebook_likes: integer
* director_name: string
* director_id: string, starting with nm and following by 7 digits, unique key of a person
* director_facebook_likes: integer