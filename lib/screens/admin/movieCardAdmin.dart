import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/details/details_screen.dart';
import 'package:provider/src/provider.dart';
import '../../../constants.dart';

class MovieCardAdmin extends StatefulWidget {
  final Movie movie;
  String urlP = "";
  MovieCardAdmin({Key key, this.movie, this.urlP}) : super(key: key);

  @override
  _MovieCardAdminState createState() => _MovieCardAdminState();
}

class _MovieCardAdminState extends State<MovieCardAdmin> {
  @override
  Widget build(BuildContext context) {
    return buildMovieCard(context);

    /*Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => buildMovieCard(context),
        // openBuilder: (context, action) => DetailsScreen(movie: widget.movie,urlP: widget.urlP,),
      ),
    );*/
  }

  Column buildMovieCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(widget.movie.poster, headers: {
                  'Authorization': "Bearer " + context.read<User>().token
                }),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: Text(
            widget.movie.title,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/star_fill.svg",
              height: 20,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              "${widget.movie.rating}",
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        )
      ],
    );
  }
}
