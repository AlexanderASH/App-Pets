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
  int page;

  bool hasNextPage;

  bool isLoadMoreRunning;
  
  Map<String, dynamic> filter;

  ScrollController _controller;

  @override
  void initState() { 
    super.initState();
    this.isFemale = false;
    this.isMale = false;
    this.isSelectedName = false;
    this.count = 0;
    this.page = 0;
    this.hasNextPage = true;
    this.isLoadMoreRunning = false;
    this.pets = [];
    this.filter = new Map<String, dynamic>();
    this._controller = ScrollController()..addListener(this._loadMore);
    this._getPets();
  }

  _getPets() async {
    this.page = 0;
    this.filter["page"] = "${this.page}";
    this.hasNextPage = true;
    this.isLoadMoreRunning = false;
    FetchPet data = await PetService.getPets(this.filter);
    this.count = data.count;
    this.pets = data.pets;
    
    setState(() {});
  }

  _loadMore() async {
    if (
      this.hasNextPage == true && 
      this.isLoadMoreRunning == false &&
      this._controller.position.extentAfter < 300
    ) {
      setState(() {
        this.isLoadMoreRunning = true;
      });

      this.page += 1;
      this.filter["page"] = "${this.page}";

      FetchPet data = await PetService.getPets(this.filter);
      
      if (data.pets.length > 0) {
        setState(() {
          this.pets.addAll(data.pets);
          this.count = data.count;
        });
      } else {
        setState(() {
          hasNextPage = false;
        });
      }

      setState(() {
        isLoadMoreRunning = false;
    });
    }
  }

  _handleName() {
    setState(() {
      this.isSelectedName = !this.isSelectedName;
    });

    if (this.isSelectedName) {
      this.filter["sort"] = "name";
      this.filter["order"] = "ASC";
    } else {
      this.filter.remove("sort");
      this.filter.remove("order");
    }

    if (this.filter.containsKey("type")) {
      this.filter.remove("type");
      this.typeId = null;
    }
  }

  _handleFemale(bool state) {
    setState(() {
      if (this.isFemale && !state) {
        this.isFemale = !this.isFemale;
        this.filter.remove("gender");
      } else {
        this.isFemale = state;
        this.isMale = !state;
        this.filter["gender"] = "female";
      }
    });
  }

  _handleMale(bool state) {
    setState(() {
      if (this.isMale && !state) {
        this.isMale = !this.isMale;
        this.filter.remove("gender");
      } else {
        this.isMale = state;
        this.isFemale = !state;
        this.filter["gender"] = "male";
      }
    });
  }

  _handleType(int typeId) {
    if (this.isSelectedName) {
      this.isSelectedName = false;
    }

    this.filter["sort"] = "id";
    this.filter["order"] = "DESC";
    
    setState(() {
      this.typeId = typeId;
      this.filter["type"] = "$typeId";
    });
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
                    IconButton(onPressed: this._getPets, icon: Icon(Icons.search))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: this._handleName,
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
                          onChanged: this._handleFemale,
                        ),
                        Text("Male"),
                        Checkbox(
                          value: this.isMale, 
                          onChanged: this._handleMale
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
                      onChanged: this._handleType,
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
              controller: this._controller,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: this.pets.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return this._getCardPet(this.pets[index]);
              }
            ),
          )
          : CircularProgressIndicator(),
          if (this.isLoadMoreRunning)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
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

  @override
  void dispose() {
    this._controller.removeListener(_loadMore);
    this._controller.dispose();
    super.dispose();
  }
}