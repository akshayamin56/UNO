class MoviesModel {
  String title;
  String artists;
  String posterImageUrl;
  String thumbnailimageUrl;
  String movieUrl;

  var languages = [];

  MoviesModel(this.title, this.artists, this.posterImageUrl,
      this.thumbnailimageUrl, this.movieUrl);

  MoviesModel.fromJson(Map<String, dynamic> json) {
    title = json['MovieName'];
    artists = json['Artists'];
    posterImageUrl = json['PosterImageUrl'];
    thumbnailimageUrl = json['ThumbnailimageUrl'];
    movieUrl = json['MovieUrl'];
  }
}

class AudioBookModel {
  String title;
  String artists;
  String posterImageUrl;
  String thumbnailimageUrl;
  String trackUrl;

  var languages = [];

  AudioBookModel(this.title, this.artists, this.posterImageUrl,
      this.thumbnailimageUrl, this.trackUrl);

  AudioBookModel.fromJson(Map<String, dynamic> json) {
    title = json['BookName'];
    artists = json['Author'];
    posterImageUrl = json['PosterImageUrl'];
    thumbnailimageUrl = json['BookImageUrl'];
    trackUrl = json['TrackUrl'];
  }
}
