import 'package:app_pets/src/models/Pet.dart';
import 'package:app_pets/src/models/Type.dart';
import 'package:app_pets/src/services/pet.dart';
import 'package:app_pets/src/services/type.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int typeId;
  bool isMale;
  bool isFemale;
  bool isSelectedName;
  List<Pet> pets;
  int count;

  @override
  void initState() { 
    super.initState();
    this.isFemale = false;
    this.isMale = false;
    this.isSelectedName = false;
    this.count = 0;
    this.pets = [];
    this._getPets();
  }

  _getPets() async {
    FetchPet data = await PetService.getPets();
    this.count = data.count;
    this.pets = data.pets;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pets"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.23,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Search", style: TextStyle(fontSize: 20.0),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.search))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isSelectedName = !this.isSelectedName;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: (!this.isSelectedName) ? Colors.grey[600] : Colors.pink,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Center(
                          child: Text("Name", style: TextStyle(color: Colors.white),),
                        )
                      )
                    ),
                    Row(
                      children: [
                        Text("Female"),
                        Checkbox(
                          value: this.isFemale, 
                          onChanged: (value){
                            setState(() {
                              if (this.isFemale && !value) {
                                this.isFemale = !this.isFemale;
                              } else {
                                this.isFemale = value;
                                this.isMale = !value;
                              }
                            });
                          },
                        ),
                        Text("Male"),
                        Checkbox(
                          value: this.isMale, 
                          onChanged: (value) {
                            setState(() {
                              if (this.isMale && !value) {
                                this.isMale = !this.isMale;
                              } else {
                                this.isMale = value;
                                this.isFemale = !value;
                              }
                            });
                          }
                        )
                      ],
                    )
                  ],
                ),
                FutureBuilder<List<Type>>(
                  future: TypeService.getTypes(),
                  initialData: [],
                  builder: (context, snapshot){
                    return DropdownButton<int>(
                      isExpanded: true,
                      iconEnabledColor: Colors.pink,
                      hint: Text('Select pet type'),
                      icon: Icon(Icons.add),
                      items: _getTypeItems(snapshot.data),
                      onChanged: (id) {
                        setState(() {
                          this.typeId = id;  
                        });
                      },
                      value: this.typeId
                    );
                  },
                ),
              ],
            ),
          ),
          (this.pets.length > 0)
          ?
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: this.count,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return this._getCardPet(this.pets[index]);
              }
            ),
          )
          : CircularProgressIndicator()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, 'form'), 
        label: Row(
          children: [
            Icon(Icons.pets_sharp),
            SizedBox(width: 5.0,),
            Text("New Pet")
          ],
        )
      )
    );
  }

  List<DropdownMenuItem<int>> _getTypeItems(List<Type> types) {
    List<DropdownMenuItem<int>> items = [];
    types.forEach((type) {
      items.add(
        DropdownMenuItem(
          child: Text(type.name),
          value: type.id
        )
      );
    });

    return items;
  }

  Card _getCardPet(Pet pet) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pet.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),  
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: NetworkImage(pet.image),
                      fit: BoxFit.fill
                    )
                  )
                ),
                SizedBox(width: 10.0,),
                Flexible(child: Text(pet.description)),
              ],
            ),
            Text("Gender: ${pet.gender}"),
            Text("Type: ${pet.type.name}")
          ],
        ),
      ),
    );
  }
}