import 'package:lab5/models/trailers.dart';

class Movie {
  final String title;
  final String imageUrl;
  final String description;
  final double rating;
  final List<String> genres;
  final String releaseDate;
  final List<Trailer> trailers;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.genres,
    required this.releaseDate,
    required this.trailers,
  });
}

//  (Static sample data)
final List<Movie> movies = [
  Movie(
    title: "Avatar: Fire and Ash",
    imageUrl: "https://getyourcomicon.co.uk/wp-content/uploads/2025/09/AvatarFireAsh-EnsemblePoster-Header.webp",
    description: "Avatar: Fire and Ash(Vietnamese title:Avatar: Fire and AshesThis blockbuster, highly anticipated worldwide, continues the unfinished story of the Sully family from the previous installment, while also revealing the dark side of the Na'vi – something never before shown in the earlier films."
        "Director James Cameron"
        "New movie Avatar: Fire And Ash/ Avatar: Fire and AshesEarly screening on December 18th (Movie Voucher not applicable), scheduled release on December 19th, 2025 at various locations.cinemanationwide.",
    rating: 9.5,
    genres: ["Fantasy", "Act", "Adventure"],
    releaseDate: "2025",
    trailers: [
      Trailer(
        title: "Official Trailer",
        duration: "2:30",
        videoUrl: "https://www.youtube.com/watch?v=nb_fFj_0rq8",
      ),
      Trailer(
        title: "Teaser",
        duration: "1:05",
        videoUrl: "https://www.youtube.com/watch?v=xxEt9fnILgQ",
      ),
    ],
  ),
  Movie(
    title: "Shark Jaws",
    imageUrl: "https://cdn.galaxycine.vn/media/2026/1/12/jaw-500_1768208979911.jpg",
    description: "Following the tragic incident where a young woman was killed by a shark while swimming near the beach in the New England tourist town of Amity, Sheriff Martin Brody wanted to close the beaches. However, Mayor Larry Vaughn objected, fearing the town would be devastated by the loss of tourist revenue. Fisherman Matt Hooper and veteran captain Quint offered to assist Brody in hunting down the bloodthirsty monster. The trio embarked on a dramatic battle between man and nature.",
    rating: 9.1,
    genres: ["Horrified", "Sensational"],
    releaseDate: "2026",
    trailers: [
      Trailer(
        title: "Official Trailer",
        duration: "2:30",
        videoUrl: "https://www.youtube.com/watch?v=R_aCEDuH7wA&time_continue=6&source_ve_path=NzY3NTg&embeds_referring_euri=https%3A%2F%2Fwww.galaxycine.vn%2F",
      ),
      Trailer(
        title: "Teaser",
        duration: "1:05",
        videoUrl: "https://www.youtube.com/watch?v=oJ9zBnXI8Q0",
      ),
    ],
  ),

];