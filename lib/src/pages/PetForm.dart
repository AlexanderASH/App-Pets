import 'package:app_pets/src/commons/validations/input.dart';
import 'package:app_pets/src/models/Type.dart';
import 'package:flutter/material.dart';

class PetFormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<PetFormPage> {
  TextEditingController name;
  TextEditingController description;
  TextEditingController color;
  TextEditingController size;
  TextEditingController image;
  TextEditingController gender;
  int typeId;

  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() { 
    super.initState();
    this.name = TextEditingController();
    this.description = TextEditingController();
    this.color = TextEditingController();
    this.size = TextEditingController();
    this.image = TextEditingController();
    this.gender = TextEditingController();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New pet"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              TextFormField(
                controller: this.name,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: this.description,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: this.color,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Color",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: this.size,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Size",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: this.image,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: this.gender,
                validator: InputValidations.validateText,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10.0,),
              FutureBuilder<List<Type>>(
                future: null,
                initialData: [],
                builder: (context, snapshot){
                  return DropdownButtonFormField<int>(
                    validator: InputValidations.validateDropDown,
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    textStyle: TextStyle(fontSize: 20.0)
                  ),
                  child:Text('Create'),
                  onPressed: () {
                    if (this._formKey.currentState.validate()) {
                      // TODO: CREATE PET
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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

  void _createpet() async {
    try {
      //TODO: Call service
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(e.message),
          duration: Duration(milliseconds: 5000),
        ));
    }
  }

  @override
  void dispose() { 
    this.name.dispose();
    this.description.dispose();
    this.color.dispose();
    this.size.dispose();
    this.image.dispose();
    this.gender.dispose();
    super.dispose();
  }
}