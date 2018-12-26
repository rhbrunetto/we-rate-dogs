import 'package:flutter/material.dart';
import '../models/dog.dart';

class DogWidget extends StatefulWidget{
  final Dog dog;

  DogWidget(this.dog);

  @override
  _DogWidgetState createState() => _DogWidgetState(dog);
}

class _DogWidgetState extends State<DogWidget>{
  Dog dog;
  String renderUrl;

  _DogWidgetState(this.dog);

  void initState(){
    super.initState();
    renderDogPic();
  }

  void renderDogPic() async {
    print('DOGGING PIC');
    await dog.getImageUrl();
    setState(() {
          renderUrl = dog.imageUrl;
        });
  }

  Widget get dogImage{
    return Container(
      width:  100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(renderUrl ?? '')
        )
      ),
    );
  }

  Widget get dogCard{
    return Container(
      // Arbitrary number that I decided looked good:
      width: 290.0,
      height: 115.0,
      // A stack takes children, with a list of widgets.
      child: Card(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left:64.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(widget.dog.name, style: Theme.of(context).textTheme.headline),
              Text(widget.dog.location, style: Theme.of(context).textTheme.subhead),
              Row(
                children: <Widget>[
                  Icon(Icons.star),
                  Text(':${widget.dog.rating} / 10')
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 115.0,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 50.0,
              child: dogCard,
            ),
            Positioned(top: 7.5, child: dogImage),
          ],
        ),
      ),
    );
  }
}

class  DogListWidget extends StatelessWidget{
  final List<Dog> doggos;
  DogListWidget(this.doggos);

  @override
  Widget build(BuildContext context){
    return _buildList(context);
  }

  ListView _buildList(context){
    return ListView.builder(
      itemCount: doggos.length,
      itemBuilder: (context, index){
        return DogWidget(doggos[index]);
      },
    );
  }
}