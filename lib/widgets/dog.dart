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
    await dog.getImageUrl();
    setState(() {
          renderUrl = dog.imageUrl;
        });
  }

  Widget get dogImage{
    var dogAvatar = Hero(
      tag : dog,
      child : Container(
        width:  100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(renderUrl ?? '')
          )
        ),
      )
    );
    
    var placeholder = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black54, Colors.black, Colors.blueGrey[600]]
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'DOGGO',
        textAlign: TextAlign.center,
      )
    );
  
    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: dogAvatar,
      crossFadeState: widget.dog.imageUrl == null
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 1000)
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

  showDogDetailPage(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DogDetailPage(dog);
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDogDetailPage,
      child: Padding(
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
      )
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

class DogDetailPage extends StatefulWidget{
  final Dog dog;
  DogDetailPage(this.dog);

  @override
  _DogDetailPageState createState() => _DogDetailPageState();
}

class _DogDetailPageState extends State<DogDetailPage>{
  final double dogAvatarSize = 150.0;
  double _sliderValue;

  void updateRating(){
    if (_sliderValue < 10){
      _ratingErrorDialog();
      return;
    }
    setState(() => widget.dog.rating = _sliderValue.toInt());
  }

  void initState(){
    super.initState();
    _sliderValue =  widget.dog.rating.toDouble();
  }

  Future<Null> _ratingErrorDialog() async{
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Error!'),
          content: Text('They\'re all good dogs!'),
          actions : [
            FlatButton(
              child: Text('Try again'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ]
        );
      }
    );
  }

  Widget get submitRatingButton{
    return RaisedButton(
      onPressed: updateRating,
      child: Text('Submit Rating'),
      color: Colors.indigoAccent
    );
  }

  Widget get addRating{
    return Column (
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating){
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                  value: _sliderValue,
                ),
              ),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text(
                  '${_sliderValue.toInt()}',
                  style: Theme.of(context).textTheme.display1
                )
              )
            ],
          )
        ),
        submitRatingButton
      ],
    );
  }

  Widget get dogImage {
    return Hero(
      tag: widget.dog,
      child: Container(
        height: dogAvatarSize,
        width : dogAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            const BoxShadow(
              offset: const Offset(1.0, 2.0),
              blurRadius: 2.0,
              spreadRadius: -1.0,
              color: const Color(0x33000000)
            ),
            const BoxShadow(
              offset: const Offset(2.0, 1.0),
              blurRadius: 3.0,
              spreadRadius: 0.0,
              color: const Color(0x24000000)
            ),
            const BoxShadow(
              offset: const Offset(3.0, 1.0),
              blurRadius: 4.0,
              spreadRadius: 2.0,
              color: const Color(0x1F000000)
            )],
          image: DecorationImage(
            fit: BoxFit.cover,
            image:NetworkImage(widget.dog.imageUrl)
          )
        ),
      )
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0
        ),
        Text(
          ' ${widget.dog.rating} / 10',
          style: Theme.of(context).textTheme.display2,
        )
      ],
    );
  }

  Widget get dogProfile {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          dogImage,
          Text(
            '${widget.dog.name} 🎾',
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0
            ),
            child: Text(widget.dog.description)
          ),
          rating
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Meet ${widget.dog.name}')
      ),
      body: ListView(
        children: <Widget>[dogProfile, addRating]
      )
    );
  }
}

class AddDogFormPage extends StatefulWidget{
  @override
  _AddDogFormPageState createState() => _AddDogFormPageState();
}

class _AddDogFormPageState extends State<AddDogFormPage>{

  TextEditingController nameController        = TextEditingController();
  TextEditingController locationController    = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Widget txtfield(TextEditingController ctrl, String hint){
    return Padding(
      padding: const EdgeInsets.only(bottom:8.0),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(labelText: hint),
      )
    );
  }

  void submitPup(BuildContext context){
    if (nameController.text.isEmpty){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Dog needs a name!')
        )
      );
      return;
    }
    var newDog = Dog(
      name: nameController.text,
      location: locationController.text,
      description: descriptionController.text
    );
    Navigator.of(context).pop(newDog);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Dog'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0
          ),
          child: Column(
            children: <Widget>[
              txtfield(nameController, 'Name the pup'),
              txtfield(locationController, 'Pup\'s location'),
              txtfield(descriptionController, 'All about the pup'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context){
                    return RaisedButton(
                      onPressed : () => submitPup(context),
                      color: Colors.indigoAccent,
                      child: Text('Submit Pup')
                    );
                  }
                )
              )
            ],
          )
        ),
      ),
    );
  }
}