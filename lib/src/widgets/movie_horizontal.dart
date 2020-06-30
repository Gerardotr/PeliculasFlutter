
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;

  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageCtrl = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );



  @override
  Widget build(BuildContext context) {


    final _screenSise = MediaQuery.of(context).size;

    _pageCtrl.addListener( () {

      if ( _pageCtrl.position.pixels  >= _pageCtrl.position.maxScrollExtent -200) {
        siguientePagina();
      }

    });
    
    return Container(
      height: _screenSise.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageCtrl,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _targeta(context, peliculas[i]);
        },
        //children: _targetas(context),

      ),
        
    );
  }

  Widget _targeta(BuildContext context, Pelicula pelicula) {

      
      pelicula.uniqueId = '${pelicula.id}-poster';
       final tarjeta =  Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 130.0,
                ),
              ),
            ),
            SizedBox( height: 5.0,),
            Text(pelicula.title, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption,)
          ],
        ),

      );

      return GestureDetector(
        child: tarjeta,
        onTap: () {
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
          print('ID de la pelicula ${pelicula.id}');
        },
      );
  }

  List<Widget>_targetas(BuildContext context) {

    return peliculas.map((pelicula) {

      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 130.0,
              ),
            ),
            SizedBox( height: 5.0,),
            Text(pelicula.title, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption,)
          ],
        ),

      );
    }).toList();



  }
}